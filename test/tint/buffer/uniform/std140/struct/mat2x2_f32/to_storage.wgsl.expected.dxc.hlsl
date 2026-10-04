struct S {
  int before;
  float2x2 m;
  int after;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
RWByteAddressBuffer s : register(u1);
void v(uint offset, float2x2 obj) {
  s.Store2((offset + 0u), asuint(obj[0u]));
  s.Store2((offset + 8u), asuint(obj[1u]));
}

float2x2 v_1(uint start_byte_offset) {
  uint4 v_2 = u[(start_byte_offset / 16u)];
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = u[(v_3 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_2.zw, v_2.xy)), asfloat(select((((v_3 & 15u) >> 2u) == 2u), v_4.zw, v_4.xy)));
}

void v_5(uint offset, S obj) {
  s.Store((offset + 0u), asuint(obj.before));
  v((offset + 8u), obj.m);
  s.Store((offset + 64u), asuint(obj.after));
}

S v_6(uint start_byte_offset) {
  int v_7 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float2x2 v_8 = v_1((8u + start_byte_offset));
  uint v_9 = (64u + start_byte_offset);
  S v_10 = {v_7, v_8, asint(u[(v_9 / 16u)][((v_9 & 15u) >> 2u)])};
  return v_10;
}

void v_11(uint offset, S obj[4]) {
  {
    uint v_12 = 0u;
    v_12 = 0u;
    while(true) {
      uint v_13 = v_12;
      if ((v_13 >= 4u)) {
        break;
      }
      S v_14 = obj[v_13];
      v_5((offset + (v_13 * 128u)), v_14);
      {
        v_12 = (v_13 + 1u);
      }
    }
  }
}

typedef S ary_ret[4];
ary_ret v_15(uint start_byte_offset) {
  S v_16 = v_6(start_byte_offset);
  S v_17 = v_6((128u + start_byte_offset));
  S v_18 = v_6((256u + start_byte_offset));
  S v_19 = v_6((384u + start_byte_offset));
  S v_20[4] = {v_16, v_17, v_18, v_19};
  return v_20;
}

[numthreads(1, 1, 1)]
void f() {
  S v_21[4] = v_15(0u);
  v_11(0u, v_21);
  S v_22 = v_6(256u);
  v_5(128u, v_22);
  v(392u, v_1(264u));
  s.Store2(136u, asuint(asfloat(u[1u].xy).yx));
}

