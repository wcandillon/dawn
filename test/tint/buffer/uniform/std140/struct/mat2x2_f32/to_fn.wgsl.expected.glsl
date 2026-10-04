#version 310 es


struct S {
  int before;
  mat2 m;
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
void c(mat2 m) {
}
void d(vec2 v) {
}
void e(float f_1) {
}
mat2 v_2(uint start_byte_offset) {
  uvec4 v_3 = v_1.inner[(start_byte_offset / 16u)];
  vec2 v_4 = uintBitsToFloat(mix(v_3.xy, v_3.zw, bvec2((((start_byte_offset & 15u) >> 2u) == 2u))));
  uint v_5 = (8u + start_byte_offset);
  uvec4 v_6 = v_1.inner[(v_5 / 16u)];
  return mat2(v_4, uintBitsToFloat(mix(v_6.xy, v_6.zw, bvec2((((v_5 & 15u) >> 2u) == 2u)))));
}
S v_7(uint start_byte_offset) {
  uvec4 v_8 = v_1.inner[(start_byte_offset / 16u)];
  int v_9 = int(v_8[((start_byte_offset & 15u) >> 2u)]);
  mat2 v_10 = v_2((8u + start_byte_offset));
  uint v_11 = (64u + start_byte_offset);
  uvec4 v_12 = v_1.inner[(v_11 / 16u)];
  return S(v_9, v_10, int(v_12[((v_11 & 15u) >> 2u)]));
}
S[4] v_13(uint start_byte_offset) {
  S v_14 = v_7(start_byte_offset);
  S v_15 = v_7((128u + start_byte_offset));
  S v_16 = v_7((256u + start_byte_offset));
  return S[4](v_14, v_15, v_16, v_7((384u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  a(v_13(0u));
  b(v_7(256u));
  c(v_2(264u));
  d(uintBitsToFloat(v_1.inner[1u].xy).yx);
  uvec4 v_17 = v_1.inner[1u];
  e(uintBitsToFloat(v_17.y));
}
