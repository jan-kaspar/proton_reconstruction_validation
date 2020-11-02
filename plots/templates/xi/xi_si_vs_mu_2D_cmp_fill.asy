import root;
import pad_layout;
include "../settings.asy";

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
		scale(Linear, Linear, Log);

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "singleMultiCorrelationPlots/si_rp" + rps[rpi]  + "_mu_" + rp_arms[rpi] + "/h2_xi_mu_vs_xi_si";
		
		RootObject hist = RootGetObject(f, on, error=false);

		if (!hist.valid)
			continue;

		if (rebin)
			hist.vExec("Rebin2D", 2, 2);
		
		draw(hist);

		real xi_max = 0.3;

		draw((0, 0)--(xi_max, xi_max), dashed);

		limits((0., 0.), (xi_max, xi_max), Crop);
	}
}

GShipout(hSkip=1mm, vSkip=0mm);
