import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

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
		NewPad("$\xi_{\rm multi}$", "mean of $\th^*_y\ung{\mu rad}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/do_fits.root";
		string on = "multiRPPlots/" + arms[ai] + "/p_th_y_vs_xi";

		RootObject hist = RootGetObject(f, on, error=false);
		RootObject fit = RootGetObject(f, on + "|ff_pol1", error=false);
		if (!hist.valid)
			continue;

		draw(scale(1., 1e6), hist, "d0,eb", blue);
		draw(scale(1., 1e6), fit, "def", red+1pt);

		limits((0.00, -300), (0.25, +300), Crop);
	}
}

GShipout("th_y_vs_xi_profile_cmp_fill", hSkip=0mm, vSkip=0mm);
