
cbuffer cbuffer_a : register(b0) {
  uint4 a[8];
};
RWByteAddressBuffer s : register(u1);
float2x4 v(uint start_byte_offset) {
  return float2x4(asfloat(a[(start_byte_offset / 16u)]), asfloat(a[((16u + start_byte_offset) / 16u)]));
}

typedef float2x4 ary_ret[4];
ary_ret v_1(uint start_byte_offset) {
  float2x4 v_2 = v(start_byte_offset);
  float2x4 v_3 = v((32u + start_byte_offset));
  float2x4 v_4 = v((64u + start_byte_offset));
  float2x4 v_5[4] = {v_2, v_3, v_4, v((96u + start_byte_offset))};
  return v_5;
}

[numthreads(1, 1, 1)]
void f() {
  float2x4 l_a[4] = v_1(0u);
  float2x4 l_a_i = v(64u);
  float4 l_a_i_i = asfloat(a[5u]);
  s.Store(0u, asuint((((asfloat(a[5u].x) + l_a[int(0)][int(0)].x) + l_a_i[int(0)].x) + l_a_i_i.x)));
}

