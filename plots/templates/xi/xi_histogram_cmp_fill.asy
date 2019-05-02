import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[], c_si_N_rps[], c_si_F_rps[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_si_N_rps.push("rp3"); c_si_F_rps.push("rp23");
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_si_N_rps.push("rp103"); c_si_F_rps.push("rp123");

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);

AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

AddToLegend("single-RP, ``near'' RP", blue);
AddToLegend("single-RP, ``far'' RP", heavygreen);
AddToLegend("multi-RP", red);

AttachLegend();

for (int ci : cols.keys)
	NewPadLabel(c_labels[ci]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ci : cols.keys)
	{
		NewPad("$\xi$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		
		RootObject hist_si_N = RootGetObject(f, "singleRPPlots/" + c_si_N_rps[ci] + "/h_xi", error=false);
		RootObject hist_si_F = RootGetObject(f, "singleRPPlots/" + c_si_F_rps[ci] + "/h_xi", error=false);
		RootObject hist_mu = RootGetObject(f, "multiRPPlots/" + cols[ci] + "/h_xi", error=false);

		if (hist_si_N.valid)
			draw(hist_si_N, "vl", blue);

		if (hist_si_F.valid)
			draw(hist_si_F, "vl", heavygreen);

		if (hist_mu.valid)
			draw(hist_mu, "vl", red);

		xlimits(0.00, +0.25, Crop);
	}
}

GShipout("xi_histogram_cmp_fill.asy", hSkip=1mm, vSkip=0mm);
