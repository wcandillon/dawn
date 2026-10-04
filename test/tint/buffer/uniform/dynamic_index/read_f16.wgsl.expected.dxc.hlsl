struct main_inputs {
  uint idx : SV_GroupIndex;
};


cbuffer cbuffer_ub : register(b0) {
  uint4 ub[400];
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

matrix<float16_t, 4, 2> v_1(uint start_byte_offset) {
  vector<float16_t, 2> v_2 = tint_bitcast_to_f16(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  vector<float16_t, 2> v_4 = tint_bitcast_to_f16(ub[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  vector<float16_t, 2> v_6 = tint_bitcast_to_f16(ub[(v_5 / 16u)][((v_5 & 15u) >> 2u)]);
  uint v_7 = (12u + start_byte_offset);
  return matrix<float16_t, 4, 2>(v_2, v_4, v_6, tint_bitcast_to_f16(ub[(v_7 / 16u)][((v_7 & 15u) >> 2u)]));
}

typedef matrix<float16_t, 4, 2> ary_ret[2];
ary_ret v_8(uint start_byte_offset) {
  matrix<float16_t, 4, 2> v_9 = v_1(start_byte_offset);
  matrix<float16_t, 4, 2> v_10[2] = {v_9, v_1((16u + start_byte_offset))};
  return v_10;
}

typedef float3 ary_ret_1[2];
ary_ret_1 v_11(uint start_byte_offset) {
  float3 v_12[2] = {asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz)};
  return v_12;
}

vector<float16_t, 4> tint_bitcast_to_f16_1(uint2 src) {
  uint2 v = src;
  vector<uint16_t, 4> v16 = vector<uint16_t, 4>(((v.xxyy >> uint4(0u, 16u, 0u, 16u)) & (65535u).xxxx));
  return asfloat16(v16);
}

matrix<float16_t, 4, 4> v_13(uint start_byte_offset) {
  uint4 v_14 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_15 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_14.zw, v_14.xy));
  uint v_16 = (8u + start_byte_offset);
  uint4 v_17 = ub[(v_16 / 16u)];
  vector<float16_t, 4> v_18 = tint_bitcast_to_f16_1(select((((v_16 & 15u) >> 2u) == 2u), v_17.zw, v_17.xy));
  uint v_19 = (16u + start_byte_offset);
  uint4 v_20 = ub[(v_19 / 16u)];
  vector<float16_t, 4> v_21 = tint_bitcast_to_f16_1(select((((v_19 & 15u) >> 2u) == 2u), v_20.zw, v_20.xy));
  uint v_22 = (24u + start_byte_offset);
  uint4 v_23 = ub[(v_22 / 16u)];
  return matrix<float16_t, 4, 4>(v_15, v_18, v_21, tint_bitcast_to_f16_1(select((((v_22 & 15u) >> 2u) == 2u), v_23.zw, v_23.xy)));
}

matrix<float16_t, 4, 3> v_24(uint start_byte_offset) {
  uint4 v_25 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_26 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_25.zw, v_25.xy)).xyz;
  uint v_27 = (8u + start_byte_offset);
  uint4 v_28 = ub[(v_27 / 16u)];
  vector<float16_t, 3> v_29 = tint_bitcast_to_f16_1(select((((v_27 & 15u) >> 2u) == 2u), v_28.zw, v_28.xy)).xyz;
  uint v_30 = (16u + start_byte_offset);
  uint4 v_31 = ub[(v_30 / 16u)];
  vector<float16_t, 3> v_32 = tint_bitcast_to_f16_1(select((((v_30 & 15u) >> 2u) == 2u), v_31.zw, v_31.xy)).xyz;
  uint v_33 = (24u + start_byte_offset);
  uint4 v_34 = ub[(v_33 / 16u)];
  return matrix<float16_t, 4, 3>(v_26, v_29, v_32, tint_bitcast_to_f16_1(select((((v_33 & 15u) >> 2u) == 2u), v_34.zw, v_34.xy)).xyz);
}

