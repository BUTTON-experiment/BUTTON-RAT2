/// Adam Tarrant 4/3/25
//// A geomentry for liner allows for the input of a liner thickness along with hole to fit pmt (encapsulation)
/* Example code 
{
name: "GEO",
index: "black_sheet",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "detector_target_gb",
type: "Liner", // This is the type that selects the liner geomentry 
r_max: 1590.,
size_z: 1301.,
r_hole: 500., // Radius of the holes
liner_thickness: 1.,
pmt_table: "PMTINFO",
pmt_hole: 1,
material: "stainless_steel_304H", // need to change to liner material 
color: [0.8,0.5,0.0,0.5],
drawstyle: "solid",
invisible: 0 // omitted for visualization
}
*/


#include <CLHEP/Units/PhysicalConstants.h>
#include <CLHEP/Units/SystemOfUnits.h>

#include <G4Box.hh>
#include <G4Sphere.hh>
#include <G4SubtractionSolid.hh>
#include <G4Tubs.hh>
#include <G4UnionSolid.hh>
#include <RAT/GeoLiner.hh>
#include <RAT/PMTInfoParser.hh>
#include <RAT/ToroidalPMTConstruction.hh>
#include <vector>

namespace RAT {

G4VSolid *GeoLiner::ConstructSolid(DBLinkPtr table) {
  std::string volume_name = table->GetIndex();
  // Find mother
  std::string mother_name = table->GetS("mother");
  G4LogicalVolume *mother = FindMother(mother_name);
  G4double r_max = table->GetD("r_max") * CLHEP::mm; // radius of main plate
  G4double size_z =
      table->GetD("size_z") * CLHEP::mm; // half thickness of plate

  G4double r_hole = table->GetD("r_hole") *
                    CLHEP::mm; // radius of the holes.  If this is std::set <=
                               // zero, then use PMTs to make the holes.

  // Optional parameters
  G4double r_min = 0.0;
  try {
    r_min = table->GetD("r_min") * CLHEP::mm;
  } catch (DBNotFoundError &e) {
  };
  G4double phi_start = 0.0;
  try {
    phi_start = table->GetD("phi_start") * CLHEP::deg;
  } catch (DBNotFoundError &e) {
  };
  G4double phi_delta = CLHEP::twopi;
  try {
    phi_delta = table->GetD("phi_delta") * CLHEP::deg;
  } catch (DBNotFoundError &e) {
  };
  G4double liner_thickness = 0.1 * CLHEP::mm;
  try {
    liner_thickness = table->GetD("liner_thickness") * CLHEP::mm;
  } catch (DBNotFoundError &e) {
  };
  int pmt_bool = 1;
  try {
    pmt_bool = table->GetI("pmt_hole");
  } catch (DBNotFoundError &e) {
  };
  // end optional parms

  /// Set up the liner volume 
  
  G4VSolid *liner = new G4Tubs(volume_name, r_min, r_max, size_z, phi_start, phi_delta);
  G4VSolid *inner_liner = new G4Tubs(volume_name, r_min, r_max-liner_thickness, size_z-liner_thickness, phi_start, phi_delta);
  liner = new G4SubtractionSolid(volume_name, liner, inner_liner);

  /// Add Liners 
  if(pmt_bool==1){
  std::cout << "Encapsulation turned on" << std::endl;     
  
  // Get PMT postion and direction 
  std::string pmt_table_name = table->GetS("pmt_table");
  DBLinkPtr pmt_table = DB::Get()->GetLink(pmt_table_name);

  std::vector<double> x = pmt_table->GetDArray("x"); // get pmt postion 
  std::vector<double> y = pmt_table->GetDArray("y"); 
  std::vector<double> z = pmt_table->GetDArray("z"); 

  std::vector<double> dir_x = pmt_table->GetDArray("dir_x"); // Get pmt direction 
  std::vector<double> dir_y = pmt_table->GetDArray("dir_x"); // Get pmt direction 
  std::vector<double> dir_z = pmt_table->GetDArray("dir_x"); // Get pmt direction 

  int vector_size = x.size();

  G4RotationMatrix* rotate = new G4RotationMatrix();

  G4Sphere *encapsuation_volume = new G4Sphere(volume_name, 0.* CLHEP::mm, r_hole, phi_start, phi_delta, phi_start, phi_delta);

  for (int i = 0; i < vector_size; i++) {

    rotate->rotateX(dir_x.at(i));
    rotate->rotateY(dir_y.at(i));
    rotate->rotateZ(dir_z.at(i));

    //G4RotationMatrix pmtrot = pmt_parser.GetPMTRotation(pmtID);
    liner = new G4SubtractionSolid(volume_name, liner, encapsuation_volume, 0, G4ThreeVector(x.at(i)* CLHEP::mm,y.at(i)* CLHEP::mm,z.at(i)* CLHEP::mm));
 
   }
  }
  else{
    std::cout << "No encpasulation for you" << std::endl;
  }

  return liner;
}

} // namespace RAT
