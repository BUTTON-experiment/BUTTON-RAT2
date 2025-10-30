#include <BonsaiProc.hh>
#include <Button.hh>
#include <ButtonDAQProc.hh>
#include <GeoLiner.hh>
#include <GeoLinerHex.hh>
#include <VertexGen_PhotonRayWithAngularDist.hh>

/*
#include <RAT/GLG4PrimaryGeneratorAction.hh>
#include <RAT/GLG4VertexGen.hh>
#include <RAT/Gsim.hh>
#include <RAT/ProcBlockManager.hh>
#include <RAT/Rat.hh>
*/

#include <CLHEP/Units/PhysicalConstants.h>

// #include <RAT/ToroidalPMTConstruction.hh>
#include <RAT/Factory.hh>

namespace BUTTON {
Button::Button(RAT::AnyParse *p, int argc, char **argv) : Rat(p, argc, argv) {
  // Append an additional data directory (for ratdb and geo)
  char *buttondata = getenv("BUTTONDATA");
  if (buttondata != NULL) {
    ratdb_directories.insert(static_cast<std::string>(buttondata) + "/ratdb");
    model_directories.insert(static_cast<std::string>(buttondata) + "/models");
  }
  // Initialize a geometry factory
  new GeoLinerHex();
  new GeoLiner();

  // Include a new type of processor
  RAT::ProcBlockManager::AppendProcessor<BonsaiProc>();
  RAT::ProcBlockManager::AppendProcessor<ButtonDAQProc>();
  // Add a unique component to the datastructure

  // Add a generator

  // RAT::GlobalFactory<GLG4Gen>::Register("pray", new RAT::Alloc<GLG4Gen,
  // VertexGen_PhotonRay>);
  RAT::GlobalFactory<GLG4VertexGen>::Register(
      "diffuser", new RAT::Alloc<GLG4VertexGen, VertexGen_PhotonRay>);
  // RAT::GlobalFactory<GLG4VertexGen>::Register();
}
} // namespace BUTTON
