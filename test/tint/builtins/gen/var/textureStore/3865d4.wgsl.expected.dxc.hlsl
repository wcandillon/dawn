//
// fragment_main
//

RWTexture2D<float4> arg_0 : register(u0, space1);
void textureStore_3865d4() {
  uint2 arg_1 = (1u).xx;
  float4 arg_2 = (1.0f).xxxx;
  arg_0[arg_1] = arg_2;
}

void fragment_main() {
  textureStore_3865d4();
}

//
// compute_main
//

RWTexture2D<float4> arg_0 : register(u0, space1);
void textureStore_3865d4() {
  uint2 arg_1 = (1u).xx;
  float4 arg_2 = (1.0f).xxxx;
  arg_0[arg_1] = arg_2;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_3865d4();
}

