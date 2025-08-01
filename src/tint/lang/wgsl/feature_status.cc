// Copyright 2023 The Dawn & Tint Authors
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

#include "src/tint/lang/wgsl/feature_status.h"

#include "src/tint/lang/wgsl/enums.h"

namespace tint::wgsl {

FeatureStatus GetLanguageFeatureStatus(LanguageFeature f) {
    switch (f) {
            ////////////////////////////////////////////////////////////////////
            // Experimental features
            ///////////////////////////////////////////////////////////////////
        case LanguageFeature::kSizedBindingArray:
        case LanguageFeature::kTexelBuffers:
            return FeatureStatus::kUnsafeExperimental;

            ////////////////////////////////////////////////////////////////////
            // Chromium developer features
            ///////////////////////////////////////////////////////////////////
        case LanguageFeature::kChromiumPrint:
            return FeatureStatus::kUnsafeExperimental;

            ////////////////////////////////////////////////////////////////////
            // Enabled features
            ////////////////////////////////////////////////////////////////////
        case LanguageFeature::kPacked4X8IntegerDotProduct:
        case LanguageFeature::kPointerCompositeAccess:
        case LanguageFeature::kUnrestrictedPointerParameters:
        case LanguageFeature::kReadonlyAndReadwriteStorageTextures:
            return FeatureStatus::kShippedWithKillswitch;

            ////////////////////////////////////////////////////////////////////
            // Testing / special cases
            ////////////////////////////////////////////////////////////////////
        case LanguageFeature::kChromiumTestingUnimplemented:
            return FeatureStatus::kUnimplemented;
        case LanguageFeature::kChromiumTestingUnsafeExperimental:
            return FeatureStatus::kUnsafeExperimental;
        case LanguageFeature::kChromiumTestingExperimental:
            return FeatureStatus::kExperimental;
        case LanguageFeature::kChromiumTestingShippedWithKillswitch:
            return FeatureStatus::kShippedWithKillswitch;
        case LanguageFeature::kChromiumTestingShipped:
            return FeatureStatus::kShipped;
        case LanguageFeature::kUndefined:
            return FeatureStatus::kUnknown;
    }

    return FeatureStatus::kUnknown;
}

}  // namespace tint::wgsl
