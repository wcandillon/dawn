@group(1) @binding(0) var arg_0 : texture_storage_1d<r16sint, read_write>;

fn textureStore_efe5e9() {
  textureStore(arg_0, 1i, vec4<i32>(1i));
}

@fragment
fn fragment_main() {
  textureStore_efe5e9();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_efe5e9();
}
