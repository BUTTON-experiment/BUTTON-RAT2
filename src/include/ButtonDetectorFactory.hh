#ifndef __BUTTON_ButtonDetectorFactory__
#define __BUTTON_ButtonDetectorFactory__

#include <RAT/DetectorFactory.hh>

namespace BUTTON {

class ButtonDetectorFactory : public RAT::DetectorFactory {
public:
  ButtonDetectorFactory() {}
  virtual ~ButtonDetectorFactory() {}

protected:
  virtual void DefineDetector(RAT::DBLinkPtr detector);
};

} // namespace BUTTON
#endif
