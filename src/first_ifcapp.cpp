//System includes
#include <iostream>
#include <cstdlib>
/**
//IFC SDK includes
#include <OdaCommon.h> // must be first
#include <IfcExamplesCommon.h>
#include <IfcCore.h>
#include <StaticRxObject.h>
#include <RxDynamicModule.h>
#include <ExPrintConsole.h>
#include <daiHeaderSection.h>
#include <daiHeaderEntities.h>
*/

// Verify define macro definitions
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



#undef CMAKE_INTDIRT

int main(int argc, char* argv[]) {
   std::cout << "Hello.5." << std::endl;


   std::cout
   /*
   << IS_DEFINED(UNICODE) << "\n"
   << IS_DEFINED(TEIGHA_TRIAL) << "\n"
   << IS_DEFINED(ODA_LICENSING_ENABLED) << "\n"
   << IS_DEFINED(IFC_DYNAMIC_BUILD) << "\n"
   << IS_DEFINED(_TOOLKIT_IN_DLL_) << "\n"
   */
   << AA(CMAKE_INTDIR, ReleaseNot) << "\n"
   << AA(CMAKE_INTDIRT, ReleaseNot) << "\n"
   /*
   << MACRO_NAME_STR(CMAKE_INTDIR) << "\n"
   << MACRO_NAME_STR(CMAKE_INTDIRT) << "\n"
   << DEFINED_S2(CMAKE_INTDIR) << "\n"
   << DEFINED_S2(CMAKE_INTDIRT) << "\n"
   */
   ;

   return 0;
}

/**
 * Following https://docs.intellicad.org/files/oda/2021_11/oda_ifc_docs/frames.html?frmname=topic&frmfile=ifc_intro_first_app.html
 * as of 3 May 2024
 */
