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

#include "./macro_toys.hpp"
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
