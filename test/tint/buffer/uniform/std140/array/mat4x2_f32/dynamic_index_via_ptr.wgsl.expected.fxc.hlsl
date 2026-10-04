
cbuffer cbuffer_a : register(b0) {
  uint4 a[8];
};
RWByteAddressBuffer s : register(u1);
static int counter = int(0);
int i() {
  counter = asint((asuint(counter) + 1u));
  return counter;
}

float4x2 v(uint start_byte_offset) {
  uint4 v_1 = a[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = a[(v_3 / 16u)];
  float2 v_5 = asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy)));
  uint v_6 = (16u + start_byte_offset);
  uint4 v_7 = a[(v_6 / 16u)];
  float2 v_8 = asfloat((((((v_6 & 15u) >> 2u) == 2u)) ? (v_7.zw) : (v_7.xy)));
  uint v_9 = (24u + start_byte_offset);
  uint4 v_10 = a[(v_9 / 16u)];
  return float4x2(v_2, v_5, v_8, asfloat((((((v_9 & 15u) >> 2u) == 2u)) ? (v_10.zw) : (v_10.xy))));
}

typedef float4x2 ary_ret[4];
ary_ret v_11(uint start_byte_offset) {
  float4x2 v_12 = v(start_byte_offset);
  float4x2 v_13 = v((32u + start_byte_offset));
  float4x2 v_14 = v((64u + start_byte_offset));
  float4x2 v_15[4] = {v_12, v_13, v_14, v((96u + start_byte_offset))};
  return v_15;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_16 = (min(uint(i()), 3u) * 32u);
  uint v_17 = (min(uint(i()), 3u) * 8u);
  float4x2 l_a[4] = v_11(0u);
  float4x2 l_a_i = v(v_16);
  uint v_18 = (v_16 + v_17);
  uint4 v_19 = a[(v_18 / 16u)];
  float2 l_a_i_i = asfloat((((((v_18 & 15u) >> 2u) == 2u)) ? (v_19.zw) : (v_19.xy)));
  uint v_20 = (v_16 + v_17);
  s.Store(0u, asuint((((asfloat(a[(v_20 / 16u)][((v_20 & 15u) >> 2u)]) + l_a[int(0)][int(0)].x) + l_a_i[int(0)].x) + l_a_i_i.x)));
}

