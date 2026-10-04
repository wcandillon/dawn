struct S {
  int before;
  float2x2 m;
  int after;
};

struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
groupshared S w[4];
float2x2 v(uint start_byte_offset) {
  uint4 v_1 = u[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = u[(v_3 / 16u)];
  return float2x2(v_2, asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy))));
}

S v_5(uint start_byte_offset) {
  int v_6 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float2x2 v_7 = v((8u + start_byte_offset));
  uint v_8 = (64u + start_byte_offset);
  S v_9 = {v_6, v_7, asint(u[(v_8 / 16u)][((v_8 & 15u) >> 2u)])};
  return v_9;
}

typedef S ary_ret[4];
ary_ret v_10(uint start_byte_offset) {
  S v_11 = v_5(start_byte_offset);
  S v_12 = v_5((128u + start_byte_offset));
  S v_13 = v_5((256u + start_byte_offset));
  S v_14 = v_5((384u + start_byte_offset));
  S v_15[4] = {v_11, v_12, v_13, v_14};
  return v_15;
}

void f_inner(uint tint_local_index) {
  {
    uint v_16 = 0u;
    v_16 = tint_local_index;
    while(true) {
      uint v_17 = v_16;
      if ((v_17 >= 4u)) {
        break;
      }
      S v_18 = (S)0;
      w[v_17] = v_18;
      {
        v_16 = (v_17 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_19[4] = v_10(0u);
  w = v_19;
  S v_20 = v_5(256u);
  w[int(1)] = v_20;
  w[int(3)].m = v(264u);
  w[int(1)].m[int(0)] = asfloat(u[1u].xy).yx;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

