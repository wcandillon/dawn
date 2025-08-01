//* Copyright 2020 The Dawn & Tint Authors
//*
//* Redistribution and use in source and binary forms, with or without
//* modification, are permitted provided that the following conditions are met:
//*
//* 1. Redistributions of source code must retain the above copyright notice, this
//*    list of conditions and the following disclaimer.
//*
//* 2. Redistributions in binary form must reproduce the above copyright notice,
//*    this list of conditions and the following disclaimer in the documentation
//*    and/or other materials provided with the distribution.
//*
//* 3. Neither the name of the copyright holder nor the names of its
//*    contributors may be used to endorse or promote products derived from
//*    this software without specific prior written permission.
//*
//* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//*
//*
{% include 'BSD_LICENSE' %}

{%- if 'dawn' in enabled_tags %}
    #ifdef __EMSCRIPTEN__
    #error "Do not include this header. Emscripten already provides headers needed for {{metadata.api}}."
    #endif
{% endif %}

#ifndef {{metadata.api.upper()}}_H_
#define {{metadata.api.upper()}}_H_

//* -------------------------------------------------------------------------------------
//* The follow block defines Dawn generator specific macros
//* -------------------------------------------------------------------------------------
{% macro render_c_default_value(member) -%}
    {%- if member.annotation in ["*", "const*", "const*const*"] -%}
        //* Pointer types should always default to NULL.
        NULL
    {%- elif member.type.category == "object" -%}
        //* Object types should always default to NULL.
        NULL
    {%- elif member.type.category in ["callback function", "function pointer"] -%}
        //* Callback function types should always default to NULL.
        NULL
    {%- elif member.type.category == "enum" -%}
        {%- if member.type.hasUndefined -%}
            //* For enums that have an undefined value, instead of using the
            //* default, just put undefined.
            {{as_cEnum(member.type.name, Name("undefined"))}}
        {%- elif member.default_value != None -%}
            //* Enum types are either their default values, or zero-init.
            {{as_cEnum(member.type.name, Name(member.default_value))}}
        {%- else -%}
            _{{api}}_ENUM_ZERO_INIT({{as_cType(member.type.name)}})
        {%- endif -%}
    {%- elif member.type.category == "bitmask" -%}
        {%- if member.default_value != None -%}
            {{as_cEnum(member.type.name, Name(member.default_value))}}
        {%- else -%}
            //* Bitmask types should currently always default to "none" if not
            //* explicitly set.
            {{as_cEnum(member.type.name, Name("none"))}}
        {%- endif -%}
    {%- elif member.type.category in ["structure", "callback info"] -%}
        //* Structure types, must be by value here, otherwise, they should have
        //* been caught as a pointer type.
        {{- assert(member.annotation == "value") -}}
        {%- if member.default_value == "zero" -%}
            //* Special case for structures to use zero init instead of default
            //* struct init.
            _{{api}}_STRUCT_ZERO_INIT
        {%- else -%}
            {{API}}_{{member.type.name.SNAKE_CASE()}}_INIT
        {%- endif -%}
    {%- elif member.type.category == "native" -%}
        //* Defaults in native types are either directly specified, or
        //* explicitly defined per type.
        {%- if member.default_value != None and member.type.name.get() != "bool" -%}
            //* Check to see if the default value is a known constant.
            {%- set constant = find_by_name(by_category["constant"], member.default_value) -%}
            {%- if constant -%}
                {{API}}_{{constant.name.SNAKE_CASE()}}
            {%- else -%}
                {{member.default_value}}
            {%- endif -%}
        {%- else -%}
            {%- if "int" in member.type.name.get() or member.type.name.get() == "size_t" -%}
                0
            {%- elif member.type.name.get() == "float" -%}
                0.f
            {%- elif member.type.name.get() == "double" -%}
                0.
            {%- elif member.type.name.get() == "bool" -%}
                {%- if member.default_value == "true" -%}
                    {{API}}_TRUE
                {%- else -%}
                    {{API}}_FALSE
                {%- endif -%}
            {%- elif "void" in member.type.name.get() -%}
                //* For members, void types are always pointers. We should
                //* probably update the json file to make it more consistent
                //* for these types by using annotations.
                NULL
            {%- else -%}
                {{- assert(false, 'Unknown type "' + member.type.name.get() + '" with annotations "' + member.annotation + '" when trying to render default value.') -}}
            {%- endif -%}
        {%- endif -%}
    {%- else -%}
        {{- assert(false, 'Unknown type "' + member.type.name.get() + '" with annotations "' + member.annotation + '" when trying to render default value.') -}}
    {%- endif -%}
{%- endmacro -%}

