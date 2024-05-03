//System includes
#include <iostream>
#include <cstdlib>

//IFC SDK includes
#include <OdaCommon.h> // must be first
#include <IfcExamplesCommon.h>
#include <IfcCore.h>
#include <StaticRxObject.h>
#include <RxDynamicModule.h>
#include <ExPrintConsole.h>
#include <daiHeaderSection.h>
#include <daiHeaderEntities.h>

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
#define DEFINED_AS(macroname, val) ((##macroname) == (val) ? "corretto "#macroname" = " ""#val : "non corretto " #macroname)
*/

int main(int argc, char* argv[]) {
   std::cout << "Hello.5." << std::endl;

   std::cout
   << IS_DEFINED(UNICODE) << "\n"
   << IS_DEFINED(TEIGHA_TRIAL) << "\n"
   << IS_DEFINED(ODA_LICENSING_ENABLED) << "\n"
   << IS_DEFINED(IFC_DYNAMIC_BUILD) << "\n"
   << IS_DEFINED(_TOOLKIT_IN_DLL_) << "\n"
   << DEFINED_AS(CMAKE_INTDIR,"Release") << "\n"
   ;

   return 0;
}

/**
 * Following https://docs.intellicad.org/files/oda/2021_11/oda_ifc_docs/frames.html?frmname=topic&frmfile=ifc_intro_first_app.html
 * as of 3 May 2024
 */
