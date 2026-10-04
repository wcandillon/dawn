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
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = a[(v_3 / 16u)];
  return float2x2(v_2, asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy))));
}

Inner v_5(uint start_byte_offset) {
  Inner v_6 = {v(start_byte_offset)};
  return v_6;
}

typedef Inner ary_ret[4];
ary_ret v_7(uint start_byte_offset) {
  Inner v_8 = v_5(start_byte_offset);
  Inner v_9 = v_5((64u + start_byte_offset));
  Inner v_10 = v_5((128u + start_byte_offset));
  Inner v_11 = v_5((192u + start_byte_offset));
  Inner v_12[4] = {v_8, v_9, v_10, v_11};
  return v_12;
}

Outer v_13(uint start_byte_offset) {
  Inner v_14[4] = v_7(start_byte_offset);
  Outer v_15 = {v_14};
  return v_15;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_16(uint start_byte_offset) {
  Outer v_17 = v_13(start_byte_offset);
  Outer v_18 = v_13((256u + start_byte_offset));
  Outer v_19 = v_13((512u + start_byte_offset));
  Outer v_20 = v_13((768u + start_byte_offset));
  Outer v_21[4] = {v_17, v_18, v_19, v_20};
  return v_21;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_22 = (min(uint(i()), 3u) * 256u);
  uint v_23 = (min(uint(i()), 3u) * 64u);
  uint v_24 = (min(uint(i()), 1u) * 8u);
  Outer l_a[4] = v_16(0u);
  Outer l_a_i = v_13(v_22);
  Inner l_a_i_a[4] = v_7(v_22);
  Inner l_a_i_a_i = v_5((v_22 + v_23));
  float2x2 l_a_i_a_i_m = v((v_22 + v_23));
  uint v_25 = ((v_22 + v_23) + v_24);
  uint4 v_26 = a[(v_25 / 16u)];
  float2 l_a_i_a_i_m_i = asfloat((((((v_25 & 15u) >> 2u) == 2u)) ? (v_26.zw) : (v_26.xy)));
  uint v_27 = (((v_22 + v_23) + v_24) + (min(uint(i()), 1u) * 4u));
  float l_a_i_a_i_m_i_i = asfloat(a[(v_27 / 16u)][((v_27 & 15u) >> 2u)]);
}

