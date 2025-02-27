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

#include "src/tint/lang/hlsl/writer/helper_test.h"

using namespace tint::core::fluent_types;     // NOLINT
using namespace tint::core::number_suffixes;  // NOLINT

namespace tint::hlsl::writer {
namespace {

TEST_F(HlslWriterTest, AccessArray) {
    auto* func = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    func->SetWorkgroupSize(1, 1, 1);

    b.Append(func->Block(), [&] {
        auto* v = b.Var("v", b.Zero<array<f32, 3>>());
        b.Let("x", b.Load(b.Access(ty.ptr<function, f32>(), v, 1_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
[numthreads(1, 1, 1)]
void a() {
  float v[3] = (float[3])0;
  float x = v[1u];
}

)");
}

TEST_F(HlslWriterTest, AccessStruct) {
    Vector members{
        ty.Get<core::type::StructMember>(b.ir.symbols.New("a"), ty.i32(), 0u, 0u, 4u, 4u,
                                         core::IOAttributes{}),
        ty.Get<core::type::StructMember>(b.ir.symbols.New("b"), ty.f32(), 1u, 4u, 4u, 4u,
                                         core::IOAttributes{}),
    };
    auto* strct = ty.Struct(b.ir.symbols.New("S"), std::move(members));

    auto* f = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    f->SetWorkgroupSize(1, 1, 1);

    b.Append(f->Block(), [&] {
        auto* v = b.Var("v", b.Zero(strct));
        b.Let("x", b.Load(b.Access(ty.ptr<function, f32>(), v, 1_u)));
        b.Return(f);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(struct S {
  int a;
  float b;
};


[numthreads(1, 1, 1)]
void a() {
  S v = (S)0;
  float x = v.b;
}

)");
}

TEST_F(HlslWriterTest, AccessVector) {
    auto* func = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    func->SetWorkgroupSize(1, 1, 1);

    b.Append(func->Block(), [&] {
        auto* v = b.Var("v", b.Zero<vec3<f32>>());
        b.Let("x", b.LoadVectorElement(v, 1_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
[numthreads(1, 1, 1)]
void a() {
  float3 v = (0.0f).xxx;
  float x = v.y;
}

)");
}

TEST_F(HlslWriterTest, AccessMatrix) {
    auto* func = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    func->SetWorkgroupSize(1, 1, 1);

    b.Append(func->Block(), [&] {
        auto* v = b.Var("v", b.Zero<mat4x4<f32>>());
        auto* v1 = b.Access(ty.ptr<function, vec4<f32>>(), v, 1_u);
        b.Let("x", b.LoadVectorElement(v1, 2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
[numthreads(1, 1, 1)]
void a() {
  float4x4 v = float4x4((0.0f).xxxx, (0.0f).xxxx, (0.0f).xxxx, (0.0f).xxxx);
  float x = v[1u].z;
}

)");
}

TEST_F(HlslWriterTest, AccessStoreVectorElementConstantIndex) {
    auto* func = b.Function("foo", ty.void_());
    b.Append(func->Block(), [&] {
        auto* vec_var = b.Var("vec", ty.ptr<function, vec4<i32>>());
        b.StoreVectorElement(vec_var, 1_u, b.Constant(42_i));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
void foo() {
  int4 vec = (0).xxxx;
  vec[1u] = 42;
}

[numthreads(1, 1, 1)]
void unused_entry_point() {
}

)");
}

TEST_F(HlslWriterTest, AccessStoreVectorElementDynamicIndex) {
    auto* idx = b.FunctionParam("idx", ty.i32());
    auto* func = b.Function("foo", ty.void_());
    func->SetParams({idx});
    b.Append(func->Block(), [&] {
        auto* vec_var = b.Var("vec", ty.ptr<function, vec4<i32>>());
        b.StoreVectorElement(vec_var, idx, b.Constant(42_i));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
void foo(int idx) {
  int4 vec = (0).xxxx;
  vec[min(uint(idx), 3u)] = 42;
}

[numthreads(1, 1, 1)]
void unused_entry_point() {
}

)");
}

TEST_F(HlslWriterTest, AccessNested) {
    Vector members_a{
        ty.Get<core::type::StructMember>(b.ir.symbols.New("d"), ty.i32(), 0u, 0u, 4u, 4u,
                                         core::IOAttributes{}),
        ty.Get<core::type::StructMember>(b.ir.symbols.New("e"), ty.array<f32, 3>(), 1u, 4u, 4u, 4u,
                                         core::IOAttributes{}),
    };
    auto* a_strct = ty.Struct(b.ir.symbols.New("A"), std::move(members_a));

    Vector members_s{
        ty.Get<core::type::StructMember>(b.ir.symbols.New("a"), ty.i32(), 0u, 0u, 4u, 4u,
                                         core::IOAttributes{}),
        ty.Get<core::type::StructMember>(b.ir.symbols.New("b"), ty.f32(), 1u, 4u, 4u, 4u,
                                         core::IOAttributes{}),
        ty.Get<core::type::StructMember>(b.ir.symbols.New("c"), a_strct, 2u, 8u, 8u, 8u,
                                         core::IOAttributes{}),
    };
    auto* s_strct = ty.Struct(b.ir.symbols.New("S"), std::move(members_s));

    auto* f = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    f->SetWorkgroupSize(1, 1, 1);

    b.Append(f->Block(), [&] {
        auto* v = b.Var("v", b.Zero(s_strct));
        b.Let("x", b.Load(b.Access(ty.ptr<function, f32>(), v, 2_u, 1_u, 1_i)));
        b.Return(f);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(struct A {
  int d;
  float e[3];
};

struct S {
  int a;
  float b;
  A c;
};


[numthreads(1, 1, 1)]
void a() {
  S v = (S)0;
  float x = v.c.e[1u];
}

)");
}

TEST_F(HlslWriterTest, AccessSwizzle) {
    auto* f = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    f->SetWorkgroupSize(1, 1, 1);

    b.Append(f->Block(), [&] {
        auto* v = b.Var("v", b.Zero<vec3<f32>>());
        b.Let("b", b.Swizzle(ty.f32(), v, {1u}));
        b.Return(f);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
[numthreads(1, 1, 1)]
void a() {
  float3 v = (0.0f).xxx;
  float b = v.y;
}

)");
}

TEST_F(HlslWriterTest, AccessSwizzleMulti) {
    auto* f = b.Function("a", ty.void_(), core::ir::Function::PipelineStage::kCompute);
    f->SetWorkgroupSize(1, 1, 1);

    b.Append(f->Block(), [&] {
        auto* v = b.Var("v", b.Zero<vec4<f32>>());
        b.Let("b", b.Swizzle(ty.vec4<f32>(), v, {3u, 2u, 1u, 0u}));
        b.Return(f);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
[numthreads(1, 1, 1)]
void a() {
  float4 v = (0.0f).xxxx;
  float4 b = v.wzyx;
}

)");
}

TEST_F(HlslWriterTest, AccessStorageVector) {
    auto* var = b.Var<storage, vec4<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.LoadVectorElement(var, 0_u));
        b.Let("c", b.LoadVectorElement(var, 1_u));
        b.Let("d", b.LoadVectorElement(var, 2_u));
        b.Let("e", b.LoadVectorElement(var, 3_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
ByteAddressBuffer v : register(t0);
void foo() {
  float4 a = asfloat(v.Load4(0u));
  float b = asfloat(v.Load(0u));
  float c = asfloat(v.Load(4u));
  float d = asfloat(v.Load(8u));
  float e = asfloat(v.Load(12u));
}

)");
}

TEST_F(HlslWriterTest, AccessStorageVectorF16) {
    auto* var = b.Var<storage, vec4<f16>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.LoadVectorElement(var, 0_u));
        b.Let("c", b.LoadVectorElement(var, 1_u));
        b.Let("d", b.LoadVectorElement(var, 2_u));
        b.Let("e", b.LoadVectorElement(var, 3_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
ByteAddressBuffer v : register(t0);
void foo() {
  vector<float16_t, 4> a = v.Load<vector<float16_t, 4> >(0u);
  float16_t b = v.Load<float16_t>(0u);
  float16_t c = v.Load<float16_t>(2u);
  float16_t d = v.Load<float16_t>(4u);
  float16_t e = v.Load<float16_t>(6u);
}

)");
}

TEST_F(HlslWriterTest, AccessStorageMatrix) {
    auto* var = b.Var<storage, mat4x4<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<storage, vec4<f32>, core::Access::kRead>(), var, 3_u)));
        b.Let("c", b.LoadVectorElement(
                       b.Access(ty.ptr<storage, vec4<f32>, core::Access::kRead>(), var, 1_u), 2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
ByteAddressBuffer v : register(t0);
float4x4 v_1(uint offset) {
  float4 v_2 = asfloat(v.Load4((offset + 0u)));
  float4 v_3 = asfloat(v.Load4((offset + 16u)));
  float4 v_4 = asfloat(v.Load4((offset + 32u)));
  return float4x4(v_2, v_3, v_4, asfloat(v.Load4((offset + 48u))));
}

void foo() {
  float4x4 a = v_1(0u);
  float4 b = asfloat(v.Load4(48u));
  float c = asfloat(v.Load(24u));
}

)");
}

TEST_F(HlslWriterTest, AccessStorageArray) {
    auto* var = b.Var<storage, array<vec3<f32>, 5>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<storage, vec3<f32>, core::Access::kRead>(), var, 3_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
ByteAddressBuffer v : register(t0);
typedef float3 ary_ret[5];
ary_ret v_1(uint offset) {
  float3 a[5] = (float3[5])0;
  {
    uint v_2 = 0u;
    v_2 = 0u;
    while(true) {
      uint v_3 = v_2;
      if ((v_3 >= 5u)) {
        break;
      }
      a[v_3] = asfloat(v.Load3((offset + (v_3 * 16u))));
      {
        v_2 = (v_3 + 1u);
      }
      continue;
    }
  }
  float3 v_4[5] = a;
  return v_4;
}

void foo() {
  float3 a[5] = v_1(0u);
  float3 b = asfloat(v.Load3(48u));
}

)");
}

TEST_F(HlslWriterTest, AccessStorageStruct) {
    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.f32()},
                                                });

    auto* var = b.Var("v", storage, SB, core::Access::kRead);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<storage, f32, core::Access::kRead>(), var, 1_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(struct SB {
  int a;
  float b;
};


ByteAddressBuffer v : register(t0);
SB v_1(uint offset) {
  int v_2 = asint(v.Load((offset + 0u)));
  SB v_3 = {v_2, asfloat(v.Load((offset + 4u)))};
  return v_3;
}

void foo() {
  SB a = v_1(0u);
  float b = asfloat(v.Load(4u));
}

)");
}

TEST_F(HlslWriterTest, AccessStorageNested) {
    auto* Inner =
        ty.Struct(mod.symbols.New("Inner"), {
                                                {mod.symbols.New("s"), ty.mat3x3<f32>()},
                                                {mod.symbols.New("t"), ty.array<vec3<f32>, 5>()},
                                            });
    auto* Outer = ty.Struct(mod.symbols.New("Outer"), {
                                                          {mod.symbols.New("x"), ty.f32()},
                                                          {mod.symbols.New("y"), Inner},
                                                      });

    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), Outer},
                                                });

    auto* var = b.Var("v", storage, SB, core::Access::kRead);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.LoadVectorElement(b.Access(ty.ptr<storage, vec3<f32>, core::Access::kRead>(),
                                                var, 1_u, 1_u, 1_u, 3_u),
                                       2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(struct Inner {
  float3x3 s;
  float3 t[5];
};

struct Outer {
  float x;
  Inner y;
};

struct SB {
  int a;
  Outer b;
};


ByteAddressBuffer v : register(t0);
typedef float3 ary_ret[5];
ary_ret v_1(uint offset) {
  float3 a[5] = (float3[5])0;
  {
    uint v_2 = 0u;
    v_2 = 0u;
    while(true) {
      uint v_3 = v_2;
      if ((v_3 >= 5u)) {
        break;
      }
      a[v_3] = asfloat(v.Load3((offset + (v_3 * 16u))));
      {
        v_2 = (v_3 + 1u);
      }
      continue;
    }
  }
  float3 v_4[5] = a;
  return v_4;
}

float3x3 v_5(uint offset) {
  float3 v_6 = asfloat(v.Load3((offset + 0u)));
  float3 v_7 = asfloat(v.Load3((offset + 16u)));
  return float3x3(v_6, v_7, asfloat(v.Load3((offset + 32u))));
}

Inner v_8(uint offset) {
  float3x3 v_9 = v_5((offset + 0u));
  float3 v_10[5] = v_1((offset + 48u));
  Inner v_11 = {v_9, v_10};
  return v_11;
}

Outer v_12(uint offset) {
  float v_13 = asfloat(v.Load((offset + 0u)));
  Inner v_14 = v_8((offset + 16u));
  Outer v_15 = {v_13, v_14};
  return v_15;
}

SB v_16(uint offset) {
  int v_17 = asint(v.Load((offset + 0u)));
  Outer v_18 = v_12((offset + 16u));
  SB v_19 = {v_17, v_18};
  return v_19;
}

void foo() {
  SB a = v_16(0u);
  float b = asfloat(v.Load(136u));
}

)");
}

TEST_F(HlslWriterTest, AccessStorageStoreVector) {
    auto* var = b.Var<storage, vec4<f32>, core::Access::kReadWrite>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.StoreVectorElement(var, 0_u, 2_f);
        b.StoreVectorElement(var, 1_u, 4_f);
        b.StoreVectorElement(var, 2_u, 8_f);
        b.StoreVectorElement(var, 3_u, 16_f);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  v.Store(0u, asuint(2.0f));
  v.Store(4u, asuint(4.0f));
  v.Store(8u, asuint(8.0f));
  v.Store(12u, asuint(16.0f));
}

)");
}

TEST_F(HlslWriterTest, AccessDirectVariable) {
    auto* var1 = b.Var<storage, vec4<f32>, core::Access::kRead>("v1");
    var1->SetBindingPoint(0, 0);
    b.ir.root_block->Append(var1);

    auto* var2 = b.Var<storage, vec4<f32>, core::Access::kRead>("v2");
    var2->SetBindingPoint(0, 1);
    b.ir.root_block->Append(var2);

    auto* p = b.FunctionParam("x", ty.ptr<storage, vec4<f32>, core::Access::kRead>());
    auto* bar = b.Function("bar", ty.void_());
    bar->SetParams({p});
    b.Append(bar->Block(), [&] {
        b.Let("a", b.LoadVectorElement(p, 1_u));
        b.Return(bar);
    });

    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Call(bar, var1);
        b.Call(bar, var2);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
ByteAddressBuffer v1 : register(t0);
ByteAddressBuffer v2 : register(t1);
void bar() {
  float a = asfloat(v1.Load(4u));
}

void bar_1() {
  float a = asfloat(v2.Load(4u));
}

void foo() {
  bar();
  bar_1();
}

)");
}

TEST_F(HlslWriterTest, AccessChainFromUnnamedAccessChain) {
    auto* Inner = ty.Struct(mod.symbols.New("Inner"), {
                                                          {mod.symbols.New("c"), ty.f32()},
                                                          {mod.symbols.New("d"), ty.u32()},
                                                      });
    auto* sb = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), Inner},
                                                });

    auto* var = b.Var("v", storage, sb, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);
    b.ir.root_block->Append(var);

    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* x = b.Access(ty.ptr(storage, sb, core::Access::kReadWrite), var);
        auto* y = b.Access(ty.ptr(storage, Inner, core::Access::kReadWrite), x->Result(0), 1_u);
        b.Let("b", b.Load(b.Access(ty.ptr(storage, ty.u32(), core::Access::kReadWrite),
                                   y->Result(0), 1_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  uint b = v.Load(8u);
}

)");
}

TEST_F(HlslWriterTest, AccessChainFromLetAccessChain) {
    auto* Inner = ty.Struct(mod.symbols.New("Inner"), {
                                                          {mod.symbols.New("c"), ty.f32()},
                                                      });
    auto* sb = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), Inner},
                                                });

