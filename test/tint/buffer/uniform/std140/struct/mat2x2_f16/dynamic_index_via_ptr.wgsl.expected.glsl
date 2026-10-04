#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct Inner {
  f16mat2 m;
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
f16vec2 tint_bitcast_to_16bit(uint src) {
  return unpackFloat2x16(src);
}
f16mat2 v_1(uint start_byte_offset) {
  f16vec2 v_2 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  return f16mat2(v_2, tint_bitcast_to_16bit(v.inner[(v_3 / 16u)][((v_3 & 15u) >> 2u)]));
}
Inner v_4(uint start_byte_offset) {
  return Inner(v_1(start_byte_offset));
}
Inner[4] v_5(uint start_byte_offset) {
  Inner v_6 = v_4(start_byte_offset);
  Inner v_7 = v_4((64u + start_byte_offset));
  Inner v_8 = v_4((128u + start_byte_offset));
  return Inner[4](v_6, v_7, v_8, v_4((192u + start_byte_offset)));
}
Outer v_9(uint start_byte_offset) {
  return Outer(v_5(start_byte_offset));
}
Outer[4] v_10(uint start_byte_offset) {
  Outer v_11 = v_9(start_byte_offset);
  Outer v_12 = v_9((256u + start_byte_offset));
  Outer v_13 = v_9((512u + start_byte_offset));
  return Outer[4](v_11, v_12, v_13, v_9((768u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_14 = (min(uint(i()), 3u) * 256u);
  uint v_15 = (min(uint(i()), 3u) * 64u);
  uint v_16 = (min(uint(i()), 1u) * 4u);
  Outer l_a[4] = v_10(0u);
  Outer l_a_i = v_9(v_14);
  Inner l_a_i_a[4] = v_5(v_14);
  Inner l_a_i_a_i = v_4((v_14 + v_15));
  f16mat2 l_a_i_a_i_m = v_1((v_14 + v_15));
  uint v_17 = ((v_14 + v_15) + v_16);
  f16vec2 l_a_i_a_i_m_i = tint_bitcast_to_16bit(v.inner[(v_17 / 16u)][((v_17 & 15u) >> 2u)]);
  uint v_18 = (((v_14 + v_15) + v_16) + (min(uint(i()), 1u) * 2u));
  uvec4 v_19 = v.inner[(v_18 / 16u)];
  float16_t l_a_i_a_i_m_i_i = tint_bitcast_to_16bit(v_19[((v_18 & 15u) >> 2u)])[mix(1u, 0u, ((v_18 % 4u) == 0u))];
}
