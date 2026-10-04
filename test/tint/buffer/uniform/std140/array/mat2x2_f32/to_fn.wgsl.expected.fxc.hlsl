
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
  float2 v_3 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_2.zw) : (v_2.xy)));
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = u[(v_4 / 16u)];
  return float2x2(v_3, asfloat((((((v_4 & 15u) >> 2u) == 2u)) ? (v_5.zw) : (v_5.xy))));
}

typedef float2x2 ary_ret[4];
ary_ret v_6(uint start_byte_offset) {
  float2x2 v_7 = v_1(start_byte_offset);
  float2x2 v_8 = v_1((16u + start_byte_offset));
  float2x2 v_9 = v_1((32u + start_byte_offset));
  float2x2 v_10[4] = {v_7, v_8, v_9, v_1((48u + start_byte_offset))};
  return v_10;
}

[numthreads(1, 1, 1)]
void f() {
  float2x2 v_11[4] = v_6(0u);
  float v_12 = a(v_11);
  float v_13 = (v_12 + b(v_1(16u)));
  float v_14 = (v_13 + c(asfloat(u[1u].xy).yx));
  s.Store(0u, asuint((v_14 + d(asfloat(u[1u].y)))));
}

