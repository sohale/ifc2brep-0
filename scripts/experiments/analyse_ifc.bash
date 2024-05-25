# A text analysis of IFC file

# normalisaiton sub-scripts
# kills hash refs in IFC as par of "normalising" it into (extracting) unique satemetns
function kill_hashrefs {
  sed 's/#\([0-9]\+\)/##/g'
}

export ifcf="/home/ephemssss/novorender/ifc2brep-0/examples/novo-samples/SP-00-VA.ifc"

cat $ifcf \
   |  grep -v '=IFCCARTESIANPOINT(' \
   |  grep -v 'IFCPOLYLOOP(' \
   |  grep -v '=IFCCOLOURRGB(' \
   |  grep -v '=IFCFACEOUTERBOUND(' \
   |  grep -v '=IFCPRESENTATIONSTYLEASSIGNMENT(' \
   |  grep -v '=IFCSTYLEDITEM' \
   |  grep -v '=IFCFACE(' \
   |  grep -v 'IFCSURFACESTYLERENDERING(' \
   |  grep -v 'IFCDIRECTION(' \
   |  grep -v '=IFCAXIS2PLACEMENT2D(' \
   |  grep -v '=IFCOPENSHELL(' \
   |  grep -v '=IFCAXIS2PLACEMENT3D(' \
   |  grep -v '=IFCSURFACESTYLE(' \
   |  grep -v '=IFCEXTRUDEDAREASOLID('  \
   |  grep -v '=IFCCIRCLEPROFILEDEF(' \
   |  grep -v '=IFCSHELLBASEDSURFACEMODEL(' \
   |  grep -v 'Colour (RGB):'\
  |   tee temp-tee-out.txt  && wc -l temp-tee-out.txt

# (TBC). From 69077 lines down to 5986 lines.
