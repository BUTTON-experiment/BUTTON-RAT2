#ifndef __BUTTON_GeoLiner__
#define __BUTTON_GeoLiner__

#include <RAT/GeoSolidFactory.hh>

namespace BUTTON {
class GeoLiner : public RAT::GeoSolidFactory {
public:
  GeoLiner() : GeoSolidFactory("Liner") {};
  virtual G4VSolid *ConstructSolid(RAT::DBLinkPtr table);
};

} // namespace BUTTON 

#endif
