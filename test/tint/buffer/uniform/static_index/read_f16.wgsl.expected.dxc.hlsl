struct Inner {
  int scalar_i32;
  float scalar_f32;
  float16_t scalar_f16;
};


cbuffer cbuffer_ub : register(b0) {
  uint4 ub[55];
};
RWByteAddressBuffer s : register(u1);
int tint_f16_to_i32(float16_t value) {
  return int(clamp(value, float16_t(-65504.0h), float16_t(65504.0h)));
}

int tint_f32_to_i32(float value) {
  return int(clamp(value, -2147483648.0f, 2147483520.0f));
}

vector<float16_t, 2> tint_bitcast_to_f16(uint src) {
  uint v = src;
  vector<uint16_t, 2> v16 = vector<uint16_t, 2>(((uint2(v, v) >> uint2(0u, 16u)) & (65535u).xx));
  return asfloat16(v16);
}

Inner v_1(uint start_byte_offset) {
  int v_2 = asint(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  float v_4 = asfloat(ub[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  Inner v_6 = {v_2, v_4, tint_bitcast_to_f16(ub[(v_5 / 16u)][((v_5 & 15u) >> 2u)])[select(((v_5 % 4u) == 0u), 0u, 1u)]};
  return v_6;
}

typedef Inner ary_ret[4];
ary_ret v_7(uint start_byte_offset) {
  Inner v_8 = v_1(start_byte_offset);
  Inner v_9 = v_1((16u + start_byte_offset));
  Inner v_10 = v_1((32u + start_byte_offset));
  Inner v_11 = v_1((48u + start_byte_offset));
  Inner v_12[4] = {v_8, v_9, v_10, v_11};
  return v_12;
}

matrix<float16_t, 4, 2> v_13(uint start_byte_offset) {
  vector<float16_t, 2> v_14 = tint_bitcast_to_f16(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_15 = (4u + start_byte_offset);
  vector<float16_t, 2> v_16 = tint_bitcast_to_f16(ub[(v_15 / 16u)][((v_15 & 15u) >> 2u)]);
  uint v_17 = (8u + start_byte_offset);
  vector<float16_t, 2> v_18 = tint_bitcast_to_f16(ub[(v_17 / 16u)][((v_17 & 15u) >> 2u)]);
  uint v_19 = (12u + start_byte_offset);
  return matrix<float16_t, 4, 2>(v_14, v_16, v_18, tint_bitcast_to_f16(ub[(v_19 / 16u)][((v_19 & 15u) >> 2u)]));
}

typedef matrix<float16_t, 4, 2> ary_ret_1[2];
ary_ret_1 v_20(uint start_byte_offset) {
  matrix<float16_t, 4, 2> v_21 = v_13(start_byte_offset);
  matrix<float16_t, 4, 2> v_22[2] = {v_21, v_13((16u + start_byte_offset))};
  return v_22;
}

typedef float3 ary_ret_2[2];
ary_ret_2 v_23(uint start_byte_offset) {
  float3 v_24[2] = {asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz)};
  return v_24;
}

vector<float16_t, 4> tint_bitcast_to_f16_1(uint2 src) {
  uint2 v = src;
  vector<uint16_t, 4> v16 = vector<uint16_t, 4>(((v.xxyy >> uint4(0u, 16u, 0u, 16u)) & (65535u).xxxx));
  return asfloat16(v16);
}

matrix<float16_t, 4, 4> v_25(uint start_byte_offset) {
  uint4 v_26 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_27 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_26.zw, v_26.xy));
  uint v_28 = (8u + start_byte_offset);
  uint4 v_29 = ub[(v_28 / 16u)];
  vector<float16_t, 4> v_30 = tint_bitcast_to_f16_1(select((((v_28 & 15u) >> 2u) == 2u), v_29.zw, v_29.xy));
  uint v_31 = (16u + start_byte_offset);
  uint4 v_32 = ub[(v_31 / 16u)];
  vector<float16_t, 4> v_33 = tint_bitcast_to_f16_1(select((((v_31 & 15u) >> 2u) == 2u), v_32.zw, v_32.xy));
  uint v_34 = (24u + start_byte_offset);
  uint4 v_35 = ub[(v_34 / 16u)];
  return matrix<float16_t, 4, 4>(v_27, v_30, v_33, tint_bitcast_to_f16_1(select((((v_34 & 15u) >> 2u) == 2u), v_35.zw, v_35.xy)));
}

matrix<float16_t, 4, 3> v_36(uint start_byte_offset) {
  uint4 v_37 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_38 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_37.zw, v_37.xy)).xyz;
  uint v_39 = (8u + start_byte_offset);
  uint4 v_40 = ub[(v_39 / 16u)];
  vector<float16_t, 3> v_41 = tint_bitcast_to_f16_1(select((((v_39 & 15u) >> 2u) == 2u), v_40.zw, v_40.xy)).xyz;
  uint v_42 = (16u + start_byte_offset);
  uint4 v_43 = ub[(v_42 / 16u)];
  vector<float16_t, 3> v_44 = tint_bitcast_to_f16_1(select((((v_42 & 15u) >> 2u) == 2u), v_43.zw, v_43.xy)).xyz;
  uint v_45 = (24u + start_byte_offset);
  uint4 v_46 = ub[(v_45 / 16u)];
  return matrix<float16_t, 4, 3>(v_38, v_41, v_44, tint_bitcast_to_f16_1(select((((v_45 & 15u) >> 2u) == 2u), v_46.zw, v_46.xy)).xyz);
}

