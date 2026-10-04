struct Inner {
  matrix<float16_t, 3, 2> m;
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

matrix<float16_t, 3, 2> v_1(uint start_byte_offset) {
  vector<float16_t, 2> v_2 = tint_bitcast_to_f16(a[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  vector<float16_t, 2> v_4 = tint_bitcast_to_f16(a[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  return matrix<float16_t, 3, 2>(v_2, v_4, tint_bitcast_to_f16(a[(v_5 / 16u)][((v_5 & 15u) >> 2u)]));
}

Inner v_6(uint start_byte_offset) {
  Inner v_7 = {v_1(start_byte_offset)};
  return v_7;
}

typedef Inner ary_ret[4];
ary_ret v_8(uint start_byte_offset) {
  Inner v_9 = v_6(start_byte_offset);
  Inner v_10 = v_6((64u + start_byte_offset));
  Inner v_11 = v_6((128u + start_byte_offset));
  Inner v_12 = v_6((192u + start_byte_offset));
  Inner v_13[4] = {v_9, v_10, v_11, v_12};
  return v_13;
}

Outer v_14(uint start_byte_offset) {
  Inner v_15[4] = v_8(start_byte_offset);
  Outer v_16 = {v_15};
  return v_16;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_17(uint start_byte_offset) {
  Outer v_18 = v_14(start_byte_offset);
  Outer v_19 = v_14((256u + start_byte_offset));
  Outer v_20 = v_14((512u + start_byte_offset));
  Outer v_21 = v_14((768u + start_byte_offset));
  Outer v_22[4] = {v_18, v_19, v_20, v_21};
  return v_22;
}

[numthreads(1, 1, 1)]
void f() {
  Outer l_a[4] = v_17(0u);
  Outer l_a_3 = v_14(768u);
  Inner l_a_3_a[4] = v_8(768u);
  Inner l_a_3_a_2 = v_6(896u);
  matrix<float16_t, 3, 2> l_a_3_a_2_m = v_1(896u);
  vector<float16_t, 2> l_a_3_a_2_m_1 = tint_bitcast_to_f16(a[56u].y);
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_f16(a[56u].y).x;
}

