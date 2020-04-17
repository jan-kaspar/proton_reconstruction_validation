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

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/arm" + arms[ai] + "/h2_th_y_vs_xi";

		RootObject obj = RootGetObject(f, on, error=false);
		if (!obj.valid)
			continue;

		if (rebin)
			obj.vExec("Rebin2D", 2, 2);

		draw(scale(1., 1e6), obj);

		limits((0.00, -300), (0.25, +1000), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
