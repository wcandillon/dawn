//
// fragment_main
//

RWTexture1D<float4> arg_0 : register(u0, space1);
void textureStore_09b543() {
  uint arg_1 = 1u;
  float4 arg_2 = (1.0f).xxxx;
  arg_0[arg_1] = arg_2;
}

void fragment_main() {
  textureStore_09b543();
}

//
// compute_main
//

RWTexture1D<float4> arg_0 : register(u0, space1);
void textureStore_09b543() {
  uint arg_1 = 1u;
  float4 arg_2 = (1.0f).xxxx;
  arg_0[arg_1] = arg_2;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_09b543();
}

