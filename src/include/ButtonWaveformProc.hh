#ifndef __RAT_ButtonWaveformProc__
#define __RAT_ButtonWaveformProc__

#include <RAT/DB.hh>
#include <RAT/Digitizer.hh>
#include <RAT/Processor.hh>
#include <string>


namespace BUTTON {

	class ButtonWaveProc : public RAT::Processor {
	public:
		ButtonWaveProc(); // A version of the constructor with no argument given
		//ButtonWaveProc(std::string analyzer_name); // A version of the constructor with the analyser name given
		virtual ~ButtonWaveProc() {}

		void Configure(); // const std::string& analyzer_name

		virtual void SetS(std::string param, std::string value);
		virtual void SetI(std::string param, int value);
		//virtual void SetD(std::string param, double value);

		void RunAnalysis(RAT::DS::DigitPMT* digitpmt, int pmtID, RAT::DS::Digit* dsdigit, double timeOffset);
		virtual RAT::Processor::Result Event(RAT::DS::Root* ds, RAT::DS::EV* ev);

		double IntegrateWaveform(RAT::DS::DigitPMT* digitisedPMT, std::vector<double> digitisedWaveform, double timeStep);

	protected:
		// Digitizer settings
		RAT::DBLinkPtr fDigit;
		double fTimeStep;
		double fVoltageRes;
		double fTermOhms;

		// Analysis constants
		int fPedWindowLow;
		int fPedWindowHigh;
		double fLookback;
		int fIntWindowLow;
		int fIntWindowHigh;
		double fConstFrac;
		int fLowIntWindow;
		int fHighIntWindow;
		double fVoltageCrossing;
		double fThreshold;
		int fSlidingWindow;
		double fChargeThresh;
		
		// Fitted variables
		double fFittedTime;
		double fFittedCharge;
		double fFittedBaseline;

	};

} // namespace BUTTON

#endif