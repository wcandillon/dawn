RWTexture2DArray<uint4> arg_0 : register(u0, space1);

void textureStore_9f7cea() {
  arg_0[int3((1).xx, int(1u))] = (1u).xxxx;
}

void fragment_main() {
  textureStore_9f7cea();
  return;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_9f7cea();
  return;
}
