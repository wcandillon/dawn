RWTexture2D<float4> arg_0 : register(u0, space1);

void textureStore_064c7f() {
  arg_0[(1).xx] = (1.0f).xxxx;
}

void fragment_main() {
  textureStore_064c7f();
  return;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_064c7f();
  return;
}
