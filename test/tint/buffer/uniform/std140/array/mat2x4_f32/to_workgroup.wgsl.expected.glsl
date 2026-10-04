#version 310 es

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[8];
} v;
shared mat2x4 w[4];
mat2x4 v_1(uint start_byte_offset) {
  return mat2x4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]));
}
mat2x4[4] v_2(uint start_byte_offset) {
  mat2x4 v_3 = v_1(start_byte_offset);
  mat2x4 v_4 = v_1((32u + start_byte_offset));
  mat2x4 v_5 = v_1((64u + start_byte_offset));
  return mat2x4[4](v_3, v_4, v_5, v_1((96u + start_byte_offset)));
}
void f_inner(uint tint_local_index) {
  {
    uint v_6 = 0u;
    v_6 = tint_local_index;
    while(true) {
      uint v_7 = v_6;
      if ((v_7 >= 4u)) {
        break;
      }
      w[v_7] = mat2x4(vec4(0.0f), vec4(0.0f));
      {
        v_6 = (v_7 + 1u);
      }
    }
  }
  barrier();
  w = v_2(0u);
  w[1] = v_1(64u);
  w[1][0] = uintBitsToFloat(v.inner[1u]).ywxz;
  uvec4 v_8 = v.inner[1u];
  w[1][0].x = uintBitsToFloat(v_8.x);
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  f_inner(gl_LocalInvocationIndex);
}
