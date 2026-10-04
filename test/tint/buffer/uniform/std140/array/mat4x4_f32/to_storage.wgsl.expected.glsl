#version 310 es

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[16];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  mat4 inner[4];
} v_1;
mat4 v_2(uint start_byte_offset) {
  return mat4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)]));
}
mat4[4] v_3(uint start_byte_offset) {
  mat4 v_4 = v_2(start_byte_offset);
  mat4 v_5 = v_2((64u + start_byte_offset));
  mat4 v_6 = v_2((128u + start_byte_offset));
  return mat4[4](v_4, v_5, v_6, v_2((192u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v_1.inner = v_3(0u);
  v_1.inner[1] = v_2(128u);
  v_1.inner[1][0] = uintBitsToFloat(v.inner[1u]).ywxz;
  uvec4 v_7 = v.inner[1u];
  v_1.inner[1][0].x = uintBitsToFloat(v_7.x);
}