matrix<float16_t, 3, 4> v_35(uint start_byte_offset) {
  uint4 v_36 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_37 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_36.zw, v_36.xy));
  uint v_38 = (8u + start_byte_offset);
  uint4 v_39 = ub[(v_38 / 16u)];
  vector<float16_t, 4> v_40 = tint_bitcast_to_f16_1(select((((v_38 & 15u) >> 2u) == 2u), v_39.zw, v_39.xy));
  uint v_41 = (16u + start_byte_offset);
  uint4 v_42 = ub[(v_41 / 16u)];
  return matrix<float16_t, 3, 4>(v_37, v_40, tint_bitcast_to_f16_1(select((((v_41 & 15u) >> 2u) == 2u), v_42.zw, v_42.xy)));
}

matrix<float16_t, 3, 3> v_43(uint start_byte_offset) {
  uint4 v_44 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_45 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_44.zw, v_44.xy)).xyz;
  uint v_46 = (8u + start_byte_offset);
  uint4 v_47 = ub[(v_46 / 16u)];
  vector<float16_t, 3> v_48 = tint_bitcast_to_f16_1(select((((v_46 & 15u) >> 2u) == 2u), v_47.zw, v_47.xy)).xyz;
  uint v_49 = (16u + start_byte_offset);
  uint4 v_50 = ub[(v_49 / 16u)];
  return matrix<float16_t, 3, 3>(v_45, v_48, tint_bitcast_to_f16_1(select((((v_49 & 15u) >> 2u) == 2u), v_50.zw, v_50.xy)).xyz);
}

matrix<float16_t, 3, 2> v_51(uint start_byte_offset) {
  vector<float16_t, 2> v_52 = tint_bitcast_to_f16(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_53 = (4u + start_byte_offset);
  vector<float16_t, 2> v_54 = tint_bitcast_to_f16(ub[(v_53 / 16u)][((v_53 & 15u) >> 2u)]);
  uint v_55 = (8u + start_byte_offset);
  return matrix<float16_t, 3, 2>(v_52, v_54, tint_bitcast_to_f16(ub[(v_55 / 16u)][((v_55 & 15u) >> 2u)]));
}

matrix<float16_t, 2, 4> v_56(uint start_byte_offset) {
  uint4 v_57 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_58 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_57.zw, v_57.xy));
  uint v_59 = (8u + start_byte_offset);
  uint4 v_60 = ub[(v_59 / 16u)];
  return matrix<float16_t, 2, 4>(v_58, tint_bitcast_to_f16_1(select((((v_59 & 15u) >> 2u) == 2u), v_60.zw, v_60.xy)));
}

matrix<float16_t, 2, 3> v_61(uint start_byte_offset) {
  uint4 v_62 = ub[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_63 = tint_bitcast_to_f16_1(select((((start_byte_offset & 15u) >> 2u) == 2u), v_62.zw, v_62.xy)).xyz;
  uint v_64 = (8u + start_byte_offset);
  uint4 v_65 = ub[(v_64 / 16u)];
  return matrix<float16_t, 2, 3>(v_63, tint_bitcast_to_f16_1(select((((v_64 & 15u) >> 2u) == 2u), v_65.zw, v_65.xy)).xyz);
}

matrix<float16_t, 2, 2> v_66(uint start_byte_offset) {
  vector<float16_t, 2> v_67 = tint_bitcast_to_f16(ub[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_68 = (4u + start_byte_offset);
  return matrix<float16_t, 2, 2>(v_67, tint_bitcast_to_f16(ub[(v_68 / 16u)][((v_68 & 15u) >> 2u)]));
}

float4x4 v_69(uint start_byte_offset) {
  return float4x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]), asfloat(ub[((48u + start_byte_offset) / 16u)]));
}

float4x3 v_70(uint start_byte_offset) {
  return float4x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz), asfloat(ub[((48u + start_byte_offset) / 16u)].xyz));
}

