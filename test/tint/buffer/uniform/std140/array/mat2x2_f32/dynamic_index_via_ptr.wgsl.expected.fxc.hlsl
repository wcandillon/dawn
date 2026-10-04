
cbuffer cbuffer_a : register(b0) {
  uint4 a[4];
};
RWByteAddressBuffer s : register(u1);
static int counter = int(0);
int i() {
  counter = asint((asuint(counter) + 1u));
  return counter;
}

float2x2 v(uint start_byte_offset) {
  uint4 v_1 = a[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = a[(v_3 / 16u)];
  return float2x2(v_2, asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy))));
}

typedef float2x2 ary_ret[4];
ary_ret v_5(uint start_byte_offset) {
  float2x2 v_6 = v(start_byte_offset);
  float2x2 v_7 = v((16u + start_byte_offset));
  float2x2 v_8 = v((32u + start_byte_offset));
  float2x2 v_9[4] = {v_6, v_7, v_8, v((48u + start_byte_offset))};
  return v_9;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_10 = (min(uint(i()), 3u) * 16u);
  uint v_11 = (min(uint(i()), 1u) * 8u);
  float2x2 l_a[4] = v_5(0u);
  float2x2 l_a_i = v(v_10);
  uint v_12 = (v_10 + v_11);
  uint4 v_13 = a[(v_12 / 16u)];
  float2 l_a_i_i = asfloat((((((v_12 & 15u) >> 2u) == 2u)) ? (v_13.zw) : (v_13.xy)));
  uint v_14 = (v_10 + v_11);
  s.Store(0u, asuint((((asfloat(a[(v_14 / 16u)][((v_14 & 15u) >> 2u)]) + l_a[int(0)][int(0)].x) + l_a_i[int(0)].x) + l_a_i_i.x)));
}

