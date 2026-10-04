struct S {
  int before;
  float4x2 m;
  int after;
};

struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
groupshared S w[4];
float4x2 v(uint start_byte_offset) {
  uint4 v_1 = u[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = u[(v_3 / 16u)];
  float2 v_5 = asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy)));
  uint v_6 = (16u + start_byte_offset);
  uint4 v_7 = u[(v_6 / 16u)];
  float2 v_8 = asfloat((((((v_6 & 15u) >> 2u) == 2u)) ? (v_7.zw) : (v_7.xy)));
  uint v_9 = (24u + start_byte_offset);
  uint4 v_10 = u[(v_9 / 16u)];
  return float4x2(v_2, v_5, v_8, asfloat((((((v_9 & 15u) >> 2u) == 2u)) ? (v_10.zw) : (v_10.xy))));
}

S v_11(uint start_byte_offset) {
  int v_12 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float4x2 v_13 = v((8u + start_byte_offset));
  uint v_14 = (64u + start_byte_offset);
  S v_15 = {v_12, v_13, asint(u[(v_14 / 16u)][((v_14 & 15u) >> 2u)])};
  return v_15;
}

typedef S ary_ret[4];
ary_ret v_16(uint start_byte_offset) {
  S v_17 = v_11(start_byte_offset);
  S v_18 = v_11((128u + start_byte_offset));
  S v_19 = v_11((256u + start_byte_offset));
  S v_20 = v_11((384u + start_byte_offset));
  S v_21[4] = {v_17, v_18, v_19, v_20};
  return v_21;
}

void f_inner(uint tint_local_index) {
  {
    uint v_22 = 0u;
    v_22 = tint_local_index;
    while(true) {
      uint v_23 = v_22;
      if ((v_23 >= 4u)) {
        break;
      }
      S v_24 = (S)0;
      w[v_23] = v_24;
      {
        v_22 = (v_23 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_25[4] = v_16(0u);
  w = v_25;
  S v_26 = v_11(256u);
  w[int(1)] = v_26;
  w[int(3)].m = v(264u);
  w[int(1)].m[int(0)] = asfloat(u[1u].xy).yx;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

