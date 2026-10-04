#version 310 es

layout(binding = 0, std140)
uniform S_block_1_ubo {
  uvec4 inner[4];
} v;
ivec4[4] v_1(uint start_byte_offset) {
  ivec4 v_2 = ivec4(v.inner[(start_byte_offset / 16u)]);
  ivec4 v_3 = ivec4(v.inner[((16u + start_byte_offset) / 16u)]);
  ivec4 v_4 = ivec4(v.inner[((32u + start_byte_offset) / 16u)]);
  return ivec4[4](v_2, v_3, v_4, ivec4(v.inner[((48u + start_byte_offset) / 16u)]));
}
ivec4[4] func() {
  return v_1(0u);
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  ivec4 r[4] = func();
}
