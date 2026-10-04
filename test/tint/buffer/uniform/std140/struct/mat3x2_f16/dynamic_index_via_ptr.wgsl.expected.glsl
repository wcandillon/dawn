#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct Inner {
  f16mat3x2 m;
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
f16mat3x2 v_1(uint start_byte_offset) {
  f16vec2 v_2 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  f16vec2 v_4 = tint_bitcast_to_16bit(v.inner[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  return f16mat3x2(v_2, v_4, tint_bitcast_to_16bit(v.inner[(v_5 / 16u)][((v_5 & 15u) >> 2u)]));
}
Inner v_6(uint start_byte_offset) {
  return Inner(v_1(start_byte_offset));
}
Inner[4] v_7(uint start_byte_offset) {
  Inner v_8 = v_6(start_byte_offset);
  Inner v_9 = v_6((64u + start_byte_offset));
  Inner v_10 = v_6((128u + start_byte_offset));
  return Inner[4](v_8, v_9, v_10, v_6((192u + start_byte_offset)));
}
Outer v_11(uint start_byte_offset) {
  return Outer(v_7(start_byte_offset));
}
Outer[4] v_12(uint start_byte_offset) {
  Outer v_13 = v_11(start_byte_offset);
  Outer v_14 = v_11((256u + start_byte_offset));
  Outer v_15 = v_11((512u + start_byte_offset));
  return Outer[4](v_13, v_14, v_15, v_11((768u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uint v_16 = (min(uint(i()), 3u) * 256u);
  uint v_17 = (min(uint(i()), 3u) * 64u);
  uint v_18 = (min(uint(i()), 2u) * 4u);
  Outer l_a[4] = v_12(0u);
  Outer l_a_i = v_11(v_16);
  Inner l_a_i_a[4] = v_7(v_16);
  Inner l_a_i_a_i = v_6((v_16 + v_17));
  f16mat3x2 l_a_i_a_i_m = v_1((v_16 + v_17));
  uint v_19 = ((v_16 + v_17) + v_18);
  f16vec2 l_a_i_a_i_m_i = tint_bitcast_to_16bit(v.inner[(v_19 / 16u)][((v_19 & 15u) >> 2u)]);
  uint v_20 = (((v_16 + v_17) + v_18) + (min(uint(i()), 1u) * 2u));
  uvec4 v_21 = v.inner[(v_20 / 16u)];
  float16_t l_a_i_a_i_m_i_i = tint_bitcast_to_16bit(v_21[((v_20 & 15u) >> 2u)])[mix(1u, 0u, ((v_20 % 4u) == 0u))];
}
