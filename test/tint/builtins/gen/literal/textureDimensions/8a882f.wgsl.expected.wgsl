@group(0) @binding(0) var<storage, read_write> prevent_dce : u32;

@group(1) @binding(0) var arg_0 : texture_storage_1d<rgb10a2uint, write>;

fn textureDimensions_8a882f() -> u32 {
  var res : u32 = textureDimensions(arg_0);
  return res;
}

@fragment
fn fragment_main() {
  prevent_dce = textureDimensions_8a882f();
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = textureDimensions_8a882f();
}
