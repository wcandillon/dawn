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

#ifndef SRC_TINT_LANG_WGSL_SEM_BUILTIN_ATTRIBUTE_H_
#define SRC_TINT_LANG_WGSL_SEM_BUILTIN_ATTRIBUTE_H_

#include "src/tint/lang/core/builtin_value.h"
#include "src/tint/lang/wgsl/ast/builtin_attribute.h"
#include "src/tint/lang/wgsl/sem/expression.h"

namespace tint::sem {

/// BuiltinAttribute holds the semantic information for ast nodes that resolve to a
/// builtin value.
class BuiltinAttribute : public Castable<BuiltinAttribute, Node> {
  public:
    /// Constructor
    /// @param declaration the AST node
    /// @param value the builtin value
    BuiltinAttribute(const ast::BuiltinAttribute* declaration, core::BuiltinValue value);

    /// Destructor
    ~BuiltinAttribute() override;

    /// @returns the case selector declaration
    const ast::BuiltinAttribute* Declaration() const;

    /// @return the enumerator value
    core::BuiltinValue Value() const;

  private:
    const ast::BuiltinAttribute* declaration_;
    const core::BuiltinValue value_;
};

}  // namespace tint::sem

#endif  // SRC_TINT_LANG_WGSL_SEM_BUILTIN_ATTRIBUTE_H_
