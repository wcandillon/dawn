RWTexture2DArray<int4> arg_0 : register(u0, space1);

void textureStore_4c454f() {
  arg_0[uint3((1u).xx, 1u)] = (1).xxxx;
}

void fragment_main() {
  textureStore_4c454f();
  return;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_4c454f();
  return;
}
