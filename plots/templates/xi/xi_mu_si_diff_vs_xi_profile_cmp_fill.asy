import root;
import pad_layout;
include "../settings.asy";

xTicksDef = LeftTicks(0.05, 0.01);

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
		NewPad("$\xi_{\rm multi}$", "mean of $\xi_{\rm single} - \xi_{\rm multi}$");

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/do_fits.root";
		string on = "singleMultiCorrelationPlots/si_rp" + rps[rpi]  + "_mu_" + rp_arms[rpi] + "/p_xi_diff_si_mu_vs_xi_mu";
		
		RootObject hist = RootGetObject(f, on, error=false);
		RootObject fit = RootGetObject(f, on + "|ff_pol1", error=false);

		if (!hist.valid || !fit.valid)
			continue;
		
		draw(hist, "d0,vl", blue);
		draw(fit, "def", red+1pt);

		limits((0., -0.1), (0.25, +0.1), Crop);
	}
}

GShipout(hSkip=1mm, vSkip=0mm);
