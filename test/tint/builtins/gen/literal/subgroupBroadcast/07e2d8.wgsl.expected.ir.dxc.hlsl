SKIP: FAILED

float16_t subgroupBroadcast_07e2d8() {
  float16_t res = WaveReadLaneAt(float16_t(1.0h), 1u);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce = subgroupBroadcast_07e2d8();
}

DXC validation failure:
hlsl.hlsl:8:3: error: use of undeclared identifier 'prevent_dce'
  prevent_dce = subgroupBroadcast_07e2d8();
  ^

