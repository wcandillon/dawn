#version 310 es
#extension GL_AMD_gpu_shader_half_float: require

layout(binding = 0, std140)
uniform ub_block_1_ubo {
  uvec4 inner[400];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  int inner;
} v_1;
int tint_f16_to_i32(float16_t value) {
  return int(clamp(value, -65504.0hf, 65504.0hf));
}
int tint_f32_to_i32(float value) {
  return int(clamp(value, -2147483648.0f, 2147483520.0f));
}
f16vec2 tint_bitcast_to_16bit(uint src) {
  return unpackFloat2x16(src);
}
f16mat4x2 v_2(uint start_byte_offset) {
  f16vec2 v_3 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_4 = (4u + start_byte_offset);
  f16vec2 v_5 = tint_bitcast_to_16bit(v.inner[(v_4 / 16u)][((v_4 & 15u) >> 2u)]);
  uint v_6 = (8u + start_byte_offset);
  f16vec2 v_7 = tint_bitcast_to_16bit(v.inner[(v_6 / 16u)][((v_6 & 15u) >> 2u)]);
  uint v_8 = (12u + start_byte_offset);
  return f16mat4x2(v_3, v_5, v_7, tint_bitcast_to_16bit(v.inner[(v_8 / 16u)][((v_8 & 15u) >> 2u)]));
}
f16mat4x2[2] v_9(uint start_byte_offset) {
  f16mat4x2 v_10 = v_2(start_byte_offset);
  return f16mat4x2[2](v_10, v_2((16u + start_byte_offset)));
}
vec3[2] v_11(uint start_byte_offset) {
  return vec3[2](uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
f16vec4 tint_bitcast_to_16bit_1(uvec2 src) {
  return f16vec4(unpackFloat2x16(src.x), unpackFloat2x16(src.y));
}
f16mat4 v_12(uint start_byte_offset) {
  uvec4 v_13 = v.inner[(start_byte_offset / 16u)];
  f16vec4 v_14 = tint_bitcast_to_16bit_1(mix(v_13.xy, v_13.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_15 = (8u + start_byte_offset);
  uvec4 v_16 = v.inner[(v_15 / 16u)];
  f16vec4 v_17 = tint_bitcast_to_16bit_1(mix(v_16.xy, v_16.zw, bvec2((((v_15 & 15u) >> 2u) == 2u))));
  uint v_18 = (16u + start_byte_offset);
  uvec4 v_19 = v.inner[(v_18 / 16u)];
  f16vec4 v_20 = tint_bitcast_to_16bit_1(mix(v_19.xy, v_19.zw, bvec2((((v_18 & 15u) >> 2u) == 2u))));
  uint v_21 = (24u + start_byte_offset);
  uvec4 v_22 = v.inner[(v_21 / 16u)];
  return f16mat4(v_14, v_17, v_20, tint_bitcast_to_16bit_1(mix(v_22.xy, v_22.zw, bvec2((((v_21 & 15u) >> 2u) == 2u)))));
}
f16mat4x3 v_23(uint start_byte_offset) {
  uvec4 v_24 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_25 = tint_bitcast_to_16bit_1(mix(v_24.xy, v_24.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_26 = (8u + start_byte_offset);
  uvec4 v_27 = v.inner[(v_26 / 16u)];
  f16vec3 v_28 = tint_bitcast_to_16bit_1(mix(v_27.xy, v_27.zw, bvec2((((v_26 & 15u) >> 2u) == 2u)))).xyz;
  uint v_29 = (16u + start_byte_offset);
  uvec4 v_30 = v.inner[(v_29 / 16u)];
  f16vec3 v_31 = tint_bitcast_to_16bit_1(mix(v_30.xy, v_30.zw, bvec2((((v_29 & 15u) >> 2u) == 2u)))).xyz;
  uint v_32 = (24u + start_byte_offset);
  uvec4 v_33 = v.inner[(v_32 / 16u)];
  return f16mat4x3(v_25, v_28, v_31, tint_bitcast_to_16bit_1(mix(v_33.xy, v_33.zw, bvec2((((v_32 & 15u) >> 2u) == 2u)))).xyz);
}
f16mat3x4 v_34(uint start_byte_offset) {
  uvec4 v_35 = v.inner[(start_byte_offset / 16u)];
  f16vec4 v_36 = tint_bitcast_to_16bit_1(mix(v_35.xy, v_35.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_37 = (8u + start_byte_offset);
  uvec4 v_38 = v.inner[(v_37 / 16u)];
  f16vec4 v_39 = tint_bitcast_to_16bit_1(mix(v_38.xy, v_38.zw, bvec2((((v_37 & 15u) >> 2u) == 2u))));
  uint v_40 = (16u + start_byte_offset);
  uvec4 v_41 = v.inner[(v_40 / 16u)];
  return f16mat3x4(v_36, v_39, tint_bitcast_to_16bit_1(mix(v_41.xy, v_41.zw, bvec2((((v_40 & 15u) >> 2u) == 2u)))));
}
f16mat3 v_42(uint start_byte_offset) {
  uvec4 v_43 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_44 = tint_bitcast_to_16bit_1(mix(v_43.xy, v_43.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_45 = (8u + start_byte_offset);
  uvec4 v_46 = v.inner[(v_45 / 16u)];
  f16vec3 v_47 = tint_bitcast_to_16bit_1(mix(v_46.xy, v_46.zw, bvec2((((v_45 & 15u) >> 2u) == 2u)))).xyz;
  uint v_48 = (16u + start_byte_offset);
  uvec4 v_49 = v.inner[(v_48 / 16u)];
  return f16mat3(v_44, v_47, tint_bitcast_to_16bit_1(mix(v_49.xy, v_49.zw, bvec2((((v_48 & 15u) >> 2u) == 2u)))).xyz);
}
f16mat3x2 v_50(uint start_byte_offset) {
  f16vec2 v_51 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_52 = (4u + start_byte_offset);
  f16vec2 v_53 = tint_bitcast_to_16bit(v.inner[(v_52 / 16u)][((v_52 & 15u) >> 2u)]);
  uint v_54 = (8u + start_byte_offset);
  return f16mat3x2(v_51, v_53, tint_bitcast_to_16bit(v.inner[(v_54 / 16u)][((v_54 & 15u) >> 2u)]));
}
f16mat2x4 v_55(uint start_byte_offset) {
  uvec4 v_56 = v.inner[(start_byte_offset / 16u)];
  f16vec4 v_57 = tint_bitcast_to_16bit_1(mix(v_56.xy, v_56.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_58 = (8u + start_byte_offset);
  uvec4 v_59 = v.inner[(v_58 / 16u)];
  return f16mat2x4(v_57, tint_bitcast_to_16bit_1(mix(v_59.xy, v_59.zw, bvec2((((v_58 & 15u) >> 2u) == 2u)))));
}
f16mat2x3 v_60(uint start_byte_offset) {
  uvec4 v_61 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_62 = tint_bitcast_to_16bit_1(mix(v_61.xy, v_61.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_63 = (8u + start_byte_offset);
  uvec4 v_64 = v.inner[(v_63 / 16u)];
  return f16mat2x3(v_62, tint_bitcast_to_16bit_1(mix(v_64.xy, v_64.zw, bvec2((((v_63 & 15u) >> 2u) == 2u)))).xyz);
}
f16mat2 v_65(uint start_byte_offset) {
  f16vec2 v_66 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_67 = (4u + start_byte_offset);
  return f16mat2(v_66, tint_bitcast_to_16bit(v.inner[(v_67 / 16u)][((v_67 & 15u) >> 2u)]));
}
mat4 v_68(uint start_byte_offset) {
  return mat4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)]));
}
mat4x3 v_69(uint start_byte_offset) {
  return mat4x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)].xyz));
}
mat4x2 v_70(uint start_byte_offset) {
  uvec4 v_71 = v.inner[(start_byte_offset / 16u)];
  vec2 v_72 = uintBitsToFloat(mix(v_71.xy, v_71.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_73 = (8u + start_byte_offset);
  uvec4 v_74 = v.inner[(v_73 / 16u)];
  vec2 v_75 = uintBitsToFloat(mix(v_74.xy, v_74.zw, bvec2((((v_73 & 15u) >> 2u) == 2u))));
  uint v_76 = (16u + start_byte_offset);
  uvec4 v_77 = v.inner[(v_76 / 16u)];
  vec2 v_78 = uintBitsToFloat(mix(v_77.xy, v_77.zw, bvec2((((v_76 & 15u) >> 2u) == 2u))));
  uint v_79 = (24u + start_byte_offset);
  uvec4 v_80 = v.inner[(v_79 / 16u)];
  return mat4x2(v_72, v_75, v_78, uintBitsToFloat(mix(v_80.xy, v_80.zw, bvec2((((v_79 & 15u) >> 2u) == 2u)))));
}
mat3x4 v_81(uint start_byte_offset) {
  return mat3x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]));
}
mat3 v_82(uint start_byte_offset) {
  return mat3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz));
}
mat3x2 v_83(uint start_byte_offset) {
  uvec4 v_84 = v.inner[(start_byte_offset / 16u)];
  vec2 v_85 = uintBitsToFloat(mix(v_84.xy, v_84.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_86 = (8u + start_byte_offset);
  uvec4 v_87 = v.inner[(v_86 / 16u)];
  vec2 v_88 = uintBitsToFloat(mix(v_87.xy, v_87.zw, bvec2((((v_86 & 15u) >> 2u) == 2u))));
  uint v_89 = (16u + start_byte_offset);
  uvec4 v_90 = v.inner[(v_89 / 16u)];
  return mat3x2(v_85, v_88, uintBitsToFloat(mix(v_90.xy, v_90.zw, bvec2((((v_89 & 15u) >> 2u) == 2u)))));
}
mat2x4 v_91(uint start_byte_offset) {
  return mat2x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]));
}
mat2x3 v_92(uint start_byte_offset) {
  return mat2x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat2 v_93(uint start_byte_offset) {
  uvec4 v_94 = v.inner[(start_byte_offset / 16u)];
  vec2 v_95 = uintBitsToFloat(mix(v_94.xy, v_94.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_96 = (8u + start_byte_offset);
  uvec4 v_97 = v.inner[(v_96 / 16u)];
  return mat2(v_95, uintBitsToFloat(mix(v_97.xy, v_97.zw, bvec2((((v_96 & 15u) >> 2u) == 2u)))));
}
void main_inner(uint idx) {
  uint v_98 = (idx * 800u);
  uvec4 v_99 = v.inner[(v_98 / 16u)];
  float scalar_f32 = uintBitsToFloat(v_99[((v_98 & 15u) >> 2u)]);
  uint v_100 = (4u + (idx * 800u));
  uvec4 v_101 = v.inner[(v_100 / 16u)];
  int scalar_i32 = int(v_101[((v_100 & 15u) >> 2u)]);
  uint v_102 = (8u + (idx * 800u));
  uvec4 v_103 = v.inner[(v_102 / 16u)];
  uint scalar_u32 = v_103[((v_102 & 15u) >> 2u)];
  uint v_104 = (12u + (idx * 800u));
  uvec4 v_105 = v.inner[(v_104 / 16u)];
  float16_t scalar_f16 = tint_bitcast_to_16bit(v_105[((v_104 & 15u) >> 2u)])[mix(1u, 0u, ((v_104 % 4u) == 0u))];
  uint v_106 = (16u + (idx * 800u));
  uvec4 v_107 = v.inner[(v_106 / 16u)];
  vec2 vec2_f32 = uintBitsToFloat(mix(v_107.xy, v_107.zw, bvec2((((v_106 & 15u) >> 2u) == 2u))));
  uint v_108 = (24u + (idx * 800u));
  uvec4 v_109 = v.inner[(v_108 / 16u)];
  ivec2 vec2_i32 = ivec2(mix(v_109.xy, v_109.zw, bvec2((((v_108 & 15u) >> 2u) == 2u))));
  uint v_110 = (32u + (idx * 800u));
  uvec4 v_111 = v.inner[(v_110 / 16u)];
  uvec2 vec2_u32 = mix(v_111.xy, v_111.zw, bvec2((((v_110 & 15u) >> 2u) == 2u)));
  uint v_112 = (40u + (idx * 800u));
  f16vec2 vec2_f16 = tint_bitcast_to_16bit(v.inner[(v_112 / 16u)][((v_112 & 15u) >> 2u)]);
  vec3 vec3_f32 = uintBitsToFloat(v.inner[((48u + (idx * 800u)) / 16u)].xyz);
  ivec3 vec3_i32 = ivec3(v.inner[((64u + (idx * 800u)) / 16u)].xyz);
  uvec3 vec3_u32 = v.inner[((80u + (idx * 800u)) / 16u)].xyz;
  uint v_113 = (96u + (idx * 800u));
  uvec4 v_114 = v.inner[(v_113 / 16u)];
  f16vec3 vec3_f16 = tint_bitcast_to_16bit_1(mix(v_114.xy, v_114.zw, bvec2((((v_113 & 15u) >> 2u) == 2u)))).xyz;
  vec4 vec4_f32 = uintBitsToFloat(v.inner[((112u + (idx * 800u)) / 16u)]);
  ivec4 vec4_i32 = ivec4(v.inner[((128u + (idx * 800u)) / 16u)]);
  uvec4 vec4_u32 = v.inner[((144u + (idx * 800u)) / 16u)];
  uint v_115 = (160u + (idx * 800u));
  uvec4 v_116 = v.inner[(v_115 / 16u)];
  f16vec4 vec4_f16 = tint_bitcast_to_16bit_1(mix(v_116.xy, v_116.zw, bvec2((((v_115 & 15u) >> 2u) == 2u))));
  mat2 mat2x2_f32 = v_93((168u + (idx * 800u)));
  mat2x3 mat2x3_f32 = v_92((192u + (idx * 800u)));
  mat2x4 mat2x4_f32 = v_91((224u + (idx * 800u)));
  mat3x2 mat3x2_f32 = v_83((256u + (idx * 800u)));
  mat3 mat3x3_f32 = v_82((288u + (idx * 800u)));
  mat3x4 mat3x4_f32 = v_81((336u + (idx * 800u)));
  mat4x2 mat4x2_f32 = v_70((384u + (idx * 800u)));
  mat4x3 mat4x3_f32 = v_69((416u + (idx * 800u)));
  mat4 mat4x4_f32 = v_68((480u + (idx * 800u)));
  f16mat2 mat2x2_f16 = v_65((544u + (idx * 800u)));
  f16mat2x3 mat2x3_f16 = v_60((552u + (idx * 800u)));
  f16mat2x4 mat2x4_f16 = v_55((568u + (idx * 800u)));
  f16mat3x2 mat3x2_f16 = v_50((584u + (idx * 800u)));
  f16mat3 mat3x3_f16 = v_42((600u + (idx * 800u)));
  f16mat3x4 mat3x4_f16 = v_34((624u + (idx * 800u)));
  f16mat4x2 mat4x2_f16 = v_2((648u + (idx * 800u)));
  f16mat4x3 mat4x3_f16 = v_23((664u + (idx * 800u)));
  f16mat4 mat4x4_f16 = v_12((696u + (idx * 800u)));
  vec3 arr2_vec3_f32[2] = v_11((736u + (idx * 800u)));
  f16mat4x2 arr2_mat4x2_f16[2] = v_9((768u + (idx * 800u)));
  uint v_117 = uint(tint_f32_to_i32(scalar_f32));
  int v_118 = int((v_117 + uint(scalar_i32)));
  int v_119 = int(scalar_u32);
  uint v_120 = uint(v_118);
  int v_121 = int((v_120 + uint(v_119)));
  int v_122 = tint_f16_to_i32(scalar_f16);
  uint v_123 = uint(v_121);
  int v_124 = int((v_123 + uint(v_122)));
  int v_125 = tint_f32_to_i32(vec2_f32.x);
  uint v_126 = uint(v_124);
  uint v_127 = uint(int((v_126 + uint(v_125))));
  int v_128 = int((v_127 + uint(vec2_i32.x)));
  int v_129 = int(vec2_u32.x);
  uint v_130 = uint(v_128);
  int v_131 = int((v_130 + uint(v_129)));
  int v_132 = tint_f16_to_i32(vec2_f16.x);
  uint v_133 = uint(v_131);
  int v_134 = int((v_133 + uint(v_132)));
  int v_135 = tint_f32_to_i32(vec3_f32.y);
  uint v_136 = uint(v_134);
  uint v_137 = uint(int((v_136 + uint(v_135))));
  int v_138 = int((v_137 + uint(vec3_i32.y)));
  int v_139 = int(vec3_u32.y);
  uint v_140 = uint(v_138);
  int v_141 = int((v_140 + uint(v_139)));
  int v_142 = tint_f16_to_i32(vec3_f16.y);
  uint v_143 = uint(v_141);
  int v_144 = int((v_143 + uint(v_142)));
  int v_145 = tint_f32_to_i32(vec4_f32.z);
  uint v_146 = uint(v_144);
  uint v_147 = uint(int((v_146 + uint(v_145))));
  int v_148 = int((v_147 + uint(vec4_i32.z)));
  int v_149 = int(vec4_u32.z);
  uint v_150 = uint(v_148);
  int v_151 = int((v_150 + uint(v_149)));
  int v_152 = tint_f16_to_i32(vec4_f16.z);
  uint v_153 = uint(v_151);
  int v_154 = int((v_153 + uint(v_152)));
  int v_155 = tint_f32_to_i32(mat2x2_f32[0].x);
  uint v_156 = uint(v_154);
  int v_157 = int((v_156 + uint(v_155)));
  int v_158 = tint_f32_to_i32(mat2x3_f32[0].x);
  uint v_159 = uint(v_157);
  int v_160 = int((v_159 + uint(v_158)));
  int v_161 = tint_f32_to_i32(mat2x4_f32[0].x);
  uint v_162 = uint(v_160);
  int v_163 = int((v_162 + uint(v_161)));
  int v_164 = tint_f32_to_i32(mat3x2_f32[0].x);
  uint v_165 = uint(v_163);
  int v_166 = int((v_165 + uint(v_164)));
  int v_167 = tint_f32_to_i32(mat3x3_f32[0].x);
  uint v_168 = uint(v_166);
  int v_169 = int((v_168 + uint(v_167)));
  int v_170 = tint_f32_to_i32(mat3x4_f32[0].x);
  uint v_171 = uint(v_169);
  int v_172 = int((v_171 + uint(v_170)));
  int v_173 = tint_f32_to_i32(mat4x2_f32[0].x);
  uint v_174 = uint(v_172);
  int v_175 = int((v_174 + uint(v_173)));
  int v_176 = tint_f32_to_i32(mat4x3_f32[0].x);
  uint v_177 = uint(v_175);
  int v_178 = int((v_177 + uint(v_176)));
  int v_179 = tint_f32_to_i32(mat4x4_f32[0].x);
  uint v_180 = uint(v_178);
  int v_181 = int((v_180 + uint(v_179)));
  int v_182 = tint_f16_to_i32(mat2x2_f16[0].x);
  uint v_183 = uint(v_181);
  int v_184 = int((v_183 + uint(v_182)));
  int v_185 = tint_f16_to_i32(mat2x3_f16[0].x);
  uint v_186 = uint(v_184);
  int v_187 = int((v_186 + uint(v_185)));
  int v_188 = tint_f16_to_i32(mat2x4_f16[0].x);
  uint v_189 = uint(v_187);
  int v_190 = int((v_189 + uint(v_188)));
  int v_191 = tint_f16_to_i32(mat3x2_f16[0].x);
  uint v_192 = uint(v_190);
  int v_193 = int((v_192 + uint(v_191)));
  int v_194 = tint_f16_to_i32(mat3x3_f16[0].x);
  uint v_195 = uint(v_193);
  int v_196 = int((v_195 + uint(v_194)));
  int v_197 = tint_f16_to_i32(mat3x4_f16[0].x);
  uint v_198 = uint(v_196);
  int v_199 = int((v_198 + uint(v_197)));
  int v_200 = tint_f16_to_i32(mat4x2_f16[0].x);
  uint v_201 = uint(v_199);
  int v_202 = int((v_201 + uint(v_200)));
  int v_203 = tint_f16_to_i32(mat4x3_f16[0].x);
  uint v_204 = uint(v_202);
  int v_205 = int((v_204 + uint(v_203)));
  int v_206 = tint_f16_to_i32(mat4x4_f16[0].x);
  uint v_207 = uint(v_205);
  int v_208 = int((v_207 + uint(v_206)));
  int v_209 = tint_f32_to_i32(arr2_vec3_f32[0].x);
  uint v_210 = uint(v_208);
  int v_211 = int((v_210 + uint(v_209)));
  int v_212 = tint_f16_to_i32(arr2_mat4x2_f16[0][0].x);
  uint v_213 = uint(v_211);
  v_1.inner = int((v_213 + uint(v_212)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  main_inner(gl_LocalInvocationIndex);
}
