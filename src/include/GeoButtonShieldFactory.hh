#ifndef __BUTTON_GeoButtonShieldFactory__
#define __BUTTON_GeoButtonShieldFactory__

#include <G4OpticalSurface.hh>
#include <G4VPhysicalVolume.hh>
#include <G4VisAttributes.hh>
#include <RAT/GeoFactory.hh>

namespace BUTTON {
class GeoButtonShieldFactory : public RAT::GeoFactory {
public:
  GeoButtonShieldFactory() : RAT::GeoFactory("buttonshield"){};
  virtual G4VPhysicalVolume *Construct(RAT::DBLinkPtr table);

protected:
  G4VisAttributes *GetVisAttributes(RAT::DBLinkPtr table);
  G4OpticalSurface *GetSurface(std::string surface_name);
};

} // namespace BUTTON

#endif
