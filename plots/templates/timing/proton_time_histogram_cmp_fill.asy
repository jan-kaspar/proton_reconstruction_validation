import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

for (int vi : versions.keys)
	AddToLegend(versions[vi], StdPen(vi + 1));

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
		NewPad("proton time");
		//scale(Linear, Log);

		for (int vi : versions.keys)
		{
			version = versions[vi];
			pen p = StdPen(vi + 1);

			string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
				+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/arm" + arms[ai] + "/h_time";

			RootObject hist = RootGetObject(f, on, error=false);
			if (!hist.valid)
				continue;

			draw(hist, "vl", p);
		}

		//xlimits(-5, 5., Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
