#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct Inner {
  f16mat4x3 m;
};

struct Outer {
  Inner a[4];
};

layout(binding = 0, std140)
uniform a_block_1_ubo {
  uvec4 inner[64];
} v;
f16vec2 tint_bitcast_to_16bit_1(uint src) {
  return unpackFloat2x16(src);
}
f16vec4 tint_bitcast_to_16bit(uvec2 src) {
  return f16vec4(unpackFloat2x16(src.x), unpackFloat2x16(src.y));
}
f16mat4x3 v_1(uint start_byte_offset) {
  uvec4 v_2 = v.inner[(start_byte_offset / 16u)];
  f16vec3 v_3 = tint_bitcast_to_16bit(mix(v_2.xy, v_2.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u)))).xyz;
  uint v_4 = (8u + start_byte_offset);
  uvec4 v_5 = v.inner[(v_4 / 16u)];
  f16vec3 v_6 = tint_bitcast_to_16bit(mix(v_5.xy, v_5.zw, bvec2((((v_4 & 15u) >> 2u) == 2u)))).xyz;
  uint v_7 = (16u + start_byte_offset);
  uvec4 v_8 = v.inner[(v_7 / 16u)];
  f16vec3 v_9 = tint_bitcast_to_16bit(mix(v_8.xy, v_8.zw, bvec2((((v_7 & 15u) >> 2u) == 2u)))).xyz;
  uint v_10 = (24u + start_byte_offset);
  uvec4 v_11 = v.inner[(v_10 / 16u)];
  return f16mat4x3(v_3, v_6, v_9, tint_bitcast_to_16bit(mix(v_11.xy, v_11.zw, bvec2((((v_10 & 15u) >> 2u) == 2u)))).xyz);
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
  Outer l_a[4] = v_18(0u);
  Outer l_a_3 = v_17(768u);
  Inner l_a_3_a[4] = v_13(768u);
  Inner l_a_3_a_2 = v_12(896u);
  f16mat4x3 l_a_3_a_2_m = v_1(896u);
  f16vec3 l_a_3_a_2_m_1 = tint_bitcast_to_16bit(v.inner[56u].zw).xyz;
  uvec4 v_22 = v.inner[56u];
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_16bit_1(v_22.z).x;
}
