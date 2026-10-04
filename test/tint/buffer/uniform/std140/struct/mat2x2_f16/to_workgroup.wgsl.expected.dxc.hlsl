struct S {
  int before;
  matrix<float16_t, 2, 2> m;
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

matrix<float16_t, 2, 2> v_1(uint start_byte_offset) {
  vector<float16_t, 2> v_2 = tint_bitcast_to_f16(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  uint v_3 = (4u + start_byte_offset);
  return matrix<float16_t, 2, 2>(v_2, tint_bitcast_to_f16(u[(v_3 / 16u)][((v_3 & 15u) >> 2u)]));
}

S v_4(uint start_byte_offset) {
  int v_5 = asint(u[(start_byte_offset / 16u)][((start_byte_offset & 15u) >> 2u)]);
  matrix<float16_t, 2, 2> v_6 = v_1((4u + start_byte_offset));
  uint v_7 = (64u + start_byte_offset);
  S v_8 = {v_5, v_6, asint(u[(v_7 / 16u)][((v_7 & 15u) >> 2u)])};
  return v_8;
}

typedef S ary_ret[4];
ary_ret v_9(uint start_byte_offset) {
  S v_10 = v_4(start_byte_offset);
  S v_11 = v_4((128u + start_byte_offset));
  S v_12 = v_4((256u + start_byte_offset));
  S v_13 = v_4((384u + start_byte_offset));
  S v_14[4] = {v_10, v_11, v_12, v_13};
  return v_14;
}

void f_inner(uint tint_local_index) {
  {
    uint v_15 = 0u;
    v_15 = tint_local_index;
    while(true) {
      uint v_16 = v_15;
      if ((v_16 >= 4u)) {
        break;
      }
      S v_17 = (S)0;
      w[v_16] = v_17;
      {
        v_15 = (v_16 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_18[4] = v_9(0u);
  w = v_18;
  S v_19 = v_4(256u);
  w[int(1)] = v_19;
  w[int(3)].m = v_1(260u);
  w[int(1)].m[int(0)] = tint_bitcast_to_f16(u[0u].z).yx;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

