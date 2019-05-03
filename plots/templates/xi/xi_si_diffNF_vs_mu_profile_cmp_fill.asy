import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
label("\vbox{\hbox{version: " + version + "}\hbox{stream: " + stream + "}\hbox{xangle: " + xangle + "}\hbox{beta: " + beta + "}}");

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ai : arms.keys)
	{
		NewPad("$\xi_{\rm multi}$", "$\xi_{\rm single,F} - \xi_{\rm single,N}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/do_fits.root";
		string on = "armCorrelationPlots/" + arms[ai] + "/p_xi_si_diffNF_vs_xi_mu";
		
		RootObject hist = RootGetObject(f, on, error=false);
		RootObject fit = RootGetObject(f, on+"|ff_pol1", error=false);

		if (!hist.valid)
			continue;
		
		draw(hist, "eb,d0", blue);
		draw(fit, "l", red+1pt);

		limits((0., -0.01), (0.25, +0.01), Crop);
	}
}

GShipout("xi_si_diffNF_vs_mu_profile_cmp_fill", hSkip=1mm, vSkip=0mm);
