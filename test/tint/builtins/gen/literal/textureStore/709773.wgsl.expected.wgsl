@group(1) @binding(0) var arg_0 : texture_storage_2d<rg16snorm, write>;

fn textureStore_709773() {
  textureStore(arg_0, vec2<i32>(1i), vec4<f32>(1.0f));
}

@fragment
fn fragment_main() {
  textureStore_709773();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_709773();
}
