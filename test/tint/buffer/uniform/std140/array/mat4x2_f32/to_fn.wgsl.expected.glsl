#version 310 es

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[8];
} v_1;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  float inner;
} v_2;
float a(mat4x2 a_1[4]) {
  return a_1[0][0].x;
}
float b(mat4x2 m) {
  return m[0].x;
}
float c(vec2 v) {
  return v.x;
}
float d(float f_1) {
  return f_1;
}
mat4x2 v_3(uint start_byte_offset) {
  uvec4 v_4 = v_1.inner[(start_byte_offset / 16u)];
  vec2 v_5 = uintBitsToFloat(mix(v_4.xy, v_4.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_6 = (8u + start_byte_offset);
  uvec4 v_7 = v_1.inner[(v_6 / 16u)];
  vec2 v_8 = uintBitsToFloat(mix(v_7.xy, v_7.zw, bvec2((((v_6 & 15u) >> 2u) == 2u))));
  uint v_9 = (16u + start_byte_offset);
  uvec4 v_10 = v_1.inner[(v_9 / 16u)];
  vec2 v_11 = uintBitsToFloat(mix(v_10.xy, v_10.zw, bvec2((((v_9 & 15u) >> 2u) == 2u))));
  uint v_12 = (24u + start_byte_offset);
  uvec4 v_13 = v_1.inner[(v_12 / 16u)];
  return mat4x2(v_5, v_8, v_11, uintBitsToFloat(mix(v_13.xy, v_13.zw, bvec2((((v_12 & 15u) >> 2u) == 2u)))));
}
mat4x2[4] v_14(uint start_byte_offset) {
  mat4x2 v_15 = v_3(start_byte_offset);
  mat4x2 v_16 = v_3((32u + start_byte_offset));
  mat4x2 v_17 = v_3((64u + start_byte_offset));
  return mat4x2[4](v_15, v_16, v_17, v_3((96u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  float v_18 = a(v_14(0u));
  float v_19 = (v_18 + b(v_3(32u)));
  float v_20 = (v_19 + c(uintBitsToFloat(v_1.inner[2u].xy).yx));
  uvec4 v_21 = v_1.inner[2u];
  v_2.inner = (v_20 + d(uintBitsToFloat(v_21.y)));
}
