
cbuffer cbuffer_a : register(b0) {
  uint4 a[12];
};
RWByteAddressBuffer s : register(u1);
float3x3 v(uint start_byte_offset) {
  return float3x3(asfloat(a[(start_byte_offset / 16u)].xyz), asfloat(a[((16u + start_byte_offset) / 16u)].xyz), asfloat(a[((32u + start_byte_offset) / 16u)].xyz));
}

typedef float3x3 ary_ret[4];
ary_ret v_1(uint start_byte_offset) {
  float3x3 v_2 = v(start_byte_offset);
  float3x3 v_3 = v((48u + start_byte_offset));
  float3x3 v_4 = v((96u + start_byte_offset));
  float3x3 v_5[4] = {v_2, v_3, v_4, v((144u + start_byte_offset))};
  return v_5;
}

[numthreads(1, 1, 1)]
void f() {
  float3x3 l_a[4] = v_1(0u);
  float3x3 l_a_i = v(96u);
  float3 l_a_i_i = asfloat(a[7u].xyz);
  s.Store(0u, asuint((((asfloat(a[7u].x) + l_a[int(0)][int(0)].x) + l_a_i[int(0)].x) + l_a_i_i.x)));
}

