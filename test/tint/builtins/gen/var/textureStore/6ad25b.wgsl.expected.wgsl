@group(1) @binding(0) var arg_0 : texture_storage_3d<rg11b10ufloat, write>;

fn textureStore_6ad25b() {
  var arg_1 = vec3<u32>(1u);
  var arg_2 = vec4<f32>(1.0f);
  textureStore(arg_0, arg_1, arg_2);
}

@fragment
fn fragment_main() {
  textureStore_6ad25b();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_6ad25b();
}
