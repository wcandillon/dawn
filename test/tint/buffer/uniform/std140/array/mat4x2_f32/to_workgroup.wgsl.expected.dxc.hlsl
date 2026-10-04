struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[8];
};
groupshared float4x2 w[4];
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

typedef float4x2 ary_ret[4];
ary_ret v_8(uint start_byte_offset) {
  float4x2 v_9 = v(start_byte_offset);
  float4x2 v_10 = v((32u + start_byte_offset));
  float4x2 v_11 = v((64u + start_byte_offset));
  float4x2 v_12[4] = {v_9, v_10, v_11, v((96u + start_byte_offset))};
  return v_12;
}

void f_inner(uint tint_local_index) {
  {
    uint v_13 = 0u;
    v_13 = tint_local_index;
    while(true) {
      uint v_14 = v_13;
      if ((v_14 >= 4u)) {
        break;
      }
      w[v_14] = float4x2((0.0f).xx, (0.0f).xx, (0.0f).xx, (0.0f).xx);
      {
        v_13 = (v_14 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  float4x2 v_15[4] = v_8(0u);
  w = v_15;
  w[int(1)] = v(64u);
  w[int(1)][int(0)] = asfloat(u[0u].zw).yx;
  w[int(1)][int(0)].x = asfloat(u[0u].z);
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

