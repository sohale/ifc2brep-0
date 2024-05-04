// macro_toys.hpp
#ifndef MACROTOYS_HPP
#define MACROTOYS_HPP

#include <string>

// some experimental macro definition helpers
// to Verify define macro definitions
// to Verify define macro definitions
// macro/definition verification toys/macros/definitions

// macro_toys.hpp macro_verificaiton_toys.hpp definition_verificaiton_macros.hpp

/*
#define STRINGIFY(x) #x
#define DEFVAL_HELPER(x) DEFVAL_##x
#define DEFVAL_COMPARE(macroname, val) DEFVAL_HELPER(macroname) == (val) ? "corretto "macroname" = " "##val" : "non corretto (##macroname)"
*/
/*
#define DEFVAL_HELPER(x) DEFVAL_##x
#define DEFVAL_COMPARE(macroname, val) ((DEFVAL_HELPER(macroname)) == (val) ? "corretto "#macroname" = " ""#val : "non corretto " #macroname)
*/
/*
// verifying define macros
#define IS_DEFINED(x) DEFVAL_##x
#define IS_DEFINED(x) do{ #ifdef ; true ; #else; false #endif } while0;
#define DEFINED_AS(macroname, val) ((##macroname) == (val) ? "corretto "#macroname" = " ""#val : "non corretto " #macroname)
*/

/*
#define DEFINED_AS_HELPER(macroname, val, truestr, falsestr) ((macroname) == (val) ? truestr : falsestr)
#define DEFINED_AS(macroname, val) DEFINED_AS_HELPER(macroname, val, "correct " #macroname " = " #val, "incorrect " #macroname)
*/
/*
#define MACRO_NAME_STR(macroname) (" " #macroname " ")

// Returns "CMAKE_INTDIR", as a literal tring, regardless of whether it is defined
#define MACRO_NAME_STR(macroname) ( #macroname )

// `#macroname` -> the macro name given as macroname, with expanding
// `##macroname` -> the macro name given as macroname, without expanding
#define DEFINED_AS(macroname, val) MACRO_NAME_STR(#macroname)
#define DEFINED_S2(macroname) MACRO_NAME_STR(#macroname)
*/

/*
// CMAKE_INTDIR
#define AA(macroname, barevalue) ((#macroname) )

// invalid literal suffix: operator ""Release
// #define AA(macroname, barevalue) (#macroname ":" ##barevalue )

*/

/*
// #define AA(macroname, barevalue) #macroname ":" << ##macroname << #barevalue
//  " 'Release': undeclared identifier"
// #define AA(macroname, barevalue) #macroname ":" << #barevalue << ##macroname
#define ANYTHING_TOSTR(token) ( #token )
#define AA(macroname, barevalue) #macroname ":" << #barevalue << ANYTHING_TOSTR(##macroname)
*/


#define ANYTHING_TOSTR(token) (#token)
#define STRINGIZE(x) #x
#define TOSTRING(x) STRINGIZE(x)
#define AA(macroname, barevalue) #macroname << ": " << TOSTRING(macroname) << " " << ANYTHING_TOSTR(barevalue)




// PRINT_MACRO_VALUE_OR_DEFAULT
// Define a helper macro that will expand to itself when x is undefined
#define UNDEFINED_IDENTIFIER_HELPER(x) UNDEFINED_IDENTIFIER_HELPER_IMPL(x)
#define UNDEFINED_IDENTIFIER_HELPER_IMPL(x) x

// Check if a macro is defined
#define IS_DEFINED(x) _IS_DEFINED(x)
#define _IS_DEFINED(x) IS_DEFINED_HELPER1(IS_DEFINED_HELPER2(x))
#define IS_DEFINED_HELPER2(x) #x
#define IS_DEFINED_HELPER1(contents) (0 contents[] == 'u')

// Print the value or "UNDEFINED_LALA" if undefined
#define PRINT_MACRO_VALUE_OR_DEFAULT(x, default_value) \
    (IS_DEFINED(UNDEFINED_IDENTIFIER_HELPER(x)) ? TOSTRING(x) : TOSTRING(default_value))

// Stringize macros
#define STRINGIZE(x) #x
#define TOSTRING(x) STRINGIZE(x)

// Main macro for printing values
#define BB(macroname, barevalue) \
    STRINGIZE(macroname) << ": " << PRINT_MACRO_VALUE_OR_DEFAULT(macroname, UNDEFINED_LALA) << " " << STRINGIZE(barevalue)


// Internal helper macros


// Helper macros for stringizing
#define __MACROTOYS__STRINGIZE(x) #x
#define __MACROTOYS__TOSTRING(x) __MACROTOYS__STRINGIZE(x)

#define __MACROTOYS__UNDEFINED_IDENTIFIER_HELPER(x) __MACROTOYS__UNDEFINED_IDENTIFIER_HELPER_IMPL(x)
#define __MACROTOYS__UNDEFINED_IDENTIFIER_HELPER_IMPL(x) x

#define __MACROTOYS__IS_DEFINED(x) __MACROTOYS__IS_DEFINED_HELPER1(__MACROTOYS__IS_DEFINED_HELPER2(x))
#define __MACROTOYS__IS_DEFINED_HELPER2(x) #x
#define __MACROTOYS__IS_DEFINED_HELPER1(contents) (0 contents[] == 'u')

