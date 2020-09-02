// Copyright 2018 The Dawn Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <cstdint>
#include <string>
#include <vector>

#include <spirv_msl.hpp>

#include "DawnSPIRVCrossFuzzer.h"

namespace {

    int FuzzTask(const std::vector<uint32_t>& input) {
        // Values come from ShaderModuleMTL.mm
        spirv_cross::CompilerMSL::Options options_msl;
        options_msl.enable_point_size_builtin = false;
        options_msl.buffer_size_buffer_index = 30;

        spirv_cross::CompilerMSL compiler(input);
        compiler.set_msl_options(options_msl);
        compiler.compile();

        return 0;
    }

}  // namespace

extern "C" int LLVMFuzzerInitialize(int* argc, char*** argv) {
    return 0;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    return DawnSPIRVCrossFuzzer::Run(data, size, FuzzTask);
}
