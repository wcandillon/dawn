// Copyright 2022 The Dawn & Tint Authors
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "dawn/native/opengl/ContextEGL.h"

#include <memory>
#include <string>
#include <utility>
#include <vector>

#include "dawn/native/opengl/DisplayEGL.h"
#include "dawn/native/opengl/UtilsEGL.h"

#ifndef EGL_DISPLAY_TEXTURE_SHARE_GROUP_ANGLE
#define EGL_DISPLAY_TEXTURE_SHARE_GROUP_ANGLE 0x33AF
#endif

namespace dawn::native::opengl {

// static
ResultOrError<std::unique_ptr<ContextEGL>> ContextEGL::Create(const DisplayEGL* display,
                                                              wgpu::BackendType backend,
                                                              bool useRobustness,
                                                              bool useANGLETextureSharing) {
    auto context = std::make_unique<ContextEGL>(display);
    DAWN_TRY(context->Initialize(backend, useRobustness, useANGLETextureSharing));
    return std::move(context);
}

ContextEGL::ContextEGL(const DisplayEGL* display) : mDisplay(display) {}

ContextEGL::~ContextEGL() {
    if (mOffscreenSurface != EGL_NO_SURFACE) {
        mDisplay->egl.DestroySurface(mDisplay->GetDisplay(), mOffscreenSurface);
        mOffscreenSurface = EGL_NO_SURFACE;
    }
    if (mContext != EGL_NO_CONTEXT) {
        mDisplay->egl.DestroyContext(mDisplay->GetDisplay(), mContext);
        mContext = EGL_NO_CONTEXT;
    }
}

MaybeError ContextEGL::Initialize(wgpu::BackendType backend,
                                  bool useRobustness,
                                  bool useANGLETextureSharing) {
    const EGLFunctions& egl = mDisplay->egl;

    // Unless EGL_KHR_no_config is present, we need to choose an EGLConfig on context creation that
    // will lock the EGLContext to be use with a single kind of color buffer. In that case the
    // display should only list one kind of color buffer as potentially supported.
    EGLConfig contextConfig = kNoConfig;
    if (!egl.HasExt(EGLExt::NoConfigContext)) {
        DAWN_ASSERT(mDisplay->GetPotentialSurfaceFormats().size() == 1);
        wgpu::TextureFormat format = mDisplay->GetPotentialSurfaceFormats()[0];

        contextConfig = mDisplay->ChooseConfig(EGL_WINDOW_BIT, format);
        if (contextConfig == kNoConfig) {
            return DAWN_FORMAT_INTERNAL_ERROR(
                "Couldn't find an EGLConfig rendering to a window for %s.", format);
        }
    }

    DAWN_TRY(CheckEGL(egl, egl.BindAPI(mDisplay->GetAPIEnum()), "eglBindAPI"));

    int major, minor;
    switch (backend) {
        case wgpu::BackendType::OpenGLES:
            major = 3;
            minor = 1;
            break;
        case wgpu::BackendType::OpenGL:
            major = 4;
            minor = 4;
            break;
        default:
            DAWN_UNREACHABLE();
    }

    std::vector<EGLint> attribs{
        EGL_CONTEXT_MAJOR_VERSION,
        major,
        EGL_CONTEXT_MINOR_VERSION,
        minor,
    };

    if (useRobustness) {
        DAWN_ASSERT(egl.HasExt(EGLExt::CreateContextRobustness));
        // EGL_EXT_create_context_robustness is promoted to 1.5 but with a different enum value.
        if (egl.GetMinorVersion() >= 5) {
            attribs.push_back(EGL_CONTEXT_OPENGL_ROBUST_ACCESS);
        } else {
            attribs.push_back(EGL_CONTEXT_OPENGL_ROBUST_ACCESS_EXT);
        }
        attribs.push_back(EGL_TRUE);
    }

    if (useANGLETextureSharing) {
        DAWN_ASSERT(egl.HasExt(EGLExt::DisplayTextureShareGroup));
        attribs.push_back(EGL_DISPLAY_TEXTURE_SHARE_GROUP_ANGLE);
        attribs.push_back(EGL_TRUE);
    }

    attribs.push_back(EGL_NONE);

    mContext =
        egl.CreateContext(mDisplay->GetDisplay(), contextConfig, EGL_NO_CONTEXT, attribs.data());
    DAWN_TRY(CheckEGL(egl, mContext != EGL_NO_CONTEXT, "eglCreateContext"));

    // When EGL_KHR_surfaceless_context is not supported, we need to create a pbuffer to act
    // as an offscreen surface.
    if (!egl.HasExt(EGLExt::SurfacelessContext)) {
        // The first potential surface format is always a good choice to find the config. Either we
        // only support this one and the context will be compatible with the pbuffer, or
        // EGL_KHR_no_config_context is supported and the context is compatible with any config.
        wgpu::TextureFormat format = mDisplay->GetPotentialSurfaceFormats()[0];

        EGLConfig pbufferConfig = mDisplay->ChooseConfig(EGL_PBUFFER_BIT, format);
        if (pbufferConfig == kNoConfig) {
            return DAWN_FORMAT_INTERNAL_ERROR(
                "Couldn't find an EGLConfig rendering to a window for %s.", format);
        }

        EGLint pbufferAttribs[] = {
            EGL_WIDTH,  1,  //
            EGL_HEIGHT, 1,  //
            EGL_NONE,
        };
        mOffscreenSurface =
            egl.CreatePbufferSurface(mDisplay->GetDisplay(), pbufferConfig, pbufferAttribs);
        DAWN_TRY(
            CheckEGL(egl, mOffscreenSurface != EGL_NO_SURFACE, "Creating the offscreen surface."));
    }

    return {};
}

void ContextEGL::MakeCurrent() {
    EGLBoolean success = mDisplay->egl.MakeCurrent(mDisplay->GetDisplay(), mCurrentSurface,
                                                   mCurrentSurface, mContext);
    IgnoreErrors(CheckEGL(mDisplay->egl, success == EGL_TRUE, "eglMakeCurrent"));
}

// ScopedMakeSurfaceCurrent

[[nodiscard]] ContextEGL::ScopedMakeSurfaceCurrent ContextEGL::MakeSurfaceCurrentScope(
    EGLSurface surface) {
    return {this, surface};
}

ContextEGL::ScopedMakeSurfaceCurrent::ScopedMakeSurfaceCurrent(ContextEGL* context,
                                                               EGLSurface surface)
    : mContext(context) {
    mContext->mCurrentSurface = surface;
}

ContextEGL::ScopedMakeSurfaceCurrent::~ScopedMakeSurfaceCurrent() {
    mContext->mCurrentSurface = mContext->mOffscreenSurface;
}

}  // namespace dawn::native::opengl
