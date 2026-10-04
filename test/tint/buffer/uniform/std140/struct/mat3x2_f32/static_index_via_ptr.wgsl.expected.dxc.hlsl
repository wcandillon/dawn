struct Inner {
  float3x2 m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
float3x2 v(uint start_byte_offset) {
  uint4 v_1 = a[(start_byte_offset / 16u)];
  uint v_2 = (8u + start_byte_offset);
  uint4 v_3 = a[(v_2 / 16u)];
  uint v_4 = (16u + start_byte_offset);
  uint4 v_5 = a[(v_4 / 16u)];
  return float3x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_1.zw, v_1.xy)), asfloat(select((((v_2 & 15u) >> 2u) == 2u), v_3.zw, v_3.xy)), asfloat(select((((v_4 & 15u) >> 2u) == 2u), v_5.zw, v_5.xy)));
}

Inner v_6(uint start_byte_offset) {
  Inner v_7 = {v(start_byte_offset)};
  return v_7;
}

typedef Inner ary_ret[4];
ary_ret v_8(uint start_byte_offset) {
  Inner v_9 = v_6(start_byte_offset);
  Inner v_10 = v_6((64u + start_byte_offset));
  Inner v_11 = v_6((128u + start_byte_offset));
  Inner v_12 = v_6((192u + start_byte_offset));
  Inner v_13[4] = {v_9, v_10, v_11, v_12};
  return v_13;
}

Outer v_14(uint start_byte_offset) {
  Inner v_15[4] = v_8(start_byte_offset);
  Outer v_16 = {v_15};
  return v_16;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_17(uint start_byte_offset) {
  Outer v_18 = v_14(start_byte_offset);
  Outer v_19 = v_14((256u + start_byte_offset));
  Outer v_20 = v_14((512u + start_byte_offset));
  Outer v_21 = v_14((768u + start_byte_offset));
  Outer v_22[4] = {v_18, v_19, v_20, v_21};
  return v_22;
}

[numthreads(1, 1, 1)]
void f() {
  Outer l_a[4] = v_17(0u);
  Outer l_a_3 = v_14(768u);
  Inner l_a_3_a[4] = v_8(768u);
  Inner l_a_3_a_2 = v_6(896u);
  float3x2 l_a_3_a_2_m = v(896u);
  float2 l_a_3_a_2_m_1 = asfloat(a[56u].zw);
  float l_a_3_a_2_m_1_0 = asfloat(a[56u].z);
}

