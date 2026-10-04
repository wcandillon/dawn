
cbuffer cbuffer_u : register(b0) {
  uint4 u[12];
};
RWByteAddressBuffer s : register(u1);
static float3x4 p[4] = (float3x4[4])0;
float3x4 v(uint start_byte_offset) {
  return float3x4(asfloat(u[(start_byte_offset / 16u)]), asfloat(u[((16u + start_byte_offset) / 16u)]), asfloat(u[((32u + start_byte_offset) / 16u)]));
}

typedef float3x4 ary_ret[4];
ary_ret v_1(uint start_byte_offset) {
  float3x4 v_2 = v(start_byte_offset);
  float3x4 v_3 = v((48u + start_byte_offset));
  float3x4 v_4 = v((96u + start_byte_offset));
  float3x4 v_5[4] = {v_2, v_3, v_4, v((144u + start_byte_offset))};
  return v_5;
}

[numthreads(1, 1, 1)]
void f() {
  float3x4 v_6[4] = v_1(0u);
  p = v_6;
  p[int(1)] = v(96u);
  p[int(1)][int(0)] = asfloat(u[1u]).ywxz;
  p[int(1)][int(0)].x = asfloat(u[1u].x);
  s.Store(0u, asuint(p[int(1)][int(0)].x));
}

