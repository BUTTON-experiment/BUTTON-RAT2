#include "LAPPDGen2Proc.hh"
#include <RAT/DS/EV.hh>
#include <RAT/DS/LAPPD.hh>
#include <RAT/DS/LAPPDHit.hh>
#include <RAT/DS/MC.hh>
#include <RAT/DS/MCPMT.hh>
#include <RAT/DS/MCPhoton.hh>
#include <RAT/DS/PMTInfo.hh>
#include <RAT/DS/Root.hh>
#include <RAT/DS/Run.hh>
#include <RAT/DS/RunStore.hh>
#include <TRandom3.h>
#include <TVector3.h>
#include <cmath>

namespace RAT {

LAPPDGen2Proc::LAPPDGen2Proc() : Processor("LAPPDGen2Proc") {
  fNumPads = 8;
  fPadSize = 25.0; // mm (Adjust to your actual anode pitch)

  // Korpar et al. Sample #162 Parameters
  fPCtoMCP1 = 1.19;     // l [mm]
  fMCP2toAnode = 3.0;   // g [mm]
  fBackPlateD = 2.0;    // d [mm]
  fBackPlateEps = 10.0; // Ceramic
  fSigmaPrompt = 0.030; // 30 ps resolution
  fBackscatterProb = 0.30;

  // z_eff = g + d/eps = 3.2 mm
  fZeff = fMCP2toAnode + (fBackPlateD / fBackPlateEps);
}

Processor::Result LAPPDGen2Proc::DSEvent(DS::Root *ds) {
  DS::MC *mc = ds->GetMC();
  if (!mc)
    return Processor::OK;

  // Get PMT positions for local coordinate conversion
  DS::Run *run = DS::RunStore::Get()->GetRun(ds);
  DS::PMTInfo *pmtInfo = run->GetPMTInfo();

  DS::EV *ev = ds->GetEVCount() > 0 ? ds->GetEV(0) : ds->AddNewEV();

  for (int i = 0; i < mc->GetMCPMTCount(); i++) {
    DS::MCPMT *mcpmt = mc->GetMCPMT(i);
    TVector3 pmtPos = pmtInfo->GetPosition(mcpmt->GetID());

    DS::LAPPD *lappd = ev->AddNewLAPPD();
    lappd->SetID(mcpmt->GetID());

    for (int j = 0; j < mcpmt->GetMCPhotonCount(); j++) {
      DS::MCPhoton *ph = mcpmt->GetMCPhoton(j);

      // Calculate LOCAL hit position relative to LAPPD center
      TVector3 localHit = ph->GetPosition() - pmtPos;
      double x_hit = localHit.X();
      double y_hit = localHit.Y();
      double t_hit = ph->GetHitTime();
      double photonQ = 1; // ph->GetCharge();

      // 1. Back-scattering Logic (from paper)
      if (gRandom->Uniform() < fBackscatterProb) {
        double phi = gRandom->Uniform(0, 2 * M_PI);
        double r_dist = gRandom->Uniform(0, 2 * fPCtoMCP1);
        x_hit += r_dist * cos(phi);
        y_hit += r_dist * sin(phi);
        t_hit += gRandom->Uniform(0, 0.300); // 300ps tail
      }

      // 2. Timing Resolution
      t_hit += gRandom->Gaus(0, fSigmaPrompt);

      // 3. Induced Charge Spread (Per-Pad Induction)
      for (int px = 0; px < fNumPads; px++) {
        for (int py = 0; py < fNumPads; py++) {
          double padCX = (px - (fNumPads - 1) / 2.0) * fPadSize;
          double padCY = (py - (fNumPads - 1) / 2.0) * fPadSize;

          double dx = x_hit - padCX;
          double dy = y_hit - padCY;
          double r2 = dx * dx + dy * dy;

          // Korpar's Induction Model (Eq 5.2)
          double density = fZeff / (2.0 * M_PI * pow(r2 + fZeff * fZeff, 1.5));
          double padQ = photonQ * density * (fPadSize * fPadSize);

          if (padQ > 1e-4) { // Threshold to prevent saving empty hits
            DS::LAPPDHit *hit = lappd->AddNewHit();
            hit->SetPosition(TVector3(padCX, padCY, 0.0));
            hit->SetCharge(padQ);
            hit->SetTime(t_hit);
          }
        }
      }
    }
  }
  return Processor::OK;
}
} // namespace RAT
