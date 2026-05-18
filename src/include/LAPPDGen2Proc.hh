#ifndef __LAPPDGEN2PROC__
#define __LAPPDGEN2PROC__

#include <RAT/Processor.hh>

namespace RAT {

class LAPPDGen2Proc : public Processor {
public:
  LAPPDGen2Proc();
  virtual ~LAPPDGen2Proc() {}

  virtual Processor::Result DSEvent(DS::Root *ds);

protected:
  // LAPPD preamters
  double fPCtoMCP1;
  double fMCP2toAnode;
  double fBackPlateD;
  double fBackPlateEps;
  double fSigmaPrompt;
  double fBackscatterProb;
  double fZeff;

  // Grid parameters
  int fNumPads;
  double fPadSize;
};

} // namespace RAT

#endif