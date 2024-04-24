# ifc2brep-0
PoC for an IFC to BREP converter for BIM  in C++ (3D, BIM, cli)

### Features (provisional):
* Is a CLI application `ifc2brep-0`, written in C++.
* It uses IFC [SDK](https://www.opendesign.com/products/ifc-sdk).
* The BREP files are in Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts).
* It converts "cylinders", "circular arcs", etc [TBC]
* IFC is partially implemented in the PoC: "cylinders" and "circular arcs", enough to convert certain sample files.

### Sponsor
Sponsored by **Novorender** "*The World`s Most Powerful Digital Twin & BIM Platform*"
* Novorender: [novorender.com](https://novorender.com/) ([on linkedin](https://www.linkedin.com/company/novorender/about/)) `013cbab0ccd3c7fd21`
* Sample files are kindly provided by RISA Norway: [risa.no](https://risa.no)

### Technical Details
#### IFC SDK:
* Uses IFC [SDK](https://www.opendesign.com/products/ifc-sdk)
* IFC SDK includes a viewer.

#### The Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts):
* The BREP files will be in Novorender JSON [format](https://github.com/novorender/ts/blob/main/measure/worker/brep.ts). 
* IFC `id`s are used as filenames
