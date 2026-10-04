#version 310 es


struct Inner {
  int scalar_i32;
  float scalar_f32;
};

layout(binding = 0, std140)
uniform ub_block_1_ubo {
  uvec4 inner[44];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  int inner;
} v_1;
int tint_f32_to_i32(float value) {
  return int(clamp(value, -2147483648.0f, 2147483520.0f));
}
Inner v_2(uint start_byte_offset) {
  uvec4 v_3 = v.inner[(start_byte_offset / 16u)];
  int v_4 = int(v_3[((start_byte_offset & 15u) >> 2u)]);
  uint v_5 = (16u + start_byte_offset);
  uvec4 v_6 = v.inner[(v_5 / 16u)];
  return Inner(v_4, uintBitsToFloat(v_6[((v_5 & 15u) >> 2u)]));
}
Inner[4] v_7(uint start_byte_offset) {
  Inner v_8 = v_2(start_byte_offset);
  Inner v_9 = v_2((32u + start_byte_offset));
  Inner v_10 = v_2((64u + start_byte_offset));
  return Inner[4](v_8, v_9, v_10, v_2((96u + start_byte_offset)));
}
vec3[2] v_11(uint start_byte_offset) {
  return vec3[2](uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat4 v_12(uint start_byte_offset) {
  return mat4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)]));
}
mat4x3 v_13(uint start_byte_offset) {
  return mat4x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)].xyz));
}
mat4x2 v_14(uint start_byte_offset) {
  uvec4 v_15 = v.inner[(start_byte_offset / 16u)];
  vec2 v_16 = uintBitsToFloat(mix(v_15.xy, v_15.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_17 = (8u + start_byte_offset);
  uvec4 v_18 = v.inner[(v_17 / 16u)];
  vec2 v_19 = uintBitsToFloat(mix(v_18.xy, v_18.zw, bvec2((((v_17 & 15u) >> 2u) == 2u))));
  uint v_20 = (16u + start_byte_offset);
  uvec4 v_21 = v.inner[(v_20 / 16u)];
  vec2 v_22 = uintBitsToFloat(mix(v_21.xy, v_21.zw, bvec2((((v_20 & 15u) >> 2u) == 2u))));
  uint v_23 = (24u + start_byte_offset);
  uvec4 v_24 = v.inner[(v_23 / 16u)];
  return mat4x2(v_16, v_19, v_22, uintBitsToFloat(mix(v_24.xy, v_24.zw, bvec2((((v_23 & 15u) >> 2u) == 2u)))));
}
mat3x4 v_25(uint start_byte_offset) {
  return mat3x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]));
}
mat3 v_26(uint start_byte_offset) {
  return mat3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz));
}
mat3x2 v_27(uint start_byte_offset) {
  uvec4 v_28 = v.inner[(start_byte_offset / 16u)];
  vec2 v_29 = uintBitsToFloat(mix(v_28.xy, v_28.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_30 = (8u + start_byte_offset);
  uvec4 v_31 = v.inner[(v_30 / 16u)];
  vec2 v_32 = uintBitsToFloat(mix(v_31.xy, v_31.zw, bvec2((((v_30 & 15u) >> 2u) == 2u))));
  uint v_33 = (16u + start_byte_offset);
  uvec4 v_34 = v.inner[(v_33 / 16u)];
  return mat3x2(v_29, v_32, uintBitsToFloat(mix(v_34.xy, v_34.zw, bvec2((((v_33 & 15u) >> 2u) == 2u)))));
}
mat2x4 v_35(uint start_byte_offset) {
  return mat2x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]));
}
mat2x3 v_36(uint start_byte_offset) {
  return mat2x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat2 v_37(uint start_byte_offset) {
  uvec4 v_38 = v.inner[(start_byte_offset / 16u)];
  vec2 v_39 = uintBitsToFloat(mix(v_38.xy, v_38.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_40 = (8u + start_byte_offset);
  uvec4 v_41 = v.inner[(v_40 / 16u)];
  return mat2(v_39, uintBitsToFloat(mix(v_41.xy, v_41.zw, bvec2((((v_40 & 15u) >> 2u) == 2u)))));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uvec4 v_42 = v.inner[0u];
  float scalar_f32 = uintBitsToFloat(v_42.x);
  uvec4 v_43 = v.inner[0u];
  int scalar_i32 = int(v_43.y);
  uvec4 v_44 = v.inner[0u];
  uint scalar_u32 = v_44.z;
  vec2 vec2_f32 = uintBitsToFloat(v.inner[1u].xy);
  ivec2 vec2_i32 = ivec2(v.inner[1u].zw);
  uvec2 vec2_u32 = v.inner[2u].xy;
  vec3 vec3_f32 = uintBitsToFloat(v.inner[3u].xyz);
  ivec3 vec3_i32 = ivec3(v.inner[4u].xyz);
  uvec3 vec3_u32 = v.inner[5u].xyz;
  vec4 vec4_f32 = uintBitsToFloat(v.inner[6u]);
  ivec4 vec4_i32 = ivec4(v.inner[7u]);
  uvec4 vec4_u32 = v.inner[8u];
  mat2 mat2x2_f32 = v_37(144u);
  mat2x3 mat2x3_f32 = v_36(160u);
  mat2x4 mat2x4_f32 = v_35(192u);
  mat3x2 mat3x2_f32 = v_27(224u);
  mat3 mat3x3_f32 = v_26(256u);
  mat3x4 mat3x4_f32 = v_25(304u);
  mat4x2 mat4x2_f32 = v_14(352u);
  mat4x3 mat4x3_f32 = v_13(384u);
  mat4 mat4x4_f32 = v_12(448u);
  vec3 arr2_vec3_f32[2] = v_11(512u);
  Inner struct_inner = v_2(544u);
  Inner array_struct_inner[4] = v_7(576u);
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
  uint v_100 = uint(int((v_99 + uint(v_98))));
  uint v_101 = uint(int((v_100 + uint(struct_inner.scalar_i32))));
  v_1.inner = int((v_101 + uint(array_struct_inner[0].scalar_i32)));
}
