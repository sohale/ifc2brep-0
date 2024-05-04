
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


