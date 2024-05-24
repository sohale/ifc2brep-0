
Learnings:

* BCF (BIM Collaboration Format)
allows the addition of textual comments, screenshots, and more on top of IFC files without altering the actual IFC file itself.
* BCF is used widely in BIM projects
* to facilitate communication and issue tracking among architects, engineers, project managers, etc.
* links objects in a BIM model to discussions and issues directly

* Use of Wine (...)
* Activation (...)

* What is a  `.tx` module?
    * It is related to "Teigha"
    * `.tx` files are modules.
    * Only needed in run-time.
    * Can put it in the PATH
    * inside wine (windows)


### C++ code
* "How to initialize ODA IFC SDK for using SDAI API"
https://www.opendesign.com/faq/question/how-initialize-oda-ifc-sdk-using-sdai-api

* compilter flags issue:
Make compile use Dynamic Runtime Linking. Since dependencies are using that.
`/MT` Static Linking
`/MD` Use the DLL version of the runtime library

* Standard library:
   * `MSVCRT`: is needed (don't `/NODEFAULTLIB` the `MSVCRT`)
   * `libucrt.lib`: should not be linked (use: `/NODEFAULTLIB:libucrt.lib`)

### IFC concept & file format
In IFC, in general:
* Two primary types of entries: geometric representations and property assignments

IFC Format: refs are `#1342`

* "Revit IFC" (Sometimes misattriuted ti Revit)
"Autodesk Revit 2023"

### Task
Inputs:
* An IFC file
* The two objects in question consist of mostly **cylinders** and **circular arcs**, so you can disregard any other type of primitives to keep things simple.


Target of conversion (output):
* The task is to reproduce two json files using the BREP modeler of the IFC SDK in a C++ CLI application.
* Use their respective "IFC ids" as filenames for json files.

* Sponsored by Novorener.
* Ownership: The code will belong to you (`@sohale`)
* IFC file is provided by https://risa.no

### IFC proimitives & details

* IFCEXTRUDEDAREASOLID
* IfcProfileDef


<!-- ### Befre 24 May 2024:-->

* My approach:
https://github.com/sohale/ifc2brep-0/blob/main/src/first_ifcapp.cpp#L158

My approach in IFC:
Exploring the IFC file:

In search of "cycliners" and "circular arcs" to convert:

Finding the right component using `grep`:
```bash
cat $ifcf |grep -v '=IFCCARTESIANPOINT(' | grep -v 'IFCPOLYLOOP(' | grep -v '=IFCCOLOURRGB(' | grep -v '=IFCFACEOUTERBOUND(' | grep -v '=IFCPRESENTATIONSTYLEASSIGNMENT(' | grep -v '=IFCSTYLEDITEM' | grep -v '=IFCFACE(' | grep -v 'IFCSURFACESTYLERENDERING(' | grep -v 'IFCDIRECTION(' | grep -v '=IFCAXIS2PLACEMENT2D(' | grep -v '=IFCOPENSHELL(' | grep -v '=IFCAXIS2PLACEMENT3D(' | grep -v '=IFCSURFACESTYLE(' | grep -v '=IFCEXTRUDEDAREASOLID('  | grep -v '=IFCCIRCLEPROFILEDEF(' | grep -v '=IFCSHELLBASEDSURFACEMODEL(' | grep -v 'Colour (RGB):'|  tee temp-tee-out.txt  && wc -l temp-tee-out.txt
```
(TBC). From 69077 lines down to 5986 lines.


Notable structures found:
* `IFCOPENSHELL` IFC.OPEN.SHELL (IFC:: SHELL: OPEN)
* `IFCEXTRUDEDAREASOLID` IFC.EXTRUDED.AREA.SOLID   (IFC:: "EXTRUDED AREA": SOLID)
* `IFCCURVESTYLE` IFC.CURVE.STYLE
* `IFCCIRCLEPROFILEDEF` IFC.CIRCLE.PROFILE.DEF
* `IFCSHELLBASEDSURFACEMODEL` IFC.SHELL-BASED.SURFACE.MODEL (many points / args)
* `IFCAXIS2PLACEMENT2D` IFC.AXIS2.PLACEMENT.2D
* `IFCAXIS2PLACEMENT3D` IFC.AXIS2.PLACEMENT.3D

* `IFCDIRECTION`
* `IFCSURFACESTYLE`

* `IFCSHELLBASEDSURFACEMODEL`


### After 24 May 2024:

IFC: Ref arguments are added by each inheritance.

Approach:
* Can havbe multiple approaches: low-level, high-level.
* May primitives
* Use hight-level
* User (Certain) examples
    * For a ready loop
    * The [vc16/Ifc/Examples/ExIfcDump/ExIfcDump.cpp](/home/ephemssss/novorender/oda-sdk/vc16/Ifc/Examples/ExIfcDump/ExIfcDump.cpp)#L265
* You can `cast()`
    * which is between FC versions
    * provides a more unified and portable approach
    * Someitmes converta geometric as well
