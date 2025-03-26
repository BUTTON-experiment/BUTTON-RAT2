# The files in this folder need to be added to the RAT-PAC core build before remaking.  
Please note that some of these files already exist in RAT-PAC so if you wanted to keep the originals would recommend to alter their names. 
# Assuming you are in the ratpac folder:

**Place in** `src/geo`:
CMakeLists.txt

**Place in** `src/geo/src`:
GeoBuilder.cc (This should be the same as the original, so if its not been been modified can skip)  

**Place in** `src/geo/src/pmt`:
EncapsulatedPMTConstruction.cc,
PMTConstruction.cc,
PMTFactory.cc

**Place in** `src/geo/include/RAT`:
EncapsulatedPMTConstruction.hh,

Once in place simply run `make`  

The liner files are no longer part of the rat-pac core, they have been moved to `BUTTON-RAT2/src`.