//* The |render_c_struct_definition| macro renders both the struct definition and the init macros for a given struct.
{%- macro render_c_struct_definition(type) -%}
    {% for root in type.chain_roots %}
        // Can be chained in {{as_cType(root.name)}}
    {% endfor %}
    typedef struct {{as_cType(type.name)}} {
        {% if type.extensible %}
            {{API}}ChainedStruct * nextInChain;
        {% endif %}
        {% if type.chained %}
            {{API}}ChainedStruct chain;
        {% endif %}
        {% for member in type.members %}
            {{as_nullability_annotated_cType(member)}};
        {% endfor %}
    } {{as_cType(type.name)}} {{API}}_STRUCTURE_ATTRIBUTE;

    #define {{API}}_{{type.name.SNAKE_CASE()}}_INIT _{{api}}_MAKE_INIT_STRUCT({{as_cType(type.name)}}, { \
        {% if type.extensible %}
            /*.nextInChain=*/NULL _{{api}}_COMMA \
        {% endif %}
        {% if type.chained %}
            /*.chain=*/_{{api}}_MAKE_INIT_STRUCT({{API}}ChainedStruct, { \
                /*.next=*/NULL _{{api}}_COMMA \
                /*.sType=*/{{API}}SType_{{type.name.CamelCase()}} _{{api}}_COMMA \
            }) _{{api}}_COMMA \
        {% endif %}
        {% for member in type.members %}
            /*.{{as_varName(member.name)}}=*/{{render_c_default_value(member)}} _{{api}}_COMMA \
        {% endfor %}
    })
{%- endmacro %}

{%- macro render_c_function_args(args) %}
    {% for arg in args -%}
        {% if not loop.first %}, {% endif -%}
        {{as_nullability_annotated_cType(arg)}}
    {%- endfor %}
{%- endmacro %}

{%- macro render_c_method_args(this, args) %}
    {{as_cType(this.name)}} {{as_varName(this.name)}}
    {%- if args -%}
        , {{ render_c_function_args(args) }}
    {%- endif %}
{%- endmacro %}

//* Special structures that require some custom code generation.
{%- set SpecialStructures = ["string view"] %}
//* -------------------------------------------------------------------------------------
//* End of Dawn generator specific macros
//* -------------------------------------------------------------------------------------

{%- set API = metadata.c_prefix %}
{% set api = API.lower() %}
#if defined({{API}}_SHARED_LIBRARY)
#    if defined(_WIN32)
#        if defined({{API}}_IMPLEMENTATION)
#            define {{API}}_EXPORT __declspec(dllexport)
#        else
#            define {{API}}_EXPORT __declspec(dllimport)
#        endif
#    else  // defined(_WIN32)
#        if defined({{API}}_IMPLEMENTATION)
#            define {{API}}_EXPORT __attribute__((visibility("default")))
#        else
#            define {{API}}_EXPORT
#        endif
#    endif  // defined(_WIN32)
#else       // defined({{API}}_SHARED_LIBRARY)
#    define {{API}}_EXPORT
#endif  // defined({{API}}_SHARED_LIBRARY)

