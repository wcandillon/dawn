#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct S {
  int before;
  f16mat2 m;
  int after;
};

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[32];
} v_1;
void a(S a_1[4]) {
}
void b(S s) {
}
void c(f16mat2 m) {
}
void d(f16vec2 v) {
}
void e(float16_t f_1) {
}
f16vec2 tint_bitcast_to_16bit(uint src) {
  return unpackFloat2x16(src);
}
f16mat2 v_2(uint start_byte_offset) {
  f16vec2 v_3 = tint_bitcast_to_16bit(v_1.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_4 = (4u + start_byte_offset);
  return f16mat2(v_3, tint_bitcast_to_16bit(v_1.inner[(v_4 / 16u)][((v_4 & 15u) >> 2u)]));
}
S v_5(uint start_byte_offset) {
  uvec4 v_6 = v_1.inner[(start_byte_offset / 16u)];
  int v_7 = int(v_6[((start_byte_offset & 15u) >> 2u)]);
  f16mat2 v_8 = v_2((4u + start_byte_offset));
  uint v_9 = (64u + start_byte_offset);
  uvec4 v_10 = v_1.inner[(v_9 / 16u)];
  return S(v_7, v_8, int(v_10[((v_9 & 15u) >> 2u)]));
}
S[4] v_11(uint start_byte_offset) {
  S v_12 = v_5(start_byte_offset);
  S v_13 = v_5((128u + start_byte_offset));
  S v_14 = v_5((256u + start_byte_offset));
  return S[4](v_12, v_13, v_14, v_5((384u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  a(v_11(0u));
  b(v_5(256u));
  c(v_2(260u));
  d(tint_bitcast_to_16bit(v_1.inner[0u].z).yx);
  uvec4 v_15 = v_1.inner[0u];
  e(tint_bitcast_to_16bit(v_15.z).y);
}
