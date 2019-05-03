import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(0.05, 0.01);
yTicksDef = RightTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);
AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int rpi : rps.keys)
	{
		NewPad("$\xi_{\rm single}$", "$\xi_{\rm multi}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "singleMultiCorrelationPlots/si_rp" + rps[rpi]  + "_mu_" + rp_arms[rpi] + "/h2_xi_mu_vs_xi_si";
		
		RootObject hist = RootGetObject(f, on, error=false);

		if (!hist.valid)
			continue;

		hist.vExec("Rebin2D", 2, 2);
		
		draw(hist);

		draw((0, 0)--(0.25, 0.25), dashed);

		limits((0., 0.), (0.25, 0.25), Crop);
	}
}

GShipout("xi_si_vs_mu_2D_cmp_fill", hSkip=1mm, vSkip=0mm);
