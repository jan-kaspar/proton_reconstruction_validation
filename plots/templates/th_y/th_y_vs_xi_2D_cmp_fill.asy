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
		NewPad("$\xi_{\rm multi}$", "$\th^*_y\ung{\mu rad}$");

		string dir = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream;

		string base = "multiRPPlots/arm" + arms[ai];

		RootObject hist = RootGetObject(dir + "/output.root", base+"/h2_th_y_vs_xi", error=false);
		RootObject prof = RootGetObject(dir + "/do_fits.root", base+"/p_th_y_vs_xi", error=false);

		if (!hist.valid)
			continue;

		if (rebin)
			hist.vExec("Rebin2D", 2, 2);

		draw(scale(1., 1e6), hist);

		if (prof.valid)
			draw(scale(1., 1e6), prof, "vl", black);

		limits((0.00, -300), (0.25, +300), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
