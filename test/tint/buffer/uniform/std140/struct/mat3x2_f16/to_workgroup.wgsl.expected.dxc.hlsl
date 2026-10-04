struct S {
  int before;
  matrix<float16_t, 3, 2> m;
  int after;
};

struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
groupshared S w[4];
vector<float16_t, 2> tint_bitcast_to_f16(uint src) {
  uint v = src;
  vector<uint16_t, 2> v16 = vector<uint16_t, 2>(((uint2(v, v) >> uint2(0u, 16u)) & (65535u).xx));
  return asfloat16(v16);
}

matrix<float16_t, 3, 2> v_1(uint start_byte_offset) {
  vector<float16_t, 2> v_2 = tint_bitcast_to_f16(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  vector<float16_t, 2> v_4 = tint_bitcast_to_f16(u[(v_3 / 16u)][((v_3 & 15u) >> 2u)]);
  uint v_5 = (8u + start_byte_offset);
  return matrix<float16_t, 3, 2>(v_2, v_4, tint_bitcast_to_f16(u[(v_5 / 16u)][((v_5 & 15u) >> 2u)]));
}

S v_6(uint start_byte_offset) {
  int v_7 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  matrix<float16_t, 3, 2> v_8 = v_1((4u + start_byte_offset));
  uint v_9 = (64u + start_byte_offset);
  S v_10 = {v_7, v_8, asint(u[(v_9 / 16u)][((v_9 & 15u) >> 2u)])};
  return v_10;
}

typedef S ary_ret[4];
ary_ret v_11(uint start_byte_offset) {
  S v_12 = v_6(start_byte_offset);
  S v_13 = v_6((128u + start_byte_offset));
  S v_14 = v_6((256u + start_byte_offset));
  S v_15 = v_6((384u + start_byte_offset));
  S v_16[4] = {v_12, v_13, v_14, v_15};
  return v_16;
}

void f_inner(uint tint_local_index) {
  {
    uint v_17 = 0u;
    v_17 = tint_local_index;
    while(true) {
      uint v_18 = v_17;
      if ((v_18 >= 4u)) {
        break;
      }
      S v_19 = (S)0;
      w[v_18] = v_19;
      {
        v_17 = (v_18 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_20[4] = v_11(0u);
  w = v_20;
  S v_21 = v_6(256u);
  w[int(1)] = v_21;
  w[int(3)].m = v_1(260u);
  w[int(1)].m[int(0)] = tint_bitcast_to_f16(u[0u].z).yx;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

