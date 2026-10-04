struct Inner {
  matrix<float16_t, 4, 4> m;
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

matrix<float16_t, 4, 4> v_1(uint start_byte_offset) {
  uint4 v_2 = a[(start_byte_offset / 16u)];
  vector<float16_t, 4> v_3 = tint_bitcast_to_f16(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy));
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = a[(v_4 / 16u)];
  vector<float16_t, 4> v_6 = tint_bitcast_to_f16(select((((v_4 & 15u) >> 2u) == 2u), v_5.zw, v_5.xy));
  uint v_7 = (16u + start_byte_offset);
  uint4 v_8 = a[(v_7 / 16u)];
  vector<float16_t, 4> v_9 = tint_bitcast_to_f16(select((((v_7 & 15u) >> 2u) == 2u), v_8.zw, v_8.xy));
  uint v_10 = (24u + start_byte_offset);
  uint4 v_11 = a[(v_10 / 16u)];
  return matrix<float16_t, 4, 4>(v_3, v_6, v_9, tint_bitcast_to_f16(select((((v_10 & 15u) >> 2u) == 2u), v_11.zw, v_11.xy)));
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
  uint v_29 = (min(uint(i()), 3u) * 256u);
  uint v_30 = (min(uint(i()), 3u) * 64u);
  uint v_31 = (min(uint(i()), 3u) * 8u);
  Outer l_a[4] = v_23(0u);
  Outer l_a_i = v_20(v_29);
  Inner l_a_i_a[4] = v_14(v_29);
  Inner l_a_i_a_i = v_12((v_29 + v_30));
  matrix<float16_t, 4, 4> l_a_i_a_i_m = v_1((v_29 + v_30));
  uint v_32 = ((v_29 + v_30) + v_31);
  uint4 v_33 = a[(v_32 / 16u)];
  vector<float16_t, 4> l_a_i_a_i_m_i = tint_bitcast_to_f16(select((((v_32 & 15u) >> 2u) == 2u), v_33.zw, v_33.xy));
  uint v_34 = (((v_29 + v_30) + v_31) + (min(uint(i()), 3u) * 2u));
  float16_t l_a_i_a_i_m_i_i = tint_bitcast_to_f16_1(a[(v_34 / 16u)][((v_34 & 15u) >> 2u)])[select(((v_34 % 4u) == 0u), 0u, 1u)];
}

