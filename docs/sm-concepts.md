
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
