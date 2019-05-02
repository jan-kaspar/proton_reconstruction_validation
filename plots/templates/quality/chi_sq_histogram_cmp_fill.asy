import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[];
cols.push("arm0"); c_labels.push("sector 45 (L)");
cols.push("arm1"); c_labels.push("sector 56 (R)");

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//xTicksDef = LeftTicks(0.05, 0.01);

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
		NewPad("$\log_{10}(\ch^2)$");
		//scale(Linear, Log);

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/" + cols[ci] + "/h_log_chi_sq";

		RootObject hist = RootGetObject(f, on, error=false);
		if (!hist.valid)
			continue;

		draw(hist, "vl", blue);

		xlimits(-20., 5., Crop);
	}
}

GShipout("chi_sq_histogram_cmp_fill", hSkip=0mm, vSkip=0mm);