matrix<float16_t, 3, 4> v_47(uint start_byte_offset) {
  uint4 v_48 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_49 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_48.zw, v_48.xy));
  uint v_50 = (8u + start_byte_offset);
  uint4 v_51 = ub[(v_50 / 16u)];
  vector<float16_t, 4> v_52 = tint_bitcast_to_f16_1(select((((v_50 & 15u) >> 2u) == 2u), v_51.zw, v_51.xy));
  uint v_53 = (16u + start_byte_offset);
  uint4 v_54 = ub[(v_53 / 16u)];
  return matrix<float16_t, 3, 4>(v_49, v_52, tint_bitcast_to_f16_1(select((((v_53 & 15u) >> 2u) == 2u), v_54.zw, v_54.xy)));
}

matrix<float16_t, 3, 3> v_55(uint start_byte_offset) {
  uint4 v_56 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_57 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_56.zw, v_56.xy)).xyz;
  uint v_58 = (8u + start_byte_offset);
  uint4 v_59 = ub[(v_58 / 16u)];
  vector<float16_t, 3> v_60 = tint_bitcast_to_f16_1(select((((v_58 & 15u) >> 2u) == 2u), v_59.zw, v_59.xy)).xyz;
  uint v_61 = (16u + start_byte_offset);
  uint4 v_62 = ub[(v_61 / 16u)];
  return matrix<float16_t, 3, 3>(v_57, v_60, tint_bitcast_to_f16_1(select((((v_61 & 15u) >> 2u) == 2u), v_62.zw, v_62.xy)).xyz);
}

matrix<float16_t, 3, 2> v_63(uint start_byte_offset) {
  vector<float16_t, 2> v_64 = tint_bitcast_to_f16(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_65 = (4u + start_byte_offset);
  vector<float16_t, 2> v_66 = tint_bitcast_to_f16(ub[(v_65 / 16u)][((v_65 & 15u) >> 2u)]);
  uint v_67 = (8u + start_byte_offset);
  return matrix<float16_t, 3, 2>(v_64, v_66, tint_bitcast_to_f16(ub[(v_67 / 16u)][((v_67 & 15u) >> 2u)]));
}

matrix<float16_t, 2, 4> v_68(uint start_byte_offset) {
  uint4 v_69 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_70 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_69.zw, v_69.xy));
  uint v_71 = (8u + start_byte_offset);
  uint4 v_72 = ub[(v_71 / 16u)];
  return matrix<float16_t, 2, 4>(v_70, tint_bitcast_to_f16_1(select((((v_71 & 15u) >> 2u) == 2u), v_72.zw, v_72.xy)));
}

matrix<float16_t, 2, 3> v_73(uint start_byte_offset) {
  uint4 v_74 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_75 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_74.zw, v_74.xy)).xyz;
  uint v_76 = (8u + start_byte_offset);
  uint4 v_77 = ub[(v_76 / 16u)];
  return matrix<float16_t, 2, 3>(v_75, tint_bitcast_to_f16_1(select((((v_76 & 15u) >> 2u) == 2u), v_77.zw, v_77.xy)).xyz);
}

matrix<float16_t, 2, 2> v_78(uint start_byte_offset) {
  vector<float16_t, 2> v_79 = tint_bitcast_to_f16(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_80 = (4u + start_byte_offset);
  return matrix<float16_t, 2, 2>(v_79, tint_bitcast_to_f16(ub[(v_80 / 16u)][((v_80 & 15u) >> 2u)]));
}

float4x4 v_81(uint start_byte_offset) {
  return float4x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]), asfloat(ub[((48u + start_byte_offset) / 16u)]));
}

float4x3 v_82(uint start_byte_offset) {
  return float4x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz), asfloat(ub[((48u + start_byte_offset) / 16u)].xyz));
}

