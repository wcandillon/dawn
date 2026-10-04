struct Inner {
  matrix<float16_t, 3, 3> m;
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

matrix<float16_t, 3, 3> v_1(uint start_byte_offset) {
  uint4 v_2 = a[(start_byte_offset / 16u)];
  vector<float16_t, 3> v_3 = tint_bitcast_to_f16(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy)).xyz;
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = a[(v_4 / 16u)];
  vector<float16_t, 3> v_6 = tint_bitcast_to_f16(select((((v_4 & 15u) >> 2u) == 2u), v_5.zw, v_5.xy)).xyz;
  uint v_7 = (16u + start_byte_offset);
  uint4 v_8 = a[(v_7 / 16u)];
  return matrix<float16_t, 3, 3>(v_3, v_6, tint_bitcast_to_f16(select((((v_7 & 15u) >> 2u) == 2u), v_8.zw, v_8.xy)).xyz);
}

Inner v_9(uint start_byte_offset) {
  Inner v_10 = {v_1(start_byte_offset)};
  return v_10;
}

typedef Inner ary_ret[4];
ary_ret v_11(uint start_byte_offset) {
  Inner v_12 = v_9(start_byte_offset);
  Inner v_13 = v_9((64u + start_byte_offset));
  Inner v_14 = v_9((128u + start_byte_offset));
  Inner v_15 = v_9((192u + start_byte_offset));
  Inner v_16[4] = {v_12, v_13, v_14, v_15};
  return v_16;
}

Outer v_17(uint start_byte_offset) {
  Inner v_18[4] = v_11(start_byte_offset);
  Outer v_19 = {v_18};
  return v_19;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_20(uint start_byte_offset) {
  Outer v_21 = v_17(start_byte_offset);
  Outer v_22 = v_17((256u + start_byte_offset));
  Outer v_23 = v_17((512u + start_byte_offset));
  Outer v_24 = v_17((768u + start_byte_offset));
  Outer v_25[4] = {v_21, v_22, v_23, v_24};
  return v_25;
}

[numthreads(1, 1, 1)]
void f() {
  Outer l_a[4] = v_20(0u);
  Outer l_a_3 = v_17(768u);
  Inner l_a_3_a[4] = v_11(768u);
  Inner l_a_3_a_2 = v_9(896u);
  matrix<float16_t, 3, 3> l_a_3_a_2_m = v_1(896u);
  vector<float16_t, 3> l_a_3_a_2_m_1 = tint_bitcast_to_f16(a[56u].zw).xyz;
  float16_t l_a_3_a_2_m_1_0 = tint_bitcast_to_f16_1(a[56u].z).x;
}

