struct Inner {
  int scalar_i32;
  float scalar_f32;
};


cbuffer cbuffer_ub : register(b0) {
  uint4 ub[44];
};
RWByteAddressBuffer s : register(u1);
int tint_f32_to_i32(float value) {
  return int(clamp(value, -2147483648.0f, 2147483520.0f));
}

Inner v(uint start_byte_offset) {
  uint v_1 = (16u + start_byte_offset);
  Inner v_2 = {asint(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]), asfloat(ub[(v_1 / 16u)][((v_1 & 15u) >> 2u)])};
  return v_2;
}

typedef Inner ary_ret[4];
ary_ret v_3(uint start_byte_offset) {
  Inner v_4 = v(start_byte_offset);
  Inner v_5 = v((32u + start_byte_offset));
  Inner v_6 = v((64u + start_byte_offset));
  Inner v_7 = v((96u + start_byte_offset));
  Inner v_8[4] = {v_4, v_5, v_6, v_7};
  return v_8;
}

typedef float3 ary_ret_1[2];
ary_ret_1 v_9(uint start_byte_offset) {
  float3 v_10[2] = {asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz)};
  return v_10;
}

float4x4 v_11(uint start_byte_offset) {
  return float4x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]), asfloat(ub[((48u + start_byte_offset) / 16u)]));
}

float4x3 v_12(uint start_byte_offset) {
  return float4x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz), asfloat(ub[((48u + start_byte_offset) / 16u)].xyz));
}

float4x2 v_13(uint start_byte_offset) {
  uint4 v_14 = ub[(start_byte_offset / 16u)];
  float2 v_15 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_14.zw) : (v_14.xy)));
  uint v_16 = (8u + start_byte_offset);
  uint4 v_17 = ub[(v_16 / 16u)];
  float2 v_18 = asfloat((((((v_16 & 15u) >> 2u) == 2u)) ? (v_17.zw) : (v_17.xy)));
  uint v_19 = (16u + start_byte_offset);
  uint4 v_20 = ub[(v_19 / 16u)];
  float2 v_21 = asfloat((((((v_19 & 15u) >> 2u) == 2u)) ? (v_20.zw) : (v_20.xy)));
  uint v_22 = (24u + start_byte_offset);
  uint4 v_23 = ub[(v_22 / 16u)];
  return float4x2(v_15, v_18, v_21, asfloat((((((v_22 & 15u) >> 2u) == 2u)) ? (v_23.zw) : (v_23.xy))));
}

float3x4 v_24(uint start_byte_offset) {
  return float3x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]));
}

float3x3 v_25(uint start_byte_offset) {
  return float3x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz));
}

float3x2 v_26(uint start_byte_offset) {
  uint4 v_27 = ub[(start_byte_offset / 16u)];
  float2 v_28 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_27.zw) : (v_27.xy)));
  uint v_29 = (8u + start_byte_offset);
  uint4 v_30 = ub[(v_29 / 16u)];
  float2 v_31 = asfloat((((((v_29 & 15u) >> 2u) == 2u)) ? (v_30.zw) : (v_30.xy)));
  uint v_32 = (16u + start_byte_offset);
  uint4 v_33 = ub[(v_32 / 16u)];
  return float3x2(v_28, v_31, asfloat((((((v_32 & 15u) >> 2u) == 2u)) ? (v_33.zw) : (v_33.xy))));
}

float2x4 v_34(uint start_byte_offset) {
  return float2x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]));
}

float2x3 v_35(uint start_byte_offset) {
  return float2x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz));
}

float2x2 v_36(uint start_byte_offset) {
  uint4 v_37 = ub[(start_byte_offset / 16u)];
  float2 v_38 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_37.zw) : (v_37.xy)));
  uint v_39 = (8u + start_byte_offset);
  uint4 v_40 = ub[(v_39 / 16u)];
  return float2x2(v_38, asfloat((((((v_39 & 15u) >> 2u) == 2u)) ? (v_40.zw) : (v_40.xy))));
}

