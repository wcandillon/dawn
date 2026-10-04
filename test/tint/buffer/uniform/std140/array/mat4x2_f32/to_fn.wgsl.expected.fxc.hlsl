
cbuffer cbuffer_u : register(b0) {
  uint4 u[8];
};
RWByteAddressBuffer s : register(u1);
float a(float4x2 a_1[4]) {
  return a_1[int(0)][int(0)].x;
}

float b(float4x2 m) {
  return m[int(0)].x;
}

float c(float2 v) {
  return v.x;
}

float d(float f_1) {
  return f_1;
}

float4x2 v_1(uint start_byte_offset) {
  uint4 v_2 = u[(start_byte_offset / 16u)];
  float2 v_3 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_2.zw) : (v_2.xy)));
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = u[(v_4 / 16u)];
  float2 v_6 = asfloat((((((v_4 & 15u) >> 2u) == 2u)) ? (v_5.zw) : (v_5.xy)));
  uint v_7 = (16u + start_byte_offset);
  uint4 v_8 = u[(v_7 / 16u)];
  float2 v_9 = asfloat((((((v_7 & 15u) >> 2u) == 2u)) ? (v_8.zw) : (v_8.xy)));
  uint v_10 = (24u + start_byte_offset);
  uint4 v_11 = u[(v_10 / 16u)];
  return float4x2(v_3, v_6, v_9, asfloat((((((v_10 & 15u) >> 2u) == 2u)) ? (v_11.zw) : (v_11.xy))));
}

typedef float4x2 ary_ret[4];
ary_ret v_12(uint start_byte_offset) {
  float4x2 v_13 = v_1(start_byte_offset);
  float4x2 v_14 = v_1((32u + start_byte_offset));
  float4x2 v_15 = v_1((64u + start_byte_offset));
  float4x2 v_16[4] = {v_13, v_14, v_15, v_1((96u + start_byte_offset))};
  return v_16;
}

[numthreads(1, 1, 1)]
void f() {
  float4x2 v_17[4] = v_12(0u);
  float v_18 = a(v_17);
  float v_19 = (v_18 + b(v_1(32u)));
  float v_20 = (v_19 + c(asfloat(u[2u].xy).yx));
  s.Store(0u, asuint((v_20 + d(asfloat(u[2u].y)))));
}

