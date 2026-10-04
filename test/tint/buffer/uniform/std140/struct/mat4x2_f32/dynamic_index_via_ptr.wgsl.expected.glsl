#version 310 es


struct Inner {
  mat4x2 m;
};

struct Outer {
  Inner a[4];
};

layout(binding = 0, std140)
uniform a_block_1_ubo {
  uvec4 inner[64];
} v;
int counter = 0;
int i() {
  counter = int((uint(counter) + 1u));
  return counter;
}
mat4x2 v_1(uint start_byte_offset) {
  uvec4 v_2 = v.inner[(start_byte_offset / 16u)];
  vec2 v_3 = uintBitsToFloat(mix(v_2.xy, v_2.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_4 = (8u + start_byte_offset);
  uvec4 v_5 = v.inner[(v_4 / 16u)];
  vec2 v_6 = uintBitsToFloat(mix(v_5.xy, v_5.zw, bvec2((((v_4 & 15u) >> 2u) == 2u))));
  uint v_7 = (16u + start_byte_offset);
  uvec4 v_8 = v.inner[(v_7 / 16u)];
  vec2 v_9 = uintBitsToFloat(mix(v_8.xy, v_8.zw, bvec2((((v_7 & 15u) >> 2u) == 2u))));
  uint v_10 = (24u + start_byte_offset);
  uvec4 v_11 = v.inner[(v_10 / 16u)];
  return mat4x2(v_3, v_6, v_9, uintBitsToFloat(mix(v_11.xy, v_11.zw, bvec2((((v_10 & 15u) >> 2u) == 2u)))));
}
Inner v_12(uint start_byte_offset) {
  return Inner(v_1(start_byte_offset));
}
Inner[4] v_13(uint start_byte_offset) {
  Inner v_14 = v_12(start_byte_offset);
  Inner v_15 = v_12((64u + start_byte_offset));
  Inner v_16 = v_12((128u + start_byte_offset));
  return Inner[4](v_14, v_15, v_16, v_12((192u + start_byte_offset)));
}
Outer v_17(uint start_byte_offset) {
  return Outer(v_13(start_byte_offset));
}
Outer[4] v_18(uint start_byte_offset) {
  Outer v_19 = v_17(start_byte_offset);
  Outer v_20 = v_17((256u + start_byte_offset));
  Outer v_21 = v_17((512u + start_byte_offset));
  return Outer[4](v_19, v_20, v_21, v_17((768u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_22 = (min(uint(i()), 3u) * 256u);
  uint v_23 = (min(uint(i()), 3u) * 64u);
  uint v_24 = (min(uint(i()), 3u) * 8u);
  Outer l_a[4] = v_18(0u);
  Outer l_a_i = v_17(v_22);
  Inner l_a_i_a[4] = v_13(v_22);
  Inner l_a_i_a_i = v_12((v_22 + v_23));
  mat4x2 l_a_i_a_i_m = v_1((v_22 + v_23));
  uint v_25 = ((v_22 + v_23) + v_24);
  uvec4 v_26 = v.inner[(v_25 / 16u)];
  vec2 l_a_i_a_i_m_i = uintBitsToFloat(mix(v_26.xy, v_26.zw, bvec2((((v_25 & 15u) >> 2u) == 2u))));
  uint v_27 = (((v_22 + v_23) + v_24) + (min(uint(i()), 1u) * 4u));
  uvec4 v_28 = v.inner[(v_27 / 16u)];
  float l_a_i_a_i_m_i_i = uintBitsToFloat(v_28[((v_27 & 15u) >> 2u)]);
}
