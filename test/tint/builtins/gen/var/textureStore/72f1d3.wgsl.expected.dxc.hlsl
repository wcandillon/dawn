//
// fragment_main
//

RWTexture3D<float4> arg_0 : register(u0, space1);
void textureStore_72f1d3() {
  int3 arg_1 = (int(1)).xxx;
  float4 arg_2 = (1.0f).xxxx;
  arg_0[arg_1] = arg_2;
}

void fragment_main() {
  textureStore_72f1d3();
}

//
// compute_main
//

RWTexture3D<float4> arg_0 : register(u0, space1);
void textureStore_72f1d3() {
  int3 arg_1 = (int(1)).xxx;
  float4 arg_2 = (1.0f).xxxx;
  arg_0[arg_1] = arg_2;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_72f1d3();
}

