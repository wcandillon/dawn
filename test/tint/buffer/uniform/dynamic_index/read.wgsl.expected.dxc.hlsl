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
  uint v_6 = (8u + start_byte_offset);
  uint4 v_7 = ub[(v_6 / 16u)];
  uint v_8 = (16u + start_byte_offset);
  uint4 v_9 = ub[(v_8 / 16u)];
  uint v_10 = (24u + start_byte_offset);
  uint4 v_11 = ub[(v_10 / 16u)];
  return float4x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_5.zw, v_5.xy)), asfloat(select((((v_6 & 15u) >> 2u) == 2u), v_7.zw, v_7.xy)), asfloat(select((((v_8 & 15u) >> 2u) == 2u), v_9.zw, v_9.xy)), asfloat(select((((v_10 & 15u) >> 2u) == 2u), v_11.zw, v_11.xy)));
}

float3x4 v_12(uint start_byte_offset) {
  return float3x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]));
}

float3x3 v_13(uint start_byte_offset) {
  return float3x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz));
}

float3x2 v_14(uint start_byte_offset) {
  uint4 v_15 = ub[(start_byte_offset / 16u)];
  uint v_16 = (8u + start_byte_offset);
  uint4 v_17 = ub[(v_16 / 16u)];
  uint v_18 = (16u + start_byte_offset);
  uint4 v_19 = ub[(v_18 / 16u)];
  return float3x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_15.zw, v_15.xy)), asfloat(select((((v_16 & 15u) >> 2u) == 2u), v_17.zw, v_17.xy)), asfloat(select((((v_18 & 15u) >> 2u) == 2u), v_19.zw, v_19.xy)));
}

float2x4 v_20(uint start_byte_offset) {
  return float2x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]));
}

float2x3 v_21(uint start_byte_offset) {
  return float2x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz));
}

float2x2 v_22(uint start_byte_offset) {
  uint4 v_23 = ub[(start_byte_offset / 16u)];
  uint v_24 = (8u + start_byte_offset);
  uint4 v_25 = ub[(v_24 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_23.zw, v_23.xy)), asfloat(select((((v_24 & 15u) >> 2u) == 2u), v_25.zw, v_25.xy)));
}

void main_inner(uint idx) {
  uint v_26 = (idx * 544u);
  float scalar_f32 = asfloat(ub[(v_26 / 16u)][((v_26 & 15u) >> 2u)]);
  uint v_27 = (4u + (idx * 544u));
  int scalar_i32 = asint(ub[(v_27 / 16u)][((v_27 & 15u) >> 2u)]);
  uint v_28 = (8u + (idx * 544u));
  uint scalar_u32 = ub[(v_28 / 16u)][((v_28 & 15u) >> 2u)];
  uint v_29 = (16u + (idx * 544u));
  uint4 v_30 = ub[(v_29 / 16u)];
  float2 vec2_f32 = asfloat(select((((v_29 & 15u) >> 2u) == 2u), v_30.zw, v_30.xy));
  uint v_31 = (24u + (idx * 544u));
  uint4 v_32 = ub[(v_31 / 16u)];
  int2 vec2_i32 = asint(select((((v_31 & 15u) >> 2u) == 2u), v_32.zw, v_32.xy));
  uint v_33 = (32u + (idx * 544u));
  uint4 v_34 = ub[(v_33 / 16u)];
  uint2 vec2_u32 = select((((v_33 & 15u) >> 2u) == 2u), v_34.zw, v_34.xy);
  float3 vec3_f32 = asfloat(ub[((48u + (idx * 544u)) / 16u)].xyz);
  int3 vec3_i32 = asint(ub[((64u + (idx * 544u)) / 16u)].xyz);
  uint3 vec3_u32 = ub[((80u + (idx * 544u)) / 16u)].xyz;
  float4 vec4_f32 = asfloat(ub[((96u + (idx * 544u)) / 16u)]);
  int4 vec4_i32 = asint(ub[((112u + (idx * 544u)) / 16u)]);
  uint4 vec4_u32 = ub[((128u + (idx * 544u)) / 16u)];
  float2x2 mat2x2_f32 = v_22((144u + (idx * 544u)));
  float2x3 mat2x3_f32 = v_21((160u + (idx * 544u)));
  float2x4 mat2x4_f32 = v_20((192u + (idx * 544u)));
  float3x2 mat3x2_f32 = v_14((224u + (idx * 544u)));
  float3x3 mat3x3_f32 = v_13((256u + (idx * 544u)));
  float3x4 mat3x4_f32 = v_12((304u + (idx * 544u)));
  float4x2 mat4x2_f32 = v_4((352u + (idx * 544u)));
  float4x3 mat4x3_f32 = v_3((384u + (idx * 544u)));
  float4x4 mat4x4_f32 = v_2((448u + (idx * 544u)));
  float3 arr2_vec3_f32[2] = v((512u + (idx * 544u)));
  int v_35 = asint((asuint(tint_f32_to_i32(scalar_f32)) + asuint(scalar_i32)));
  int v_36 = asint((asuint(v_35) + asuint(int(scalar_u32))));
  int v_37 = asint((asuint(asint((asuint(v_36) + asuint(tint_f32_to_i32(vec2_f32.x))))) + asuint(vec2_i32.x)));
  int v_38 = asint((asuint(v_37) + asuint(int(vec2_u32.x))));
  int v_39 = asint((asuint(asint((asuint(v_38) + asuint(tint_f32_to_i32(vec3_f32.y))))) + asuint(vec3_i32.y)));
  int v_40 = asint((asuint(v_39) + asuint(int(vec3_u32.y))));
  int v_41 = asint((asuint(asint((asuint(v_40) + asuint(tint_f32_to_i32(vec4_f32.z))))) + asuint(vec4_i32.z)));
  int v_42 = asint((asuint(v_41) + asuint(int(vec4_u32.z))));
  int v_43 = asint((asuint(v_42) + asuint(tint_f32_to_i32(mat2x2_f32[int(0)].x))));
  int v_44 = asint((asuint(v_43) + asuint(tint_f32_to_i32(mat2x3_f32[int(0)].x))));
  int v_45 = asint((asuint(v_44) + asuint(tint_f32_to_i32(mat2x4_f32[int(0)].x))));
  int v_46 = asint((asuint(v_45) + asuint(tint_f32_to_i32(mat3x2_f32[int(0)].x))));
  int v_47 = asint((asuint(v_46) + asuint(tint_f32_to_i32(mat3x3_f32[int(0)].x))));
  int v_48 = asint((asuint(v_47) + asuint(tint_f32_to_i32(mat3x4_f32[int(0)].x))));
  int v_49 = asint((asuint(v_48) + asuint(tint_f32_to_i32(mat4x2_f32[int(0)].x))));
  int v_50 = asint((asuint(v_49) + asuint(tint_f32_to_i32(mat4x3_f32[int(0)].x))));
  int v_51 = asint((asuint(v_50) + asuint(tint_f32_to_i32(mat4x4_f32[int(0)].x))));
  s.Store(0u, asuint(asint((asuint(v_51) + asuint(tint_f32_to_i32(arr2_vec3_f32[int(0)].x))))));
}

[numthreads(1, 1, 1)]
void main(main_inputs inputs) {
  main_inner(inputs.idx);
}

