//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
RWTexture3D<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_111d0b() {
  uint4 res = arg_0.Load(int4(int3((1u).xxx), int(0)));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_111d0b());
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
RWTexture3D<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_111d0b() {
  uint4 res = arg_0.Load(int4(int3((1u).xxx), int(0)));
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_111d0b());
}

