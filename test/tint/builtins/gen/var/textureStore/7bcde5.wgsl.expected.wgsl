@group(1) @binding(0) var arg_0 : texture_storage_2d_array<rg11b10ufloat, read_write>;

fn textureStore_7bcde5() {
  var arg_1 = vec2<i32>(1i);
  var arg_2 = 1i;
  var arg_3 = vec4<f32>(1.0f);
  textureStore(arg_0, arg_1, arg_2, arg_3);
}

@fragment
fn fragment_main() {
  textureStore_7bcde5();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_7bcde5();
}
