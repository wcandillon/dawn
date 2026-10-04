
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
  uint v_2 = (8u + start_byte_offset);
  uint4 v_3 = a[(v_2 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_1.zw, v_1.xy)), asfloat(select((((v_2 & 15u) >> 2u) == 2u), v_3.zw, v_3.xy)));
}

typedef float2x2 ary_ret[4];
ary_ret v_4(uint start_byte_offset) {
  float2x2 v_5 = v(start_byte_offset);
  float2x2 v_6 = v((16u + start_byte_offset));
  float2x2 v_7 = v((32u + start_byte_offset));
  float2x2 v_8[4] = {v_5, v_6, v_7, v((48u + start_byte_offset))};
  return v_8;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_9 = (min(uint(i()), 3u) * 16u);
  uint v_10 = (min(uint(i()), 1u) * 8u);
  float2x2 l_a[4] = v_4(0u);
  float2x2 l_a_i = v(v_9);
  uint v_11 = (v_9 + v_10);
  uint4 v_12 = a[(v_11 / 16u)];
  float2 l_a_i_i = asfloat(select((((v_11 & 15u) >> 2u) == 2u), v_12.zw, v_12.xy));
  uint v_13 = (v_9 + v_10);
  s.Store(0u, asuint((((asfloat(a[(v_13 / 16u)][((v_13 & 15u) >> 2u)]) + l_a[int(0)][int(0)].x) + l_a_i[int(0)].x) + l_a_i_i.x)));
}