    auto* var = b.Var("v", storage, sb, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);
    b.ir.root_block->Append(var);

    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* x = b.Let("x", var);
        auto* y = b.Let(
            "y", b.Access(ty.ptr(storage, Inner, core::Access::kReadWrite), x->Result(0), 1_u));
        auto* z = b.Let(
            "z", b.Access(ty.ptr(storage, ty.f32(), core::Access::kReadWrite), y->Result(0), 0_u));
        b.Let("a", b.Load(z));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  float a = asfloat(v.Load(4u));
}

)");
}

TEST_F(HlslWriterTest, AccessComplexDynamicAccessChain) {
    auto* S1 = ty.Struct(mod.symbols.New("S1"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.vec3<f32>()},
                                                    {mod.symbols.New("c"), ty.i32()},
                                                });
    auto* S2 = ty.Struct(mod.symbols.New("S2"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.array(S1, 3)},
                                                    {mod.symbols.New("c"), ty.i32()},
                                                });

    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.runtime_array(S2)},
                                                });

    auto* var = b.Var("sb", storage, SB, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* i = b.Load(b.Var("i", 4_i));
        auto* j = b.Load(b.Var("j", 1_u));
        auto* k = b.Load(b.Var("k", 2_i));
        // let x : f32 = sb.b[i].b[j].b[k];
        b.Let("x",
              b.LoadVectorElement(
                  b.Access(ty.ptr<storage, vec3<f32>, read_write>(), var, 1_u, i, 1_u, j, 1_u), k));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer sb : register(u0);
void foo() {
  int i = 4;
  int v = i;
  uint j = 1u;
  uint v_1 = j;
  int k = 2;
  int v_2 = k;
  uint v_3 = 0u;
  sb.GetDimensions(v_3);
  uint v_4 = (((v_3 - 16u) / 128u) - 1u);
  uint v_5 = min(uint(v), v_4);
  uint v_6 = min(v_1, 2u);
  uint v_7 = (uint(v_5) * 128u);
  uint v_8 = (uint(v_6) * 32u);
  float x = asfloat(sb.Load((((48u + v_7) + v_8) + (uint(min(uint(v_2), 2u)) * 4u))));
}

)");
}

