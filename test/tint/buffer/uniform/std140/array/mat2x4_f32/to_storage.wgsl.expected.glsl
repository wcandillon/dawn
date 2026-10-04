#version 310 es

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[8];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  mat2x4 inner[4];
} v_1;
mat2x4 v_2(uint start_byte_offset) {
  return mat2x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]));
}
mat2x4[4] v_3(uint start_byte_offset) {
  mat2x4 v_4 = v_2(start_byte_offset);
  mat2x4 v_5 = v_2((32u + start_byte_offset));
  mat2x4 v_6 = v_2((64u + start_byte_offset));
  return mat2x4[4](v_4, v_5, v_6, v_2((96u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v_1.inner = v_3(0u);
  v_1.inner[1] = v_2(64u);
  v_1.inner[1][0] = uintBitsToFloat(v.inner[1u]).ywxz;
  uvec4 v_7 = v.inner[1u];
  v_1.inner[1][0].x = uintBitsToFloat(v_7.x);
}
