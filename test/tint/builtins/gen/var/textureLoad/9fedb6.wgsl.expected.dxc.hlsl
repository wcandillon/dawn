//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
RWTexture2DArray<float4> arg_0 : register(u0, space1);
float4 textureLoad_9fedb6() {
  int2 arg_1 = (int(1)).xx;
  uint arg_2 = 1u;
  int2 v = arg_1;
  float4 res = arg_0.Load(int4(v, int(arg_2), int(0)));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_9fedb6()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
RWTexture2DArray<float4> arg_0 : register(u0, space1);
float4 textureLoad_9fedb6() {
  int2 arg_1 = (int(1)).xx;
  uint arg_2 = 1u;
  int2 v = arg_1;
  float4 res = arg_0.Load(int4(v, int(arg_2), int(0)));
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_9fedb6()));
}

