import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);
AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ai : arms.keys)
	{
		NewPad("$x_F - x_N\ung{mm}$", "");

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_efficiency.root";

		string base = "arm " + arms[ai];

		RootObject hist = RootGetObject(f, base + "/h_de_x", error=false);
		RootObject fit = RootGetObject(f, base + "/h_de_x|ff", error=false);

		if (!hist.valid || !fit.valid)
			continue;

		draw(hist, "vl", blue);
		draw(fit, "l", red+1pt);

		xlimits(-1., +1., Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
