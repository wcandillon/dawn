struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[4];
};
groupshared float2x2 w[4];
float2x2 v(uint start_byte_offset) {
  uint4 v_1 = u[(start_byte_offset / 16u)];
  uint v_2 = (8u + start_byte_offset);
  uint4 v_3 = u[(v_2 / 16u)];
  return float2x2(asfloat(select((((start_byte_offset & 15u) >> 2u) == 2u), v_1.zw, v_1.xy)), asfloat(select((((v_2 & 15u) >> 2u) == 2u), v_3.zw, v_3.xy)));
}

typedef float2x2 ary_ret[4];
ary_ret v_4(uint start_byte_offset) {
  float2x2 v_5 = v(start_byte_offset);
  float2x2 v_6 = v((16u + start_byte_offset));
  float2x2 v_7 = v((32u + start_byte_offset));
  float2x2 v_8[4] = {v_5, v_6, v_7, v((48u + start_byte_offset))};
  return v_8;
}

void f_inner(uint tint_local_index) {
  {
    uint v_9 = 0u;
    v_9 = tint_local_index;
    while(true) {
      uint v_10 = v_9;
      if ((v_10 >= 4u)) {
        break;
      }
      w[v_10] = float2x2((0.0f).xx, (0.0f).xx);
      {
        v_9 = (v_10 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  float2x2 v_11[4] = v_4(0u);
  w = v_11;
  w[int(1)] = v(32u);
  w[int(1)][int(0)] = asfloat(u[0u].zw).yx;
  w[int(1)][int(0)].x = asfloat(u[0u].z);
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

