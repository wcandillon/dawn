@group(1) @binding(0) var arg_0 : texture_storage_1d<rg32sint, write>;

fn textureStore_3d6f01() {
  textureStore(arg_0, 1u, vec4<i32>(1i));
}

@fragment
fn fragment_main() {
  textureStore_3d6f01();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_3d6f01();
}
