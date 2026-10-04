struct S {
  int before;
  float3x4 m;
  int after;
};

struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
groupshared S w[4];
float3x4 v(uint start_byte_offset) {
  return float3x4(asfloat(u[(start_byte_offset / 16u)]), asfloat(u[((16u + start_byte_offset) / 16u)]), asfloat(u[((32u + start_byte_offset) / 16u)]));
}

S v_1(uint start_byte_offset) {
  int v_2 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  float3x4 v_3 = v((16u + start_byte_offset));
  uint v_4 = (64u + start_byte_offset);
  S v_5 = {v_2, v_3, asint(u[(v_4 / 16u)][((v_4 & 15u) >> 2u)])};
  return v_5;
}

typedef S ary_ret[4];
ary_ret v_6(uint start_byte_offset) {
  S v_7 = v_1(start_byte_offset);
  S v_8 = v_1((128u + start_byte_offset));
  S v_9 = v_1((256u + start_byte_offset));
  S v_10 = v_1((384u + start_byte_offset));
  S v_11[4] = {v_7, v_8, v_9, v_10};
  return v_11;
}

void f_inner(uint tint_local_index) {
  {
    uint v_12 = 0u;
    v_12 = tint_local_index;
    while(true) {
      uint v_13 = v_12;
      if ((v_13 >= 4u)) {
        break;
      }
      S v_14 = (S)0;
      w[v_13] = v_14;
      {
        v_12 = (v_13 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_15[4] = v_6(0u);
  w = v_15;
  S v_16 = v_1(256u);
  w[int(1)] = v_16;
  w[int(3)].m = v(272u);
  w[int(1)].m[int(0)] = asfloat(u[2u]).ywxz;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