#if !defined({{API}}_OBJECT_ATTRIBUTE)
#define {{API}}_OBJECT_ATTRIBUTE
#endif
#if !defined({{API}}_ENUM_ATTRIBUTE)
#define {{API}}_ENUM_ATTRIBUTE
#endif
#if !defined({{API}}_STRUCTURE_ATTRIBUTE)
#define {{API}}_STRUCTURE_ATTRIBUTE
#endif
#if !defined({{API}}_FUNCTION_ATTRIBUTE)
#define {{API}}_FUNCTION_ATTRIBUTE
#endif
#if !defined({{API}}_NULLABLE)
#define {{API}}_NULLABLE
#endif

#include <stdint.h>
#include <stddef.h>
#include <math.h>

#define _{{api}}_COMMA ,
#if defined(__cplusplus)
#  define _{{api}}_ENUM_ZERO_INIT(type) type(0)
#  define _{{api}}_STRUCT_ZERO_INIT {}
#  if __cplusplus >= 201103L
#    define _{{api}}_MAKE_INIT_STRUCT(type, value) (type value)
#  else
#    define _{{api}}_MAKE_INIT_STRUCT(type, value) value
#  endif
#else
#  define _{{api}}_ENUM_ZERO_INIT(type) (type)0
#  define _{{api}}_STRUCT_ZERO_INIT {0}
#  if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#    define _{{api}}_MAKE_INIT_STRUCT(type, value) ((type) value)
#  else
#    define _{{api}}_MAKE_INIT_STRUCT(type, value) value
#  endif
#endif

#define WGPU_TRUE (UINT32_C(1))
#define WGPU_FALSE (UINT32_C(0))
{% for constant in by_category["constant"] %}
    #define {{API}}_{{constant.name.SNAKE_CASE()}} ({{constant.value}})
{% endfor %}

//* The upstream header fully declares WGPUStringView up front so do the same here.
{{render_c_struct_definition(types["string view"])}}

typedef uint64_t {{API}}Flags;
typedef uint32_t {{API}}Bool;

{% for type in by_category["object"] %}
    typedef struct {{as_cType(type.name)}}Impl* {{as_cType(type.name)}} {{API}}_OBJECT_ATTRIBUTE;
{% endfor %}

// Structure forward declarations
{% for type in by_category["structure"] if type.name.get() not in SpecialStructures %}
    struct {{as_cType(type.name)}};
{% endfor %}

// Callback info structure forward declarations.
{% for type in by_category["callback info"] %}
    struct {{as_cType(type.name)}};
{% endfor %}

{% for type in by_category["enum"] %}
    typedef enum {{as_cType(type.name)}} {
        {% for value in type.values %}
            {{as_cEnum(type.name, value.name)}} = 0x{{format(value.value, "08X")}},
        {% endfor %}
        {{as_cEnum(type.name, Name("force32"))}} = 0x7FFFFFFF
    } {{as_cType(type.name)}} {{API}}_ENUM_ATTRIBUTE;

{% endfor -%}

{% for type in by_category["bitmask"] %}
    typedef {{API}}Flags {{as_cType(type.name)}};
    {% for value in type.values %}
        static const {{as_cType(type.name)}} {{as_cEnum(type.name, value.name)}} = 0x{{format(value.value, "016X")}};
    {% endfor %}

{% endfor -%}

{% for type in by_category["function pointer"] %}
    typedef {{as_nullability_annotated_cType(type.returns)}} (*{{as_cType(type.name)}})(
        {%- if type.arguments == [] -%}
            void
        {%- else -%}
            {{- render_c_function_args(type.arguments) -}}
        {%- endif -%}
    ) {{API}}_FUNCTION_ATTRIBUTE;
{% endfor %}

// Callback function pointers
{% for type in by_category["callback function"] %}
    typedef {{as_annotated_cType(type.returns)}} (*{{as_cType(type.name)}})(
        {%- for arg in type.arguments -%}
            {% if arg.type.category == "structure" and arg.type.name.get() != "string view" %}struct {% endif %}{{as_annotated_cType(arg)}}{{", "}}
        {%- endfor -%}
    {{API}}_NULLABLE void* userdata1, {{API}}_NULLABLE void* userdata2) {{API}}_FUNCTION_ATTRIBUTE;

