# The files in this folder need to be added to the RAT-PAC core build before remaking.  
Please note that some of these files already exist in RAT-PAC so if you wanted to keep the originals would recommend to alter their names. 
# Assuming you are in the ratpac folder:

**Place in** `src/geo`:
CMakeLists.txt

**Place in** `src/geo/src`:
GeoBuilder.cc,
GeoLiner.cc,
GeoLinerHex.cc

**Place in** `src/geo/src/pmt`:
EncapsulatedPMTConstruction.cc,
PMTConstruction.cc,
PMTFactory.cc

**Place in** `src/geo/include/RAT`:
EncapsulatedPMTConstruction.hh,
GeoLiner.hh,
GeoLinerHex.hh

Once in place simply run `make`

