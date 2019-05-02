import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[];
cols.push("arm0"); c_labels.push("sector 45 (L)");
cols.push("arm1"); c_labels.push("sector 56 (R)");

TH2_palette = Gradient(blue, heavygreen, yellow, red);

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
		NewPad("$\xi_{\rm multi}$", "mean of $y^*\ung{\mu m}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/do_fits.root";
		string on = "multiRPPlots/" + cols[ci] + "/p_vtx_y_vs_xi";

		RootObject hist = RootGetObject(f, on, error=false);
		RootObject fit = RootGetObject(f, on + "|ff_pol1", error=false);
		if (!hist.valid)
			continue;

		draw(scale(1., 1e4), hist, "d0,eb", blue);
		draw(scale(1., 1e4), fit, "def", red+1pt);

		limits((0.00, -1000), (0.25, +1000), Crop);
	}
}

GShipout("vtx_y_vs_xi_profile_cmp_fill", hSkip=0mm, vSkip=0mm);
