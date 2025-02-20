#ifndef __BUTTON_Button__
#define __BUTTON_Button__

#include <Config.hh>
#include <RAT/AnyParse.hh>
#include <RAT/ProcAllocator.hh>
#include <RAT/ProcBlockManager.hh>
#include <RAT/Rat.hh>

namespace BUTTON {
class Button : public RAT::Rat {
public:
  Button(RAT::AnyParse *p, int argc, char **argv);
};
} // namespace BUTTON

#endif // __BUTTON_Button__
