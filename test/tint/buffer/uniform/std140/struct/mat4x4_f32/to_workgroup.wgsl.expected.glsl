#version 310 es


struct S {
  int before;
  mat4 m;
  int after;
};

layout(binding = 0, std140)
uniform u_block_1_ubo {
  uvec4 inner[48];
} v;
shared S w[4];
mat4 v_1(uint start_byte_offset) {
  return mat4(uintBitsToFloat(v.inner[(start_byte_offset / 16u)]), uintBitsToFloat(v.inner[((16u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((32u + start_byte_offset) / 16u)]), uintBitsToFloat(v.inner[((48u + start_byte_offset) / 16u)]));
}
S v_2(uint start_byte_offset) {
  uvec4 v_3 = v.inner[(start_byte_offset / 16u)];
  int v_4 = int(v_3[((start_byte_offset & 15u) >> 2u)]);
  mat4 v_5 = v_1((16u + start_byte_offset));
  uint v_6 = (128u + start_byte_offset);
  uvec4 v_7 = v.inner[(v_6 / 16u)];
  return S(v_4, v_5, int(v_7[((v_6 & 15u) >> 2u)]));
}
S[4] v_8(uint start_byte_offset) {
  S v_9 = v_2(start_byte_offset);
  S v_10 = v_2((192u + start_byte_offset));
  S v_11 = v_2((384u + start_byte_offset));
  return S[4](v_9, v_10, v_11, v_2((576u + start_byte_offset)));
}
void f_inner(uint tint_local_index) {
  {
    uint v_12 = 0u;
    v_12 = tint_local_index;
    while(true) {
      uint v_13 = v_12;
      if ((v_13 >= 4u)) {
        break;
      }
      w[v_13] = S(0, mat4(vec4(0.0f), vec4(0.0f), vec4(0.0f), vec4(0.0f)), 0);
      {
        v_12 = (v_13 + 1u);
      }
    }
  }
  barrier();
  w = v_8(0u);
  w[1] = v_2(384u);
  w[3].m = v_1(400u);
  w[1].m[0] = uintBitsToFloat(v.inner[2u]).ywxz;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  f_inner(gl_LocalInvocationIndex);
}