[numthreads(1, 1, 1)]
void main() {
  float scalar_f32 = asfloat(ub[0u].x);
  int scalar_i32 = asint(ub[0u].y);
  uint scalar_u32 = ub[0u].z;
  float2 vec2_f32 = asfloat(ub[1u].xy);
  int2 vec2_i32 = asint(ub[1u].zw);
  uint2 vec2_u32 = ub[2u].xy;
  float3 vec3_f32 = asfloat(ub[3u].xyz);
  int3 vec3_i32 = asint(ub[4u].xyz);
  uint3 vec3_u32 = ub[5u].xyz;
  float4 vec4_f32 = asfloat(ub[6u]);
  int4 vec4_i32 = asint(ub[7u]);
  uint4 vec4_u32 = ub[8u];
  float2x2 mat2x2_f32 = v_36(144u);
  float2x3 mat2x3_f32 = v_35(160u);
  float2x4 mat2x4_f32 = v_34(192u);
  float3x2 mat3x2_f32 = v_26(224u);
  float3x3 mat3x3_f32 = v_25(256u);
  float3x4 mat3x4_f32 = v_24(304u);
  float4x2 mat4x2_f32 = v_13(352u);
  float4x3 mat4x3_f32 = v_12(384u);
  float4x4 mat4x4_f32 = v_11(448u);
  float3 arr2_vec3_f32[2] = v_9(512u);
  Inner struct_inner = v(544u);
  Inner array_struct_inner[4] = v_3(576u);
  int v_41 = asint((asuint(tint_f32_to_i32(scalar_f32)) + asuint(scalar_i32)));
  int v_42 = asint((asuint(v_41) + asuint(int(scalar_u32))));
  int v_43 = asint((asuint(asint((asuint(v_42) + asuint(tint_f32_to_i32(vec2_f32.x))))) + asuint(vec2_i32.x)));
  int v_44 = asint((asuint(v_43) + asuint(int(vec2_u32.x))));
  int v_45 = asint((asuint(asint((asuint(v_44) + asuint(tint_f32_to_i32(vec3_f32.y))))) + asuint(vec3_i32.y)));
  int v_46 = asint((asuint(v_45) + asuint(int(vec3_u32.y))));
  int v_47 = asint((asuint(asint((asuint(v_46) + asuint(tint_f32_to_i32(vec4_f32.z))))) + asuint(vec4_i32.z)));
  int v_48 = asint((asuint(v_47) + asuint(int(vec4_u32.z))));
  int v_49 = asint((asuint(v_48) + asuint(tint_f32_to_i32(mat2x2_f32[int(0)].x))));
  int v_50 = asint((asuint(v_49) + asuint(tint_f32_to_i32(mat2x3_f32[int(0)].x))));
  int v_51 = asint((asuint(v_50) + asuint(tint_f32_to_i32(mat2x4_f32[int(0)].x))));
  int v_52 = asint((asuint(v_51) + asuint(tint_f32_to_i32(mat3x2_f32[int(0)].x))));
  int v_53 = asint((asuint(v_52) + asuint(tint_f32_to_i32(mat3x3_f32[int(0)].x))));
  int v_54 = asint((asuint(v_53) + asuint(tint_f32_to_i32(mat3x4_f32[int(0)].x))));
  int v_55 = asint((asuint(v_54) + asuint(tint_f32_to_i32(mat4x2_f32[int(0)].x))));
  int v_56 = asint((asuint(v_55) + asuint(tint_f32_to_i32(mat4x3_f32[int(0)].x))));
  int v_57 = asint((asuint(v_56) + asuint(tint_f32_to_i32(mat4x4_f32[int(0)].x))));
  s.Store(0u, asuint(asint((asuint(asint((asuint(asint((asuint(v_57) + asuint(tint_f32_to_i32(arr2_vec3_f32[int(0)].x))))) + asuint(struct_inner.scalar_i32)))) + asuint(array_struct_inner[int(0)].scalar_i32)))));
}

