SKIP: INVALID

//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
int subgroupBroadcastFirst_9a1bdc() {
  int arg_0 = int(1);
  int res = WaveReadLaneFirst(arg_0);
  return res;
}

void fragment_main() {
  prevent_dce.Store(0u, asuint(subgroupBroadcastFirst_9a1bdc()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
int subgroupBroadcastFirst_9a1bdc() {
  int arg_0 = int(1);
  int res = WaveReadLaneFirst(arg_0);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store(0u, asuint(subgroupBroadcastFirst_9a1bdc()));
}

