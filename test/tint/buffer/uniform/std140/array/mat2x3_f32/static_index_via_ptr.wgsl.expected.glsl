#version 310 es

layout(binding = 0, std140)
uniform a_block_1_ubo {
  uvec4 inner[8];
} v;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  float inner;
} v_1;
mat2x3 v_2(uint start_byte_offset) {
  return mat2x3(uintBitsToFloat(v.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)].xyz));
}
mat2x3[4] v_3(uint start_byte_offset) {
  mat2x3 v_4 = v_2(start_byte_offset);
  mat2x3 v_5 = v_2((32u + start_byte_offset));
  mat2x3 v_6 = v_2((64u + start_byte_offset));
  return mat2x3[4](v_4, v_5, v_6, v_2((96u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  mat2x3 l_a[4] = v_3(0u);
  mat2x3 l_a_i = v_2(64u);
  vec3 l_a_i_i = uintBitsToFloat(v.inner[5u].xyz);
  uvec4 v_7 = v.inner[5u];
  v_1.inner = (((uintBitsToFloat(v_7.x) + l_a[0][0].x) + l_a_i[0].x) + l_a_i_i.x);
}
