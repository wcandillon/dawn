SKIP: FAILED

float3 dpdyFine_1fb7ab() {
  float3 arg_0 = (1.0f).xxx;
  float3 res = ddy_fine(arg_0);
  return res;
}

void fragment_main() {
  prevent_dce = dpdyFine_1fb7ab();
}

