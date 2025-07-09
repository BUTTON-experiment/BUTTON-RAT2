#include <G4ThreeVector.hh>
#include <RAT/DS/DigitPMT.hh>
#include <RAT/DS/MCPMT.hh>
#include <RAT/DS/PMT.hh>
#include <RAT/DS/RunStore.hh>
#include <ButtonDAQProc.hh>
#include <algorithm>
#include <vector>

// Needed for quick sort
#include <bits/stdc++.h>

namespace BUTTON {

    ButtonDAQProc::ButtonDAQProc() : RAT::Processor("buttondaq") {
        printf("ButtonDAQProc: Initialisation of the Button processor.\n");
    }




    void ButtonDAQProc::BeginOfRun(RAT::DS::Run* run) {
        // Trigger Specifications
        printf("ButtonDAQProc starting BeginOfRun.\n");

        ldaq = RAT::DB::Get()->GetLink("ButtonDAQ");
        fEventCounter = 0;
        fPulseWidth = ldaq->GetD("pulse_width");
        fTriggerThreshold = ldaq->GetD("trigger_threshold");
        fTriggerWindow = ldaq->GetD("trigger_window");
        fPmtLockout = ldaq->GetD("pmt_lockout");
        fTriggerLockout = ldaq->GetD("trigger_lockout");
        fTriggerResolution = ldaq->GetD("trigger_resolution");
        fLookback = ldaq->GetD("lookback");
        fMaxHitTime = ldaq->GetD("max_hit_time");
        fTriggerOnNoise = ldaq->GetI("trigger_on_noise");
        fDigitizerType = ldaq->GetS("digitizer_name");
        fDigitize = ldaq->GetZ("digitize");

        printf("fPulseWidth: %f\n", fPulseWidth);

        printf("Digitize value: %s\n", fDigitize ? "true" : "false");
        

        fDigitizer = new RAT::Digitizer(fDigitizerType);
        if (fDigitize) {
            RAT::DS::PMTInfo* pmtinfo = run->GetPMTInfo();
            const size_t numModels = pmtinfo->GetModelCount();
            for (size_t i = 0; i < numModels; i++) {
                const std::string& modelName = pmtinfo->GetModelName(i);
                fDigitizer->AddWaveformGenerator(modelName);
            }
        }
    }





