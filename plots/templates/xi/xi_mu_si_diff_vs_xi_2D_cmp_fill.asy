import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
label("\vbox{\hbox{version: " + version + "}\hbox{stream: " + stream + "}\hbox{xangle: " + xangle + "}\hbox{beta: " + beta + "}}");

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int rpi : rps.keys)
	{
		NewPad("$\xi_{\rm multi}$", "$\xi_{\rm single} - \xi_{\rm multi}$");
		//scale(Linear, Linear, Log);

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "singleMultiCorrelationPlots/si_rp" + rps[rpi]  + "_mu_" + rp_arms[rpi] + "/h2_xi_diff_si_mu_vs_xi_mu";
		
		RootObject hist = RootGetObject(f, on, error=false);

		if (!hist.valid)
			continue;

		hist.vExec("Rebin2D", 2, 2);
		
		draw(hist);

		limits((0., -0.1), (0.25, +0.1), Crop);
	}
}

GShipout("xi_mu_si_diff_vs_xi_2D_cmp_fill", hSkip=1mm, vSkip=0mm);