float4x2 v_83(uint start_byte_offset) {
  uint4 v_84 = ub[(start_byte_offset / 16u)];
  uint v_85 = (8u + start_byte_offset);
  uint4 v_86 = ub[(v_85 / 16u)];
  uint v_87 = (16u + start_byte_offset);
  uint4 v_88 = ub[(v_87 / 16u)];
  uint v_89 = (24u + start_byte_offset);
  uint4 v_90 = ub[(v_89 / 16u)];
  return float4x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_84.zw, v_84.xy)), asfloat(select((((v_85 & 15u) >> 2u) == 2u), v_86.zw, v_86.xy)), asfloat(select((((v_87 & 15u) >> 2u) == 2u), v_88.zw, v_88.xy)), asfloat(select((((v_89 & 15u) >> 2u) == 2u), v_90.zw, v_90.xy)));
}

float3x4 v_91(uint start_byte_offset) {
  return float3x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]));
}

float3x3 v_92(uint start_byte_offset) {
  return float3x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz));
}

float3x2 v_93(uint start_byte_offset) {
  uint4 v_94 = ub[(start_byte_offset / 16u)];
  uint v_95 = (8u + start_byte_offset);
  uint4 v_96 = ub[(v_95 / 16u)];
  uint v_97 = (16u + start_byte_offset);
  uint4 v_98 = ub[(v_97 / 16u)];
  return float3x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_94.zw, v_94.xy)), asfloat(select((((v_95 & 15u) >> 2u) == 2u), v_96.zw, v_96.xy)), asfloat(select((((v_97 & 15u) >> 2u) == 2u), v_98.zw, v_98.xy)));
}

float2x4 v_99(uint start_byte_offset) {
  return float2x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]));
}

float2x3 v_100(uint start_byte_offset) {
  return float2x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz));
}

float2x2 v_101(uint start_byte_offset) {
  uint4 v_102 = ub[(start_byte_offset / 16u)];
  uint v_103 = (8u + start_byte_offset);
  uint4 v_104 = ub[(v_103 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_102.zw, v_102.xy)), asfloat(select((((v_103 & 15u) >> 2u) == 2u), v_104.zw, v_104.xy)));
}

