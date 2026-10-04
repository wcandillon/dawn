struct Inner {
  matrix<float16_t, 2, 2> m;
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

vector<float16_t, 2> tint_bitcast_to_f16(uint src) {
  uint v = src;
  vector<uint16_t, 2> v16 = vector<uint16_t, 2>(((uint2(v, v) >> uint2(0u, 16u)) & (65535u).xx));
  return asfloat16(v16);
}

matrix<float16_t, 2, 2> v_1(uint start_byte_offset) {
  vector<float16_t, 2> v_2 = tint_bitcast_to_f16(a[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  return matrix<float16_t, 2, 2>(v_2, tint_bitcast_to_f16(a[(v_3 / 16u)][((v_3 & 15u) >> 2u)]));
}

Inner v_4(uint start_byte_offset) {
  Inner v_5 = {v_1(start_byte_offset)};
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
  uint v_23 = (min(uint(i()), 1u) * 4u);
  Outer l_a[4] = v_15(0u);
  Outer l_a_i = v_12(v_21);
  Inner l_a_i_a[4] = v_6(v_21);
  Inner l_a_i_a_i = v_4((v_21 + v_22));
  matrix<float16_t, 2, 2> l_a_i_a_i_m = v_1((v_21 + v_22));
  uint v_24 = ((v_21 + v_22) + v_23);
  vector<float16_t, 2> l_a_i_a_i_m_i = tint_bitcast_to_f16(a[(v_24 / 16u)][((v_24 & 15u) >> 2u)]);
  uint v_25 = (((v_21 + v_22) + v_23) + (min(uint(i()), 1u) * 2u));
  float16_t l_a_i_a_i_m_i_i = tint_bitcast_to_f16(a[(v_25 / 16u)][((v_25 & 15u) >> 2u)])[select(((v_25 % 4u) == 0u), 0u, 1u)];
}

