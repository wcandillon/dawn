struct Inner {
  matrix<float16_t, 4, 2> m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
vector<float16_t, 2> tint_bitcast_to_f16(uint src) {
  uint v = src;
  vector<uint16_t, 2> v16 = vector<uint16_t, 2>(((uint2(v, v) >> uint2(0u, 16u)) & (65535u).xx));
  return asfloat16(v16);
}

matrix<float16_t, 4, 2> v_1(uint start_byte_offset) {
  vector<float16_t, 2> v_2 = tint_bitcast_to_f16(a[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  vector<float16_t, 2> v_4 = tint_bitcast_to_f16(a[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  vector<float16_t, 2> v_6 = tint_bitcast_to_f16(a[(v_5 / 16u)][((v_5 & 15u) >> 2u)]);
  uint v_7 = (12u + start_byte_offset);
  return matrix<float16_t, 4, 2>(v_2, v_4, v_6, tint_bitcast_to_f16(a[(v_7 / 16u)][((v_7 & 15u) >> 2u)]));
}

Inner v_8(uint start_byte_offset) {
  Inner v_9 = {v_1(start_byte_offset)};
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
  Outer l_a[4] = v_19(0u);
  Outer l_a_3 = v_16(768u);
  Inner l_a_3_a[4] = v_10(768u);
  Inner l_a_3_a_2 = v_8(896u);
  matrix<float16_t, 4, 2> l_a_3_a_2_m = v_1(896u);
  vector<float16_t, 2> l_a_3_a_2_m_1 = tint_bitcast_to_f16(a[56u].y);
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_f16(a[56u].y).x;
}

