
cbuffer cbuffer_a : register(b0) {
  uint4 a[8];
};
RWByteAddressBuffer s : register(u1);
static int counter = int(0);
int i() {
  counter = asint((asuint(counter) + 1u));
  return counter;
}

float2x3 v(uint start_byte_offset) {
  return float2x3(asfloat(a[(start_byte_offset / 16u)].xyz), asfloat(a[((16u + start_byte_offset) / 16u)].xyz));
}

typedef float2x3 ary_ret[4];
ary_ret v_1(uint start_byte_offset) {
  float2x3 v_2 = v(start_byte_offset);
  float2x3 v_3 = v((32u + start_byte_offset));
  float2x3 v_4 = v((64u + start_byte_offset));
  float2x3 v_5[4] = {v_2, v_3, v_4, v((96u + start_byte_offset))};
  return v_5;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_6 = (min(uint(i()), 3u) * 32u);
  uint v_7 = (min(uint(i()), 1u) * 16u);
  float2x3 l_a[4] = v_1(0u);
  float2x3 l_a_i = v(v_6);
  float3 l_a_i_i = asfloat(a[((v_6 + v_7) / 16u)].xyz);
  uint v_8 = (v_6 + v_7);
  s.Store(0u, asuint((((asfloat(a[(v_8 / 16u)][((v_8 & 15u) >> 2u)]) + l_a[int(0)][int(0)].x) + l_a_i[int(0)].x) + l_a_i_i.x)));
}

