#!/bin/bash
# A text analysis of IFC file
# A neat IFC analysis bash script (IFC normaliser)

set -eu

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

# temp-tee-out.txt
TEMPFILE=$(mktemp ____tempXXXX)


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
   |sort | uniq \
   |   tee $TEMPFILE \
;

sleep 1

echo "ok"

wc -l $TEMPFILE
wc -l $ifcf
# (TBC). From 69077 lines down to 5986 lines.

# rm $TEMPFILE

# batcat || sudo apt install bat

echo "The result of analysis"
cat << 'EXPLAIN.MD' | batcat  #> explanation.md
    #!/usr/bin/env batcat
    The result of analysis:
```txt
    sdfsd
    ##=IFCAPPLICATION(##,'str','str','str');
    ##=IFCAXIS0.00PLACEMENT(##,##);
    ##=IFCBUILDINGELEMENTPROXY('str',##,$,$,$,##,$,$,$);
    ##=IFCBUILDINGELEMENTPROXY('str',##,'str',$,'str',##,##,$,$);
    ##=IFCBUILDINGELEMENTPROXY('str',##,'str',$,'str',##,$,$,$);
    ##=IFCCARTESIANTRANSFORMATIONOPERATOR0.00D($,$,##,0.00,$);
    ##=IFCCIRCLEHOLLOWPROFILEDEF(.AREA.,$,##,0.00,0.00);
    ##=IFCCONVERSIONBASEDUNIT(##,.PLANEANGLEUNIT.,'str',##);
    ##=IFCDERIVEDUNIT((##,##),.VOLUMETRICFLOWRATEUNIT.,$);
    ##=IFCDERIVEDUNIT((##,##,##),.THERMALTRANSMITTANCEUNIT.,$);
    ##=IFCDERIVEDUNITELEMENT(##,-0.00);
    ##=IFCDERIVEDUNITELEMENT(##,0.00);
    ##=IFCDIMENSIONALEXPONENTS(0.00,0.00,0.00,0.00,0.00,0.00,0.00);
    ##=IFCGEOMETRICREPRESENTATIONCONTEXT($,'str',0.00,0.00E-0.00,##,$);
    ##=IFCGEOMETRICREPRESENTATIONSUBCONTEXT('str','str',*,*,*,*,##,$,.MODEL_VIEW.,$);
    ##=IFCGROUP('str',##,'str',$,$);
    ##=IFCLOCALPLACEMENT(##,##);
    ##=IFCLOCALPLACEMENT($,##);
    ##=IFCMAPPEDITEM(##,##);
    ##=IFCMEASUREWITHUNIT(IFCPLANEANGLEMEASURE(0.00),##);
    ##=IFCORGANIZATION($,'str',$,$,$);
    ##=IFCOWNERHISTORY(##,##,$,.NOCHANGE.,$,$,$,0.00);
    ##=IFCPERSON($,'str',$,$,$,$,$,$);
    ##=IFCPERSONANDORGANIZATION(##,##,$);
    ##=IFCPRESENTATIONLAYERASSIGNMENT('str',$,(##,##,##,##,##,##),$);
    ##=IFCPRESENTATIONLAYERASSIGNMENT('str',$,(##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##),$);
    ##=IFCPRODUCTDEFINITIONSHAPE($,$,(##));
    ##=IFCPROJECT('str',##,'str','str',$,'str',$,(##),##);
    ##=IFCPROPERTYSET('str',##,'str','str',(##));
    ##=IFCPROPERTYSET('str',##,'str','str',(##,##));
    ##=IFCPROPERTYSET('str',##,'str','str',(##,##,##));
    ##=IFCPROPERTYSET('str',##,'str','str',(##,##,##,##));
    ##=IFCPROPERTYSET('str',##,'str','str',(##,##,##,##,##,##,##));
    ##=IFCPROPERTYSET('str',##,'str','str',(##,##,##,##,##,##,##,##));
    ##=IFCPROPERTYSET('str',##,'str','str',());
    ##=IFCPROPERTYSINGLEVALUE('str',$,IFCTEXT('str'),$);
    ##=IFCRELAGGREGATES('str',##,$,$,##,(##));
    ##=IFCRELASSIGNSTOGROUP('str',##,$,$,(##),$,##);
    ##=IFCRELASSIGNSTOGROUP('str',##,$,$,(##,##,##,##,##),$,##);
    ##=IFCRELASSIGNSTOGROUP('str',##,$,$,(##,##,##,##,##,##,##,##,##,##,##,##,##),$,##);
    ##=IFCRELASSIGNSTOGROUP('str',##,$,$,(##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##),$,##);
    ##=IFCRELASSIGNSTOGROUP('str',##,$,$,(##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##),$,##);
    ##=IFCRELASSIGNSTOGROUP('str',##,$,$,(##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##),$,##);
    ##=IFCRELCONTAINEDINSPATIALSTRUCTURE('str',##,$,$,(##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##),##);
    ##=IFCRELDEFINESBYPROPERTIES('str',##,$,$,(##),##);
    ##=IFCREPRESENTATIONMAP(##,##);
    ##=IFCREVOLVEDAREASOLID(##,##,##,0.00);
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##,##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##,##,##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##,##,##,##,##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##,##,##,##,##,##,##,##,##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##,##,##,##,##,##,##,##,##,##,##,##,##));
    ##=IFCSHAPEREPRESENTATION(##,'str','str',(##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##));
    ##=IFCSITE('str',##,'str',$,$,##,$,$,.ELEMENT.,$,$,$,'str',$);
    ##=IFCSIUNIT(*,.AREAUNIT.,$,.SQUARE_METRE.);
    ##=IFCSIUNIT(*,.ELECTRICCURRENTUNIT.,$,.AMPERE.);
    ##=IFCSIUNIT(*,.ELECTRICRESISTANCEUNIT.,$,.OHM.);
    ##=IFCSIUNIT(*,.ELECTRICVOLTAGEUNIT.,$,.VOLT.);
    ##=IFCSIUNIT(*,.FREQUENCYUNIT.,$,.HERTZ.);
    ##=IFCSIUNIT(*,.ILLUMINANCEUNIT.,$,.LUX.);
    ##=IFCSIUNIT(*,.LENGTHUNIT.,$,.METRE.);
    ##=IFCSIUNIT(*,.LUMINOUSFLUXUNIT.,$,.LUMEN.);
    ##=IFCSIUNIT(*,.MASSUNIT.,$,.GRAM.);
    ##=IFCSIUNIT(*,.PLANEANGLEUNIT.,$,.RADIAN.);
    ##=IFCSIUNIT(*,.POWERUNIT.,$,.WATT.);
    ##=IFCSIUNIT(*,.PRESSUREUNIT.,$,.PASCAL.);
    ##=IFCSIUNIT(*,.SOLIDANGLEUNIT.,$,.STERADIAN.);
    ##=IFCSIUNIT(*,.THERMODYNAMICTEMPERATUREUNIT.,$,.DEGREE_CELSIUS.);
    ##=IFCSIUNIT(*,.THERMODYNAMICTEMPERATUREUNIT.,$,.KELVIN.);
    ##=IFCSIUNIT(*,.TIMEUNIT.,$,.SECOND.);
    ##=IFCSIUNIT(*,.VOLUMEUNIT.,$,.CUBIC_METRE.);
    ##=IFCUNITASSIGNMENT((##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##,##));
    DATA;
    END-ISO-0.00-0.00;
    ENDSEC;
    FILE_DESCRIPTION(('str'),'str');
    FILE_NAME('str','str',('str'),('str'),'str','str','str');
    FILE_SCHEMA(('str'));
    HEADER;
    ISO-0.00-0.00;
```
EXPLAIN.MD

echo "B"
