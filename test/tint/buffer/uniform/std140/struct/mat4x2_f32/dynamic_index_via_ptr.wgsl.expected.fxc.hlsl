struct Inner {
  float4x2 m;
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

float4x2 v(uint start_byte_offset) {
  uint4 v_1 = a[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = a[(v_3 / 16u)];
  float2 v_5 = asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy)));
  uint v_6 = (16u + start_byte_offset);
  uint4 v_7 = a[(v_6 / 16u)];
  float2 v_8 = asfloat((((((v_6 & 15u) >> 2u) == 2u)) ? (v_7.zw) : (v_7.xy)));
  uint v_9 = (24u + start_byte_offset);
  uint4 v_10 = a[(v_9 / 16u)];
  return float4x2(v_2, v_5, v_8, asfloat((((((v_9 & 15u) >> 2u) == 2u)) ? (v_10.zw) : (v_10.xy))));
}

Inner v_11(uint start_byte_offset) {
  Inner v_12 = {v(start_byte_offset)};
  return v_12;
}

typedef Inner ary_ret[4];
ary_ret v_13(uint start_byte_offset) {
  Inner v_14 = v_11(start_byte_offset);
  Inner v_15 = v_11((64u + start_byte_offset));
  Inner v_16 = v_11((128u + start_byte_offset));
  Inner v_17 = v_11((192u + start_byte_offset));
  Inner v_18[4] = {v_14, v_15, v_16, v_17};
  return v_18;
}

Outer v_19(uint start_byte_offset) {
  Inner v_20[4] = v_13(start_byte_offset);
  Outer v_21 = {v_20};
  return v_21;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_22(uint start_byte_offset) {
  Outer v_23 = v_19(start_byte_offset);
  Outer v_24 = v_19((256u + start_byte_offset));
  Outer v_25 = v_19((512u + start_byte_offset));
  Outer v_26 = v_19((768u + start_byte_offset));
  Outer v_27[4] = {v_23, v_24, v_25, v_26};
  return v_27;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_28 = (min(uint(i()), 3u) * 256u);
  uint v_29 = (min(uint(i()), 3u) * 64u);
  uint v_30 = (min(uint(i()), 3u) * 8u);
  Outer l_a[4] = v_22(0u);
  Outer l_a_i = v_19(v_28);
  Inner l_a_i_a[4] = v_13(v_28);
  Inner l_a_i_a_i = v_11((v_28 + v_29));
  float4x2 l_a_i_a_i_m = v((v_28 + v_29));
  uint v_31 = ((v_28 + v_29) + v_30);
  uint4 v_32 = a[(v_31 / 16u)];
  float2 l_a_i_a_i_m_i = asfloat((((((v_31 & 15u) >> 2u) == 2u)) ? (v_32.zw) : (v_32.xy)));
  uint v_33 = (((v_28 + v_29) + v_30) + (min(uint(i()), 1u) * 4u));
  float l_a_i_a_i_m_i_i = asfloat(a[(v_33 / 16u)][((v_33 & 15u) >> 2u)]);
}

