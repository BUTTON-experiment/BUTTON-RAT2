/// A example event display for a cude lappd detector 
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

void LAPPDMultiDisplay(std::string filename, std::string mode = "q", double tMin = -1000.0, double tMax = 1000.0, bool showMC = true) {
    // define lappd size and number of pads
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

    // Create a 4x3 multi-panel layout canvas
    TCanvas *c1 = new TCanvas("c1", "6-LAPPD Cubical Net Display", 1200, 900);
    c1->Divide(4, 3, 0.005, 0.005);

    //  GEOMETRICAL MAPPING BASED ON YOUR POSITION METRICS need to be changed if pmtinfo changes:
    int canvasMap[6] = {
        6,  // ID 0 -> Front (+Z)
        7,  // ID 1 -> Right (+X)
        2,  // ID 2 -> Top (+Y)
        8,  // ID 3 -> Back (-Z)
        5,  // ID 4 -> Left (-X)
        10  // ID 5 -> Bottom (-Y)
    };
    
    std::string faceNames[6] = {
        "Front (+Z, ID 0)", 
        "Right (+X, ID 1)", 
        "Top (+Y, ID 2)", 
        "Back (-Z, ID 3)", 
        "Left (-X, ID 4)", 
        "Bottom (-Y, ID 5)"
    };

    for (Long64_t iEv = 0; iEv < t->GetEntries(); ++iEv) {
        t->GetEntry(iEv);
        
        TH2D *h[6] = {nullptr};

        // Initialise 6 individual histograms 
        for (int id = 0; id < 6; ++id) {
            std::string name = Form("h_%d_ev%lld", id, iEv);
            std::string title = faceNames[id] + Form(" | Event %lld", iEv);
            
            h[id] = new TH2D(name.c_str(), title.c_str(), nPads, -halfWidth, halfWidth, nPads, -halfWidth, halfWidth);
            h[id]->GetXaxis()->SetTitle("Pad X Position (mm)");
            h[id]->GetYaxis()->SetTitle("Pad Y Position (mm)");
        }

        // Sort and distribute hits to the correct face
        for (size_t i = 0; i < lappdID->size(); ++i) {
            int id = lappdID->at(i);
            if (id < 0 || id >= 6) continue;

            // Apply time validation window cuts
            if (lappdHitT->at(i) < tMin || lappdHitT->at(i) > tMax) continue;

            double val = (mode == "t") ? lappdHitT->at(i) : lappdHitQ->at(i);
            h[id]->Fill(lappdHitX->at(i), lappdHitY->at(i), val);
        }

        // Clear panel layout buffers from the previous event frame
        for (int slot = 1; slot <= 12; ++slot) {
            c1->cd(slot);
            gPad->Clear();
        }

        // Draw active histograms cleanly onto their mapped positions 
        for (int id = 0; id < 6; ++id) {
            c1->cd(canvasMap[id]);
            h[id]->Draw("COLZ");

            // MC TRUTH OVERLAY 
            if (showMC) {
                for (size_t j = 0; j < lappdMCX->size(); ++j) {
                    TMarker *mTrue = new TMarker(lappdMCX->at(j), lappdMCY->at(j), 29);
                    mTrue->SetMarkerColor(kRed);
                    mTrue->SetMarkerSize(2.5);
                    mTrue->Draw("same");
                    
                    TLatex *tex = new TLatex(lappdMCX->at(j) + 1, lappdMCY->at(j) + 1, Form("%.3f ns", lappdMCT->at(j)));
                    tex->SetTextColor(kRed);
                    tex->SetTextSize(0.04);
                    tex->Draw("same");
                }
            }
        }

        c1->Update();
        
        // Navigation terminal commands
        std::cout << "Displaying Event " << iEv << ". Press Enter for next, or 'q' to quit: ";
        std::string choice;
        std::getline(std::cin, choice);
        
        for (int id = 0; id < 6; ++id) delete h[id];
        if (choice == "q" || choice == "Q") break;
    }
}