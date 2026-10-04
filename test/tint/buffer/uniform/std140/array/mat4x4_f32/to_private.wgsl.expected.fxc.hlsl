
cbuffer cbuffer_u : register(b0) {
  uint4 u[16];
};
RWByteAddressBuffer s : register(u1);
static float4x4 p[4] = (float4x4[4])0;
float4x4 v(uint start_byte_offset) {
  return float4x4(asfloat(u[(start_byte_offset / 16u)]), asfloat(u[((16u + start_byte_offset) / 16u)]), asfloat(u[((32u + start_byte_offset) / 16u)]), asfloat(u[((48u + start_byte_offset) / 16u)]));
}

typedef float4x4 ary_ret[4];
ary_ret v_1(uint start_byte_offset) {
  float4x4 v_2 = v(start_byte_offset);
  float4x4 v_3 = v((64u + start_byte_offset));
  float4x4 v_4 = v((128u + start_byte_offset));
  float4x4 v_5[4] = {v_2, v_3, v_4, v((192u + start_byte_offset))};
  return v_5;
}

[numthreads(1, 1, 1)]
void f() {
  float4x4 v_6[4] = v_1(0u);
  p = v_6;
  p[int(1)] = v(128u);
  p[int(1)][int(0)] = asfloat(u[1u]).ywxz;
  p[int(1)][int(0)].x = asfloat(u[1u].x);
  s.Store(0u, asuint(p[int(1)][int(0)].x));
}

