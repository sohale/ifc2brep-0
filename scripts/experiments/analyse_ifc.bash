# A text analysis of IFC file

# normalisaiton sub-scripts
# kills hash refs in IFC as par of "normalising" it into (extracting) unique satemetns
function kill_hashrefs {
  sed 's/#\([0-9]\+\)/##/g'
}

# To remove any occurrence of 0.001 and replace it with 0.00
# function remove_numbers {
function remove_all_numbers_with_decimals {
    # sed 's/[0-9]\+\.[0-9]\+/0\.00/g'
    # sed 's/[0-9]\+\.[0-9]\{1,\}/0\.00/g'
    sed 's/[0-9]\+\(\.[0-9]*\)\{0,1\}/0\.00/g'
}

function replace_single_quoted_strings {
    sed "s/'[^']*'/'str'/g"
}

# ##=IFCRELDEFINESBYPROPERTIES('0.00ynpyqVej0.00xBVte0.00smL0.00X',##,$,$,(##),##);
# IFCRELDEFINESBYPROPERTIES = ?

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
   | replace_single_quoted_strings \
   | kill_hashrefs \
   | remove_all_numbers_with_decimals \
   |   tee temp-tee-out.txt

echo

wc -l temp-tee-out.txt

# (TBC). From 69077 lines down to 5986 lines.


cat << EXPLAIN.MD
Here it goes
EXPLAIN.MD
