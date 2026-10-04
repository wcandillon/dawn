struct Inner {
  matrix<float16_t, 2, 4> m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
vector<float16_t, 2> tint_bitcast_to_f16_1(uint src) {
  uint v = src;
  vector<uint16_t, 2> v16 = vector<uint16_t, 2>(((uint2(v, v) >> uint2(0u, 16u)) & (65535u).xx));
  return asfloat16(v16);
}

vector<float16_t, 4> tint_bitcast_to_f16(uint2 src) {
  uint2 v = src;
  vector<uint16_t, 4> v16 = vector<uint16_t, 4>(((v.xxyy >> uint4(0u, 16u, 0u, 16u)) & (65535u).xxxx));
  return asfloat16(v16);
}

matrix<float16_t, 2, 4> v_1(uint start_byte_offset) {
  uint4 v_2 = a[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_3 = tint_bitcast_to_f16(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy));
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = a[(v_4 / 16u)];
  return matrix<float16_t, 2, 4>(v_3, tint_bitcast_to_f16(select((((v_4 & 15u) >> 2u) == 2u), v_5.zw, v_5.xy)));
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
  matrix<float16_t, 2, 4> l_a_3_a_2_m = v_1(896u);
  vector<float16_t, 4> l_a_3_a_2_m_1 = tint_bitcast_to_f16(a[56u].zw);
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_f16_1(a[56u].z).x;
}

