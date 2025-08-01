@group(0) @binding(0) var<storage, read_write> prevent_dce : vec4<i32>;

@group(1) @binding(0) var arg_0 : texture_storage_2d<r16sint, read_write>;

fn textureLoad_757d45() -> vec4<i32> {
  var arg_1 = vec2<u32>(1u);
  var res : vec4<i32> = textureLoad(arg_0, arg_1);
  return res;
}

@fragment
fn fragment_main() {
  prevent_dce = textureLoad_757d45();
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = textureLoad_757d45();
}
