@group(1) @binding(0) var arg_0 : texture_storage_1d<rg16snorm, read_write>;

fn textureStore_3eda2c() {
  var arg_1 = 1u;
  var arg_2 = vec4<f32>(1.0f);
  textureStore(arg_0, arg_1, arg_2);
}

@fragment
fn fragment_main() {
  textureStore_3eda2c();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_3eda2c();
}
