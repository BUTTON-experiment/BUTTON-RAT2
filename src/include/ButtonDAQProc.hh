#ifndef __RAT_ButtonDAQProc__
#define __RAT_ButtonDAQProc__

#include <RAT/DB.hh>
#include <RAT/Digitizer.hh>
#include <RAT/Processor.hh>
#include <string>
/*
namespace RAT {

class ButtonDAQProc : public Processor {
 public:
  ButtonDAQProc();
  virtual ~ButtonDAQProc(){};
  virtual Processor::Result DSEvent(DS::Root *ds);
  void SetD(std::string param, double value);
  void SetI(std::string param, int value);

  void BeginOfRun(DS::Run *run);
  int partition(std::vector<int>& vec, int low, int high);
  void quickSort(std::vector<int>& vec, int low, int high);

 protected:
  int fEventCounter;
  double fPulseWidth;
  double fTriggerThreshold;
  double fTriggerWindow;
  double fPmtLockout;
  double fTriggerLockout;
  double fTriggerResolution;
  double fLookback;
  double fMaxHitTime;
  bool fDigitize;

  int fTriggerOnNoise;
  DBLinkPtr ldaq;

  Digitizer *fDigitizer;
  std::string fDigitizerType;
};

}  // namespace RAT

#endif*/

namespace BUTTON {

	class ButtonDAQProc : public RAT::Processor {
	public:
		ButtonDAQProc();
		virtual ~ButtonDAQProc() {}

		void BeginOfRun(RAT::DS::Run* run);

		//virtual RAT::Processor::Result Event(RAT::DS::Root* ds, RAT::DS::EV* ev);
		virtual RAT::Processor::Result DSEvent(RAT::DS::Root* ds);

		void SetD(std::string param, double value);
		void SetI(std::string param, int value);

		//int partition(std::vector<int>& vec, int low, int high);
		//void quickSort(std::vector<int>& vec, int low, int high);

		//int nwin(float twin, float* v, int nfit, int* cfit, float* tfit, int* cwin);

		//int bs_useCherenkovAngle;
		//float bs_nTmin, bs_nTmax;

		//RAT::DS::PMTInfo* bs_pmtinfo;

		//inline static std::string bs_likeFilename;

		//fit_param bspar;
		//bonsaifit* bsfit, * cffit;
		//pmt_geometry* bsgeom;
		//likelihood* bslike;
		//goodness* bsgdn;
		//fourhitgrid* bsgrid;
		//int bs_cables[5000], bs_veto_cables[5000];
		//int bs_cables_win[500], bs_veto_cables_win[5000];
		//float bs_times[5000], bs_veto_times[5000];
		//float bs_charges[5000], bs_veto_charges[5000];
		//int bs_n, bs_count;
		//int bs_inpmt;
		//int bs_hit, bs_nhit, bs_veto_count;
		//float bs_bonsai_vtxfit[4];
		//double bs_vertex[3];
		//float bs_dir[3];
		//double bs_ddir[3], bs_wall[3];

		//float bs_goodn[2], bs_agoodn;
		//float bs_offset = 800.0;
		//int bs_nsel;

	protected:
		// cppflow::model *hitmanModel;
		int fEventCounter;
		double fPulseWidth;
		double fTriggerThreshold;
		double fTriggerWindow;
		double fPmtLockout;
		double fTriggerLockout;
		double fTriggerResolution;
		double fLookback;
		double fMaxHitTime;
		bool fDigitize;

		int fTriggerOnNoise;
		RAT::DBLinkPtr ldaq;

		RAT::Digitizer* fDigitizer;
		std::string fDigitizerType;



	};

} // namespace BUTTON

#endif
