import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);

AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

AddToLegend("single-RP, ``near'' RP", blue);
AddToLegend("single-RP, ``far'' RP", heavygreen);
AddToLegend("multi-RP", red);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ai : arms.keys)
	{
		NewPad("$\xi$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		
		RootObject hist_si_N = RootGetObject(f, "singleRPPlots/rp" + a_nr_rps[ai] + "/h_xi", error=false);
		RootObject hist_si_F = RootGetObject(f, "singleRPPlots/rp" + a_fr_rps[ai] + "/h_xi", error=false);
		RootObject hist_mu = RootGetObject(f, "multiRPPlots/" + arms[ai] + "/h_xi", error=false);

		if (hist_si_N.valid)
			draw(hist_si_N, "vl", blue);

		if (hist_si_F.valid)
			draw(hist_si_F, "vl", heavygreen);

		if (hist_mu.valid)
			draw(hist_mu, "vl", red);

		xlimits(0.00, +0.25, Crop);
	}
}

GShipout(hSkip=1mm, vSkip=0mm);
