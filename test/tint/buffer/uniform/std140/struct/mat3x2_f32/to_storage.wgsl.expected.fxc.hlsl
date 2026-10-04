struct S {
  int before;
  float3x2 m;
  int after;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
RWByteAddressBuffer s : register(u1);
void v(uint offset, float3x2 obj) {
  s.Store2((offset + 0u), asuint(obj[0u]));
  s.Store2((offset + 8u), asuint(obj[1u]));
  s.Store2((offset + 16u), asuint(obj[2u]));
}

float3x2 v_1(uint start_byte_offset) {
  uint4 v_2 = u[(start_byte_offset / 16u)];
  float2 v_3 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_2.zw) : (v_2.xy)));
  uint v_4 = (8u + start_byte_offset);
  uint4 v_5 = u[(v_4 / 16u)];
  float2 v_6 = asfloat((((((v_4 & 15u) >> 2u) == 2u)) ? (v_5.zw) : (v_5.xy)));
  uint v_7 = (16u + start_byte_offset);
  uint4 v_8 = u[(v_7 / 16u)];
  return float3x2(v_3, v_6, asfloat((((((v_7 & 15u) >> 2u) == 2u)) ? (v_8.zw) : (v_8.xy))));
}

void v_9(uint offset, S obj) {
  s.Store((offset + 0u), asuint(obj.before));
  v((offset + 8u), obj.m);
  s.Store((offset + 64u), asuint(obj.after));
}

S v_10(uint start_byte_offset) {
  int v_11 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float3x2 v_12 = v_1((8u + start_byte_offset));
  uint v_13 = (64u + start_byte_offset);
  S v_14 = {v_11, v_12, asint(u[(v_13 / 16u)][((v_13 & 15u) >> 2u)])};
  return v_14;
}

void v_15(uint offset, S obj[4]) {
  {
    uint v_16 = 0u;
    v_16 = 0u;
    while(true) {
      uint v_17 = v_16;
      if ((v_17 >= 4u)) {
        break;
      }
      S v_18 = obj[v_17];
      v_9((offset + (v_17 * 128u)), v_18);
      {
        v_16 = (v_17 + 1u);
      }
    }
  }
}

typedef S ary_ret[4];
ary_ret v_19(uint start_byte_offset) {
  S v_20 = v_10(start_byte_offset);
  S v_21 = v_10((128u + start_byte_offset));
  S v_22 = v_10((256u + start_byte_offset));
  S v_23 = v_10((384u + start_byte_offset));
  S v_24[4] = {v_20, v_21, v_22, v_23};
  return v_24;
}

[numthreads(1, 1, 1)]
void f() {
  S v_25[4] = v_19(0u);
  v_15(0u, v_25);
  S v_26 = v_10(256u);
  v_9(128u, v_26);
  v(392u, v_1(264u));
  s.Store2(136u, asuint(asfloat(u[1u].xy).yx));
}

