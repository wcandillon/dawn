#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct Inner {
  int scalar_i32;
  float scalar_f32;
  float16_t scalar_f16;
};

layout(binding = 0, std140)
uniform ub_block_1_ubo {
  uvec4 inner[55];
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
Inner v_2(uint start_byte_offset) {
  uvec4 v_3 = v.inner[(start_byte_offset / 16u)];
  int v_4 = int(v_3[((start_byte_offset & 15u) >> 2u)]);
  uint v_5 = (4u + start_byte_offset);
  uvec4 v_6 = v.inner[(v_5 / 16u)];
  uint v_7 = (8u + start_byte_offset);
  uvec4 v_8 = v.inner[(v_7 / 16u)];
  return Inner(v_4, uintBitsToFloat(v_6[((v_5 & 15u) >> 2u)]), tint_bitcast_to_16bit(v_8[((v_7 & 15u) >> 2u)])[mix(1u, 0u, ((v_7 % 4u) == 0u))]);
}
Inner[4] v_9(uint start_byte_offset) {
  Inner v_10 = v_2(start_byte_offset);
  Inner v_11 = v_2((16u + start_byte_offset));
  Inner v_12 = v_2((32u + start_byte_offset));
  return Inner[4](v_10, v_11, v_12, v_2((48u + start_byte_offset)));
}
f16mat4x2 v_13(uint start_byte_offset) {
  f16vec2 v_14 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_15 = (4u + start_byte_offset);
  f16vec2 v_16 = tint_bitcast_to_16bit(v.inner[(v_15 / 16u)][((v_15 & 15u) >> 2u)]);
  uint v_17 = (8u + start_byte_offset);
  f16vec2 v_18 = tint_bitcast_to_16bit(v.inner[(v_17 / 16u)][((v_17 & 15u) >> 2u)]);
  uint v_19 = (12u + start_byte_offset);
  return f16mat4x2(v_14, v_16, v_18, tint_bitcast_to_16bit(v.inner[(v_19 / 16u)][((v_19 & 15u) >> 2u)]));
}
f16mat4x2[2] v_20(uint start_byte_offset) {
  f16mat4x2 v_21 = v_13(start_byte_offset);
  return f16mat4x2[2](v_21, v_13((16u + start_byte_offset)));
}
vec3[2] v_22(uint start_byte_offset) {
  return vec3[2](uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
f16vec4 tint_bitcast_to_16bit_1(uvec2 src) {
  return f16vec4(unpackFloat2x16(src.x), unpackFloat2x16(src.y));
}
f16mat4 v_23(uint start_byte_offset) {
  uvec4 v_24 = v.inner[(start_byte_offset / 16u)];
  f16vec4 v_25 = tint_bitcast_to_16bit_1(mix(v_24.xy, v_24.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_26 = (8u + start_byte_offset);
  uvec4 v_27 = v.inner[(v_26 / 16u)];
  f16vec4 v_28 = tint_bitcast_to_16bit_1(mix(v_27.xy, v_27.zw, bvec2((((v_26 & 15u) >> 2u) == 2u))));
  uint v_29 = (16u + start_byte_offset);
  uvec4 v_30 = v.inner[(v_29 / 16u)];
  f16vec4 v_31 = tint_bitcast_to_16bit_1(mix(v_30.xy, v_30.zw, bvec2((((v_29 & 15u) >> 2u) == 2u))));
  uint v_32 = (24u + start_byte_offset);
  uvec4 v_33 = v.inner[(v_32 / 16u)];
  return f16mat4(v_25, v_28, v_31, tint_bitcast_to_16bit_1(mix(v_33.xy, v_33.zw, bvec2((((v_32 & 15u) >> 2u) == 2u)))));
}
f16mat4x3 v_34(uint start_byte_offset) {
  uvec4 v_35 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_36 = tint_bitcast_to_16bit_1(mix(v_35.xy, v_35.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_37 = (8u + start_byte_offset);
  uvec4 v_38 = v.inner[(v_37 / 16u)];
  f16vec3 v_39 = tint_bitcast_to_16bit_1(mix(v_38.xy, v_38.zw, bvec2((((v_37 & 15u) >> 2u) == 2u)))).xyz;
  uint v_40 = (16u + start_byte_offset);
  uvec4 v_41 = v.inner[(v_40 / 16u)];
  f16vec3 v_42 = tint_bitcast_to_16bit_1(mix(v_41.xy, v_41.zw, bvec2((((v_40 & 15u) >> 2u) == 2u)))).xyz;
  uint v_43 = (24u + start_byte_offset);
  uvec4 v_44 = v.inner[(v_43 / 16u)];
  return f16mat4x3(v_36, v_39, v_42, tint_bitcast_to_16bit_1(mix(v_44.xy, v_44.zw, bvec2((((v_43 & 15u) >> 2u) == 2u)))).xyz);
}
f16mat3x4 v_45(uint start_byte_offset) {
  uvec4 v_46 = v.inner[(start_byte_offset / 16u)];
  f16vec4 v_47 = tint_bitcast_to_16bit_1(mix(v_46.xy, v_46.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_48 = (8u + start_byte_offset);
  uvec4 v_49 = v.inner[(v_48 / 16u)];
  f16vec4 v_50 = tint_bitcast_to_16bit_1(mix(v_49.xy, v_49.zw, bvec2((((v_48 & 15u) >> 2u) == 2u))));
  uint v_51 = (16u + start_byte_offset);
  uvec4 v_52 = v.inner[(v_51 / 16u)];
  return f16mat3x4(v_47, v_50, tint_bitcast_to_16bit_1(mix(v_52.xy, v_52.zw, bvec2((((v_51 & 15u) >> 2u) == 2u)))));
}
f16mat3 v_53(uint start_byte_offset) {
  uvec4 v_54 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_55 = tint_bitcast_to_16bit_1(mix(v_54.xy, v_54.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_56 = (8u + start_byte_offset);
  uvec4 v_57 = v.inner[(v_56 / 16u)];
  f16vec3 v_58 = tint_bitcast_to_16bit_1(mix(v_57.xy, v_57.zw, bvec2((((v_56 & 15u) >> 2u) == 2u)))).xyz;
  uint v_59 = (16u + start_byte_offset);
  uvec4 v_60 = v.inner[(v_59 / 16u)];
  return f16mat3(v_55, v_58, tint_bitcast_to_16bit_1(mix(v_60.xy, v_60.zw, bvec2((((v_59 & 15u) >> 2u) == 2u)))).xyz);
}
f16mat3x2 v_61(uint start_byte_offset) {
  f16vec2 v_62 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_63 = (4u + start_byte_offset);
  f16vec2 v_64 = tint_bitcast_to_16bit(v.inner[(v_63 / 16u)][((v_63 & 15u) >> 2u)]);
  uint v_65 = (8u + start_byte_offset);
  return f16mat3x2(v_62, v_64, tint_bitcast_to_16bit(v.inner[(v_65 / 16u)][((v_65 & 15u) >> 2u)]));
}
f16mat2x4 v_66(uint start_byte_offset) {
  uvec4 v_67 = v.inner[(start_byte_offset / 16u)];
  f16vec4 v_68 = tint_bitcast_to_16bit_1(mix(v_67.xy, v_67.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_69 = (8u + start_byte_offset);
  uvec4 v_70 = v.inner[(v_69 / 16u)];
  return f16mat2x4(v_68, tint_bitcast_to_16bit_1(mix(v_70.xy, v_70.zw, bvec2((((v_69 & 15u) >> 2u) == 2u)))));
}
f16mat2x3 v_71(uint start_byte_offset) {
  uvec4 v_72 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_73 = tint_bitcast_to_16bit_1(mix(v_72.xy, v_72.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_74 = (8u + start_byte_offset);
  uvec4 v_75 = v.inner[(v_74 / 16u)];
  return f16mat2x3(v_73, tint_bitcast_to_16bit_1(mix(v_75.xy, v_75.zw, bvec2((((v_74 & 15u) >> 2u) == 2u)))).xyz);
}
f16mat2 v_76(uint start_byte_offset) {
  f16vec2 v_77 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_78 = (4u + start_byte_offset);
  return f16mat2(v_77, tint_bitcast_to_16bit(v.inner[(v_78 / 16u)][((v_78 & 15u) >> 2u)]));
}
mat4 v_79(uint start_byte_offset) {
  return mat4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)]));
}
mat4x3 v_80(uint start_byte_offset) {
  return mat4x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)].xyz));
}
mat4x2 v_81(uint start_byte_offset) {
  uvec4 v_82 = v.inner[(start_byte_offset / 16u)];
  vec2 v_83 = uintBitsToFloat(mix(v_82.xy, v_82.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_84 = (8u + start_byte_offset);
  uvec4 v_85 = v.inner[(v_84 / 16u)];
  vec2 v_86 = uintBitsToFloat(mix(v_85.xy, v_85.zw, bvec2((((v_84 & 15u) >> 2u) == 2u))));
  uint v_87 = (16u + start_byte_offset);
  uvec4 v_88 = v.inner[(v_87 / 16u)];
  vec2 v_89 = uintBitsToFloat(mix(v_88.xy, v_88.zw, bvec2((((v_87 & 15u) >> 2u) == 2u))));
  uint v_90 = (24u + start_byte_offset);
  uvec4 v_91 = v.inner[(v_90 / 16u)];
  return mat4x2(v_83, v_86, v_89, uintBitsToFloat(mix(v_91.xy, v_91.zw, bvec2((((v_90 & 15u) >> 2u) == 2u)))));
}
mat3x4 v_92(uint start_byte_offset) {
  return mat3x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]));
}
mat3 v_93(uint start_byte_offset) {
  return mat3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz));
}
mat3x2 v_94(uint start_byte_offset) {
  uvec4 v_95 = v.inner[(start_byte_offset / 16u)];
  vec2 v_96 = uintBitsToFloat(mix(v_95.xy, v_95.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_97 = (8u + start_byte_offset);
  uvec4 v_98 = v.inner[(v_97 / 16u)];
  vec2 v_99 = uintBitsToFloat(mix(v_98.xy, v_98.zw, bvec2((((v_97 & 15u) >> 2u) == 2u))));
  uint v_100 = (16u + start_byte_offset);
  uvec4 v_101 = v.inner[(v_100 / 16u)];
  return mat3x2(v_96, v_99, uintBitsToFloat(mix(v_101.xy, v_101.zw, bvec2((((v_100 & 15u) >> 2u) == 2u)))));
}
mat2x4 v_102(uint start_byte_offset) {
  return mat2x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]));
}
mat2x3 v_103(uint start_byte_offset) {
  return mat2x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat2 v_104(uint start_byte_offset) {
  uvec4 v_105 = v.inner[(start_byte_offset / 16u)];
  vec2 v_106 = uintBitsToFloat(mix(v_105.xy, v_105.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_107 = (8u + start_byte_offset);
  uvec4 v_108 = v.inner[(v_107 / 16u)];
  return mat2(v_106, uintBitsToFloat(mix(v_108.xy, v_108.zw, bvec2((((v_107 & 15u) >> 2u) == 2u)))));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uvec4 v_109 = v.inner[0u];
  float scalar_f32 = uintBitsToFloat(v_109.x);
  uvec4 v_110 = v.inner[0u];
  int scalar_i32 = int(v_110.y);
  uvec4 v_111 = v.inner[0u];
  uint scalar_u32 = v_111.z;
  uvec4 v_112 = v.inner[0u];
  float16_t scalar_f16 = tint_bitcast_to_16bit(v_112.w).x;
  vec2 vec2_f32 = uintBitsToFloat(v.inner[1u].xy);
  ivec2 vec2_i32 = ivec2(v.inner[1u].zw);
  uvec2 vec2_u32 = v.inner[2u].xy;
  f16vec2 vec2_f16 = tint_bitcast_to_16bit(v.inner[2u].z);
  vec3 vec3_f32 = uintBitsToFloat(v.inner[3u].xyz);
  ivec3 vec3_i32 = ivec3(v.inner[4u].xyz);
  uvec3 vec3_u32 = v.inner[5u].xyz;
  f16vec3 vec3_f16 = tint_bitcast_to_16bit_1(v.inner[6u].xy).xyz;
  vec4 vec4_f32 = uintBitsToFloat(v.inner[7u]);
  ivec4 vec4_i32 = ivec4(v.inner[8u]);
  uvec4 vec4_u32 = v.inner[9u];
  f16vec4 vec4_f16 = tint_bitcast_to_16bit_1(v.inner[10u].xy);
  mat2 mat2x2_f32 = v_104(168u);
  mat2x3 mat2x3_f32 = v_103(192u);
  mat2x4 mat2x4_f32 = v_102(224u);
  mat3x2 mat3x2_f32 = v_94(256u);
  mat3 mat3x3_f32 = v_93(288u);
  mat3x4 mat3x4_f32 = v_92(336u);
  mat4x2 mat4x2_f32 = v_81(384u);
  mat4x3 mat4x3_f32 = v_80(416u);
  mat4 mat4x4_f32 = v_79(480u);
  f16mat2 mat2x2_f16 = v_76(544u);
  f16mat2x3 mat2x3_f16 = v_71(552u);
  f16mat2x4 mat2x4_f16 = v_66(568u);
  f16mat3x2 mat3x2_f16 = v_61(584u);
  f16mat3 mat3x3_f16 = v_53(600u);
  f16mat3x4 mat3x4_f16 = v_45(624u);
  f16mat4x2 mat4x2_f16 = v_13(648u);
  f16mat4x3 mat4x3_f16 = v_34(664u);
  f16mat4 mat4x4_f16 = v_23(696u);
  vec3 arr2_vec3_f32[2] = v_22(736u);
  f16mat4x2 arr2_mat4x2_f16[2] = v_20(768u);
  Inner struct_inner = v_2(800u);
  Inner array_struct_inner[4] = v_9(816u);
  uint v_113 = uint(tint_f32_to_i32(scalar_f32));
  int v_114 = int((v_113 + uint(scalar_i32)));
  int v_115 = int(scalar_u32);
  uint v_116 = uint(v_114);
  int v_117 = int((v_116 + uint(v_115)));
  int v_118 = tint_f16_to_i32(scalar_f16);
  uint v_119 = uint(v_117);
  int v_120 = int((v_119 + uint(v_118)));
  int v_121 = tint_f32_to_i32(vec2_f32.x);
  uint v_122 = uint(v_120);
  uint v_123 = uint(int((v_122 + uint(v_121))));
  int v_124 = int((v_123 + uint(vec2_i32.x)));
  int v_125 = int(vec2_u32.x);
  uint v_126 = uint(v_124);
  int v_127 = int((v_126 + uint(v_125)));
  int v_128 = tint_f16_to_i32(vec2_f16.x);
  uint v_129 = uint(v_127);
  int v_130 = int((v_129 + uint(v_128)));
  int v_131 = tint_f32_to_i32(vec3_f32.y);
  uint v_132 = uint(v_130);
  uint v_133 = uint(int((v_132 + uint(v_131))));
  int v_134 = int((v_133 + uint(vec3_i32.y)));
  int v_135 = int(vec3_u32.y);
  uint v_136 = uint(v_134);
  int v_137 = int((v_136 + uint(v_135)));
  int v_138 = tint_f16_to_i32(vec3_f16.y);
  uint v_139 = uint(v_137);
  int v_140 = int((v_139 + uint(v_138)));
  int v_141 = tint_f32_to_i32(vec4_f32.z);
  uint v_142 = uint(v_140);
  uint v_143 = uint(int((v_142 + uint(v_141))));
  int v_144 = int((v_143 + uint(vec4_i32.z)));
  int v_145 = int(vec4_u32.z);
  uint v_146 = uint(v_144);
  int v_147 = int((v_146 + uint(v_145)));
  int v_148 = tint_f16_to_i32(vec4_f16.z);
  uint v_149 = uint(v_147);
  int v_150 = int((v_149 + uint(v_148)));
  int v_151 = tint_f32_to_i32(mat2x2_f32[0].x);
  uint v_152 = uint(v_150);
  int v_153 = int((v_152 + uint(v_151)));
  int v_154 = tint_f32_to_i32(mat2x3_f32[0].x);
  uint v_155 = uint(v_153);
  int v_156 = int((v_155 + uint(v_154)));
  int v_157 = tint_f32_to_i32(mat2x4_f32[0].x);
  uint v_158 = uint(v_156);
  int v_159 = int((v_158 + uint(v_157)));
  int v_160 = tint_f32_to_i32(mat3x2_f32[0].x);
  uint v_161 = uint(v_159);
  int v_162 = int((v_161 + uint(v_160)));
  int v_163 = tint_f32_to_i32(mat3x3_f32[0].x);
  uint v_164 = uint(v_162);
  int v_165 = int((v_164 + uint(v_163)));
  int v_166 = tint_f32_to_i32(mat3x4_f32[0].x);
  uint v_167 = uint(v_165);
  int v_168 = int((v_167 + uint(v_166)));
  int v_169 = tint_f32_to_i32(mat4x2_f32[0].x);
  uint v_170 = uint(v_168);
  int v_171 = int((v_170 + uint(v_169)));
  int v_172 = tint_f32_to_i32(mat4x3_f32[0].x);
  uint v_173 = uint(v_171);
  int v_174 = int((v_173 + uint(v_172)));
  int v_175 = tint_f32_to_i32(mat4x4_f32[0].x);
  uint v_176 = uint(v_174);
  int v_177 = int((v_176 + uint(v_175)));
  int v_178 = tint_f16_to_i32(mat2x2_f16[0].x);
  uint v_179 = uint(v_177);
  int v_180 = int((v_179 + uint(v_178)));
  int v_181 = tint_f16_to_i32(mat2x3_f16[0].x);
  uint v_182 = uint(v_180);
  int v_183 = int((v_182 + uint(v_181)));
  int v_184 = tint_f16_to_i32(mat2x4_f16[0].x);
  uint v_185 = uint(v_183);
  int v_186 = int((v_185 + uint(v_184)));
  int v_187 = tint_f16_to_i32(mat3x2_f16[0].x);
  uint v_188 = uint(v_186);
  int v_189 = int((v_188 + uint(v_187)));
  int v_190 = tint_f16_to_i32(mat3x3_f16[0].x);
  uint v_191 = uint(v_189);
  int v_192 = int((v_191 + uint(v_190)));
  int v_193 = tint_f16_to_i32(mat3x4_f16[0].x);
  uint v_194 = uint(v_192);
  int v_195 = int((v_194 + uint(v_193)));
  int v_196 = tint_f16_to_i32(mat4x2_f16[0].x);
  uint v_197 = uint(v_195);
  int v_198 = int((v_197 + uint(v_196)));
  int v_199 = tint_f16_to_i32(mat4x3_f16[0].x);
  uint v_200 = uint(v_198);
  int v_201 = int((v_200 + uint(v_199)));
  int v_202 = tint_f16_to_i32(mat4x4_f16[0].x);
  uint v_203 = uint(v_201);
  int v_204 = int((v_203 + uint(v_202)));
  int v_205 = tint_f32_to_i32(arr2_vec3_f32[0].x);
  uint v_206 = uint(v_204);
  int v_207 = int((v_206 + uint(v_205)));
  int v_208 = tint_f16_to_i32(arr2_mat4x2_f16[0][0].x);
  uint v_209 = uint(v_207);
  uint v_210 = uint(int((v_209 + uint(v_208))));
  uint v_211 = uint(int((v_210 + uint(struct_inner.scalar_i32))));
  v_1.inner = int((v_211 + uint(array_struct_inner[0].scalar_i32)));
}
