// Example event display for LAPPD
#include <TFile.h>
#include <TTree.h>
#include <TH2D.h>
#include <TCanvas.h>
#include <TMarker.h>
#include <TLatex.h>
#include <TStyle.h>
#include <iostream>
#include <vector>
#include <string>

void LAPPDEventDisplay(std::string filename, int targetPmt = 0, std::string mode = "q", double tMin = -1000.0, double tMax = 1000.0) {
    // pad size and number of pads
    double padSize = 25.0; 
    int nPads = 8;
    double halfWidth = (nPads * padSize) / 2.0; // Exactly 100.0 mm

    gStyle->SetOptStat(0);
    gStyle->SetPalette(kViridis);

    TFile *f = TFile::Open(filename.c_str());
    if (!f || f->IsZombie()) return;
    TTree *t = (TTree*)f->Get("output");

    std::vector<int> *lappdID = nullptr;
    std::vector<double> *lappdHitQ = nullptr, *lappdHitX = nullptr, *lappdHitY = nullptr, *lappdHitT = nullptr;
    std::vector<double> *lappdMCX = nullptr, *lappdMCY = nullptr, *lappdMCT = nullptr;

    t->SetBranchAddress("lappdID", &lappdID);
    t->SetBranchAddress("lappdHitQ", &lappdHitQ);
    t->SetBranchAddress("lappdHitX", &lappdHitX);
    t->SetBranchAddress("lappdHitY", &lappdHitY);
    t->SetBranchAddress("lappdHitT", &lappdHitT);
    t->SetBranchAddress("lappdMCX", &lappdMCX);
    t->SetBranchAddress("lappdMCY", &lappdMCY);
    t->SetBranchAddress("lappdMCT", &lappdMCT);

    TCanvas *c1 = new TCanvas("c1", "LAPPD 20cm Event Display", 800, 750);

    for (Long64_t iEv = 0; iEv < t->GetEntries(); ++iEv) {
        t->GetEntry(iEv);
        
        std::string title = Form("Event %lld | PMT %d | [%.1f, %.1f] ns", iEv, targetPmt, tMin, tMax);
        TH2D *h = new TH2D("h", title.c_str(), nPads, -halfWidth, halfWidth, nPads, -halfWidth, halfWidth);
        h->GetXaxis()->SetTitle("Pad X Position (mm)");
        h->GetYaxis()->SetTitle("Pad Y Position (mm)");

        bool pmtFound = false;
        double minTfound = 9999, maxTfound = -9999;

        for (size_t i = 0; i < lappdID->size(); ++i) {
            if (lappdID->at(i) == targetPmt) {
                double time = lappdHitT->at(i);
                if(time < minTfound) minTfound = time;
                if(time > maxTfound) maxTfound = time;

                // Time Cut check
                if (time < tMin || time > tMax) continue;

                pmtFound = true;
                double val = (mode == "t") ? time : lappdHitQ->at(i);
                h->Fill(lappdHitX->at(i), lappdHitY->at(i), val);
            }
        }

        if (!pmtFound) {
            std::cout << "Event " << iEv << ": No hits in time window. (Event range: " << minTfound << " to " << maxTfound << " ns)" << std::endl;
            delete h;
            continue; 
        }

        c1->cd();
        h->Draw("COLZ");

        // Overlay MC Truth
       /* for (size_t j = 0; j < lappdMCX->size(); ++j) {
            TMarker *mTrue = new TMarker(lappdMCX->at(j), lappdMCY->at(j), 29);
            mTrue->SetMarkerColor(kRed);
            mTrue->SetMarkerSize(2.5);
            mTrue->Draw("same");
            
            TLatex *tex = new TLatex(lappdMCX->at(j)+2, lappdMCY->at(j)+2, Form("MC: %.2f ns", lappdMCT->at(j)));
            tex->SetTextColor(kRed);
            tex->SetTextSize(0.025);
            tex->Draw("same");
        }*/

        c1->Update();
        
        std::cout << "Event " << iEv << " Displayed. Hit Times: " << minTfound << " - " << maxTfound << " ns." << std::endl;
        std::cout << "Enter to continue, 'q' to quit: ";
        std::string choice;
        std::getline(std::cin, choice);
        if (choice == "q" || choice == "Q") { delete h; break; }
        delete h;
    }
}