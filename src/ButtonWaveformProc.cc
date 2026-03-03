#include <TF1.h>
#include <TH1D.h>
#include <TMath.h>

#include <RAT/Log.hh>
#include <RAT/WaveformPrep.hh>
#include <RAT/WaveformUtil.hh>

#include "RAT/DS/DigitPMT.hh"
#include "RAT/DS/RunStore.hh"

#include <ButtonWaveformProc.hh>


namespace BUTTON {

    // Constructor, if it has no argument then it sends "ButtonWaveformAnalysis", which is the index of the DIGITIZER_ANALYSIS ratdb entry with the correct parameters
    ButtonWaveProc::ButtonWaveProc() : RAT::Processor("buttonWave") {
        printf("ButtonWaveProc: Initialisation of the Button Waveform processor.\n");
    }   

    // configure is used for changing the analysis name on the fly if you have multiple different versions of the analysis to run on the same data (such as with different parameters)
    void ButtonWaveProc::Configure() { // const std::string& analyzer_name
        try {
            fDigit = RAT::DB::Get()->GetLink("DIGITIZER_ANALYSIS", "ButtonWaveformAnalysis");
            fIntWindowLow = fDigit->GetI("integration_low_samples");
            std::cout << "integration_low_samples: " << fIntWindowLow << "\n";
            fIntWindowHigh = fDigit->GetI("integration_high_samples");
            std::cout << "integration_high_samples: " << fIntWindowHigh << "\n";
			fPedWindowLow = fDigit->GetI("pedestal_window_low");
			std::cout << "pedestal_low_samples: " << fPedWindowLow << "\n";
			fPedWindowHigh = fDigit->GetI("pedestal_window_high");
			std::cout << "pedestal_high_samples: " << fPedWindowHigh << "\n";

        }
        catch (RAT::DBNotFoundError) {
            std::cout << "Didn't find analysis parameters." << "\n";
            RAT::Log::Die("WaveformAnalysis: Unable to find analysis parameters.");
        }
    }


    void ButtonWaveProc::SetS(std::string param, std::string value) {
        if (param == "analyzer_name") {
            Configure();//(value);
        }
        else {
            throw RAT::Processor::ParamUnknown(param);
        }
    }

    void ButtonWaveProc::SetI(std::string param, int value) {
        if (param == "integration_low_samples") {
            fIntWindowLow = value;
        }
        else if (param == "integration_high_samples") {
            fIntWindowHigh = value;
        }

        else {
            throw RAT::Processor::ParamUnknown(param);
        }
    }

    




    void ButtonWaveProc::RunAnalysis(RAT::DS::DigitPMT* digitpmt, int pmtID, RAT::DS::Digit* dsdigit, double timeOffset) {
        fVoltageRes = dsdigit->GetVoltageResolution();
        fTimeStep = dsdigit->GetTimeStepNS();
        fTermOhms = dsdigit->GetTerminationOhms();
		std::cout << "fTimeStep: " << fTimeStep << "\n";

        std::cout << "fVoltageRes: " << fVoltageRes << "\n";

        std::vector<UShort_t> digitWfm = dsdigit->GetWaveform(pmtID); // May need to convert this to voltage as based on the type of UShort_t (an unsigned integer type) it probably doesn't have voltage values in it
        /*for (int i; i < 5; i++) {
            std::cout << "Printing digitWfm: " << digitWfm[i] << "\n";
        }*/

        // Taken from WaveformPrep.cc:
        // Calculate baseline in ADC units
		
        double pedestal = RAT::WaveformUtil::CalculatePedestalADC(digitWfm, fPedWindowLow, fPedWindowHigh);
        // Convert from ADC to mV
        std::vector<double> voltWaveform = RAT::WaveformUtil::ADCtoVoltage(digitWfm, fVoltageRes, pedestal = pedestal);
        /*for (int i; i < 5; i++) {
            std::cout << "Printing voltWaveform: " << voltWaveform[i] << "\n";
        }*/
		std::cout << "pedestal: " << pedestal << "\n";

        std::cout << "Do the integration with trapezium rule:\n";
        double integrationResult = IntegrateWaveform(digitpmt, voltWaveform, fTimeStep);

        std::cout << "Got integration result: " << integrationResult << "\n";
        //DoAnalysis(digitpmt, digitWfm, timeOffset);
		
		// Next is to try and get this into the output ntuple root file
		RAT::DS::WaveformAnalysisResult* fit_result = digitpmt->GetOrCreateWaveformAnalysisResult("ButtonWave");
		// I don't have a time or charge fit from this, so I'll set them both to 0 since they need a value (defined in the .hh)
		fFittedTime = 0;
		fFittedCharge = 0;
		fFittedBaseline = 0;
		fit_result->AddPE(fFittedTime, fFittedCharge, {{"integration", integrationResult}});
    }




