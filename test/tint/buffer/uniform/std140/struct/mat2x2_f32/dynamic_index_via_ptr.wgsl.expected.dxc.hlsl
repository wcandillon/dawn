struct Inner {
  float2x2 m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
static int counter = int(0);
int i() {
  counter = asint((asuint(counter) + 1u));
  return counter;
}

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
  uint v_21 = (min(uint(i()), 3u) * 256u);
  uint v_22 = (min(uint(i()), 3u) * 64u);
  uint v_23 = (min(uint(i()), 1u) * 8u);
  Outer l_a[4] = v_15(0u);
  Outer l_a_i = v_12(v_21);
  Inner l_a_i_a[4] = v_6(v_21);
  Inner l_a_i_a_i = v_4((v_21 + v_22));
  float2x2 l_a_i_a_i_m = v((v_21 + v_22));
  uint v_24 = ((v_21 + v_22) + v_23);
  uint4 v_25 = a[(v_24 / 16u)];
  float2 l_a_i_a_i_m_i = asfloat(select((((v_24 & 15u) >> 2u) == 2u), v_25.zw, v_25.xy));
  uint v_26 = (((v_21 + v_22) + v_23) + (min(uint(i()), 1u) * 4u));
  float l_a_i_a_i_m_i_i = asfloat(a[(v_26 / 16u)][((v_26 & 15u) >> 2u)]);
}

