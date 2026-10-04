struct main_inputs {
  uint idx : SV_GroupIndex;
};


cbuffer cbuffer_ub : register(b0) {
  uint4 ub[272];
};
RWByteAddressBuffer s : register(u1);
int tint_f32_to_i32(float value) {
  return int(clamp(value, -2147483648.0f, 2147483520.0f));
}

typedef float3 ary_ret[2];
ary_ret v(uint start_byte_offset) {
  float3 v_1[2] = {asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz)};
  return v_1;
}

float4x4 v_2(uint start_byte_offset) {
  return float4x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]), asfloat(ub[((48u + start_byte_offset) / 16u)]));
}

float4x3 v_3(uint start_byte_offset) {
  return float4x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz), asfloat(ub[((48u + start_byte_offset) / 16u)].xyz));
}

float4x2 v_4(uint start_byte_offset) {
  uint4 v_5 = ub[(start_byte_offset / 16u)];
  float2 v_6 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_5.zw) : (v_5.xy)));
  uint v_7 = (8u + start_byte_offset);
  uint4 v_8 = ub[(v_7 / 16u)];
  float2 v_9 = asfloat((((((v_7 & 15u) >> 2u) == 2u)) ? (v_8.zw) : (v_8.xy)));
  uint v_10 = (16u + start_byte_offset);
  uint4 v_11 = ub[(v_10 / 16u)];
  float2 v_12 = asfloat((((((v_10 & 15u) >> 2u) == 2u)) ? (v_11.zw) : (v_11.xy)));
  uint v_13 = (24u + start_byte_offset);
  uint4 v_14 = ub[(v_13 / 16u)];
  return float4x2(v_6, v_9, v_12, asfloat((((((v_13 & 15u) >> 2u) == 2u)) ? (v_14.zw) : (v_14.xy))));
}

float3x4 v_15(uint start_byte_offset) {
  return float3x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]));
}

float3x3 v_16(uint start_byte_offset) {
  return float3x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz));
}

float3x2 v_17(uint start_byte_offset) {
  uint4 v_18 = ub[(start_byte_offset / 16u)];
  float2 v_19 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_18.zw) : (v_18.xy)));
  uint v_20 = (8u + start_byte_offset);
  uint4 v_21 = ub[(v_20 / 16u)];
  float2 v_22 = asfloat((((((v_20 & 15u) >> 2u) == 2u)) ? (v_21.zw) : (v_21.xy)));
  uint v_23 = (16u + start_byte_offset);
  uint4 v_24 = ub[(v_23 / 16u)];
  return float3x2(v_19, v_22, asfloat((((((v_23 & 15u) >> 2u) == 2u)) ? (v_24.zw) : (v_24.xy))));
}

float2x4 v_25(uint start_byte_offset) {
  return float2x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]));
}

float2x3 v_26(uint start_byte_offset) {
  return float2x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz));
}

float2x2 v_27(uint start_byte_offset) {
  uint4 v_28 = ub[(start_byte_offset / 16u)];
  float2 v_29 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_28.zw) : (v_28.xy)));
  uint v_30 = (8u + start_byte_offset);
  uint4 v_31 = ub[(v_30 / 16u)];
  return float2x2(v_29, asfloat((((((v_30 & 15u) >> 2u) == 2u)) ? (v_31.zw) : (v_31.xy))));
}

void main_inner(uint idx) {
  uint v_32 = (idx * 544u);
  float scalar_f32 = asfloat(ub[(v_32 / 16u)][((v_32 & 15u) >> 2u)]);
  uint v_33 = (4u + (idx * 544u));
  int scalar_i32 = asint(ub[(v_33 / 16u)][((v_33 & 15u) >> 2u)]);
  uint v_34 = (8u + (idx * 544u));
  uint scalar_u32 = ub[(v_34 / 16u)][((v_34 & 15u) >> 2u)];
  uint v_35 = (16u + (idx * 544u));
  uint4 v_36 = ub[(v_35 / 16u)];
  float2 vec2_f32 = asfloat((((((v_35 & 15u) >> 2u) == 2u)) ? (v_36.zw) : (v_36.xy)));
  uint v_37 = (24u + (idx * 544u));
  uint4 v_38 = ub[(v_37 / 16u)];
  int2 vec2_i32 = asint((((((v_37 & 15u) >> 2u) == 2u)) ? (v_38.zw) : (v_38.xy)));
  uint v_39 = (32u + (idx * 544u));
  uint4 v_40 = ub[(v_39 / 16u)];
  uint2 vec2_u32 = (((((v_39 & 15u) >> 2u) == 2u)) ? (v_40.zw) : (v_40.xy));
  float3 vec3_f32 = asfloat(ub[((48u + (idx * 544u)) / 16u)].xyz);
  int3 vec3_i32 = asint(ub[((64u + (idx * 544u)) / 16u)].xyz);
  uint3 vec3_u32 = ub[((80u + (idx * 544u)) / 16u)].xyz;
  float4 vec4_f32 = asfloat(ub[((96u + (idx * 544u)) / 16u)]);
  int4 vec4_i32 = asint(ub[((112u + (idx * 544u)) / 16u)]);
  uint4 vec4_u32 = ub[((128u + (idx * 544u)) / 16u)];
  float2x2 mat2x2_f32 = v_27((144u + (idx * 544u)));
  float2x3 mat2x3_f32 = v_26((160u + (idx * 544u)));
  float2x4 mat2x4_f32 = v_25((192u + (idx * 544u)));
  float3x2 mat3x2_f32 = v_17((224u + (idx * 544u)));
  float3x3 mat3x3_f32 = v_16((256u + (idx * 544u)));
  float3x4 mat3x4_f32 = v_15((304u + (idx * 544u)));
  float4x2 mat4x2_f32 = v_4((352u + (idx * 544u)));
  float4x3 mat4x3_f32 = v_3((384u + (idx * 544u)));
  float4x4 mat4x4_f32 = v_2((448u + (idx * 544u)));
  float3 arr2_vec3_f32[2] = v((512u + (idx * 544u)));
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
  s.Store(0u, asuint(asint((asuint(v_57) + asuint(tint_f32_to_i32(arr2_vec3_f32[int(0)].x))))));
}

[numthreads(1, 1, 1)]
void main(main_inputs inputs) {
  main_inner(inputs.idx);
}

