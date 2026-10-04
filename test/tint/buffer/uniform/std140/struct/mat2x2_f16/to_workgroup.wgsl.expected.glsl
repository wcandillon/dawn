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
} v;
shared S w[4];
f16vec2 tint_bitcast_to_16bit(uint src) {
  return unpackFloat2x16(src);
}
f16mat2 v_1(uint start_byte_offset) {
  f16vec2 v_2 = tint_bitcast_to_16bit(v.inner[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  return f16mat2(v_2, tint_bitcast_to_16bit(v.inner[(v_3 / 16u)][((v_3 & 15u) >> 2u)]));
}
S v_4(uint start_byte_offset) {
  uvec4 v_5 = v.inner[(start_byte_offset / 16u)];
  int v_6 = int(v_5[((start_byte_offset & 15u) >> 2u)]);
  f16mat2 v_7 = v_1((4u + start_byte_offset));
  uint v_8 = (64u + start_byte_offset);
  uvec4 v_9 = v.inner[(v_8 / 16u)];
  return S(v_6, v_7, int(v_9[((v_8 & 15u) >> 2u)]));
}
S[4] v_10(uint start_byte_offset) {
  S v_11 = v_4(start_byte_offset);
  S v_12 = v_4((128u + start_byte_offset));
  S v_13 = v_4((256u + start_byte_offset));
  return S[4](v_11, v_12, v_13, v_4((384u + start_byte_offset)));
}
void f_inner(uint tint_local_index) {
  {
    uint v_14 = 0u;
    v_14 = tint_local_index;
    while(true) {
      uint v_15 = v_14;
      if ((v_15 >= 4u)) {
        break;
      }
      w[v_15] = S(0, f16mat2(f16vec2(0.0hf), f16vec2(0.0hf)), 0);
      {
        v_14 = (v_15 + 1u);
      }
    }
  }
  barrier();
  w = v_10(0u);
  w[1] = v_4(256u);
  w[3].m = v_1(260u);
  w[1].m[0] = tint_bitcast_to_16bit(v.inner[0u].z).yx;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  f_inner(gl_LocalInvocationIndex);
}
