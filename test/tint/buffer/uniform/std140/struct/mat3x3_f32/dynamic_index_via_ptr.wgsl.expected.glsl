#version 310 es


struct Inner {
  mat3 m;
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
mat3 v_1(uint start_byte_offset) {
  return mat3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)].xyz));
}
Inner v_2(uint start_byte_offset) {
  return Inner(v_1(start_byte_offset));
}
Inner[4] v_3(uint start_byte_offset) {
  Inner v_4 = v_2(start_byte_offset);
  Inner v_5 = v_2((64u + start_byte_offset));
  Inner v_6 = v_2((128u + start_byte_offset));
  return Inner[4](v_4, v_5, v_6, v_2((192u + start_byte_offset)));
}
Outer v_7(uint start_byte_offset) {
  return Outer(v_3(start_byte_offset));
}
Outer[4] v_8(uint start_byte_offset) {
  Outer v_9 = v_7(start_byte_offset);
  Outer v_10 = v_7((256u + start_byte_offset));
  Outer v_11 = v_7((512u + start_byte_offset));
  return Outer[4](v_9, v_10, v_11, v_7((768u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_12 = (min(uint(i()), 3u) * 256u);
  uint v_13 = (min(uint(i()), 3u) * 64u);
  uint v_14 = (min(uint(i()), 2u) * 16u);
  Outer l_a[4] = v_8(0u);
  Outer l_a_i = v_7(v_12);
  Inner l_a_i_a[4] = v_3(v_12);
  Inner l_a_i_a_i = v_2((v_12 + v_13));
  mat3 l_a_i_a_i_m = v_1((v_12 + v_13));
  vec3 l_a_i_a_i_m_i = uintBitsToFloat(v.inner[(((v_12 + v_13) + v_14) / 16u)].xyz);
  uint v_15 = (((v_12 + v_13) + v_14) + (min(uint(i()), 2u) * 4u));
  uvec4 v_16 = v.inner[(v_15 / 16u)];
  float l_a_i_a_i_m_i_i = uintBitsToFloat(v_16[((v_15 & 15u) >> 2u)]);
}