float4x2 v_71(uint start_byte_offset) {
  uint4 v_72 = ub[(start_byte_offset / 16u)];
  uint v_73 = (8u + start_byte_offset);
  uint4 v_74 = ub[(v_73 / 16u)];
  uint v_75 = (16u + start_byte_offset);
  uint4 v_76 = ub[(v_75 / 16u)];
  uint v_77 = (24u + start_byte_offset);
  uint4 v_78 = ub[(v_77 / 16u)];
  return float4x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_72.zw, v_72.xy)), asfloat(select((((v_73 & 15u) >> 2u) == 2u), v_74.zw, v_74.xy)), asfloat(select((((v_75 & 15u) >> 2u) == 2u), v_76.zw, v_76.xy)), asfloat(select((((v_77 & 15u) >> 2u) == 2u), v_78.zw, v_78.xy)));
}

float3x4 v_79(uint start_byte_offset) {
  return float3x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]), asfloat(ub[((32u + start_byte_offset) / 16u)]));
}

float3x3 v_80(uint start_byte_offset) {
  return float3x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz), asfloat(ub[((32u + start_byte_offset) / 16u)].xyz));
}

float3x2 v_81(uint start_byte_offset) {
  uint4 v_82 = ub[(start_byte_offset / 16u)];
  uint v_83 = (8u + start_byte_offset);
  uint4 v_84 = ub[(v_83 / 16u)];
  uint v_85 = (16u + start_byte_offset);
  uint4 v_86 = ub[(v_85 / 16u)];
  return float3x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_82.zw, v_82.xy)), asfloat(select((((v_83 & 15u) >> 2u) == 2u), v_84.zw, v_84.xy)), asfloat(select((((v_85 & 15u) >> 2u) == 2u), v_86.zw, v_86.xy)));
}

float2x4 v_87(uint start_byte_offset) {
  return float2x4(asfloat(ub[(start_byte_offset / 16u)]), asfloat(ub[((16u + start_byte_offset) / 16u)]));
}

float2x3 v_88(uint start_byte_offset) {
  return float2x3(asfloat(ub[(start_byte_offset / 16u)].xyz), asfloat(ub[((16u + start_byte_offset) / 16u)].xyz));
}

float2x2 v_89(uint start_byte_offset) {
  uint4 v_90 = ub[(start_byte_offset / 16u)];
  uint v_91 = (8u + start_byte_offset);
  uint4 v_92 = ub[(v_91 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_90.zw, v_90.xy)), asfloat(select((((v_91 & 15u) >> 2u) == 2u), v_92.zw, v_92.xy)));
}

