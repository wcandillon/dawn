// Copyright 2020 The Tint Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "src/tint/ast/id_attribute.h"
#include "src/tint/writer/hlsl/test_helper.h"

using namespace tint::number_suffixes;  // NOLINT

namespace tint::writer::hlsl {
namespace {

using HlslGeneratorImplTest_ModuleConstant = TestHelper;

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalLet) {
    auto* var = Let("pos", ty.array<f32, 3>(), array<f32, 3>(1_f, 2_f, 3_f));
    WrapInFunction(Decl(var));

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.EmitProgramConstVariable(var)) << gen.error();
    EXPECT_EQ(gen.result(), "static const float pos[3] = {1.0f, 2.0f, 3.0f};\n");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_AInt) {
    auto* var = GlobalConst("G", nullptr, Expr(1_a));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const int l = 1;
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_AFloat) {
    auto* var = GlobalConst("G", nullptr, Expr(1._a));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float l = 1.0f;
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_i32) {
    auto* var = GlobalConst("G", nullptr, Expr(1_i));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const int l = 1;
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_u32) {
    auto* var = GlobalConst("G", nullptr, Expr(1_u));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const uint l = 1u;
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_f32) {
    auto* var = GlobalConst("G", nullptr, Expr(1_f));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float l = 1.0f;
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_vec3_AInt) {
    auto* var = GlobalConst("G", nullptr, Construct(ty.vec3(nullptr), 1_a, 2_a, 3_a));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const int3 l = int3(1, 2, 3);
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_vec3_AFloat) {
    auto* var = GlobalConst("G", nullptr, Construct(ty.vec3(nullptr), 1._a, 2._a, 3._a));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float3 l = float3(1.0f, 2.0f, 3.0f);
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_vec3_f32) {
    auto* var = GlobalConst("G", nullptr, vec3<f32>(1_f, 2_f, 3_f));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float3 l = float3(1.0f, 2.0f, 3.0f);
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_mat2x3_AFloat) {
    auto* var = GlobalConst("G", nullptr,
                            Construct(ty.mat(nullptr, 2, 3), 1._a, 2._a, 3._a, 4._a, 5._a, 6._a));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float2x3 l = float2x3(float3(1.0f, 2.0f, 3.0f), float3(4.0f, 5.0f, 6.0f));
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_mat2x3_f32) {
    auto* var = GlobalConst("G", nullptr, mat2x3<f32>(1_f, 2_f, 3_f, 4_f, 5_f, 6_f));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float2x3 l = float2x3(float3(1.0f, 2.0f, 3.0f), float3(4.0f, 5.0f, 6.0f));
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_arr_f32) {
    auto* var = GlobalConst("G", nullptr, Construct(ty.array<f32, 3>(), 1_f, 2_f, 3_f));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const float l[3] = {1.0f, 2.0f, 3.0f};
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_GlobalConst_arr_vec2_bool) {
    auto* var = GlobalConst("G", nullptr,
                            Construct(ty.array(ty.vec2<bool>(), 3_u),  //
                                      vec2<bool>(true, false),         //
                                      vec2<bool>(false, true),         //
                                      vec2<bool>(true, true)));
    Func("f", {}, ty.void_(), {Decl(Let("l", nullptr, Expr(var)))});

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.Generate()) << gen.error();

    EXPECT_EQ(gen.result(), R"(void f() {
  const bool2 l[3] = {bool2(true, false), bool2(false, true), (true).xx};
}
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_Override) {
    auto* var = Override("pos", ty.f32(), Expr(3_f),
                         ast::AttributeList{
                             Id(23),
                         });

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.EmitOverride(var)) << gen.error();
    EXPECT_EQ(gen.result(), R"(#ifndef WGSL_SPEC_CONSTANT_23
#define WGSL_SPEC_CONSTANT_23 3.0f
#endif
static const float pos = WGSL_SPEC_CONSTANT_23;
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_Override_NoConstructor) {
    auto* var = Override("pos", ty.f32(), nullptr,
                         ast::AttributeList{
                             Id(23),
                         });

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.EmitOverride(var)) << gen.error();
    EXPECT_EQ(gen.result(), R"(#ifndef WGSL_SPEC_CONSTANT_23
#error spec constant required for constant id 23
#endif
static const float pos = WGSL_SPEC_CONSTANT_23;
)");
}

TEST_F(HlslGeneratorImplTest_ModuleConstant, Emit_Override_NoId) {
    auto* a = Override("a", ty.f32(), Expr(3_f),
                       ast::AttributeList{
                           Id(0),
                       });
    auto* b = Override("b", ty.f32(), Expr(2_f));

    GeneratorImpl& gen = Build();

    ASSERT_TRUE(gen.EmitOverride(a)) << gen.error();
    ASSERT_TRUE(gen.EmitOverride(b)) << gen.error();
    EXPECT_EQ(gen.result(), R"(#ifndef WGSL_SPEC_CONSTANT_0
#define WGSL_SPEC_CONSTANT_0 3.0f
#endif
static const float a = WGSL_SPEC_CONSTANT_0;
#ifndef WGSL_SPEC_CONSTANT_1
#define WGSL_SPEC_CONSTANT_1 2.0f
#endif
static const float b = WGSL_SPEC_CONSTANT_1;
)");
}

}  // namespace
}  // namespace tint::writer::hlsl