    double ButtonWaveProc::IntegrateWaveform(RAT::DS::DigitPMT* digitisedPMT, std::vector<double> voltWaveform, double timeStep) {
		
        double integrationResult = 0;
        double currentTrapezium = 0;
        double voltageWaveformFirst = 0;
        double voltageWaveformSecond = 0;
		int minimumLocation = std::distance(std::begin(voltWaveform), std::min_element(std::begin(voltWaveform), std::end(voltWaveform)));
		std::cout << "Minimum location " << minimumLocation << "\n";
		// Set integration window and clamp appropriately
		int lowIntegrationIndex = minimumLocation - fIntWindowLow;
		if (lowIntegrationIndex < 0) {lowIntegrationIndex=0;};
		int highIntegrationIndex = minimumLocation + fIntWindowHigh;
		if (highIntegrationIndex > voltWaveform.size()-1) {highIntegrationIndex=voltWaveform.size()-1;};
		
		
        for (int i=lowIntegrationIndex; i < highIntegrationIndex; i++) { // -2 because the last point won't have a second point to form a trapezium with
            
			//if (i-lowIntegrationIndex >= 0) {std::cout << "Integrating voltage: " << voltWaveform[i] << "\n";}
            currentTrapezium = (-1*voltWaveform[i] + -1*voltWaveform[i+1])/2 * timeStep; // -1s for making positive for convenience.
            integrationResult += currentTrapezium;
        }




        return integrationResult;
    }

    




    
    RAT::Processor::Result ButtonWaveProc::Event(RAT::DS::Root* ds, RAT::DS::EV* ev) {
        std::cout << "Button waveform processor is running the processing code." << "\n";
        std::cout << "Running configure:\n";
        Configure();
        std::cout << "Starting integration:\n";

        if (!ev->DigitizerExists()) {
            RAT::warn << "Running waveform analysis, but no digitzer information." << newline;
            return Processor::Result::OK;
        }

        RAT::DS::Digit* dsdigit = &ev->GetDigitizer();
        RAT::DS::Run* run = RAT::DS::RunStore::GetRun(ds->GetRunID());
        const RAT::DS::ChannelStatus* ch_status = run->GetChannelStatus();
        std::vector<int> pmt_ids = dsdigit->GetIDs();
        double total_charge = 0;
        double time_offset = 0;


        for (int pmt_id : pmt_ids) {
            // Do not analyze negative pmtid channels, since they do not correspond to real PMTs.
            if (pmt_id < 0) continue;
            if (!ch_status->GetOnlineByPMTID(pmt_id)) continue;
            RAT::DS::DigitPMT* digitpmt = ev->GetOrCreateDigitPMT(pmt_id);
            //time_offset = fApplyCableOffset ? ch_status->GetCableOffsetByPMTID(pmt_id) : 0.0;
            time_offset = 0;

            RunAnalysis(digitpmt, pmt_id, dsdigit, time_offset);

            //if (digitpmt->GetNCrossings() > 0) {
            //    total_charge += digitpmt->GetDigitizedCharge();
            //}
            //ZeroSuppress(ev, digitpmt, pmt_id);
            //ev->SetTotalCharge(total_charge);
        }
       

        return RAT::Processor::Result::OK;
    }



}



