# ifc2brep-0
PoC for an IFC to BREP converter for BIM  in C++ (3D, BIM, cli)

### Features:
* It uses IFC [SDK](https://www.opendesign.com/products/ifc-sdk).
* The BREP files will be in Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts).
* It converts ...
* Is a CLI application written in C++.
* IFC is partially implemented in the PoC: "cylinders" and "circular arcs", enough to convert certain sample files.

### Spondor: Novorender
Novorender. Tagline: *The World`s Most Powerful Digital Twin & BIM Platform*
* [novorender.com](https://novorender.com/)](https://novorender.com/)
* [Linkedin:novorender](https://www.linkedin.com/company/novorender/about/)
 
* Sample files are kindly provided by RISA: [risa.no](https://risa.no)

### Details
### IFC SDK:
Uses IFC [SDK](https://www.opendesign.com/products/ifc-sdk)

### The Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts):
The BREP files will be in Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts).
 
* IFC SDK includes a SDK viewer.
* IFC `id`s are used as filenames
