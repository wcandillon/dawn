struct Inner {
  float3x4 m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
float3x4 v(uint start_byte_offset) {
  return float3x4(asfloat(a[(start_byte_offset / 16u)]), asfloat(a[((16u + start_byte_offset) / 16u)]), asfloat(a[((32u + start_byte_offset) / 16u)]));
}

Inner v_1(uint start_byte_offset) {
  Inner v_2 = {v(start_byte_offset)};
  return v_2;
}

typedef Inner ary_ret[4];
ary_ret v_3(uint start_byte_offset) {
  Inner v_4 = v_1(start_byte_offset);
  Inner v_5 = v_1((64u + start_byte_offset));
  Inner v_6 = v_1((128u + start_byte_offset));
  Inner v_7 = v_1((192u + start_byte_offset));
  Inner v_8[4] = {v_4, v_5, v_6, v_7};
  return v_8;
}

Outer v_9(uint start_byte_offset) {
  Inner v_10[4] = v_3(start_byte_offset);
  Outer v_11 = {v_10};
  return v_11;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_12(uint start_byte_offset) {
  Outer v_13 = v_9(start_byte_offset);
  Outer v_14 = v_9((256u + start_byte_offset));
  Outer v_15 = v_9((512u + start_byte_offset));
  Outer v_16 = v_9((768u + start_byte_offset));
  Outer v_17[4] = {v_13, v_14, v_15, v_16};
  return v_17;
}

[numthreads(1, 1, 1)]
void f() {
  Outer l_a[4] = v_12(0u);
  Outer l_a_3 = v_9(768u);
  Inner l_a_3_a[4] = v_3(768u);
  Inner l_a_3_a_2 = v_1(896u);
  float3x4 l_a_3_a_2_m = v(896u);
  float4 l_a_3_a_2_m_1 = asfloat(a[57u]);
  float l_a_3_a_2_m_1_0 = asfloat(a[57u].x);
}

