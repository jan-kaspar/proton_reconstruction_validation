import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[], c_si_rps[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_si_rps.push("rp23");
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_si_rps.push("rp123");

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
label("\vbox{\hbox{version: " + version + "}\hbox{stream: " + stream + "}\hbox{xangle: " + xangle + "}\hbox{beta: " + beta + "}}");

for (int ci : cols.keys)
	NewPadLabel(c_labels[ci]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	write(fill);

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ci : cols.keys)
	{
		NewPad("$\xi_{\rm multi}$", "$\xi_{\rm single,F} - \xi_{\rm single,N}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/do_fits.root";
		string on = "armCorrelationPlots/" + cols[ci] + "/p_xi_si_diffNF_vs_xi_mu";
		
		RootObject hist = RootGetObject(f, on, error=false);

		if (!hist.valid)
			continue;
		
		draw(hist, "eb,d0", red);

		limits((0., -0.02), (0.25, +0.02), Crop);
	}
}

GShipout("xi_si_diffNF_vs_mu_profile_cmp_fill", hSkip=1mm, vSkip=0mm);
