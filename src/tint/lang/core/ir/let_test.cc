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

#include "src/tint/lang/core/ir/let.h"

#include "gmock/gmock.h"
#include "src/tint/lang/core/ir/builder.h"
#include "src/tint/lang/core/ir/instruction.h"
#include "src/tint/lang/core/ir/ir_helper_test.h"

namespace tint::core::ir {
namespace {

using namespace tint::core::fluent_types;     // NOLINT
using namespace tint::core::number_suffixes;  // NOLINT

using IR_LetTest = IRTestHelper;
using IR_LetDeathTest = IR_LetTest;

TEST_F(IR_LetDeathTest, Fail_NullValue) {
    EXPECT_DEATH_IF_SUPPORTED(
        {
            Module mod;
            Builder b{mod};
            ir::Value* value = nullptr;
            b.Let("l", value);
        },
        "internal compiler error");
}

TEST_F(IR_LetTest, Results) {
    auto* value = b.Constant(1_f);
    auto* let = b.Let("l", value);
    EXPECT_EQ(let->Results().Length(), 1u);
    EXPECT_TRUE(let->Result()->Is<InstructionResult>());
    EXPECT_EQ(let->Result()->Instruction(), let);
    EXPECT_EQ(let->Result()->Type(), value->Type());
}

TEST_F(IR_LetTest, Clone) {
    auto* value = b.Constant(4_f);
    auto* let = b.Let("l", value);

    auto* new_let = clone_ctx.Clone(let);

    EXPECT_NE(let, new_let);
    EXPECT_NE(nullptr, new_let->Result());
    EXPECT_NE(let->Result(), new_let->Result());

    auto new_val = new_let->Value()->As<Constant>()->Value();
    ASSERT_TRUE(new_val->Is<core::constant::Scalar<f32>>());
    EXPECT_FLOAT_EQ(4_f, new_val->As<core::constant::Scalar<f32>>()->ValueAs<f32>());

    EXPECT_EQ(std::string("l"), mod.NameOf(new_let).Name());
    EXPECT_EQ(std::string("l"), mod.NameOf(new_let->Result()).Name());
}

TEST_F(IR_LetTest, Clone_NoName) {
    auto* value = b.Constant(4_f);
    auto* let = b.Let(value);

    auto* new_let = clone_ctx.Clone(let);

    EXPECT_NE(let, new_let);
    EXPECT_NE(nullptr, new_let->Result());
    EXPECT_NE(let->Result(), new_let->Result());

    auto new_val = new_let->Value()->As<Constant>()->Value();
    ASSERT_TRUE(new_val->Is<core::constant::Scalar<f32>>());
    EXPECT_FLOAT_EQ(4_f, new_val->As<core::constant::Scalar<f32>>()->ValueAs<f32>());

    EXPECT_FALSE(mod.NameOf(new_let).IsValid());
}

}  // namespace
}  // namespace tint::core::ir
