#version 310 es

layout(binding = 0, std140)
uniform ub_block_1_ubo {
  uvec4 inner[272];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  int inner;
} v_1;
int tint_f32_to_i32(float value) {
  return int(clamp(value, -2147483648.0f, 2147483520.0f));
}
vec3[2] v_2(uint start_byte_offset) {
  return vec3[2](uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat4 v_3(uint start_byte_offset) {
  return mat4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)]));
}
mat4x3 v_4(uint start_byte_offset) {
  return mat4x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)].xyz));
}
mat4x2 v_5(uint start_byte_offset) {
  uvec4 v_6 = v.inner[(start_byte_offset / 16u)];
  vec2 v_7 = uintBitsToFloat(mix(v_6.xy, v_6.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_8 = (8u + start_byte_offset);
  uvec4 v_9 = v.inner[(v_8 / 16u)];
  vec2 v_10 = uintBitsToFloat(mix(v_9.xy, v_9.zw, bvec2((((v_8 & 15u) >> 2u) == 2u))));
  uint v_11 = (16u + start_byte_offset);
  uvec4 v_12 = v.inner[(v_11 / 16u)];
  vec2 v_13 = uintBitsToFloat(mix(v_12.xy, v_12.zw, bvec2((((v_11 & 15u) >> 2u) == 2u))));
  uint v_14 = (24u + start_byte_offset);
  uvec4 v_15 = v.inner[(v_14 / 16u)];
  return mat4x2(v_7, v_10, v_13, uintBitsToFloat(mix(v_15.xy, v_15.zw, bvec2((((v_14 & 15u) >> 2u) == 2u)))));
}
mat3x4 v_16(uint start_byte_offset) {
  return mat3x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]));
}
mat3 v_17(uint start_byte_offset) {
  return mat3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz));
}
mat3x2 v_18(uint start_byte_offset) {
  uvec4 v_19 = v.inner[(start_byte_offset / 16u)];
  vec2 v_20 = uintBitsToFloat(mix(v_19.xy, v_19.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_21 = (8u + start_byte_offset);
  uvec4 v_22 = v.inner[(v_21 / 16u)];
  vec2 v_23 = uintBitsToFloat(mix(v_22.xy, v_22.zw, bvec2((((v_21 & 15u) >> 2u) == 2u))));
  uint v_24 = (16u + start_byte_offset);
  uvec4 v_25 = v.inner[(v_24 / 16u)];
  return mat3x2(v_20, v_23, uintBitsToFloat(mix(v_25.xy, v_25.zw, bvec2((((v_24 & 15u) >> 2u) == 2u)))));
}
mat2x4 v_26(uint start_byte_offset) {
  return mat2x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]));
}
mat2x3 v_27(uint start_byte_offset) {
  return mat2x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat2 v_28(uint start_byte_offset) {
  uvec4 v_29 = v.inner[(start_byte_offset / 16u)];
  vec2 v_30 = uintBitsToFloat(mix(v_29.xy, v_29.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_31 = (8u + start_byte_offset);
  uvec4 v_32 = v.inner[(v_31 / 16u)];
  return mat2(v_30, uintBitsToFloat(mix(v_32.xy, v_32.zw, bvec2((((v_31 & 15u) >> 2u) == 2u)))));
}
void main_inner(uint idx) {
  uint v_33 = (idx * 544u);
  uvec4 v_34 = v.inner[(v_33 / 16u)];
  float scalar_f32 = uintBitsToFloat(v_34[((v_33 & 15u) >> 2u)]);
  uint v_35 = (4u + (idx * 544u));
  uvec4 v_36 = v.inner[(v_35 / 16u)];
  int scalar_i32 = int(v_36[((v_35 & 15u) >> 2u)]);
  uint v_37 = (8u + (idx * 544u));
  uvec4 v_38 = v.inner[(v_37 / 16u)];
  uint scalar_u32 = v_38[((v_37 & 15u) >> 2u)];
  uint v_39 = (16u + (idx * 544u));
  uvec4 v_40 = v.inner[(v_39 / 16u)];
  vec2 vec2_f32 = uintBitsToFloat(mix(v_40.xy, v_40.zw, bvec2((((v_39 & 15u) >> 2u) == 2u))));
  uint v_41 = (24u + (idx * 544u));
  uvec4 v_42 = v.inner[(v_41 / 16u)];
  ivec2 vec2_i32 = ivec2(mix(v_42.xy, v_42.zw, bvec2((((v_41 & 15u) >> 2u) == 2u))));
  uint v_43 = (32u + (idx * 544u));
  uvec4 v_44 = v.inner[(v_43 / 16u)];
  uvec2 vec2_u32 = mix(v_44.xy, v_44.zw, bvec2((((v_43 & 15u) >> 2u) == 2u)));
  vec3 vec3_f32 = uintBitsToFloat(v.inner[((48u + (idx * 544u)) / 16u)].xyz);
  ivec3 vec3_i32 = ivec3(v.inner[((64u + (idx * 544u)) / 16u)].xyz);
  uvec3 vec3_u32 = v.inner[((80u + (idx * 544u)) / 16u)].xyz;
  vec4 vec4_f32 = uintBitsToFloat(v.inner[((96u + (idx * 544u)) / 16u)]);
  ivec4 vec4_i32 = ivec4(v.inner[((112u + (idx * 544u)) / 16u)]);
  uvec4 vec4_u32 = v.inner[((128u + (idx * 544u)) / 16u)];
  mat2 mat2x2_f32 = v_28((144u + (idx * 544u)));
  mat2x3 mat2x3_f32 = v_27((160u + (idx * 544u)));
  mat2x4 mat2x4_f32 = v_26((192u + (idx * 544u)));
  mat3x2 mat3x2_f32 = v_18((224u + (idx * 544u)));
  mat3 mat3x3_f32 = v_17((256u + (idx * 544u)));
  mat3x4 mat3x4_f32 = v_16((304u + (idx * 544u)));
  mat4x2 mat4x2_f32 = v_5((352u + (idx * 544u)));
  mat4x3 mat4x3_f32 = v_4((384u + (idx * 544u)));
  mat4 mat4x4_f32 = v_3((448u + (idx * 544u)));
  vec3 arr2_vec3_f32[2] = v_2((512u + (idx * 544u)));
  uint v_45 = uint(tint_f32_to_i32(scalar_f32));
  int v_46 = int((v_45 + uint(scalar_i32)));
  int v_47 = int(scalar_u32);
  uint v_48 = uint(v_46);
  int v_49 = int((v_48 + uint(v_47)));
  int v_50 = tint_f32_to_i32(vec2_f32.x);
  uint v_51 = uint(v_49);
  uint v_52 = uint(int((v_51 + uint(v_50))));
  int v_53 = int((v_52 + uint(vec2_i32.x)));
  int v_54 = int(vec2_u32.x);
  uint v_55 = uint(v_53);
  int v_56 = int((v_55 + uint(v_54)));
  int v_57 = tint_f32_to_i32(vec3_f32.y);
  uint v_58 = uint(v_56);
  uint v_59 = uint(int((v_58 + uint(v_57))));
  int v_60 = int((v_59 + uint(vec3_i32.y)));
  int v_61 = int(vec3_u32.y);
  uint v_62 = uint(v_60);
  int v_63 = int((v_62 + uint(v_61)));
  int v_64 = tint_f32_to_i32(vec4_f32.z);
  uint v_65 = uint(v_63);
  uint v_66 = uint(int((v_65 + uint(v_64))));
  int v_67 = int((v_66 + uint(vec4_i32.z)));
  int v_68 = int(vec4_u32.z);
  uint v_69 = uint(v_67);
  int v_70 = int((v_69 + uint(v_68)));
  int v_71 = tint_f32_to_i32(mat2x2_f32[0].x);
  uint v_72 = uint(v_70);
  int v_73 = int((v_72 + uint(v_71)));
  int v_74 = tint_f32_to_i32(mat2x3_f32[0].x);
  uint v_75 = uint(v_73);
  int v_76 = int((v_75 + uint(v_74)));
  int v_77 = tint_f32_to_i32(mat2x4_f32[0].x);
  uint v_78 = uint(v_76);
  int v_79 = int((v_78 + uint(v_77)));
  int v_80 = tint_f32_to_i32(mat3x2_f32[0].x);
  uint v_81 = uint(v_79);
  int v_82 = int((v_81 + uint(v_80)));
  int v_83 = tint_f32_to_i32(mat3x3_f32[0].x);
  uint v_84 = uint(v_82);
  int v_85 = int((v_84 + uint(v_83)));
  int v_86 = tint_f32_to_i32(mat3x4_f32[0].x);
  uint v_87 = uint(v_85);
  int v_88 = int((v_87 + uint(v_86)));
  int v_89 = tint_f32_to_i32(mat4x2_f32[0].x);
  uint v_90 = uint(v_88);
  int v_91 = int((v_90 + uint(v_89)));
  int v_92 = tint_f32_to_i32(mat4x3_f32[0].x);
  uint v_93 = uint(v_91);
  int v_94 = int((v_93 + uint(v_92)));
  int v_95 = tint_f32_to_i32(mat4x4_f32[0].x);
  uint v_96 = uint(v_94);
  int v_97 = int((v_96 + uint(v_95)));
  int v_98 = tint_f32_to_i32(arr2_vec3_f32[0].x);
  uint v_99 = uint(v_97);
  v_1.inner = int((v_99 + uint(v_98)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  main_inner(gl_LocalInvocationIndex);
}
