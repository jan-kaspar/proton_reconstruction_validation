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
		NewPad("num.~of multi-RP reco protons", "\vbox{\hbox{num.~of timing-RP tracks}\hbox{(same arm as proton, per event)}}");
		//scale(Linear, Log);

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/" + arms[ai] + "/h2_timing_tracks_vs_prot_mult";

		RootObject hist = RootGetObject(f, on, error=false);
		if (!hist.valid)
			continue;

		draw(hist, "p,bar,t");

		limits((-0.5, -0.5), (5.5, 10.5), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
