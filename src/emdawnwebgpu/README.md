Dawn temporarily maintains a fork of the Emscripten WebGPU bindings
(`library_webgpu.js` and friends). The forked files live in
[`//third_party/emdawnwebgpu`](../third_party/emdawnwebgpu/)
and the build targets in this directory produce the other files needed to build
an Emscripten-based project using these bindings.

This allows the the webgpu.h interface to be kept roughly in sync\* between the
two implementations in a single place (the Dawn repository) instead of two,
while also avoiding constantly breaking the version of webgpu.h that is
currently in Emscripten. (\* Note we don't guarantee it will always be in sync,
though - we don't have any automated testing for this, so we'll periodically fix
it up as needed for import into other projects that use these bindings.)

Changes to this code in the Dawn repository will be synced back out to the
upstream Emscripten repository after webgpu.h becomes stable, in what should
theoretically be one big final breaking update. Between then and now, projects
can use Dawn's fork of the bindings:

- Get an emsdk toolchain:
  [instructions](https://emscripten.org/docs/getting_started/downloads.html#installation-instructions-using-the-emsdk-recommended).

- Get a separate source checkout of [Emscripten](https://github.com/emscripten-core/emscripten)
  and set it up to point at the toolchain from emsdk by creating a file at `emscripten/.emscripten`:

  ```
  LLVM_ROOT = '/path/to/emsdk/upstream/bin'
  BINARYEN_ROOT = '/path/to/emsdk/upstream'
  NODE_JS = '/path/to/emsdk/node/18.20.3_64bit/bin/node'
  ```

  Note this must be a source checkout of Emscripten,
  not emsdk's `upstream/emscripten` release, which excludes necessary tools.

- Set up a Dawn GN build, with `dawn_emscripten_dir` in the GN args set to point to
  your Emscripten source checkout.

- Build the `emscripten_webgpu` GN build target.

- Configure the Emscripten build with all of the linker flags listed in `emscripten_webgpu_config`
  (and without `-sUSE_WEBGPU`, because we don't want the built-in bindings).