TEST_F(HlslWriterTest, AccessComplexDynamicAccessChainSplit) {
    auto* S1 = ty.Struct(mod.symbols.New("S1"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.vec3<f32>()},
                                                    {mod.symbols.New("c"), ty.i32()},
                                                });
    auto* S2 = ty.Struct(mod.symbols.New("S2"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.array(S1, 3)},
                                                    {mod.symbols.New("c"), ty.i32()},
                                                });

    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.runtime_array(S2)},
                                                });

    auto* var = b.Var("sb", storage, SB, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* j = b.Load(b.Var("j", 1_u));
        b.Let("x", b.LoadVectorElement(b.Access(ty.ptr<storage, vec3<f32>, read_write>(), var, 1_u,
                                                4_u, 1_u, j, 1_u),
                                       2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer sb : register(u0);
void foo() {
  uint j = 1u;
  uint v = j;
  uint v_1 = 0u;
  sb.GetDimensions(v_1);
  uint v_2 = min(4u, (((v_1 - 16u) / 128u) - 1u));
  uint v_3 = min(v, 2u);
  uint v_4 = (uint(v_2) * 128u);
  float x = asfloat(sb.Load(((56u + v_4) + (uint(v_3) * 32u))));
}

)");
}

TEST_F(HlslWriterTest, AccessUniformChainFromUnnamedAccessChain) {
    auto* Inner = ty.Struct(mod.symbols.New("Inner"), {
                                                          {mod.symbols.New("c"), ty.f32()},
                                                          {mod.symbols.New("d"), ty.u32()},
                                                      });

    tint::Vector<const core::type::StructMember*, 2> members;
    members.Push(ty.Get<core::type::StructMember>(mod.symbols.New("a"), ty.i32(), 0u, 0u, 4u,
                                                  ty.i32()->Size(), core::IOAttributes{}));
    members.Push(ty.Get<core::type::StructMember>(mod.symbols.New("b"), Inner, 1u, 16u, 16u,
                                                  Inner->Size(), core::IOAttributes{}));
    auto* sb = ty.Struct(mod.symbols.New("SB"), members);

    auto* var = b.Var("v", uniform, sb, core::Access::kRead);
    var->SetBindingPoint(0, 0);
    b.ir.root_block->Append(var);

    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* x = b.Access(ty.ptr(uniform, sb, core::Access::kRead), var);
        auto* y = b.Access(ty.ptr(uniform, Inner, core::Access::kRead), x->Result(0), 1_u);
        b.Let("b",
              b.Load(b.Access(ty.ptr(uniform, ty.u32(), core::Access::kRead), y->Result(0), 1_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[2];
};
void foo() {
  uint b = v[1u].y;
}

)");
}

TEST_F(HlslWriterTest, AccessUniformChainFromLetAccessChain) {
    auto* Inner = ty.Struct(mod.symbols.New("Inner"), {
                                                          {mod.symbols.New("c"), ty.f32()},
                                                      });
    tint::Vector<const core::type::StructMember*, 2> members;
    members.Push(ty.Get<core::type::StructMember>(mod.symbols.New("a"), ty.i32(), 0u, 0u, 4u,
                                                  ty.i32()->Size(), core::IOAttributes{}));
    members.Push(ty.Get<core::type::StructMember>(mod.symbols.New("b"), Inner, 1u, 16u, 16u,
                                                  Inner->Size(), core::IOAttributes{}));
    auto* sb = ty.Struct(mod.symbols.New("SB"), members);

    auto* var = b.Var("v", uniform, sb, core::Access::kRead);
    var->SetBindingPoint(0, 0);
    b.ir.root_block->Append(var);

    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* x = b.Let("x", var);
        auto* y =
            b.Let("y", b.Access(ty.ptr(uniform, Inner, core::Access::kRead), x->Result(0), 1_u));
        auto* z =
            b.Let("z", b.Access(ty.ptr(uniform, ty.f32(), core::Access::kRead), y->Result(0), 0_u));
        b.Let("a", b.Load(z));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[2];
};
void foo() {
  float a = asfloat(v[1u].x);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformVector) {
    auto* var = b.Var<uniform, vec4<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.LoadVectorElement(var, 0_u));
        b.Let("c", b.LoadVectorElement(var, 1_u));
        b.Let("d", b.LoadVectorElement(var, 2_u));
        b.Let("e", b.LoadVectorElement(var, 3_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[1];
};
void foo() {
  float4 a = asfloat(v[0u]);
  float b = asfloat(v[0u].x);
  float c = asfloat(v[0u].y);
  float d = asfloat(v[0u].z);
  float e = asfloat(v[0u].w);
}

)");
}

TEST_F(HlslWriterTest, DISABLED_AccessUniformStorageVectorF16) {
    auto* var = b.Var<uniform, vec4<f16>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.LoadVectorElement(var, 0_u));
        b.Let("c", b.LoadVectorElement(var, 1_u));
        b.Let("d", b.LoadVectorElement(var, 2_u));
        b.Let("e", b.LoadVectorElement(var, 3_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[1];
};
void foo() {
  uint2 ubo_load = v[0].xy;
  vector<float16_t, 2> ubo_load_xz = vector<float16_t, 2>(f16tof32(ubo_load & 0xFFFF));
  vector<float16_t, 2> ubo_load_yw = vector<float16_t, 2>(f16tof32(ubo_load >> 16));
  vector<float16_t, 4> a = vector<float16_t, 4>(ubo_load_xz[0], ubo_load_yw[0], ubo_load_xz[1], ubo_load_yw[1]);
  float16_t b = float16_t(f16tof32(((v[0].x) & 0xFFFF)));
  float16_t c = float16_t(f16tof32(((v[0].x >> 16) & 0xFFFF)));
  float16_t d = float16_t(f16tof32(((v[0].y) & 0xFFFF)));
  float16_t e = float16_t(f16tof32(((v[0].y >> 16) & 0xFFFF)));
}

)");
}

