#include <Button.hh>
#include <BonsaiProc.hh>
#include <GeoLinerHex.hh>
#include <GeoLiner.hh>

namespace BUTTON {
Button::Button(RAT::AnyParse *p, int argc, char **argv)
    : Rat(p, argc, argv) {
  // Append an additional data directory (for ratdb and geo)
  char *buttondata = getenv("BUTTONDATA");
  if (buttondata != NULL) {
    ratdb_directories.insert(static_cast<std::string>(buttondata) +
                             "/ratdb");
    model_directories.insert(static_cast<std::string>(buttondata) +
                             "/models");
  }
  // Initialize a geometry factory
  new GeoLinerHex();
  new GeoLiner();
  // Include a new type of processor
  RAT::ProcBlockManager::AppendProcessor<BonsaiProc>();
  // Add a unique component to the datastructure
}
} // namespace BUTTON
