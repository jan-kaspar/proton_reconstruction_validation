import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[], c_si_rps[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_si_rps.push("rp23");
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_si_rps.push("rp123");

xTicksDef = LeftTicks(0.05, 0.01);
yTicksDef = RightTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
label("\vbox{\hbox{version: " + version + "}\hbox{stream: " + stream + "}\hbox{xangle: " + xangle + "}\hbox{beta: " + beta + "}}");

for (int ci : cols.keys)
	NewPadLabel(c_labels[ci]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ci : cols.keys)
	{
		NewPad("$\xi_{\rm single}$", "$\xi_{\rm multi}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "singleMultiCorrelationPlots/si_" + c_si_rps[ci]  + "_mu_" + cols[ci] + "/h2_xi_mu_vs_xi_si";
		
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
