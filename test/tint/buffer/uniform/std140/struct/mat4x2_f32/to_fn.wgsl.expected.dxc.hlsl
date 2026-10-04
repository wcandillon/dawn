struct S {
  int before;
  float4x2 m;
  int after;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
void a(S a_1[4]) {
}

void b(S s) {
}

void c(float4x2 m) {
}

void d(float2 v) {
}

void e(float f_1) {
}

float4x2 v_1(uint start_byte_offset) {
  uint4 v_2 = u[(start_byte_offset / 16u)];
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = u[(v_3 / 16u)];
  uint v_5 = (16u + start_byte_offset);
  uint4 v_6 = u[(v_5 / 16u)];
  uint v_7 = (24u + start_byte_offset);
  uint4 v_8 = u[(v_7 / 16u)];
  return float4x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy)), asfloat(select((((v_3 & 15u) >> 2u) == 2u), v_4.zw, v_4.xy)), asfloat(select((((v_5 & 15u) >> 2u) == 2u), v_6.zw, v_6.xy)), asfloat(select((((v_7 & 15u) >> 2u) == 2u), v_8.zw, v_8.xy)));
}

S v_9(uint start_byte_offset) {
  int v_10 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float4x2 v_11 = v_1((8u + start_byte_offset));
  uint v_12 = (64u + start_byte_offset);
  S v_13 = {v_10, v_11, asint(u[(v_12 / 16u)][((v_12 & 15u) >> 2u)])};
  return v_13;
}

typedef S ary_ret[4];
ary_ret v_14(uint start_byte_offset) {
  S v_15 = v_9(start_byte_offset);
  S v_16 = v_9((128u + start_byte_offset));
  S v_17 = v_9((256u + start_byte_offset));
  S v_18 = v_9((384u + start_byte_offset));
  S v_19[4] = {v_15, v_16, v_17, v_18};
  return v_19;
}

[numthreads(1, 1, 1)]
void f() {
  S v_20[4] = v_14(0u);
  a(v_20);
  S v_21 = v_9(256u);
  b(v_21);
  c(v_1(264u));
  d(asfloat(u[1u].xy).yx);
  e(asfloat(u[1u].y));
}

