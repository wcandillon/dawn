// Copyright 2020 The Tint Authors.
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

#include "src/reader/spv/parser_impl.h"

#include <cstdint>
#include <vector>

#include "gmock/gmock.h"
#include "spirv-tools/libspirv.hpp"

namespace tint {
namespace reader {
namespace spv {

namespace {

using ::testing::HasSubstr;

using SpvParserImplTest = testing::Test;

TEST_F(SpvParserImplTest, Uint32VecEmpty) {
  std::vector<uint32_t> data;
  ParserImpl p{data};
  EXPECT_FALSE(p.Parse());
  // TODO(dneto): What message?
}

/// @returns the SPIR-V module assembled from the given text.  Numeric IDs
/// are preserved.
std::vector<uint32_t> Assemble(const std::string& spirv_assembly) {
  // TODO(dneto): Use ScopedTrace?

  // (The target environment doesn't affect assembly.
  spvtools::SpirvTools tools(SPV_ENV_UNIVERSAL_1_0);
  std::stringstream errors;
  std::vector<uint32_t> result;
  tools.SetMessageConsumer([&errors](spv_message_level_t, const char*,
                                     const spv_position_t& position,
                                     const char* message) {
    errors << "assembly error:" << position.line << ":" << position.column
           << ": " << message;
  });

  const auto success = tools.Assemble(
      spirv_assembly, &result, SPV_TEXT_TO_BINARY_OPTION_PRESERVE_NUMERIC_IDS);
  EXPECT_TRUE(success) << errors.str();

  return result;
}

TEST_F(SpvParserImplTest, InvalidModuleFails) {
  auto invalid_spv = Assemble("%ty = OpTypeInt 3 0");
  ParserImpl p{invalid_spv};
  EXPECT_FALSE(p.Parse());
  EXPECT_THAT(
      p.error(),
      HasSubstr("TypeInt cannot appear before the memory model instruction"));
  EXPECT_THAT(p.error(), HasSubstr("OpTypeInt 3 0"));
}

// TODO(dneto): uint32 vec, valid SPIR-V

}  // namespace

}  // namespace spv
}  // namespace reader
}  // namespace tint