{% endfor -%}

typedef struct {{API}}ChainedStruct {
    struct {{API}}ChainedStruct * next;
    {{API}}SType sType;
} {{API}}ChainedStruct {{API}}_STRUCTURE_ATTRIBUTE;

{% for type in by_category["callback info"] %}
    typedef struct {{as_cType(type.name)}} {
        {{API}}ChainedStruct * nextInChain;
        {% for member in type.members %}
            {{as_nullability_annotated_cType(member)}};
        {% endfor %}
        {{API}}_NULLABLE void* userdata1;
        {{API}}_NULLABLE void* userdata2;
    } {{as_cType(type.name)}} {{API}}_STRUCTURE_ATTRIBUTE;

    #define {{API}}_{{type.name.SNAKE_CASE()}}_INIT _{{api}}_MAKE_INIT_STRUCT({{as_cType(type.name)}}, { \
        /*.nextInChain=*/NULL _{{api}}_COMMA \
        {% for member in type.members %}
            /*.{{as_varName(member.name)}}=*/{{render_c_default_value(member)}} _{{api}}_COMMA \
        {% endfor %}
        /*.userdata1=*/NULL _{{api}}_COMMA \
        /*.userdata2=*/NULL _{{api}}_COMMA \
    })

{% endfor -%}

{% for type in by_category["structure"] if type.name.get() not in SpecialStructures %}
    {{render_c_struct_definition(type)}}

{% endfor -%}
{% for typeDef in by_category["typedef"] %}
    // {{as_cType(typeDef.name)}} is deprecated.
    // Use {{as_cType(typeDef.type.name)}} instead.
    typedef {{as_cType(typeDef.type.name)}} {{as_cType(typeDef.name)}};

{% endfor %}
#ifdef __cplusplus
extern "C" {
#endif

#if !defined({{API}}_SKIP_PROCS)
{% if 'emscripten' in enabled_tags %}
    // TODO(374150686): Remove these Emscripten specific declarations from the
    // header once they are fully deprecated.
    {{API}}_EXPORT WGPUDevice emscripten_webgpu_get_device(void);
{% endif %}
// Global procs
{% for function in by_category["function"] %}
    typedef {{as_nullability_annotated_cType(function.returns)}} (*{{as_cProc(None, function.name)}})(
    {{- render_c_function_args(function.arguments) -}}
    ) {{API}}_FUNCTION_ATTRIBUTE;
{% endfor %}


{% for (type, methods) in c_methods_sorted_by_parent %}
    // Procs of {{type.name.CamelCase()}}
    {% for method in methods %}
        typedef {{as_nullability_annotated_cType(method.returns)}} (*{{as_cProc(type.name, method.name)}})(
        {{- render_c_method_args(type, method.arguments) -}}
        ) {{API}}_FUNCTION_ATTRIBUTE;
    {% endfor %}

{% endfor %}
#endif  // !defined({{API}}_SKIP_PROCS)

#if !defined({{API}}_SKIP_DECLARATIONS)
{% for function in by_category["function"] %}
    {{API}}_EXPORT {{as_nullability_annotated_cType(function.returns)}} {{as_cMethod(None, function.name)}}(
    {{- render_c_function_args(function.arguments) -}}
    ) {{API}}_FUNCTION_ATTRIBUTE;
{% endfor %}

{% for (type, methods) in c_methods_sorted_by_parent %}
    // Methods of {{type.name.CamelCase()}}
    {% for method in methods %}
        {{API}}_EXPORT {{as_nullability_annotated_cType(method.returns)}} {{as_cMethod(type.name, method.name)}}(
        {{- render_c_method_args(type, method.arguments) -}}
        ) {{API}}_FUNCTION_ATTRIBUTE;
    {% endfor %}

{% endfor %}
#endif  // !defined({{API}}_SKIP_DECLARATIONS)

#ifdef __cplusplus
} // extern "C"
#endif

#endif // {{metadata.api.upper()}}_H_
