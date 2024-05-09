//System includes
#include <iostream>
#include <cstdlib>

#undef ODA_LICENSING_ENABLED


//IFC SDK includes
#include <OdaCommon.h> // must be first
#include <IfcCore.h>
#include <IfcModel.h>

#include <IfcExamplesCommon.h>

#include <StaticRxObject.h>
#include <RxDynamicModule.h>
#include <ExPrintConsole.h>
#include <daiHeaderSection.h>
#include <daiHeaderEntities.h>


#include "./macro_toys.hpp"

#if CMAKE_INTDIR != Release
   #error "CMAKE_INTDIR should be Release"
#endif


#if 0 \
    || !defined(UNICODE) \
    || !defined(TEIGHA_TRIAL) \
    || defined(ODA_LICENSING_ENABLED) \
    || !defined(IFC_DYNAMIC_BUILD) \
    || !defined(_TOOLKIT_IN_DLL_)

   #error Some necessary macros not defined"

#endif

int main(int argc, char* argv[]) {
   std::cout << "Hello.5." << std::endl;

   /*
   #define CMAKE_INTDIR Release

   MACROTOYS_ENSURE_MACRO_DEFINED(CMAKE_INTDIR);

   MACROTOYS_ENSURE_MACRO_DEFINED(CMAKE_INTDIR);
   */


   // causes no static assert error
   MACROTOYS_ASSERT_MACRO_VALUE(CMAKE_INTDIR, Release);
   // causes a static assert error
   // MACROTOYS_ASSERT_MACRO_VALUE(CMAKE_INTDIR, Debug);

   std::cout
   /*
   << IS_DEFINED(UNICODE) << "\n"
   << IS_DEFINED(TEIGHA_TRIAL) << "\n"
   << IS_DEFINED(ODA_LICENSING_ENABLED) << "\n"
   << IS_DEFINED(IFC_DYNAMIC_BUILD) << "\n"
   << IS_DEFINED(_TOOLKIT_IN_DLL_) << "\n"
   */
   << "hi"
   // << MACROTOYS_ENSURE_MACRO_DEFINED2(CMAKE_INTDIR)
   // << std::string(MACROTOYS_MACRONAME(CMAKE_INTDIR)) << ": "
   // << std::string(MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(CMAKE_INTDIR, "UNDEFINED_LALA")) << " "
   // << MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(CMAKE_INTDIR, "UNDEFINED_LALA")
   // << " "
   // << MACROTOYS_MACRONAME(ReleaseNot) << "\n"
   // << MACROTOYS_MACRONAME(CMAKE_INTDIRT) << ": " << MACROTOYS_PRINT_MACRO_VALUE_OR_DEFAULT(CMAKE_INTDIRT, "UNDEFINED_LALA") << " " << MACROTOYS_MACRONAME(ReleaseNot) << "\n";

   /*
   << MACRO_NAME_STR(CMAKE_INTDIR) << "\n"
   << MACRO_NAME_STR(CMAKE_INTDIRT) << "\n"
   << DEFINED_S2(CMAKE_INTDIR) << "\n"
   << DEFINED_S2(CMAKE_INTDIRT) << "\n"
   */
   ;

   // Common ODA IFC SDK initialization part
   OdStaticRxObject<MyServices> svcs;
   odrxInitialize(&svcs);
   odIfcInitialize(false /* No CDA */, false /* No geometry calculation needed */);

   // SDAI calls can be performed just after common initialization procedure
   SdaiSession session = sdaiOpenSession();
   SdaiRep repo = _sdaiCreateRepositoryFromFile(session, "c:\\file.ifcXML", "");
   SdaiRep repoOpened = sdaiOpenRepositoryBN(session, "c:\\file.ifcXML");
   SdaiModel modelRO = sdaiAccessModelBN(repoOpened, "default", sdaiRO);
   SdaiSet cartesianPoints = sdaiGetEntityExtentBN(modelRO, "IfcCartesianPoint");
   SdaiIterator it = sdaiCreateIterator(cartesianPoints);
   for (sdaiBeginning(it); sdaiNext(it);)
   {
      SdaiAppInstance inst = nullptr;
      sdaiGetAggrByIterator(it, sdaiINSTANCE, &inst);
      // ...
   }
   sdaiDeleteIterator(it);
   sdaiCloseSession(session);

   // Common ODA IFC SDK uninitialization part
   odIfcUninitialize();
   odrxUninitialize();

   /*
   // Initialize ODA IFC SDK
   odIfcInitialize();
   // Uninitialize the SDK
   odIfcUninitialize();
   */

   return 0;
}

/**
 * Following https://docs.intellicad.org/files/oda/2021_11/oda_ifc_docs/frames.html?frmname=topic&frmfile=ifc_intro_first_app.html
 * as of 3 May 2024
 */
