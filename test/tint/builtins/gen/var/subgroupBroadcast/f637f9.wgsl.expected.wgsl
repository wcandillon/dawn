enable subgroups;

@group(0) @binding(0) var<storage, read_write> prevent_dce : vec4<i32>;

fn subgroupBroadcast_f637f9() -> vec4<i32> {
  var arg_0 = vec4<i32>(1i);
  const arg_1 = 1u;
  var res : vec4<i32> = subgroupBroadcast(arg_0, arg_1);
  return res;
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = subgroupBroadcast_f637f9();
}
