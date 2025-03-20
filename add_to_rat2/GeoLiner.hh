#ifndef __RAT_GeoLiner__
#define __RAT_GeoLiner__

#include <RAT/GeoSolidFactory.hh>

namespace RAT {
class GeoLiner : public GeoSolidFactory {
public:
  GeoLiner() : GeoSolidFactory("Liner") {};
  virtual G4VSolid *ConstructSolid(DBLinkPtr table);
};

} // namespace RAT

#endif
