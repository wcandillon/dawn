#version 310 es

layout(binding = 0, std140)
uniform a_block_1_ubo {
  uvec4 inner[4];
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
mat2 v_2(uint start_byte_offset) {
  uvec4 v_3 = v.inner[(start_byte_offset / 16u)];
  vec2 v_4 = uintBitsToFloat(mix(v_3.xy, v_3.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_5 = (8u + start_byte_offset);
  uvec4 v_6 = v.inner[(v_5 / 16u)];
  return mat2(v_4, uintBitsToFloat(mix(v_6.xy, v_6.zw, bvec2((((v_5 & 15u) >> 2u) == 2u)))));
}
mat2[4] v_7(uint start_byte_offset) {
  mat2 v_8 = v_2(start_byte_offset);
  mat2 v_9 = v_2((16u + start_byte_offset));
  mat2 v_10 = v_2((32u + start_byte_offset));
  return mat2[4](v_8, v_9, v_10, v_2((48u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_11 = (min(uint(i()), 3u) * 16u);
  uint v_12 = (min(uint(i()), 1u) * 8u);
  mat2 l_a[4] = v_7(0u);
  mat2 l_a_i = v_2(v_11);
  uint v_13 = (v_11 + v_12);
  uvec4 v_14 = v.inner[(v_13 / 16u)];
  vec2 l_a_i_i = uintBitsToFloat(mix(v_14.xy, v_14.zw, bvec2((((v_13 & 15u) >> 2u) == 2u))));
  uint v_15 = (v_11 + v_12);
  uvec4 v_16 = v.inner[(v_15 / 16u)];
  v_1.inner = (((uintBitsToFloat(v_16[((v_15 & 15u) >> 2u)]) + l_a[0][0].x) + l_a_i[0].x) + l_a_i_i.x);
}
