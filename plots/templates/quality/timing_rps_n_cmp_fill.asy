import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//xTicksDef = LeftTicks(0.05, 0.01);

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
		NewPad("number of contributing timing-RP tracks");
		//scale(Linear, Log);

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/" + arms[ai] + "/h_n_contrib_timing_tracks";

		RootObject hist = RootGetObject(f, on, error=false);
		if (!hist.valid)
			continue;

		draw(hist, "vl", blue);

		//xlimits(0, 10., Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
