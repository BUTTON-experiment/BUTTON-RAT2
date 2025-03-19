#ifndef __RAT_GeoLinerHex__
#define __RAT_GeoLinerHex__

#include <RAT/GeoSolidFactory.hh>

namespace RAT {
class GeoLinerHex : public GeoSolidFactory {
public:
  GeoLinerHex() : GeoSolidFactory("Liner_hex") {};
  virtual G4VSolid *ConstructSolid(DBLinkPtr table);
};

} // namespace RAT

#endif
