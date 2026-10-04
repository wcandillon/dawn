
cbuffer cbuffer_u : register(b0) {
  uint4 u[4];
};
RWByteAddressBuffer s : register(u1);
float a(float2x2 a_1[4]) {
  return a_1[int(0)][int(0)].x;
}

float b(float2x2 m) {
  return m[int(0)].x;
}

float c(float2 v) {
  return v.x;
}

float d(float f_1) {
  return f_1;
}

float2x2 v_1(uint start_byte_offset) {
  uint4 v_2 = u[(start_byte_offset / 16u)];
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = u[(v_3 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy)), asfloat(select((((v_3 & 15u) >> 2u) == 2u), v_4.zw, v_4.xy)));
}

typedef float2x2 ary_ret[4];
ary_ret v_5(uint start_byte_offset) {
  float2x2 v_6 = v_1(start_byte_offset);
  float2x2 v_7 = v_1((16u + start_byte_offset));
  float2x2 v_8 = v_1((32u + start_byte_offset));
  float2x2 v_9[4] = {v_6, v_7, v_8, v_1((48u + start_byte_offset))};
  return v_9;
}

[numthreads(1, 1, 1)]
void f() {
  float2x2 v_10[4] = v_5(0u);
  float v_11 = a(v_10);
  float v_12 = (v_11 + b(v_1(16u)));
  float v_13 = (v_12 + c(asfloat(u[1u].xy).yx));
  s.Store(0u, asuint((v_13 + d(asfloat(u[1u].y)))));
}

