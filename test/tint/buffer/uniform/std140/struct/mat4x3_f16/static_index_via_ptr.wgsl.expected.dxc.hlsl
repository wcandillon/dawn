struct Inner {
  matrix<float16_t, 4, 3> m;
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

matrix<float16_t, 4, 3> v_1(uint start_byte_offset) {
  uint4 v_2 = a[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_3 = tint_bitcast_to_f16(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy)).xyz;
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = a[(v_4 / 16u)];
  vector<float16_t, 3> v_6 = tint_bitcast_to_f16(select((((v_4 & 15u) >> 2u) == 2u), v_5.zw, v_5.xy)).xyz;
  uint v_7 = (16u + start_byte_offset);
  uint4 v_8 = a[(v_7 / 16u)];
  vector<float16_t, 3> v_9 = tint_bitcast_to_f16(select((((v_7 & 15u) >> 2u) == 2u), v_8.zw, v_8.xy)).xyz;
  uint v_10 = (24u + start_byte_offset);
  uint4 v_11 = a[(v_10 / 16u)];
  return matrix<float16_t, 4, 3>(v_3, v_6, v_9, tint_bitcast_to_f16(select((((v_10 & 15u) >> 2u) == 2u), v_11.zw, v_11.xy)).xyz);
}

Inner v_12(uint start_byte_offset) {
  Inner v_13 = {v_1(start_byte_offset)};
  return v_13;
}

typedef Inner ary_ret[4];
ary_ret v_14(uint start_byte_offset) {
  Inner v_15 = v_12(start_byte_offset);
  Inner v_16 = v_12((64u + start_byte_offset));
  Inner v_17 = v_12((128u + start_byte_offset));
  Inner v_18 = v_12((192u + start_byte_offset));
  Inner v_19[4] = {v_15, v_16, v_17, v_18};
  return v_19;
}

Outer v_20(uint start_byte_offset) {
  Inner v_21[4] = v_14(start_byte_offset);
  Outer v_22 = {v_21};
  return v_22;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_23(uint start_byte_offset) {
  Outer v_24 = v_20(start_byte_offset);
  Outer v_25 = v_20((256u + start_byte_offset));
  Outer v_26 = v_20((512u + start_byte_offset));
  Outer v_27 = v_20((768u + start_byte_offset));
  Outer v_28[4] = {v_24, v_25, v_26, v_27};
  return v_28;
}

[numthreads(1, 1, 1)]
void f() {
  Outer l_a[4] = v_23(0u);
  Outer l_a_3 = v_20(768u);
  Inner l_a_3_a[4] = v_14(768u);
  Inner l_a_3_a_2 = v_12(896u);
  matrix<float16_t, 4, 3> l_a_3_a_2_m = v_1(896u);
  vector<float16_t, 3> l_a_3_a_2_m_1 = tint_bitcast_to_f16(a[56u].zw).xyz;
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_f16_1(a[56u].z).x;
}

