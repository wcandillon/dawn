RWTexture3D<float4> arg_0 : register(u0, space1);

void textureStore_3f61ca() {
  arg_0[(1).xxx] = (1.0f).xxxx;
}

void fragment_main() {
  textureStore_3f61ca();
  return;
}

[numthreads(1, 1, 1)]
void compute_main() {
  textureStore_3f61ca();
  return;
}