TEST_F(HlslWriterTest, AccessUniformMatrix) {
    auto* var = b.Var<uniform, mat4x4<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, vec4<f32>, core::Access::kRead>(), var, 3_u)));
        b.Let("c", b.LoadVectorElement(
                       b.Access(ty.ptr<uniform, vec4<f32>, core::Access::kRead>(), var, 1_u), 2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[4];
};
float4x4 v_1(uint start_byte_offset) {
  float4 v_2 = asfloat(v[(start_byte_offset / 16u)]);
  float4 v_3 = asfloat(v[((16u + start_byte_offset) / 16u)]);
  float4 v_4 = asfloat(v[((32u + start_byte_offset) / 16u)]);
  return float4x4(v_2, v_3, v_4, asfloat(v[((48u + start_byte_offset) / 16u)]));
}

void foo() {
  float4x4 a = v_1(0u);
  float4 b = asfloat(v[3u]);
  float c = asfloat(v[1u].z);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformMatrix2x3) {
    auto* var = b.Var<uniform, mat2x3<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, vec3<f32>, core::Access::kRead>(), var, 1_u)));
        b.Let("c", b.LoadVectorElement(
                       b.Access(ty.ptr<uniform, vec3<f32>, core::Access::kRead>(), var, 1_u), 2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[2];
};
float2x3 v_1(uint start_byte_offset) {
  float3 v_2 = asfloat(v[(start_byte_offset / 16u)].xyz);
  return float2x3(v_2, asfloat(v[((16u + start_byte_offset) / 16u)].xyz));
}

void foo() {
  float2x3 a = v_1(0u);
  float3 b = asfloat(v[1u].xyz);
  float c = asfloat(v[1u].z);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformMatrix3x2) {
    auto* var = b.Var<uniform, mat3x2<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, vec2<f32>, core::Access::kRead>(), var, 1_u)));
        b.Let("c", b.LoadVectorElement(
                       b.Access(ty.ptr<uniform, vec2<f32>, core::Access::kRead>(), var, 1_u), 1_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[2];
};
float3x2 v_1(uint start_byte_offset) {
  uint4 v_2 = v[(start_byte_offset / 16u)];
  float2 v_3 = asfloat((((((start_byte_offset % 16u) / 4u) == 2u)) ? (v_2.zw) : (v_2.xy)));
  uint4 v_4 = v[((8u + start_byte_offset) / 16u)];
  float2 v_5 = asfloat(((((((8u + start_byte_offset) % 16u) / 4u) == 2u)) ? (v_4.zw) : (v_4.xy)));
  uint4 v_6 = v[((16u + start_byte_offset) / 16u)];
  return float3x2(v_3, v_5, asfloat(((((((16u + start_byte_offset) % 16u) / 4u) == 2u)) ? (v_6.zw) : (v_6.xy))));
}

void foo() {
  float3x2 a = v_1(0u);
  float2 b = asfloat(v[0u].zw);
  float c = asfloat(v[0u].w);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformMatrix2x2) {
    auto* var = b.Var<uniform, mat2x2<f32>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, vec2<f32>, core::Access::kRead>(), var, 1_u)));
        b.Let("c", b.LoadVectorElement(
                       b.Access(ty.ptr<uniform, vec2<f32>, core::Access::kRead>(), var, 1_u), 1_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[1];
};
float2x2 v_1(uint start_byte_offset) {
  uint4 v_2 = v[(start_byte_offset / 16u)];
  float2 v_3 = asfloat((((((start_byte_offset % 16u) / 4u) == 2u)) ? (v_2.zw) : (v_2.xy)));
  uint4 v_4 = v[((8u + start_byte_offset) / 16u)];
  return float2x2(v_3, asfloat(((((((8u + start_byte_offset) % 16u) / 4u) == 2u)) ? (v_4.zw) : (v_4.xy))));
}

void foo() {
  float2x2 a = v_1(0u);
  float2 b = asfloat(v[0u].zw);
  float c = asfloat(v[0u].w);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformArray) {
    auto* var = b.Var<uniform, array<vec3<f32>, 5>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, vec3<f32>, core::Access::kRead>(), var, 3_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[5];
};
typedef float3 ary_ret[5];
ary_ret v_1(uint start_byte_offset) {
  float3 a[5] = (float3[5])0;
  {
    uint v_2 = 0u;
    v_2 = 0u;
    while(true) {
      uint v_3 = v_2;
      if ((v_3 >= 5u)) {
        break;
      }
      a[v_3] = asfloat(v[((start_byte_offset + (v_3 * 16u)) / 16u)].xyz);
      {
        v_2 = (v_3 + 1u);
      }
      continue;
    }
  }
  float3 v_4[5] = a;
  return v_4;
}

void foo() {
  float3 a[5] = v_1(0u);
  float3 b = asfloat(v[3u].xyz);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformArrayWhichCanHaveSizesOtherThenFive) {
    auto* var = b.Var<uniform, array<vec3<f32>, 42>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, vec3<f32>, core::Access::kRead>(), var, 3_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
cbuffer cbuffer_v : register(b0) {
  uint4 v[42];
};
typedef float3 ary_ret[42];
ary_ret v_1(uint start_byte_offset) {
  float3 a[42] = (float3[42])0;
  {
    uint v_2 = 0u;
    v_2 = 0u;
    while(true) {
      uint v_3 = v_2;
      if ((v_3 >= 42u)) {
        break;
      }
      a[v_3] = asfloat(v[((start_byte_offset + (v_3 * 16u)) / 16u)].xyz);
      {
        v_2 = (v_3 + 1u);
      }
      continue;
    }
  }
  float3 v_4[42] = a;
  return v_4;
}

void foo() {
  float3 a[42] = v_1(0u);
  float3 b = asfloat(v[3u].xyz);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformStruct) {
    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.f32()},
                                                });

    auto* var = b.Var("v", uniform, SB, core::Access::kRead);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.Load(b.Access(ty.ptr<uniform, f32, core::Access::kRead>(), var, 1_u)));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(struct SB {
  int a;
  float b;
};


cbuffer cbuffer_v : register(b0) {
  uint4 v[1];
};
SB v_1(uint start_byte_offset) {
  int v_2 = asint(v[(start_byte_offset / 16u)][((start_byte_offset % 16u) / 4u)]);
  SB v_3 = {v_2, asfloat(v[((4u + start_byte_offset) / 16u)][(((4u + start_byte_offset) % 16u) / 4u)])};
  return v_3;
}

void foo() {
  SB a = v_1(0u);
  float b = asfloat(v[0u].y);
}

)");
}

