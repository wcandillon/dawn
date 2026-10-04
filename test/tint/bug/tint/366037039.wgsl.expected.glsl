#version 310 es


struct S {
  uvec3 a;
  uint b;
  uvec3 c[4];
};

layout(binding = 0, std140)
uniform ubuffer_block_1_ubo {
  uvec4 inner[5];
} v;
layout(binding = 1, std430)
buffer sbuffer_block_1_ssbo {
  S inner;
} v_1;
shared S wbuffer;
void tint_store_and_preserve_padding_1(uvec3 value_param[4]) {
  {
    uint v_2 = 0u;
    v_2 = 0u;
    while(true) {
      uint v_3 = v_2;
      if ((v_3 >= 4u)) {
        break;
      }
      v_1.inner.c[v_3] = value_param[v_3];
      {
        v_2 = (v_3 + 1u);
      }
    }
  }
}
void tint_store_and_preserve_padding(S value_param) {
  v_1.inner.a = value_param.a;
  v_1.inner.b = value_param.b;
  tint_store_and_preserve_padding_1(value_param.c);
}
uvec3[4] v_4(uint start_byte_offset) {
  return uvec3[4](v.inner[(start_byte_offset / 16u)].xyz, v.inner[((16u + start_byte_offset) / 16u)].xyz, v.inner[((32u + start_byte_offset) / 16u)].xyz, v.inner[((48u + start_byte_offset) / 16u)].xyz);
}
S v_5(uint start_byte_offset) {
  uvec3 v_6 = v.inner[(start_byte_offset / 16u)].xyz;
  uint v_7 = (12u + start_byte_offset);
  uvec4 v_8 = v.inner[(v_7 / 16u)];
  return S(v_6, v_8[((v_7 & 15u) >> 2u)], v_4((16u + start_byte_offset)));
}
void foo_inner(uint tint_local_index) {
  if ((tint_local_index < 1u)) {
    wbuffer.a = uvec3(0u);
    wbuffer.b = 0u;
  }
  {
    uint v_9 = 0u;
    v_9 = tint_local_index;
    while(true) {
      uint v_10 = v_9;
      if ((v_10 >= 4u)) {
        break;
      }
      wbuffer.c[v_10] = uvec3(0u);
      {
        v_9 = (v_10 + 1u);
      }
    }
  }
  barrier();
  S u = v_5(0u);
  S s = v_1.inner;
  S w = v_1.inner;
  tint_store_and_preserve_padding(S(uvec3(0u), 0u, uvec3[4](uvec3(0u), uvec3(0u), uvec3(0u), uvec3(0u))));
  wbuffer = S(uvec3(0u), 0u, uvec3[4](uvec3(0u), uvec3(0u), uvec3(0u), uvec3(0u)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  foo_inner(gl_LocalInvocationIndex);
}
