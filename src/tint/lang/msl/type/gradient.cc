// Copyright 2024 The Dawn & Tint Authors
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

#include "src/tint/lang/msl/type/gradient.h"

#include <cstddef>
#include <string>

#include "src/tint/lang/core/type/clone_context.h"
#include "src/tint/lang/core/type/manager.h"
#include "src/tint/lang/core/type/unique_node.h"
#include "src/tint/utils/math/hash.h"
#include "src/tint/utils/rtti/castable.h"
#include "src/tint/utils/text/string_stream.h"

TINT_INSTANTIATE_TYPEINFO(tint::msl::type::Gradient);

namespace tint::msl::type {

Gradient::Gradient(enum Dim dim)
    : Base(static_cast<size_t>(Hash(tint::TypeCode::Of<Gradient>().bits, dim)),
           core::type::Flags{core::type::kConstructable, core::type::kCreationFixedFootprint}),
      dim_(dim) {}

bool Gradient::Equals(const UniqueNode& other) const {
    if (auto* g = other.As<Gradient>()) {
        return g->Dim() == dim_;
    }
    return false;
}

std::string Gradient::FriendlyName() const {
    StringStream out;
    out << "msl.gradient";
    switch (dim_) {
        case Dim::k2d:
            out << "2d";
            break;
        case Dim::k3d:
            out << "3d";
            break;
        case Dim::kCube:
            out << "cube";
            break;
    }
    return out.str();
}

Gradient* Gradient::Clone(core::type::CloneContext& ctx) const {
    return ctx.dst.mgr->Get<Gradient>(dim_);
}

}  // namespace tint::msl::type
