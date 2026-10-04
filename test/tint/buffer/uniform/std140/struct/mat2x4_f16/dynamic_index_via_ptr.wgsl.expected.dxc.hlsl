struct Inner {
  matrix<float16_t, 2, 4> m;
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
  uint v_23 = (min(uint(i()), 3u) * 256u);
  uint v_24 = (min(uint(i()), 3u) * 64u);
  uint v_25 = (min(uint(i()), 1u) * 8u);
  Outer l_a[4] = v_17(0u);
  Outer l_a_i = v_14(v_23);
  Inner l_a_i_a[4] = v_8(v_23);
  Inner l_a_i_a_i = v_6((v_23 + v_24));
  matrix<float16_t, 2, 4> l_a_i_a_i_m = v_1((v_23 + v_24));
  uint v_26 = ((v_23 + v_24) + v_25);
  uint4 v_27 = a[(v_26 / 16u)];
  vector<float16_t, 4> l_a_i_a_i_m_i = tint_bitcast_to_f16(select((((v_26 & 15u) >> 2u) == 2u), v_27.zw, v_27.xy));
  uint v_28 = (((v_23 + v_24) + v_25) + (min(uint(i()), 3u) * 2u));
  float16_t l_a_i_a_i_m_i_i = tint_bitcast_to_f16_1(a[(v_28 / 16u)][((v_28 & 15u) >> 2u)])[select(((v_28 % 4u) == 0u), 0u, 1u)];
}

