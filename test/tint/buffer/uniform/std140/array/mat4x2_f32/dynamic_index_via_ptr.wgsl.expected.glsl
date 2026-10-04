#version 310 es

layout(binding = 0, std140)
uniform a_block_1_ubo {
  uvec4 inner[8];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  float inner;
} v_1;
int counter = 0;
int i() {
  counter = int((uint(counter) + 1u));
  return counter;
}
mat4x2 v_2(uint start_byte_offset) {
  uvec4 v_3 = v.inner[(start_byte_offset / 16u)];
  vec2 v_4 = uintBitsToFloat(mix(v_3.xy, v_3.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_5 = (8u + start_byte_offset);
  uvec4 v_6 = v.inner[(v_5 / 16u)];
  vec2 v_7 = uintBitsToFloat(mix(v_6.xy, v_6.zw, bvec2((((v_5 & 15u) >> 2u) == 2u))));
  uint v_8 = (16u + start_byte_offset);
  uvec4 v_9 = v.inner[(v_8 / 16u)];
  vec2 v_10 = uintBitsToFloat(mix(v_9.xy, v_9.zw, bvec2((((v_8 & 15u) >> 2u) == 2u))));
  uint v_11 = (24u + start_byte_offset);
  uvec4 v_12 = v.inner[(v_11 / 16u)];
  return mat4x2(v_4, v_7, v_10, uintBitsToFloat(mix(v_12.xy, v_12.zw, bvec2((((v_11 & 15u) >> 2u) == 2u)))));
}
mat4x2[4] v_13(uint start_byte_offset) {
  mat4x2 v_14 = v_2(start_byte_offset);
  mat4x2 v_15 = v_2((32u + start_byte_offset));
  mat4x2 v_16 = v_2((64u + start_byte_offset));
  return mat4x2[4](v_14, v_15, v_16, v_2((96u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_17 = (min(uint(i()), 3u) * 32u);
  uint v_18 = (min(uint(i()), 3u) * 8u);
  mat4x2 l_a[4] = v_13(0u);
  mat4x2 l_a_i = v_2(v_17);
  uint v_19 = (v_17 + v_18);
  uvec4 v_20 = v.inner[(v_19 / 16u)];
  vec2 l_a_i_i = uintBitsToFloat(mix(v_20.xy, v_20.zw, bvec2((((v_19 & 15u) >> 2u) == 2u))));
  uint v_21 = (v_17 + v_18);
  uvec4 v_22 = v.inner[(v_21 / 16u)];
  v_1.inner = (((uintBitsToFloat(v_22[((v_21 & 15u) >> 2u)]) + l_a[0][0].x) + l_a_i[0].x) + l_a_i_i.x);
}
