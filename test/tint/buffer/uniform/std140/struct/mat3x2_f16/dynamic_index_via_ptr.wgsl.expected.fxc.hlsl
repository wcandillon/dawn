SKIP: INVALID

struct Inner {
  matrix<float16_t, 3, 2> m;
};

struct Outer {
  Inner a[4];
};


cbuffer cbuffer_a : register(b0) {
  uint4 a[64];
};
static int counter = int(0);
int i() {
  counter = (counter + int(1));
  return counter;
}

vector<float16_t, 2> tint_bitcast_to_f16(uint src) {
  uint v = src;
  float t_low = f16tof32((v & 65535u));
  float t_high = f16tof32(((v >> 16u) & 65535u));
  float16_t v_1 = float16_t(t_low);
  return vector<float16_t, 2>(v_1, float16_t(t_high));
}

matrix<float16_t, 3, 2> v_2(uint start_byte_offset) {
  vector<float16_t, 2> v_3 = tint_bitcast_to_f16(a[(start_byte_offset / 16u)][((start_byte_offset % 16u) / 4u)]);
  vector<float16_t, 2> v_4 = tint_bitcast_to_f16(a[((4u + start_byte_offset) / 16u)][(((4u + start_byte_offset) % 16u) / 4u)]);
  return matrix<float16_t, 3, 2>(v_3, v_4, tint_bitcast_to_f16(a[((8u + start_byte_offset) / 16u)][(((8u + start_byte_offset) % 16u) / 4u)]));
}

Inner v_5(uint start_byte_offset) {
  Inner v_6 = {v_2(start_byte_offset)};
  return v_6;
}

typedef Inner ary_ret[4];
ary_ret v_7(uint start_byte_offset) {
  Inner a_2[4] = (Inner[4])0;
  {
    uint v_8 = 0u;
    v_8 = 0u;
    while(true) {
      uint v_9 = v_8;
      if ((v_9 >= 4u)) {
        break;
      }
      Inner v_10 = v_5((start_byte_offset + (v_9 * 64u)));
      a_2[v_9] = v_10;
      {
        v_8 = (v_9 + 1u);
      }
      continue;
    }
  }
  Inner v_11[4] = a_2;
  return v_11;
}

Outer v_12(uint start_byte_offset) {
  Inner v_13[4] = v_7(start_byte_offset);
  Outer v_14 = {v_13};
  return v_14;
}

typedef Outer ary_ret_1[4];
ary_ret_1 v_15(uint start_byte_offset) {
  Outer a_1[4] = (Outer[4])0;
  {
    uint v_16 = 0u;
    v_16 = 0u;
    while(true) {
      uint v_17 = v_16;
      if ((v_17 >= 4u)) {
        break;
      }
      Outer v_18 = v_12((start_byte_offset + (v_17 * 256u)));
      a_1[v_17] = v_18;
      {
        v_16 = (v_17 + 1u);
      }
      continue;
    }
  }
  Outer v_19[4] = a_1;
  return v_19;
}

[numthreads(1, 1, 1)]
void f() {
  uint v_20 = (256u * min(uint(i()), 3u));
  uint v_21 = (64u * min(uint(i()), 3u));
  uint v_22 = (4u * min(uint(i()), 2u));
  Outer l_a[4] = v_15(0u);
  Outer l_a_i = v_12(v_20);
  Inner l_a_i_a[4] = v_7(v_20);
  Inner l_a_i_a_i = v_5((v_20 + v_21));
  matrix<float16_t, 3, 2> l_a_i_a_i_m = v_2((v_20 + v_21));
  vector<float16_t, 2> l_a_i_a_i_m_i = tint_bitcast_to_f16(a[(((v_20 + v_21) + v_22) / 16u)][((((v_20 + v_21) + v_22) % 16u) / 4u)]);
  uint v_23 = (((v_20 + v_21) + v_22) + (min(uint(i()), 1u) * 2u));
  uint v_24 = a[(v_23 / 16u)][((v_23 % 16u) / 4u)];
  float16_t l_a_i_a_i_m_i_i = float16_t(f16tof32((v_24 >> ((((v_23 % 4u) == 0u)) ? (0u) : (16u)))));
}