TEST_F(HlslWriterTest, AccessUniformStructNested) {
    auto* Inner =
        ty.Struct(mod.symbols.New("Inner"), {
                                                {mod.symbols.New("s"), ty.mat3x3<f32>()},
                                                {mod.symbols.New("t"), ty.array<vec3<f32>, 5>()},
                                            });
    auto* Outer = ty.Struct(mod.symbols.New("Outer"), {
                                                          {mod.symbols.New("x"), ty.f32()},
                                                          {mod.symbols.New("y"), Inner},
                                                      });

    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), Outer},
                                                });

    auto* var = b.Var("v", uniform, SB, core::Access::kRead);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Let("a", b.Load(var));
        b.Let("b", b.LoadVectorElement(b.Access(ty.ptr<uniform, vec3<f32>, core::Access::kRead>(),
                                                var, 1_u, 1_u, 1_u, 3_u),
                                       2_u));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(struct Inner {
  float3x3 s;
  float3 t[5];
};

struct Outer {
  float x;
  Inner y;
};

struct SB {
  int a;
  Outer b;
};


cbuffer cbuffer_v : register(b0) {
  uint4 v[10];
};
typedef float3 ary_ret[5];
ary_ret v_1(uint start_byte_offset) {
  float3 a[5] = (float3[5])0;
  {
    uint v_2 = 0u;
    v_2 = 0u;
    while(true) {
      uint v_3 = v_2;
      if ((v_3 >= 5u)) {
        break;
      }
      a[v_3] = asfloat(v[((start_byte_offset + (v_3 * 16u)) / 16u)].xyz);
      {
        v_2 = (v_3 + 1u);
      }
      continue;
    }
  }
  float3 v_4[5] = a;
  return v_4;
}

float3x3 v_5(uint start_byte_offset) {
  float3 v_6 = asfloat(v[(start_byte_offset / 16u)].xyz);
  float3 v_7 = asfloat(v[((16u + start_byte_offset) / 16u)].xyz);
  return float3x3(v_6, v_7, asfloat(v[((32u + start_byte_offset) / 16u)].xyz));
}

Inner v_8(uint start_byte_offset) {
  float3x3 v_9 = v_5(start_byte_offset);
  float3 v_10[5] = v_1((48u + start_byte_offset));
  Inner v_11 = {v_9, v_10};
  return v_11;
}

Outer v_12(uint start_byte_offset) {
  float v_13 = asfloat(v[(start_byte_offset / 16u)][((start_byte_offset % 16u) / 4u)]);
  Inner v_14 = v_8((16u + start_byte_offset));
  Outer v_15 = {v_13, v_14};
  return v_15;
}

SB v_16(uint start_byte_offset) {
  int v_17 = asint(v[(start_byte_offset / 16u)][((start_byte_offset % 16u) / 4u)]);
  Outer v_18 = v_12((16u + start_byte_offset));
  SB v_19 = {v_17, v_18};
  return v_19;
}

void foo() {
  SB a = v_16(0u);
  float b = asfloat(v[8u].z);
}

)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreMatrixElement) {
    auto* var = b.Var<storage, mat4x4<f32>, core::Access::kReadWrite>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.StoreVectorElement(
            b.Access(ty.ptr<storage, vec4<f32>, core::Access::kReadWrite>(), var, 1_u), 2_u, 5_f);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  v.Store(24u, asuint(5.0f));
}
)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreMatrixColumn) {
    auto* var = b.Var<storage, mat4x4<f32>, core::Access::kReadWrite>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Store(b.Access(ty.ptr<storage, vec4<f32>, core::Access::kReadWrite>(), var, 1_u),
                b.Splat<vec4<f32>>(5_f));
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  v2.Store4(16u, asuint((5.0f).xxxx));
}
)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreMatrix) {
    auto* var = b.Var<storage, mat4x4<f32>, core::Access::kReadWrite>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Store(var, b.Zero<mat4x4<f32>>());
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void v_1(uint offset, float4x4 value) {
  v.Store4((offset + 0u), asuint(value[0u]));
  v.Store4((offset + 16u), asuint(value[1u]));
  v.Store4((offset + 32u), asuint(value[2u]));
  v.Store4((offset + 48u), asuint(value[3u]));
}

void foo() {
  v_1(0u, float4x4((0.0f).xxxx, (0.0f).xxxx, (0.0f).xxxx, (0.0f).xxxx));
}
)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreArrayElement) {
    auto* var = b.Var<storage, array<f32, 5>, core::Access::kReadWrite>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Store(b.Access(ty.ptr<storage, f32, core::Access::kReadWrite>(), var, 3_u), 1_f);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  v.Store(12u, asuint(1.0f));
}
)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreArray) {
    auto* var = b.Var<storage, array<vec3<f32>, 5>, core::Access::kRead>("v");
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* ary = b.Let("ary", b.Zero<array<vec3<f32>, 5>>());
        b.Store(var, ary);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void v_1(uint offset, float value[5]) {
  float array_1[5] = value;
  {
    for(uint i = 0u; (i < 5u); i = (i + 1u)) {
      v.Store((offset + (i * 4u)), asuint(array_1[i]));
    }
  }
}

void foo() {
  float tint_symbol[5] = (float[5])0;
  v_1(0u, tint_symbol);
}

)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreStructMember) {
    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), ty.f32()},
                                                });

    auto* var = b.Var("v", storage, SB, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Store(b.Access(ty.ptr<storage, f32, core::Access::kReadWrite>(), var, 1_u), 3_f);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
RWByteAddressBuffer v : register(u0);
void foo() {
  v.Store(4u, asuint(3.0f));
}
)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreStructNested) {
    auto* Inner =
        ty.Struct(mod.symbols.New("Inner"), {
                                                {mod.symbols.New("s"), ty.mat3x3<f32>()},
                                                {mod.symbols.New("t"), ty.array<vec3<f32>, 5>()},
                                            });
    auto* Outer = ty.Struct(mod.symbols.New("Outer"), {
                                                          {mod.symbols.New("x"), ty.f32()},
                                                          {mod.symbols.New("y"), Inner},
                                                      });

    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), Outer},
                                                });

    auto* var = b.Var("v", storage, SB, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        b.Store(b.Access(ty.ptr<storage, f32, core::Access::kReadWrite>(), var, 1_u, 0_u), 2_f);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
struct Inner {
  float3x3 s;
  float3 t[5];
};
struct Outer {
  float x;
  Inner y;
};
struct SB2 {
  int a;
  Outer b;
};

RWByteAddressBuffer v : register(u0);
void foo() {
  v.Store(16u, asuint(2.0f));
}
)");
}

