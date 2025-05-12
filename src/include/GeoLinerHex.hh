#ifndef __BUTTON_GeoLinerHex__
#define __BUTTON_GeoLinerHex__

#include <RAT/GeoSolidFactory.hh>

namespace BUTTON {
class GeoLinerHex : public RAT::GeoSolidFactory {
public:
  GeoLinerHex() : GeoSolidFactory("Liner_hex"){};
  virtual G4VSolid *ConstructSolid(RAT::DBLinkPtr table);
};

} // namespace BUTTON

#endif