[numthreads(1, 1, 1)]
void main() {
  float scalar_f32 = asfloat(ub[0u].x);
  int scalar_i32 = asint(ub[0u].y);
  uint scalar_u32 = ub[0u].z;
  float16_t scalar_f16 = tint_bitcast_to_f16(ub[0u].w).x;
  float2 vec2_f32 = asfloat(ub[1u].xy);
  int2 vec2_i32 = asint(ub[1u].zw);
  uint2 vec2_u32 = ub[2u].xy;
  vector<float16_t, 2> vec2_f16 = tint_bitcast_to_f16(ub[2u].z);
  float3 vec3_f32 = asfloat(ub[3u].xyz);
  int3 vec3_i32 = asint(ub[4u].xyz);
  uint3 vec3_u32 = ub[5u].xyz;
  vector<float16_t, 3> vec3_f16 = tint_bitcast_to_f16_1(ub[6u].xy).xyz;
  float4 vec4_f32 = asfloat(ub[7u]);
  int4 vec4_i32 = asint(ub[8u]);
  uint4 vec4_u32 = ub[9u];
  vector<float16_t, 4> vec4_f16 = tint_bitcast_to_f16_1(ub[10u].xy);
  float2x2 mat2x2_f32 = v_101(168u);
  float2x3 mat2x3_f32 = v_100(192u);
  float2x4 mat2x4_f32 = v_99(224u);
  float3x2 mat3x2_f32 = v_93(256u);
  float3x3 mat3x3_f32 = v_92(288u);
  float3x4 mat3x4_f32 = v_91(336u);
  float4x2 mat4x2_f32 = v_83(384u);
  float4x3 mat4x3_f32 = v_82(416u);
  float4x4 mat4x4_f32 = v_81(480u);
  matrix<float16_t, 2, 2> mat2x2_f16 = v_78(544u);
  matrix<float16_t, 2, 3> mat2x3_f16 = v_73(552u);
  matrix<float16_t, 2, 4> mat2x4_f16 = v_68(568u);
  matrix<float16_t, 3, 2> mat3x2_f16 = v_63(584u);
  matrix<float16_t, 3, 3> mat3x3_f16 = v_55(600u);
  matrix<float16_t, 3, 4> mat3x4_f16 = v_47(624u);
  matrix<float16_t, 4, 2> mat4x2_f16 = v_13(648u);
  matrix<float16_t, 4, 3> mat4x3_f16 = v_36(664u);
  matrix<float16_t, 4, 4> mat4x4_f16 = v_25(696u);
  float3 arr2_vec3_f32[2] = v_23(736u);
  matrix<float16_t, 4, 2> arr2_mat4x2_f16[2] = v_20(768u);
  Inner struct_inner = v_1(800u);
  Inner array_struct_inner[4] = v_7(816u);
  int v_105 = asint((asuint(tint_f32_to_i32(scalar_f32)) + asuint(scalar_i32)));
  int v_106 = asint((asuint(v_105) + asuint(int(scalar_u32))));
  int v_107 = asint((asuint(v_106) + asuint(tint_f16_to_i32(scalar_f16))));
  int v_108 = asint((asuint(asint((asuint(v_107) + asuint(tint_f32_to_i32(vec2_f32.x))))) + asuint(vec2_i32.x)));
  int v_109 = asint((asuint(v_108) + asuint(int(vec2_u32.x))));
  int v_110 = asint((asuint(v_109) + asuint(tint_f16_to_i32(vec2_f16.x))));
  int v_111 = asint((asuint(asint((asuint(v_110) + asuint(tint_f32_to_i32(vec3_f32.y))))) + asuint(vec3_i32.y)));
  int v_112 = asint((asuint(v_111) + asuint(int(vec3_u32.y))));
  int v_113 = asint((asuint(v_112) + asuint(tint_f16_to_i32(vec3_f16.y))));
  int v_114 = asint((asuint(asint((asuint(v_113) + asuint(tint_f32_to_i32(vec4_f32.z))))) + asuint(vec4_i32.z)));
  int v_115 = asint((asuint(v_114) + asuint(int(vec4_u32.z))));
  int v_116 = asint((asuint(v_115) + asuint(tint_f16_to_i32(vec4_f16.z))));
  int v_117 = asint((asuint(v_116) + asuint(tint_f32_to_i32(mat2x2_f32[int(0)].x))));
  int v_118 = asint((asuint(v_117) + asuint(tint_f32_to_i32(mat2x3_f32[int(0)].x))));
  int v_119 = asint((asuint(v_118) + asuint(tint_f32_to_i32(mat2x4_f32[int(0)].x))));
  int v_120 = asint((asuint(v_119) + asuint(tint_f32_to_i32(mat3x2_f32[int(0)].x))));
  int v_121 = asint((asuint(v_120) + asuint(tint_f32_to_i32(mat3x3_f32[int(0)].x))));
  int v_122 = asint((asuint(v_121) + asuint(tint_f32_to_i32(mat3x4_f32[int(0)].x))));
  int v_123 = asint((asuint(v_122) + asuint(tint_f32_to_i32(mat4x2_f32[int(0)].x))));
  int v_124 = asint((asuint(v_123) + asuint(tint_f32_to_i32(mat4x3_f32[int(0)].x))));
  int v_125 = asint((asuint(v_124) + asuint(tint_f32_to_i32(mat4x4_f32[int(0)].x))));
  int v_126 = asint((asuint(v_125) + asuint(tint_f16_to_i32(mat2x2_f16[int(0)].x))));
  int v_127 = asint((asuint(v_126) + asuint(tint_f16_to_i32(mat2x3_f16[int(0)].x))));
  int v_128 = asint((asuint(v_127) + asuint(tint_f16_to_i32(mat2x4_f16[int(0)].x))));
  int v_129 = asint((asuint(v_128) + asuint(tint_f16_to_i32(mat3x2_f16[int(0)].x))));
  int v_130 = asint((asuint(v_129) + asuint(tint_f16_to_i32(mat3x3_f16[int(0)].x))));
  int v_131 = asint((asuint(v_130) + asuint(tint_f16_to_i32(mat3x4_f16[int(0)].x))));
  int v_132 = asint((asuint(v_131) + asuint(tint_f16_to_i32(mat4x2_f16[int(0)].x))));
  int v_133 = asint((asuint(v_132) + asuint(tint_f16_to_i32(mat4x3_f16[int(0)].x))));
  int v_134 = asint((asuint(v_133) + asuint(tint_f16_to_i32(mat4x4_f16[int(0)].x))));
  int v_135 = asint((asuint(v_134) + asuint(tint_f32_to_i32(arr2_vec3_f32[int(0)].x))));
  s.Store(0u, asuint(asint((asuint(asint((asuint(asint((asuint(v_135) + asuint(tint_f16_to_i32(arr2_mat4x2_f16[int(0)][int(0)].x))))) + asuint(struct_inner.scalar_i32)))) + asuint(array_struct_inner[int(0)].scalar_i32)))));
}

