//
// fragment_main
//

RWTexture2DArray<float4> arg_0 : register(u0, space1);
void textureStore_f66e96() {
  arg_0[uint3((1u).xx, uint(int(1)))] = (1.0f).xxxx;
}

void fragment_main() {
  textureStore_f66e96();
}

//
// compute_main
//

RWTexture2DArray<float4> arg_0 : register(u0, space1);
void textureStore_f66e96() {
  arg_0[uint3((1u).xx, uint(int(1)))] = (1.0f).xxxx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_f66e96();
}

