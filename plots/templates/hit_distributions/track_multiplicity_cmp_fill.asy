import root;
import pad_layout;
include "../settings.asy";

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
		NewPad("LS", "mean track multiplicity");
		//scale(Linear, Log);

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_tracks.root";

		RootObject test = RootGetObject(f, "arm " + arms[ai], error=false);
		if (!test.valid)
			continue;

		int idx = 0;
		for (string on : RootGetListOfObjects(f, "arm " + arms[ai]))
		{
			if (find(on, "g_mean_track") != 0)
				continue;

			pen p = StdPen(++idx);

			string l = "run " + substr(on, 22);

			draw(RootGetObject(f, "arm " + arms[ai] + "/" + on), "l", p, l);
		}

		//xlimits(0, 10., Crop);

		AttachLegend(SE, SE);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
