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
   std::cout << "\n\n" << std::endl;

   std::cout << "Part1: Start\n\n" << std::endl;


   // .ifcXML ??
   auto filename_ifc = "./examples/novo-samples/SP-00-VA.ifc";

   // involves contents: (nested in this IFC file)
   // inside SP-00-VA.ifc
   auto _repository_name = "";
   auto _entity_name = "IfcCartesianPoint";
   // non-const implies change-of-mind
   // _entity_name = "IFCPROPERTYSINGLEVALUE";

   // Common ODA IFC SDK initialization part
   OdStaticRxObject<MyServices> svcs;
   odrxInitialize(&svcs);
   odIfcInitialize(false /* No CDA */, false /* No geometry calculation needed */);

   // SDAI calls can be performed just after common initialization procedure
   SdaiSession session = sdaiOpenSession();
   SdaiRep repo = _sdaiCreateRepositoryFromFile(session, filename_ifc, _repository_name);
   SdaiRep repoOpened = sdaiOpenRepositoryBN(session, filename_ifc);
   SdaiModel modelRO = sdaiAccessModelBN(repoOpened, "default", sdaiRO);

   if (false) {
   // "entity instance"s
   SdaiSet cartesianPoints = sdaiGetEntityExtentBN(modelRO, _entity_name);
   SdaiIterator it = sdaiCreateIterator(cartesianPoints);
   int counter = 0;
   for (sdaiBeginning(it); sdaiNext(it);)
   {
      SdaiAppInstance inst = nullptr;
      sdaiGetAggrByIterator(it, sdaiINSTANCE, &inst);
      // ...
      counter++;
      if (counter % 1000 == 0 || counter < 50){
         std::cout << "iteration " << counter;
         std::cout << std::endl;
      }
   }
   // iterations=24920 !
   std::cout << "iterations=" << counter << std::endl;
   sdaiDeleteIterator(it);
   std::cout << "Part1: End" << std::endl;
   }

  // sdaiGetEntityExtentBN

  if (true) {
    using std::endl;  // keep it local. Keep your conveniences contained.
    using std::cout;
    cout << "Part2: Start" << endl;

    // _entity_name = "IfcCylinder";
    // Search for all instances of IfcExtrudedAreaSolid
    auto _entity_name = "IfcExtrudedAreaSolid";
    SdaiSet extrusions = sdaiGetEntityExtentBN(modelRO, _entity_name);
    SdaiIterator extrusionIt = sdaiCreateIterator(extrusions);

    int counter = 0;
    while (sdaiNext(extrusionIt)) {
        cout << "iter " << endl;

        SdaiAppInstance extrusion = nullptr;
        sdaiGetAggrByIterator(extrusionIt, sdaiINSTANCE, &extrusion);
        cout << "bi1" << endl;

        // Get the profile defining the extrusion
        SdaiAppInstance profile;
        cout << "profile1" << endl;

        sdaiGetAttrBN(extrusion, "SweptArea", sdaiINSTANCE, &profile);
        cout << "SweptArea" << endl;

        // Check if the profile is a circle (which would make it a cylinder)
        char* profileType = nullptr;
        cout << "profile2" << endl;

        cout << "Will crash here: SDAI Error: sdaiAT_NDEF (290): Attribute not defined" << endl;

        exit(1);
        sdaiGetAttrBN(profile, "entityName", sdaiSTRING, &profileType);
        // SDAI Error: sdaiAT_NDEF (290): Attribute not defined
        cout << "sdaiGetAttrBN(1)" << endl;
        if (strcmp(profileType, "IfcCircle") == 0) {
            cout << "sdaiGetAttrBN(1)" << endl;

            cout << "Cylinder found with profile: IfcCircle" << endl;
            // Extract and handle cylinder dimensions, position, etc.
        }
        cout << "post-if" << endl;

      counter++;
      if (true || counter % 10 == 0 || counter < 50){
         cout << "iteration_b " << counter;
         cout << endl;
      }
    }
    sdaiDeleteIterator(extrusionIt);
    std::cout << "Part2: End" << endl;

  };






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
