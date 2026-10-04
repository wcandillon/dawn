#version 310 es

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[16];
} v_1;
layout(binding = 1, std430)
buffer s_block_1_ssbo {
  float inner;
} v_2;
float a(mat4x3 a_1[4]) {
  return a_1[0][0].x;
}
float b(mat4x3 m) {
  return m[0].x;
}
float c(vec3 v) {
  return v.x;
}
float d(float f_1) {
  return f_1;
}
mat4x3 v_3(uint start_byte_offset) {
  return mat4x3(uintBitsToFloat(v_1.inner[(start_byte_offset / 16u)].xyz), uintBitsToFloat(v_1.inner[((16u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v_1.inner[((32u + start_byte_offset) / 16u)].xyz), uintBitsToFloat(v_1.inner[((48u + start_byte_offset) / 16u)].xyz));
}
mat4x3[4] v_4(uint start_byte_offset) {
  mat4x3 v_5 = v_3(start_byte_offset);
  mat4x3 v_6 = v_3((64u + start_byte_offset));
  mat4x3 v_7 = v_3((128u + start_byte_offset));
  return mat4x3[4](v_5, v_6, v_7, v_3((192u + start_byte_offset)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  float v_8 = a(v_4(0u));
  float v_9 = (v_8 + b(v_3(64u)));
  float v_10 = (v_9 + c(uintBitsToFloat(v_1.inner[4u].xyz).zxy));
  uvec4 v_11 = v_1.inner[4u];
  v_2.inner = (v_10 + d(uintBitsToFloat(v_11.z)));
}
