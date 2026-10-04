struct S {
  int4 arr[4];
};

struct main_inputs {
  uint tint_local_index : SV_GroupIndex;
};


static int4 src_private[4] = (int4[4])0;
groupshared int4 src_workgroup[4];
cbuffer cbuffer_src_uniform : register(b0) {
  uint4 src_uniform[4];
};
RWByteAddressBuffer src_storage : register(u1);
static int4 v[4] = (int4[4])0;
static int dst_nested[4][3][2] = (int[4][3][2])0;
typedef int4 ary_ret[4];
ary_ret ret_arr() {
  int4 v_1[4] = (int4[4])0;
  return v_1;
}

S ret_struct_arr() {
  S v_2 = (S)0;
  return v_2;
}

typedef int4 ary_ret_1[4];
ary_ret_1 v_3(uint offset) {
  int4 a[4] = (int4[4])0;
  {
    uint v_4 = 0u;
    v_4 = 0u;
    while(true) {
      uint v_5 = v_4;
      if ((v_5 >= 4u)) {
        break;
      }
      a[v_5] = asint(src_storage.Load4((offset + (v_5 * 16u))));
      {
        v_4 = (v_5 + 1u);
      }
    }
  }
  int4 v_6[4] = a;
  return v_6;
}

typedef int4 ary_ret_2[4];
ary_ret_2 v_7(uint start_byte_offset) {
  int4 v_8[4] = {asint(src_uniform[(start_byte_offset / 16u)]), asint(src_uniform[((16u + start_byte_offset) / 16u)]), asint(src_uniform[((32u + start_byte_offset) / 16u)]), asint(src_uniform[((48u + start_byte_offset) / 16u)])};
  return v_8;
}

void foo(int4 src_param[4]) {
  int4 src_function[4] = (int4[4])0;
  int4 v_9[4] = {(int(1)).xxxx, (int(2)).xxxx, (int(3)).xxxx, (int(3)).xxxx};
  v = v_9;
  v = src_param;
  int4 v_10[4] = ret_arr();
  v = v_10;
  int4 src_let[4] = (int4[4])0;
  v = src_let;
  int4 v_11[4] = src_function;
  v = v_11;
  int4 v_12[4] = src_private;
  v = v_12;
  int4 v_13[4] = src_workgroup;
  v = v_13;
  S v_14 = ret_struct_arr();
  int4 v_15[4] = v_14.arr;
  v = v_15;
  int4 v_16[4] = v_7(0u);
  v = v_16;
  int4 v_17[4] = v_3(0u);
  v = v_17;
  int src_nested[4][3][2] = (int[4][3][2])0;
  int v_18[4][3][2] = src_nested;
  dst_nested = v_18;
}

void main_inner(uint tint_local_index) {
  {
    uint v_19 = 0u;
    v_19 = tint_local_index;
    while(true) {
      uint v_20 = v_19;
      if ((v_20 >= 4u)) {
        break;
      }
      src_workgroup[v_20] = (int(0)).xxxx;
      {
        v_19 = (v_20 + 1u);
      }
    }
  }
  GroupMemoryBarrierWithGroupSync();
  int4 a[4] = (int4[4])0;
  foo(a);
}

[numthreads(1, 1, 1)]
void main(main_inputs inputs) {
  main_inner(inputs.tint_local_index);
}

