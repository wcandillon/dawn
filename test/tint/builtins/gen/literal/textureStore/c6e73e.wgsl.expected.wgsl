@group(1) @binding(0) var arg_0 : texture_storage_1d<rg8sint, write>;

fn textureStore_c6e73e() {
  textureStore(arg_0, 1u, vec4<i32>(1i));
}

@fragment
fn fragment_main() {
  textureStore_c6e73e();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_c6e73e();
}
