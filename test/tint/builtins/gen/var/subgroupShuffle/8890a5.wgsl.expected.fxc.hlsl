SKIP: INVALID

//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float2 subgroupShuffle_8890a5() {
  float2 arg_0 = (1.0f).xx;
  uint arg_1 = 1u;
  float2 res = WaveReadLaneAt(arg_0, arg_1);
  return res;
}

void fragment_main() {
  prevent_dce.Store2(0u, asuint(subgroupShuffle_8890a5()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float2 subgroupShuffle_8890a5() {
  float2 arg_0 = (1.0f).xx;
  uint arg_1 = 1u;
  float2 res = WaveReadLaneAt(arg_0, arg_1);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store2(0u, asuint(subgroupShuffle_8890a5()));
}

