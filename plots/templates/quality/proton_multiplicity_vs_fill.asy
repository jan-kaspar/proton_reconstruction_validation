import root;
import pad_layout;
include "../settings.asy";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

AddToLegend("single-RP, ``near'' RP", blue);
AddToLegend("single-RP, ``far'' RP", heavygreen);
AddToLegend("multi-RP", red);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	NewPad("fill", "mean reco.~protons");

	for (int fi : fills.keys)
	{
		string f = topDir + "data/" + version + "/" + year + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
			+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";

		RootObject hist_si_N = RootGetObject(f, "singleRPPlots/rp" + a_nr_rps[ai] + "/h_multiplicity", error=false);
		RootObject hist_si_F = RootGetObject(f, "singleRPPlots/rp" + a_fr_rps[ai] + "/h_multiplicity", error=false);
		RootObject hist_mu = RootGetObject(f, "multiRPPlots/arm" + arms[ai] + "/h_multiplicity", error=false);
	
		real mult_si_N = (hist_si_N.valid) ? hist_si_N.rExec("GetMean") : 0.;
		real mult_si_F = (hist_si_F.valid) ? hist_si_F.rExec("GetMean") : 0.;
		real mult_mu = (hist_mu.valid) ? hist_mu.rExec("GetMean") : 0.;

		mark m = mCi+3pt;

		real x = fi;

		draw((x, mult_si_N), m+blue);
		draw((x, mult_si_F), m+heavygreen);
		draw((x, mult_mu), m+red);
	}

	DrawFillMarkers(0, 3.);

	limits((-1, 0), (fills.length, 3.), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout(hSkip=0mm, vSkip=0mm);
