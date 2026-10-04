struct S {
  int before;
  float3x2 m;
  int after;
};

struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
groupshared S w[4];
float3x2 v(uint start_byte_offset) {
  uint4 v_1 = u[(start_byte_offset / 16u)];
  float2 v_2 = asfloat((((((start_byte_offset & 15u) >> 2u) == 2u)) ? (v_1.zw) : (v_1.xy)));
  uint v_3 = (8u + start_byte_offset);
  uint4 v_4 = u[(v_3 / 16u)];
  float2 v_5 = asfloat((((((v_3 & 15u) >> 2u) == 2u)) ? (v_4.zw) : (v_4.xy)));
  uint v_6 = (16u + start_byte_offset);
  uint4 v_7 = u[(v_6 / 16u)];
  return float3x2(v_2, v_5, asfloat((((((v_6 & 15u) >> 2u) == 2u)) ? (v_7.zw) : (v_7.xy))));
}

S v_8(uint start_byte_offset) {
  int v_9 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float3x2 v_10 = v((8u + start_byte_offset));
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

void f_inner(uint tint_local_index) {
  {
    uint v_19 = 0u;
    v_19 = tint_local_index;
    while(true) {
      uint v_20 = v_19;
      if ((v_20 >= 4u)) {
        break;
      }
      S v_21 = (S)0;
      w[v_20] = v_21;
      {
        v_19 = (v_20 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_22[4] = v_13(0u);
  w = v_22;
  S v_23 = v_8(256u);
  w[int(1)] = v_23;
  w[int(3)].m = v(264u);
  w[int(1)].m[int(0)] = asfloat(u[1u].xy).yx;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

