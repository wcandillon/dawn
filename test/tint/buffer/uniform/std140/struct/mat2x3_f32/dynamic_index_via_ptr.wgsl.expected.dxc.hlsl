struct Inner {
  float2x3 m;
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

float2x3 v(uint start_byte_offset) {
  return float2x3(asfloat(a[(start_byte_offset / 16u)].xyz), asfloat(a[((16u + start_byte_offset) / 16u)].xyz));
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
  uint v_18 = (min(uint(i()), 3u) * 256u);
  uint v_19 = (min(uint(i()), 3u) * 64u);
  uint v_20 = (min(uint(i()), 1u) * 16u);
  Outer l_a[4] = v_12(0u);
  Outer l_a_i = v_9(v_18);
  Inner l_a_i_a[4] = v_3(v_18);
  Inner l_a_i_a_i = v_1((v_18 + v_19));
  float2x3 l_a_i_a_i_m = v((v_18 + v_19));
  float3 l_a_i_a_i_m_i = asfloat(a[(((v_18 + v_19) + v_20) / 16u)].xyz);
  uint v_21 = (((v_18 + v_19) + v_20) + (min(uint(i()), 2u) * 4u));
  float l_a_i_a_i_m_i_i = asfloat(a[(v_21 / 16u)][((v_21 & 15u) >> 2u)]);
}

