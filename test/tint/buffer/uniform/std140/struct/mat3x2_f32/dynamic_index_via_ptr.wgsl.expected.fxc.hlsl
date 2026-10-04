struct Inner {
  float3x2 m;
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

float3x2 v(uint start_byte_offset) {
  uint4 v_1 = a[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = a[(v_3 / 16u)];
  float2 v_5 = asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy)));
  uint v_6 = (16u + start_byte_offset);
  uint4 v_7 = a[(v_6 / 16u)];
  return float3x2(v_2, v_5, asfloat((((((v_6 & 15u) >> 2u) == 2u)) ? (v_7.zw) : (v_7.xy))));
}

Inner v_8(uint start_byte_offset) {
  Inner v_9 = {v(start_byte_offset)};
  return v_9;
}

typedef Inner ary_ret[4];
ary_ret v_10(uint start_byte_offset) {
  Inner v_11 = v_8(start_byte_offset);
  Inner v_12 = v_8((64u + start_byte_offset));
  Inner v_13 = v_8((128u + start_byte_offset));
  Inner v_14 = v_8((192u + start_byte_offset));
  Inner v_15[4] = {v_11, v_12, v_13, v_14};
  return v_15;
}

Outer v_16(uint start_byte_offset) {
  Inner v_17[4] = v_10(start_byte_offset);
  Outer v_18 = {v_17};
  return v_18;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_19(uint start_byte_offset) {
  Outer v_20 = v_16(start_byte_offset);
  Outer v_21 = v_16((256u + start_byte_offset));
  Outer v_22 = v_16((512u + start_byte_offset));
  Outer v_23 = v_16((768u + start_byte_offset));
  Outer v_24[4] = {v_20, v_21, v_22, v_23};
  return v_24;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_25 = (min(uint(i()), 3u) * 256u);
  uint v_26 = (min(uint(i()), 3u) * 64u);
  uint v_27 = (min(uint(i()), 2u) * 8u);
  Outer l_a[4] = v_19(0u);
  Outer l_a_i = v_16(v_25);
  Inner l_a_i_a[4] = v_10(v_25);
  Inner l_a_i_a_i = v_8((v_25 + v_26));
  float3x2 l_a_i_a_i_m = v((v_25 + v_26));
  uint v_28 = ((v_25 + v_26) + v_27);
  uint4 v_29 = a[(v_28 / 16u)];
  float2 l_a_i_a_i_m_i = asfloat((((((v_28 & 15u) >> 2u) == 2u)) ? (v_29.zw) : (v_29.xy)));
  uint v_30 = (((v_25 + v_26) + v_27) + (min(uint(i()), 1u) * 4u));
  float l_a_i_a_i_m_i_i = asfloat(a[(v_30 / 16u)][((v_30 & 15u) >> 2u)]);
}

