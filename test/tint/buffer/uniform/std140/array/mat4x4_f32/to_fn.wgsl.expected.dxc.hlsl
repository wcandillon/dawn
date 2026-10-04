
cbuffer cbuffer_u : register(b0) {
  uint4 u[16];
};
RWByteAddressBuffer s : register(u1);
float a(float4x4 a_1[4]) {
  return a_1[int(0)][int(0)].x;
}

float b(float4x4 m) {
  return m[int(0)].x;
}

float c(float4 v) {
  return v.x;
}

float d(float f_1) {
  return f_1;
}

float4x4 v_1(uint start_byte_offset) {
  return float4x4(asfloat(u[(start_byte_offset / 16u)]), asfloat(u[((16u + start_byte_offset) / 16u)]), asfloat(u[((32u + start_byte_offset) / 16u)]), asfloat(u[((48u + start_byte_offset) / 16u)]));
}

typedef float4x4 ary_ret[4];
ary_ret v_2(uint start_byte_offset) {
  float4x4 v_3 = v_1(start_byte_offset);
  float4x4 v_4 = v_1((64u + start_byte_offset));
  float4x4 v_5 = v_1((128u + start_byte_offset));
  float4x4 v_6[4] = {v_3, v_4, v_5, v_1((192u + start_byte_offset))};
  return v_6;
}

[numthreads(1, 1, 1)]
void f() {
  float4x4 v_7[4] = v_2(0u);
  float v_8 = a(v_7);
  float v_9 = (v_8 + b(v_1(64u)));
  float v_10 = (v_9 + c(asfloat(u[4u]).ywxz));
  s.Store(0u, asuint((v_10 + d(asfloat(u[4u].y)))));
}

