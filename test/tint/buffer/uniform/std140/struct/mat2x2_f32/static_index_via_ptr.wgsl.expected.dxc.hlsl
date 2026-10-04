struct Inner {
  float2x2 m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
float2x2 v(uint start_byte_offset) {
  uint4 v_1 = a[(start_byte_offset / 16u)];
  uint v_2 = (8u + start_byte_offset);
  uint4 v_3 = a[(v_2 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_1.zw, v_1.xy)), asfloat(select((((v_2 & 15u) >> 2u) == 2u), v_3.zw, v_3.xy)));
}

Inner v_4(uint start_byte_offset) {
  Inner v_5 = {v(start_byte_offset)};
  return v_5;
}

typedef Inner ary_ret[4];
ary_ret v_6(uint start_byte_offset) {
  Inner v_7 = v_4(start_byte_offset);
  Inner v_8 = v_4((64u + start_byte_offset));
  Inner v_9 = v_4((128u + start_byte_offset));
  Inner v_10 = v_4((192u + start_byte_offset));
  Inner v_11[4] = {v_7, v_8, v_9, v_10};
  return v_11;
}

Outer v_12(uint start_byte_offset) {
  Inner v_13[4] = v_6(start_byte_offset);
  Outer v_14 = {v_13};
  return v_14;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_15(uint start_byte_offset) {
  Outer v_16 = v_12(start_byte_offset);
  Outer v_17 = v_12((256u + start_byte_offset));
  Outer v_18 = v_12((512u + start_byte_offset));
  Outer v_19 = v_12((768u + start_byte_offset));
  Outer v_20[4] = {v_16, v_17, v_18, v_19};
  return v_20;
}

[numthreads(1, 1, 1)]
void f() {
  Outer l_a[4] = v_15(0u);
  Outer l_a_3 = v_12(768u);
  Inner l_a_3_a[4] = v_6(768u);
  Inner l_a_3_a_2 = v_4(896u);
  float2x2 l_a_3_a_2_m = v(896u);
  float2 l_a_3_a_2_m_1 = asfloat(a[56u].zw);
  float l_a_3_a_2_m_1_0 = asfloat(a[56u].z);
}

