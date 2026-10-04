struct S {
  int before;
  float4x2 m;
  int after;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
static S p[4] = (S[4])0;
float4x2 v(uint start_byte_offset) {
  uint4 v_1 = u[(start_byte_offset / 16u)];
  uint v_2 = (8u + start_byte_offset);
  uint4 v_3 = u[(v_2 / 16u)];
  uint v_4 = (16u + start_byte_offset);
  uint4 v_5 = u[(v_4 / 16u)];
  uint v_6 = (24u + start_byte_offset);
  uint4 v_7 = u[(v_6 / 16u)];
  return float4x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_1.zw, v_1.xy)), asfloat(select((((v_2 & 15u) >> 2u) == 2u), v_3.zw, v_3.xy)), asfloat(select((((v_4 & 15u) >> 2u) == 2u), v_5.zw, v_5.xy)), asfloat(select((((v_6 & 15u) >> 2u) == 2u), v_7.zw, v_7.xy)));
}

S v_8(uint start_byte_offset) {
  int v_9 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float4x2 v_10 = v((8u + start_byte_offset));
  uint v_11 = (64u + start_byte_offset);
  S v_12 = {v_9, v_10, asint(u[(v_11 / 16u)][((v_11 & 15u) >> 2u)])};
  return v_12;
}

typedef S ary_ret[4];
ary_ret v_13(uint start_byte_offset) {
  S v_14 = v_8(start_byte_offset);
  S v_15 = v_8((128u + start_byte_offset));
  S v_16 = v_8((256u + start_byte_offset));
  S v_17 = v_8((384u + start_byte_offset));
  S v_18[4] = {v_14, v_15, v_16, v_17};
  return v_18;
}

[numthreads(1, 1, 1)]
void f() {
  S v_19[4] = v_13(0u);
  p = v_19;
  S v_20 = v_8(256u);
  p[int(1)] = v_20;
  p[int(3)].m = v(264u);
  p[int(1)].m[int(0)] = asfloat(u[1u].xy).yx;
}

