SKIP: FAILED

float4 dpdyCoarse_445d24() {
  float4 arg_0 = (1.0f).xxxx;
  float4 res = ddy_coarse(arg_0);
  return res;
}

void fragment_main() {
  prevent_dce = dpdyCoarse_445d24();
}

