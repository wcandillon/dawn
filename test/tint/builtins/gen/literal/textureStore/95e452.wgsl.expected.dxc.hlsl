RWTexture2D<int4> arg_0 : register(u0, space1);

void textureStore_95e452() {
  arg_0[(1u).xx] = (1).xxxx;
}

void fragment_main() {
  textureStore_95e452();
  return;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_95e452();
  return;
}
