#version 310 es


struct Inner {
  mat3x2 m;
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
mat3x2 v_1(uint start_byte_offset) {
  uvec4 v_2 = v.inner[(start_byte_offset / 16u)];
  vec2 v_3 = uintBitsToFloat(mix(v_2.xy, v_2.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_4 = (8u + start_byte_offset);
  uvec4 v_5 = v.inner[(v_4 / 16u)];
  vec2 v_6 = uintBitsToFloat(mix(v_5.xy, v_5.zw, bvec2((((v_4 & 15u) >> 2u) == 2u))));
  uint v_7 = (16u + start_byte_offset);
  uvec4 v_8 = v.inner[(v_7 / 16u)];
  return mat3x2(v_3, v_6, uintBitsToFloat(mix(v_8.xy, v_8.zw, bvec2((((v_7 & 15u) >> 2u) == 2u)))));
}
Inner v_9(uint start_byte_offset) {
  return Inner(v_1(start_byte_offset));
}
Inner[4] v_10(uint start_byte_offset) {
  Inner v_11 = v_9(start_byte_offset);
  Inner v_12 = v_9((64u + start_byte_offset));
  Inner v_13 = v_9((128u + start_byte_offset));
  return Inner[4](v_11, v_12, v_13, v_9((192u + start_byte_offset)));
}
Outer v_14(uint start_byte_offset) {
  return Outer(v_10(start_byte_offset));
}
Outer[4] v_15(uint start_byte_offset) {
  Outer v_16 = v_14(start_byte_offset);
  Outer v_17 = v_14((256u + start_byte_offset));
  Outer v_18 = v_14((512u + start_byte_offset));
  return Outer[4](v_16, v_17, v_18, v_14((768u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_19 = (min(uint(i()), 3u) * 256u);
  uint v_20 = (min(uint(i()), 3u) * 64u);
  uint v_21 = (min(uint(i()), 2u) * 8u);
  Outer l_a[4] = v_15(0u);
  Outer l_a_i = v_14(v_19);
  Inner l_a_i_a[4] = v_10(v_19);
  Inner l_a_i_a_i = v_9((v_19 + v_20));
  mat3x2 l_a_i_a_i_m = v_1((v_19 + v_20));
  uint v_22 = ((v_19 + v_20) + v_21);
  uvec4 v_23 = v.inner[(v_22 / 16u)];
  vec2 l_a_i_a_i_m_i = uintBitsToFloat(mix(v_23.xy, v_23.zw, bvec2((((v_22 & 15u) >> 2u) == 2u))));
  uint v_24 = (((v_19 + v_20) + v_21) + (min(uint(i()), 1u) * 4u));
  uvec4 v_25 = v.inner[(v_24 / 16u)];
  float l_a_i_a_i_m_i_i = uintBitsToFloat(v_25[((v_24 & 15u) >> 2u)]);
}
