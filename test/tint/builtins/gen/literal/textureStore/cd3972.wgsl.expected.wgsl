@group(1) @binding(0) var arg_0 : texture_storage_3d<rg11b10ufloat, read_write>;

fn textureStore_cd3972() {
  textureStore(arg_0, vec3<u32>(1u), vec4<f32>(1.0f));
}

@fragment
fn fragment_main() {
  textureStore_cd3972();
}

@compute @workgroup_size(1)
fn compute_main() {
  textureStore_cd3972();
}