    RAT::Processor::Result ButtonDAQProc::DSEvent(RAT::DS::Root* ds) {
        printf("ButtonDAQProc starting DSEvent.\n");
        RAT::DS::MC* mc = ds->GetMC();
        RAT::DS::Run* run = RAT::DS::RunStore::Get()->GetRun(ds);
        RAT::DS::PMTInfo* pmtinfo = run->GetPMTInfo();
        // Prune the previous EV branchs if one exists

        printf("Starting EV Prune:\n");

        if (ds->ExistEV()) ds->PruneEV();


        //printf("Summing PMT stuff:\n");
        // First loop through the PMTs and create a summed trigger
        std::vector<double> trigPulses;
        //printf("mc GetMCPMTCount: %d \n", mc->GetMCPMTCount());
        for (int imcpmt = 0; imcpmt < mc->GetMCPMTCount(); imcpmt++) {
            
            RAT::DS::MCPMT* mcpmt = mc->GetMCPMT(imcpmt);
            double lastTrigger = -100000.0;
            for (int pidx = 0; pidx < mcpmt->GetMCPhotonCount(); pidx++) {
                RAT::DS::MCPhoton* photon = mcpmt->GetMCPhoton(pidx);
                // Do we want to trigger on noise hits?
                if (!fTriggerOnNoise && photon->IsDarkHit()) continue;
                double time = photon->GetFrontEndTime();
                //printf("Time: %f\n", time);
                if (time > fMaxHitTime) continue;
                if (time > (lastTrigger + fPmtLockout)) {
                    trigPulses.push_back(time);
                    lastTrigger = time;
                }
            }
        }

        //printf("trigPulses.size(): %d\n", trigPulses.size());
        if (trigPulses.size() < 1) return Processor::OK;  // We're done, no triggers

        double start = *std::min_element(trigPulses.begin(), trigPulses.end());
        start = floor(start / fTriggerResolution) * fTriggerResolution;
        double end = *std::max_element(trigPulses.begin(), trigPulses.end());
        end = (floor(end / fTriggerResolution) + 1) * fTriggerResolution;
        std::sort(trigPulses.begin(), trigPulses.end());

        // Turns hits into a histogram of trigger pulse leading edges
        //        _
        //   _   | |    _
        // _| |__| |___| |___
        int nbins = floor((end - start) / fTriggerResolution) + 1;
        double bw = fTriggerResolution;

        std::vector<double> triggerTrain(nbins);
        for (auto v : trigPulses) {
            int select = int((v - start) / bw);
            triggerTrain[select] += 1.0;
        }



        // Spread each bin out to the trigger pulse width to pass to a discriminator
        //             |
        //.............|_____ .... trigger threshold .....
        //        _____|     |____
        //       |     |          |____
        //   ____|     |               |____
        // _|          | global trigger!    |___
        std::vector<double> triggerHistogram(nbins);
        for (int i = 0; i < nbins; i++) {
            double x = triggerTrain[i];
            if (x > 0) {
                int j = i;
                do {
                    if (j >= nbins) break;
                    triggerHistogram[j] += x;
                    j++;
                } while (j < i + int(fPulseWidth / bw));
            }
        }


        // For button, want a trigger based on obtaining 4 hits within ~100ns of each other
        // threshold for a hit is 0.25pe, pulse size less than that we don't take

        // So to replicate this behaviour, I could...
        // sort the trigger times and check - loop through and if the trigger 3 in front of the current one is <100 ms away trigger the event
        // Do I need multiple triggers at different points? 
        // How long does it save data for?




        


        std::vector<double> hitTimes;
        double currentTime = 0;
        // First, convert the triggers into trigger times
        // What time do you want to store for the trigger? 
        // You'd want the quantised time since the system is going to have a particular sample rate (the "trigger resolution"?)
        for (int i = 0; i < nbins; i++) {
            currentTime = (i * bw) + start;
            double v = triggerHistogram[i];
            if (v == 0) continue;
            for (int j = 0; j < v; j++) {
                hitTimes.push_back(currentTime);
            }
        }
        

        // Need to sort the times
        std::sort(hitTimes.begin(), hitTimes.end()); // Sorts the hit times in ascending order
        //printf("Printing hit times:\n");
        //printf("Hit times: %f %f %f %f %f\n", hitTimes[0], hitTimes[1], hitTimes[2], hitTimes[3], hitTimes[4]);



        double lastTrigger = 0;
        std::vector<double> triggerTimes;
        for (int i = 0; i < hitTimes.size() - 3; i++) {
            //printf("i: %d\n", i);
            //printf("Hit times: %f  %f \n", hitTimes[i + 3], hitTimes[i]);
            //printf("HitTime difference: %f\n", hitTimes[i + 3] - hitTimes[i]);
            // For each photon, if the photon 3 after it arrived less than 100ns after the original photon, then that means there were at least 4 in that time frame, so add a trigger 
            // Not sure what time to assign the trigger to
            // Then there needs to be some amount of deadtime/trigger window/trigger lockout 
            if ( (hitTimes[i] - lastTrigger) < (lastTrigger + fTriggerWindow + fTriggerLockout) and (lastTrigger!=0) ){
                // If the trigger happens while you're saving data or locked out from the trigger, it won't trigger (unless they have a system for 0 deadtime, did they mention this?)
                continue;
            }

            if ((hitTimes[i + 3] - hitTimes[i]) < 100.0) { // time units in ns
                //printf("Triggering\n");
                // This means there are 4 photons within ~100ns, so call a trigger
                // UNLESS I don't want to trigger because of the trigger window/lockout
                // Dark hits are also included 
                lastTrigger = hitTimes[i];
                triggerTimes.push_back(lastTrigger);
            }
        }

        // Place the correct hits, charges, etc into the right trigger windows
        lastTrigger = 0;
        for (auto tt : triggerTimes) {
            RAT::DS::EV* ev = ds->AddNewEV();
            ev->SetID(fEventCounter++);
            ev->SetCalibratedTriggerTime(tt);
            ev->SetUTC(mc->GetUTC());
            ev->SetDeltaT(tt - lastTrigger);
            lastTrigger = tt;
            double totalEVCharge = 0;  // What does total charge get used for?
            for (int imcpmt = 0; imcpmt < mc->GetMCPMTCount(); imcpmt++) {
                RAT::DS::MCPMT* mcpmt = mc->GetMCPMT(imcpmt);
                int pmtID = mcpmt->GetID();
                // Check if the mcpmt has a time within one pulsewidth of the trigger window
                // It's just if the mcpmt has a hit within the trigger window
                bool pmtInEvent = false;
                double integratedCharge = 0;
                std::vector<double> hitTimes;
                if (mcpmt->GetMCPhotonCount() > 0) {
                    for (int pidx = 0; pidx < mcpmt->GetMCPhotonCount(); pidx++) {
                        RAT::DS::MCPhoton* photon = mcpmt->GetMCPhoton(pidx);
                        double time = photon->GetFrontEndTime();
                        if ((time > (tt - fLookback)) && (time < (tt + fTriggerWindow))) {
                            pmtInEvent = true;
                            hitTimes.push_back(time);
                            integratedCharge += photon->GetCharge();
                        }
                    }
                }
                std::sort(hitTimes.begin(), hitTimes.end());
                if (pmtInEvent) {
                    RAT::DS::PMT* pmt = ev->GetOrCreatePMT(pmtID);
                    double front_end_hit_time = *std::min_element(hitTimes.begin(), hitTimes.end());
                    // PMT Hit time relative to the trigger
                    pmt->SetTime(front_end_hit_time - tt);
                    pmt->SetCharge(integratedCharge);
                    totalEVCharge += integratedCharge; // I think what's happening here is that it's taking the integrated charge from the photons in the trigger window for each pmt and then assigning that to the pmt for later use
                    if (fDigitize) {
                        fDigitizer->DigitizePMT(mcpmt, pmtID, tt, pmtinfo);
                    }
                }
            }  // Done looping over PMTs

            if (fDigitize) {
                fDigitizer->WriteToEvent(ev);
            }

            ev->SetTotalCharge(totalEVCharge);
        }


        printf("Number of triggered events: %d\n", triggerTimes.size());


        return RAT::Processor::OK;
    }


    void ButtonDAQProc::SetD(std::string param, double value) {
        if (param == "pulse_width")
            fPulseWidth = value;
        else if (param == "trigger_threshold")
            fTriggerThreshold = value;
        else if (param == "trigger_window")
            fTriggerWindow = value;
        else if (param == "pmt_lockout")
            fPmtLockout = value;
        else if (param == "trigger_lockout")
            fTriggerLockout = value;
        else if (param == "trigger_resolution")
            fTriggerResolution = value;
        else if (param == "lookback")
            fLookback = value;
        else if (param == "max_hit_time")
            fMaxHitTime = value;
        else
            throw ParamUnknown(param);
    }

    void ButtonDAQProc::SetI(std::string param, int value){
        if (param == "trigger_on_noise")
            fTriggerOnNoise = value;
        else
            throw ParamUnknown(param);
    }


}



    