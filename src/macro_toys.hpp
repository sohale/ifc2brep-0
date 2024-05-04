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
#define __MACROTOYS__STRINGIZE(x) #x
#define __MACROTOYS__TOSTRING(x) __MACROTOYS__STRINGIZE(x)

#define __MACROTOYS__UNDEFINED_IDENTIFIER_HELPER(x) __MACROTOYS__UNDEFINED_IDENTIFIER_HELPER_IMPL(x)
#define __MACROTOYS__UNDEFINED_IDENTIFIER_HELPER_IMPL(x) x

#define __MACROTOYS__IS_DEFINED(x) __MACROTOYS__IS_DEFINED_HELPER1(__MACROTOYS__IS_DEFINED_HELPER2(x))
#define __MACROTOYS__IS_DEFINED_HELPER2(x) #x
#define __MACROTOYS__IS_DEFINED_HELPER1(contents) (0 contents[] == 'u')

// Public macros
#define MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(x, default_value) \
    (__MACROTOYS__IS_DEFINED(__MACROTOYS__UNDEFINED_IDENTIFIER_HELPER(x)) ? __MACROTOYS__TOSTRING(x) : __MACROTOYS__TOSTRING(default_value))

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


#endif // MACROTOYS_HPP