void main_inner(uint idx) {
  uint v_93 = (idx * 800u);
  float scalar_f32 = asfloat(ub[(v_93 / 16u)][((v_93 & 15u) >> 2u)]);
  uint v_94 = (4u + (idx * 800u));
  int scalar_i32 = asint(ub[(v_94 / 16u)][((v_94 & 15u) >> 2u)]);
  uint v_95 = (8u + (idx * 800u));
  uint scalar_u32 = ub[(v_95 / 16u)][((v_95 & 15u) >> 2u)];
  uint v_96 = (12u + (idx * 800u));
  float16_t scalar_f16 = tint_bitcast_to_f16(ub[(v_96 / 16u)][((v_96 & 15u) >> 2u)])[select(((v_96 % 4u) == 0u), 0u, 1u)];
  uint v_97 = (16u + (idx * 800u));
  uint4 v_98 = ub[(v_97 / 16u)];
  float2 vec2_f32 = asfloat(select((((v_97 & 15u) >> 2u) == 2u), v_98.zw, v_98.xy));
  uint v_99 = (24u + (idx * 800u));
  uint4 v_100 = ub[(v_99 / 16u)];
  int2 vec2_i32 = asint(select((((v_99 & 15u) >> 2u) == 2u), v_100.zw, v_100.xy));
  uint v_101 = (32u + (idx * 800u));
  uint4 v_102 = ub[(v_101 / 16u)];
  uint2 vec2_u32 = select((((v_101 & 15u) >> 2u) == 2u), v_102.zw, v_102.xy);
  uint v_103 = (40u + (idx * 800u));
  vector<float16_t, 2> vec2_f16 = tint_bitcast_to_f16(ub[(v_103 / 16u)][((v_103 & 15u) >> 2u)]);
  float3 vec3_f32 = asfloat(ub[((48u + (idx * 800u)) / 16u)].xyz);
  int3 vec3_i32 = asint(ub[((64u + (idx * 800u)) / 16u)].xyz);
  uint3 vec3_u32 = ub[((80u + (idx * 800u)) / 16u)].xyz;
  uint v_104 = (96u + (idx * 800u));
  uint4 v_105 = ub[(v_104 / 16u)];
  vector<float16_t, 3> vec3_f16 = tint_bitcast_to_f16_1(select((((v_104 & 15u) >> 2u) == 2u), v_105.zw, v_105.xy)).xyz;
  float4 vec4_f32 = asfloat(ub[((112u + (idx * 800u)) / 16u)]);
  int4 vec4_i32 = asint(ub[((128u + (idx * 800u)) / 16u)]);
  uint4 vec4_u32 = ub[((144u + (idx * 800u)) / 16u)];
  uint v_106 = (160u + (idx * 800u));
  uint4 v_107 = ub[(v_106 / 16u)];
  vector<float16_t, 4> vec4_f16 = tint_bitcast_to_f16_1(select((((v_106 & 15u) >> 2u) == 2u), v_107.zw, v_107.xy));
  float2x2 mat2x2_f32 = v_89((168u + (idx * 800u)));
  float2x3 mat2x3_f32 = v_88((192u + (idx * 800u)));
  float2x4 mat2x4_f32 = v_87((224u + (idx * 800u)));
  float3x2 mat3x2_f32 = v_81((256u + (idx * 800u)));
  float3x3 mat3x3_f32 = v_80((288u + (idx * 800u)));
  float3x4 mat3x4_f32 = v_79((336u + (idx * 800u)));
  float4x2 mat4x2_f32 = v_71((384u + (idx * 800u)));
  float4x3 mat4x3_f32 = v_70((416u + (idx * 800u)));
  float4x4 mat4x4_f32 = v_69((480u + (idx * 800u)));
  matrix<float16_t, 2, 2> mat2x2_f16 = v_66((544u + (idx * 800u)));
  matrix<float16_t, 2, 3> mat2x3_f16 = v_61((552u + (idx * 800u)));
  matrix<float16_t, 2, 4> mat2x4_f16 = v_56((568u + (idx * 800u)));
  matrix<float16_t, 3, 2> mat3x2_f16 = v_51((584u + (idx * 800u)));
  matrix<float16_t, 3, 3> mat3x3_f16 = v_43((600u + (idx * 800u)));
  matrix<float16_t, 3, 4> mat3x4_f16 = v_35((624u + (idx * 800u)));
  matrix<float16_t, 4, 2> mat4x2_f16 = v_1((648u + (idx * 800u)));
  matrix<float16_t, 4, 3> mat4x3_f16 = v_24((664u + (idx * 800u)));
  matrix<float16_t, 4, 4> mat4x4_f16 = v_13((696u + (idx * 800u)));
  float3 arr2_vec3_f32[2] = v_11((736u + (idx * 800u)));
  matrix<float16_t, 4, 2> arr2_mat4x2_f16[2] = v_8((768u + (idx * 800u)));
  int v_108 = asint((asuint(tint_f32_to_i32(scalar_f32)) + asuint(scalar_i32)));
  int v_109 = asint((asuint(v_108) + asuint(int(scalar_u32))));
  int v_110 = asint((asuint(v_109) + asuint(tint_f16_to_i32(scalar_f16))));
  int v_111 = asint((asuint(asint((asuint(v_110) + asuint(tint_f32_to_i32(vec2_f32.x))))) + asuint(vec2_i32.x)));
  int v_112 = asint((asuint(v_111) + asuint(int(vec2_u32.x))));
  int v_113 = asint((asuint(v_112) + asuint(tint_f16_to_i32(vec2_f16.x))));
  int v_114 = asint((asuint(asint((asuint(v_113) + asuint(tint_f32_to_i32(vec3_f32.y))))) + asuint(vec3_i32.y)));
  int v_115 = asint((asuint(v_114) + asuint(int(vec3_u32.y))));
  int v_116 = asint((asuint(v_115) + asuint(tint_f16_to_i32(vec3_f16.y))));
  int v_117 = asint((asuint(asint((asuint(v_116) + asuint(tint_f32_to_i32(vec4_f32.z))))) + asuint(vec4_i32.z)));
  int v_118 = asint((asuint(v_117) + asuint(int(vec4_u32.z))));
  int v_119 = asint((asuint(v_118) + asuint(tint_f16_to_i32(vec4_f16.z))));
  int v_120 = asint((asuint(v_119) + asuint(tint_f32_to_i32(mat2x2_f32[int(0)].x))));
  int v_121 = asint((asuint(v_120) + asuint(tint_f32_to_i32(mat2x3_f32[int(0)].x))));
  int v_122 = asint((asuint(v_121) + asuint(tint_f32_to_i32(mat2x4_f32[int(0)].x))));
  int v_123 = asint((asuint(v_122) + asuint(tint_f32_to_i32(mat3x2_f32[int(0)].x))));
  int v_124 = asint((asuint(v_123) + asuint(tint_f32_to_i32(mat3x3_f32[int(0)].x))));
  int v_125 = asint((asuint(v_124) + asuint(tint_f32_to_i32(mat3x4_f32[int(0)].x))));
  int v_126 = asint((asuint(v_125) + asuint(tint_f32_to_i32(mat4x2_f32[int(0)].x))));
  int v_127 = asint((asuint(v_126) + asuint(tint_f32_to_i32(mat4x3_f32[int(0)].x))));
  int v_128 = asint((asuint(v_127) + asuint(tint_f32_to_i32(mat4x4_f32[int(0)].x))));
  int v_129 = asint((asuint(v_128) + asuint(tint_f16_to_i32(mat2x2_f16[int(0)].x))));
  int v_130 = asint((asuint(v_129) + asuint(tint_f16_to_i32(mat2x3_f16[int(0)].x))));
  int v_131 = asint((asuint(v_130) + asuint(tint_f16_to_i32(mat2x4_f16[int(0)].x))));
  int v_132 = asint((asuint(v_131) + asuint(tint_f16_to_i32(mat3x2_f16[int(0)].x))));
  int v_133 = asint((asuint(v_132) + asuint(tint_f16_to_i32(mat3x3_f16[int(0)].x))));
  int v_134 = asint((asuint(v_133) + asuint(tint_f16_to_i32(mat3x4_f16[int(0)].x))));
  int v_135 = asint((asuint(v_134) + asuint(tint_f16_to_i32(mat4x2_f16[int(0)].x))));
  int v_136 = asint((asuint(v_135) + asuint(tint_f16_to_i32(mat4x3_f16[int(0)].x))));
  int v_137 = asint((asuint(v_136) + asuint(tint_f16_to_i32(mat4x4_f16[int(0)].x))));
  int v_138 = asint((asuint(v_137) + asuint(tint_f32_to_i32(arr2_vec3_f32[int(0)].x))));
  s.Store(0u, asuint(asint((asuint(v_138) + asuint(tint_f16_to_i32(arr2_mat4x2_f16[int(0)][int(0)].x))))));
}

[numthreads(1, 1, 1)]
void main(main_inputs inputs) {
  main_inner(inputs.idx);
}