TEST_F(HlslWriterTest, DISABLED_AccessStoreStruct) {
    auto* Inner =
        ty.Struct(mod.symbols.New("Inner"), {
                                                {mod.symbols.New("s"), ty.mat3x3<f32>()},
                                                {mod.symbols.New("t"), ty.array<vec3<f32>, 5>()},
                                            });
    auto* Outer = ty.Struct(mod.symbols.New("Outer"), {
                                                          {mod.symbols.New("x"), ty.f32()},
                                                          {mod.symbols.New("y"), Inner},
                                                      });

    auto* SB = ty.Struct(mod.symbols.New("SB"), {
                                                    {mod.symbols.New("a"), ty.i32()},
                                                    {mod.symbols.New("b"), Outer},
                                                });

    auto* var = b.Var("v", storage, SB, core::Access::kReadWrite);
    var->SetBindingPoint(0, 0);

    b.ir.root_block->Append(var);
    auto* func = b.Function("foo", ty.void_(), core::ir::Function::PipelineStage::kFragment);
    b.Append(func->Block(), [&] {
        auto* s = b.Let("s", b.Zero(SB));
        b.Store(var, s);
        b.Return(func);
    });

    ASSERT_TRUE(Generate()) << err_ << output_.hlsl;
    EXPECT_EQ(output_.hlsl, R"(
struct Inner {
  float3x3 s;
  float3 t[5];
};
struct Outer {
  float x;
  Inner y;
};
struct SB2 {
  int a;
  Outer b;
};

RWByteAddressBuffer v : register(u0);
void v_5(uint offset, float3x3 value) {
  v.Store3((offset + 0u), asuint(value[0u]));
  v.Store3((offset + 16u), asuint(value[1u]));
  v.Store3((offset + 32u), asuint(value[2u]));
}

void v_4(uint offset, float3 value[5]) {
  float3 array_2[5] = value;
  {
    for(uint i_1 = 0u; (i_1 < 5u); i_1 = (i_1 + 1u)) {
      v.Store3((offset + (i_1 * 16u)), asuint(array_2[i_1]));
    }
  }
}

void v_3(uint offset, Inner value) {
  v_5((offset + 0u), value.s);
  v_4((offset + 48u), value.t);
}

void v_2(uint offset, Outer value) {
  v.Store((offset + 0u), asuint(value.x));
  v_3((offset + 16u), value.y);
}

void v_1(uint offset, SB2 value) {
  v.Store((offset + 0u), asuint(value.a));
  v_2((offset + 16u), value.b);
}

void foo() {
  SB2 tint_symbol_1 = (SB2)0;
  v_1(0u, tint_symbol_1);
}

)");
}

}  // namespace
}  // namespace tint::hlsl::writer
