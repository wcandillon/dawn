// Copyright 2023 The Dawn & Tint Authors
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

////////////////////////////////////////////////////////////////////////////////
// File generated by 'tools/src/cmd/gen' using the template:
//   src/tint/lang/msl/intrinsic/data.cc.tmpl
//
// To regenerate run: './tools/run gen'
//
//                       Do not modify this file directly
////////////////////////////////////////////////////////////////////////////////

#include <limits>
#include <string>

#include "src/tint/lang/core/intrinsic/type_matchers.h"
#include "src/tint/lang/msl/intrinsic/dialect.h"
#include "src/tint/utils/text/string_stream.h"

namespace tint::msl::intrinsic {

using namespace tint::core::intrinsic;  // NOLINT(build/namespaces)

namespace {

using ConstEvalFunctionIndex = tint::core::intrinsic::ConstEvalFunctionIndex;
using IntrinsicInfo = tint::core::intrinsic::IntrinsicInfo;
using MatcherIndicesIndex = tint::core::intrinsic::MatcherIndicesIndex;
using MatchState = tint::core::intrinsic::MatchState;
using Number = tint::core::intrinsic::Number;
using NumberMatcher = tint::core::intrinsic::NumberMatcher;
using NumberMatcherIndex = tint::core::intrinsic::NumberMatcherIndex;
using OverloadFlag = tint::core::intrinsic::OverloadFlag;
using OverloadFlags = tint::core::intrinsic::OverloadFlags;
using OverloadIndex = tint::core::intrinsic::OverloadIndex;
using OverloadInfo = tint::core::intrinsic::OverloadInfo;
using ParameterIndex = tint::core::intrinsic::ParameterIndex;
using ParameterInfo = tint::core::intrinsic::ParameterInfo;
using StringStream = tint::StringStream;
using TemplateIndex = tint::core::intrinsic::TemplateIndex;
using Type = tint::core::type::Type;
using TypeMatcher = tint::core::intrinsic::TypeMatcher;
using TypeMatcherIndex = tint::core::intrinsic::TypeMatcherIndex;

template <size_t N>
using TemplateNumberMatcher = tint::core::intrinsic::TemplateNumberMatcher<N>;

template <size_t N>
using TemplateTypeMatcher = tint::core::intrinsic::TemplateTypeMatcher<N>;

// clang-format off

/// TypeMatcher for 'type i32'
constexpr TypeMatcher kI32Matcher {
/* match */ [](MatchState& state, const Type* ty) -> const Type* {
    if (!MatchI32(state, ty)) {
      return nullptr;
    }
    return BuildI32(state, ty);
  },
/* print */ []([[maybe_unused]] MatchState* state, StyledText& out) {
    out << style::Type("i32");
  }
};


/// TypeMatcher for 'type u32'
constexpr TypeMatcher kU32Matcher {
/* match */ [](MatchState& state, const Type* ty) -> const Type* {
    if (!MatchU32(state, ty)) {
      return nullptr;
    }
    return BuildU32(state, ty);
  },
/* print */ []([[maybe_unused]] MatchState* state, StyledText& out) {
    out << style::Type("u32");
  }
};


/// TypeMatcher for 'type atomic'
constexpr TypeMatcher kAtomicMatcher {
/* match */ [](MatchState& state, const Type* ty) -> const Type* {
  const Type* T = nullptr;
    if (!MatchAtomic(state, ty, T)) {
      return nullptr;
    }
    T = state.Type(T);
    if (T == nullptr) {
      return nullptr;
    }
    return BuildAtomic(state, ty, T);
  },
/* print */ []([[maybe_unused]] MatchState* state, StyledText& out) {StyledText T;
  state->PrintType(T);
    out << style::Type("atomic", "<", T, ">");
  }
};


/// TypeMatcher for 'type ptr'
constexpr TypeMatcher kPtrMatcher {
/* match */ [](MatchState& state, const Type* ty) -> const Type* {
  Number S = Number::invalid;
  const Type* T = nullptr;
  Number A = Number::invalid;
    if (!MatchPtr(state, ty, S, T, A)) {
      return nullptr;
    }
    S = state.Num(S);
    if (!S.IsValid()) {
      return nullptr;
    }
    T = state.Type(T);
    if (T == nullptr) {
      return nullptr;
    }
    A = state.Num(A);
    if (!A.IsValid()) {
      return nullptr;
    }
    return BuildPtr(state, ty, S, T, A);
  },
/* print */ []([[maybe_unused]] MatchState* state, StyledText& out) {StyledText S;
  state->PrintNum(S);StyledText T;
  state->PrintType(T);StyledText A;
  state->PrintNum(A);
    out << style::Type("ptr", "<", S, ", ", T, ", ", A, ">");
  }
};


/// TypeMatcher for 'match iu32'
constexpr TypeMatcher kIu32Matcher {
/* match */ [](MatchState& state, const Type* ty) -> const Type* {
    if (MatchI32(state, ty)) {
      return BuildI32(state, ty);
    }
    if (MatchU32(state, ty)) {
      return BuildU32(state, ty);
    }
    return nullptr;
  },
/* print */ [](MatchState*, StyledText& out) {
    // Note: We pass nullptr to the Matcher.print() functions, as matchers do not support
    // template arguments, nor can they match sub-types. As such, they have no use for the MatchState.
 kI32Matcher.print(nullptr, out); out << style::Plain(" or "); kU32Matcher.print(nullptr, out);}
};

/// EnumMatcher for 'match read_write'
constexpr NumberMatcher kReadWriteMatcher {
/* match */ [](MatchState&, Number number) -> Number {
    if (number.IsAny() || number.Value() == static_cast<uint32_t>(core::Access::kReadWrite)) {
      return Number(static_cast<uint32_t>(core::Access::kReadWrite));
    }
    return Number::invalid;
  },
/* print */ [](MatchState*, StyledText& out) {
  out<< style::Enum("read_write");
  }
};

/// EnumMatcher for 'match workgroup_or_storage'
constexpr NumberMatcher kWorkgroupOrStorageMatcher {
/* match */ [](MatchState&, Number number) -> Number {
    switch (static_cast<core::AddressSpace>(number.Value())) {
      case core::AddressSpace::kWorkgroup:
      case core::AddressSpace::kStorage:
        return number;
      default:
        return Number::invalid;
    }
  },
/* print */ [](MatchState*, StyledText& out) {
  out<< style::Enum("workgroup")<< style::Plain(" or ") << style::Enum("storage");
  }
};

/// Type and number matchers

/// The template types, types, and type matchers
constexpr TypeMatcher kTypeMatchers[] = {
  /* [0] */ TemplateTypeMatcher<0>::matcher,
  /* [1] */ TemplateTypeMatcher<1>::matcher,
  /* [2] */ kI32Matcher,
  /* [3] */ kU32Matcher,
  /* [4] */ kAtomicMatcher,
  /* [5] */ kPtrMatcher,
  /* [6] */ kIu32Matcher,
};

/// The template numbers, and number matchers
constexpr NumberMatcher kNumberMatchers[] = {
  /* [0] */ TemplateNumberMatcher<0>::matcher,
  /* [1] */ TemplateNumberMatcher<1>::matcher,
  /* [2] */ kReadWriteMatcher,
  /* [3] */ kWorkgroupOrStorageMatcher,
};

constexpr MatcherIndex kMatcherIndices[] = {
  /* [0] */ MatcherIndex(5),
  /* [1] */ MatcherIndex(1),
  /* [2] */ MatcherIndex(4),
  /* [3] */ MatcherIndex(0),
  /* [4] */ MatcherIndex(2),
  /* [5] */ MatcherIndex(6),
  /* [6] */ MatcherIndex(3),
};

static_assert(MatcherIndicesIndex::CanIndex(kMatcherIndices),
              "MatcherIndicesIndex is not large enough to index kMatcherIndices");

constexpr ParameterInfo kParameters[] = {
  {
    /* [0] */
    /* usage */ core::ParameterUsage::kNone,
    /* matcher_indices */ MatcherIndicesIndex(0),
  },
  {
    /* [1] */
    /* usage */ core::ParameterUsage::kNone,
    /* matcher_indices */ MatcherIndicesIndex(3),
  },
  {
    /* [2] */
    /* usage */ core::ParameterUsage::kNone,
    /* matcher_indices */ MatcherIndicesIndex(6),
  },
  {
    /* [3] */
    /* usage */ core::ParameterUsage::kNone,
    /* matcher_indices */ MatcherIndicesIndex(0),
  },
  {
    /* [4] */
    /* usage */ core::ParameterUsage::kNone,
    /* matcher_indices */ MatcherIndicesIndex(6),
  },
};

static_assert(ParameterIndex::CanIndex(kParameters),
              "ParameterIndex is not large enough to index kParameters");

constexpr TemplateInfo kTemplates[] = {
  {
    /* [0] */
    /* name */ "T",
    /* matcher_indices */ MatcherIndicesIndex(5),
    /* kind */ TemplateInfo::Kind::kType,
  },
  {
    /* [1] */
    /* name */ "S",
    /* matcher_indices */ MatcherIndicesIndex(6),
    /* kind */ TemplateInfo::Kind::kNumber,
  },
};

static_assert(TemplateIndex::CanIndex(kTemplates),
              "TemplateIndex is not large enough to index kTemplates");

constexpr OverloadInfo kOverloads[] = {
  {
    /* [0] */
    /* flags */ OverloadFlags(OverloadFlag::kIsBuiltin, OverloadFlag::kSupportsFragmentPipeline, OverloadFlag::kSupportsComputePipeline),
    /* num_parameters */ 3,
    /* num_explicit_templates */ 0,
    /* num_templates   */ 2,
    /* templates */ TemplateIndex(0),
    /* parameters */ ParameterIndex(0),
    /* return_matcher_indices */ MatcherIndicesIndex(3),
    /* const_eval_fn */ ConstEvalFunctionIndex(/* invalid */),
  },
  {
    /* [1] */
    /* flags */ OverloadFlags(OverloadFlag::kIsBuiltin, OverloadFlag::kSupportsFragmentPipeline, OverloadFlag::kSupportsComputePipeline),
    /* num_parameters */ 2,
    /* num_explicit_templates */ 0,
    /* num_templates   */ 2,
    /* templates */ TemplateIndex(0),
    /* parameters */ ParameterIndex(3),
    /* return_matcher_indices */ MatcherIndicesIndex(3),
    /* const_eval_fn */ ConstEvalFunctionIndex(/* invalid */),
  },
  {
    /* [2] */
    /* flags */ OverloadFlags(OverloadFlag::kIsBuiltin, OverloadFlag::kSupportsFragmentPipeline, OverloadFlag::kSupportsComputePipeline),
    /* num_parameters */ 3,
    /* num_explicit_templates */ 0,
    /* num_templates   */ 2,
    /* templates */ TemplateIndex(0),
    /* parameters */ ParameterIndex(0),
    /* return_matcher_indices */ MatcherIndicesIndex(/* invalid */),
    /* const_eval_fn */ ConstEvalFunctionIndex(/* invalid */),
  },
  {
    /* [3] */
    /* flags */ OverloadFlags(OverloadFlag::kIsBuiltin, OverloadFlag::kSupportsComputePipeline),
    /* num_parameters */ 1,
    /* num_explicit_templates */ 0,
    /* num_templates   */ 0,
    /* templates */ TemplateIndex(/* invalid */),
    /* parameters */ ParameterIndex(2),
    /* return_matcher_indices */ MatcherIndicesIndex(/* invalid */),
    /* const_eval_fn */ ConstEvalFunctionIndex(/* invalid */),
  },
};

static_assert(OverloadIndex::CanIndex(kOverloads),
              "OverloadIndex is not large enough to index kOverloads");

constexpr IntrinsicInfo kBuiltins[] = {
  {
    /* [0] */
    /* fn atomic_exchange_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [1] */
    /* fn atomic_fetch_add_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [2] */
    /* fn atomic_fetch_and_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [3] */
    /* fn atomic_fetch_max_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [4] */
    /* fn atomic_fetch_min_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [5] */
    /* fn atomic_fetch_or_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [6] */
    /* fn atomic_fetch_sub_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [7] */
    /* fn atomic_fetch_xor_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(0),
  },
  {
    /* [8] */
    /* fn atomic_load_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, u32) -> T */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(1),
  },
  {
    /* [9] */
    /* fn atomic_store_explicit[T : iu32, S : workgroup_or_storage](ptr<S, atomic<T>, read_write>, T, u32) */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(2),
  },
  {
    /* [10] */
    /* fn threadgroup_barrier(u32) */
    /* num overloads */ 1,
    /* overloads */ OverloadIndex(3),
  },
};

// clang-format on

}  // anonymous namespace

const core::intrinsic::TableData Dialect::kData{
    /* templates */ kTemplates,
    /* type_matcher_indices */ kMatcherIndices,
    /* type_matchers */ kTypeMatchers,
    /* number_matchers */ kNumberMatchers,
    /* parameters */ kParameters,
    /* overloads */ kOverloads,
    /* const_eval_functions */ Empty,
    /* ctor_conv */ Empty,
    /* builtins */ kBuiltins,
    /* binary '+' */ tint::core::intrinsic::kNoOverloads,
    /* binary '-' */ tint::core::intrinsic::kNoOverloads,
    /* binary '*' */ tint::core::intrinsic::kNoOverloads,
    /* binary '/' */ tint::core::intrinsic::kNoOverloads,
    /* binary '%' */ tint::core::intrinsic::kNoOverloads,
    /* binary '^' */ tint::core::intrinsic::kNoOverloads,
    /* binary '&' */ tint::core::intrinsic::kNoOverloads,
    /* binary '|' */ tint::core::intrinsic::kNoOverloads,
    /* binary '&&' */ tint::core::intrinsic::kNoOverloads,
    /* binary '||' */ tint::core::intrinsic::kNoOverloads,
    /* binary '==' */ tint::core::intrinsic::kNoOverloads,
    /* binary '!=' */ tint::core::intrinsic::kNoOverloads,
    /* binary '<' */ tint::core::intrinsic::kNoOverloads,
    /* binary '>' */ tint::core::intrinsic::kNoOverloads,
    /* binary '<=' */ tint::core::intrinsic::kNoOverloads,
    /* binary '>=' */ tint::core::intrinsic::kNoOverloads,
    /* binary '<<' */ tint::core::intrinsic::kNoOverloads,
    /* binary '>>' */ tint::core::intrinsic::kNoOverloads,
    /* unary '!' */ tint::core::intrinsic::kNoOverloads,
    /* unary '~' */ tint::core::intrinsic::kNoOverloads,
    /* unary '-' */ tint::core::intrinsic::kNoOverloads,
    /* unary '*' */ tint::core::intrinsic::kNoOverloads,
    /* unary '&' */ tint::core::intrinsic::kNoOverloads,
};

}  // namespace tint::msl::intrinsic
