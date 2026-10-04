#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct Inner {
  f16mat4x2 m;
};

struct Outer {
  Inner a[4];
};

layout(binding = 0, std140)
uniform a_block_1_ubo {
  uvec4 inner[64];
} v;
f16vec2 tint_bitcast_to_16bit(uint src) {
  return unpackFloat2x16(src);
}
f16mat4x2 v_1(uint start_byte_offset) {
  f16vec2 v_2 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  f16vec2 v_4 = tint_bitcast_to_16bit(v.inner[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  f16vec2 v_6 = tint_bitcast_to_16bit(v.inner[(v_5 / 16u)][((v_5 & 15u) >> 2u)]);
  uint v_7 = (12u + start_byte_offset);
  return f16mat4x2(v_2, v_4, v_6, tint_bitcast_to_16bit(v.inner[(v_7 / 16u)][((v_7 & 15u) >> 2u)]));
}
Inner v_8(uint start_byte_offset) {
  return Inner(v_1(start_byte_offset));
}
Inner[4] v_9(uint start_byte_offset) {
  Inner v_10 = v_8(start_byte_offset);
  Inner v_11 = v_8((64u + start_byte_offset));
  Inner v_12 = v_8((128u + start_byte_offset));
  return Inner[4](v_10, v_11, v_12, v_8((192u + start_byte_offset)));
}
Outer v_13(uint start_byte_offset) {
  return Outer(v_9(start_byte_offset));
}
Outer[4] v_14(uint start_byte_offset) {
  Outer v_15 = v_13(start_byte_offset);
  Outer v_16 = v_13((256u + start_byte_offset));
  Outer v_17 = v_13((512u + start_byte_offset));
  return Outer[4](v_15, v_16, v_17, v_13((768u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  Outer l_a[4] = v_14(0u);
  Outer l_a_3 = v_13(768u);
  Inner l_a_3_a[4] = v_9(768u);
  Inner l_a_3_a_2 = v_8(896u);
  f16mat4x2 l_a_3_a_2_m = v_1(896u);
  f16vec2 l_a_3_a_2_m_1 = tint_bitcast_to_16bit(v.inner[56u].y);
  uvec4 v_18 = v.inner[56u];
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_16bit(v_18.y).x;
}
