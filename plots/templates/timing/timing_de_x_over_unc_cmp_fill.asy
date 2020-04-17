import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

xTicksDef = LeftTicks(2., 1.);

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
		NewPad("($x_{\rm timing} - x_{\rm tracking}) / \si(x)$");
		//scale(Linear, Log);

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/arm" + arms[ai] + "/h_de_x_rel_timing_vs_tracking_ClCo";

		RootObject hist = RootGetObject(f, on, error=false);
		if (!hist.valid)
			continue;

		draw(hist, "vl", blue);

		xlimits(-4, 4., Crop);

		yaxis(XEquals(-1., false), red+1pt);
		yaxis(XEquals(+1., false), red+1pt);

		yaxis(XEquals(-1.5, false), heavygreen+1pt);
		yaxis(XEquals(+2.0, false), heavygreen+1pt);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
