struct S {
  int before;
  float4x4 m;
  int after;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[48];
};
static S p[4] = (S[4])0;
float4x4 v(uint start_byte_offset) {
  return float4x4(asfloat(u[(start_byte_offset / 16u)]), asfloat(u[((16u + start_byte_offset) / 16u)]), asfloat(u[((32u + start_byte_offset) / 16u)]), asfloat(u[((48u + start_byte_offset) / 16u)]));
}

S v_1(uint start_byte_offset) {
  int v_2 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float4x4 v_3 = v((16u + start_byte_offset));
  uint v_4 = (128u + start_byte_offset);
  S v_5 = {v_2, v_3, asint(u[(v_4 / 16u)][((v_4 & 15u) >> 2u)])};
  return v_5;
}

typedef S ary_ret[4];
ary_ret v_6(uint start_byte_offset) {
  S v_7 = v_1(start_byte_offset);
  S v_8 = v_1((192u + start_byte_offset));
  S v_9 = v_1((384u + start_byte_offset));
  S v_10 = v_1((576u + start_byte_offset));
  S v_11[4] = {v_7, v_8, v_9, v_10};
  return v_11;
}

[numthreads(1, 1, 1)]
void f() {
  S v_12[4] = v_6(0u);
  p = v_12;
  S v_13 = v_1(384u);
  p[int(1)] = v_13;
  p[int(3)].m = v(400u);
  p[int(1)].m[int(0)] = asfloat(u[2u]).ywxz;
}