// User-faced public macros

// older solution
#define MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(x, default_value) \
    (__MACROTOYS__IS_DEFINED(__MACROTOYS__UNDEFINED_IDENTIFIER_HELPER(x)) ? __MACROTOYS__TOSTRING(x) : __MACROTOYS__TOSTRING(default_value))


/*
#define MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(x, default_value) \
    (std::string((__MACROTOYS__IS_DEFINED(x)) ? __MACROTOYS__TOSTRING(x) : __MACROTOYS__TOSTRING(default_value)))
*/

#define MACROTOYS_MACRONAME(token) __MACROTOYS__STRINGIZE(token)

// two more exported utilities:
// (use std::string)
#define MACROTOYS_IS_MACRO_DEFINED(x) (__MACROTOYS__IS_DEFINED(__MACROTOYS__UNDEFINED_IDENTIFIER_HELPER(x)) ? true : false)



// Assert macro value

/*
#define MACROTOYS_ASSERT_MACRO_VALUE(macro, value) \
    static_assert(__MACROTOYS__TOSTRING(macro) == std::string(__MACROTOYS__TOSTRING(value)), #macro " must be set to " #value)
*/

// Compile-time string comparison function (recursive)
constexpr bool __MACROTOYS__compare_strings(const char* a, const char* b) {
    return *a == *b && (*a == '\0' || __MACROTOYS__compare_strings(a + 1, b + 1));
}

#define MACROTOYS_ASSERT_MACRO_VALUE(macro, value) \
    static_assert(__MACROTOYS__compare_strings(__MACROTOYS__TOSTRING(macro), __MACROTOYS__TOSTRING(value)), \
                  #macro " must be set to " #value)


/*

   #define CMAKE_INTDIR Release
   #undef CMAKE_INTDIRT

    std::cout
    << MACROTOYS_MACRONAME(CMAKE_INTDIR) << ": "
    << MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(CMAKE_INTDIR, UNDEFINED_LALA) << " "
    << MACROTOYS_MACRONAME(ReleaseNot)
    << "\n"

    << MACROTOYS_MACRONAME(CMAKE_INTDIRT) << ": "
    << MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(CMAKE_INTDIRT, UNDEFINED_LALA) << " "
    << MACROTOYS_MACRONAME(ReleaseNot)
    << "\n";

*/


/*
#define MACROTOYS_ENSURE_MACRO_DEFINED(x) \
    #ifdef x \
    static_assert(true, #x " is defined."); \
    #else \
    static_assert(false, #x " is not defined."); \
    #endif


#define MACROTOYS_ENSURE_MACRO_DEFINED2(x) \
    #ifdef x \
    "GULA" \
    #else \
    "GILU" \
    #endif
*/
/*
// This macro can be used to generate a static assertion based on whether a macro is defined
#define MACROTOYS_ENSURE_MACRO_DEFINED(x) \
    static_assert(MACROTOYS_CHECK_IF_DEFINED_HELPER(x), #x " must be defined.")

// Helper to determine if a macro is defined
#define MACROTOYS_CHECK_IF_DEFINED_HELPER(x) (sizeof(#x) && 0)
*/

/*
// Define a fallback for when a macro is not defined
#define MACROTOYS_UNDEFINED 0

// Helper to provide a value based on whether a macro is defined or not
#define MACROTOYS_MACRO_CHECKER(x, ...) MACROTOYS_MACRO_CHECKER_N(__VA_ARGS__, MACROTOYS_UNDEFINED)
#define MACROTOYS_MACRO_CHECKER_N(a, b, ...) b

// Actual checking macro
#define MACROTOYS_ENSURE_MACRO_DEFINED(x) \
    static_assert(MACROTOYS_MACRO_CHECKER(x, 1), #x " must be defined.")

*/

/*

// Define a helper macro that resolves to true if another macro is defined, false otherwise
#define MACRO_IS_DEFINED_HELPER(x, y) _MACRO_IS_DEFINED_HELPER_1(_MACRO_IS_DEFINED_HELPER_2(x, y))
#define _MACRO_IS_DEFINED_HELPER_2(x, y) _MACRO_IS_DEFINED_HELPER_3(_##x##_IS_DEFINED_##y)
#define _MACRO_IS_DEFINED_HELPER_3(x) _MACRO_IS_DEFINED_HELPER_4(x)
#define _MACRO_IS_DEFINED_HELPER_4(x) #x

#define MACRO_IS_DEFINED(x) (_MACRO_IS_DEFINED_HELPER_1(MACRO_IS_DEFINED_HELPER(x, UNIQUE)) != #x)

#define MACROTOYS_ENSURE_MACRO_DEFINED(x) \
    static_assert(MACRO_IS_DEFINED(x), #x " must be defined.")

*/

/*
// Helper macro definitions to check if a macro is defined
#define MACRO_DEFINED 1
#define MACRO_NOT_DEFINED 0

// Define another macro that checks if the target macro is defined
// and then uses static_assert to ensure it's defined
#define MACROTOYS_ENSURE_MACRO_DEFINED(x) \
    static_assert(MACRO_IS_DEFINED_##x, #x " must be defined.")
*/

#endif // MACROTOYS_HPP
