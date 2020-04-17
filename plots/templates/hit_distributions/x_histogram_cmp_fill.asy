import root;
import pad_layout;
include "../settings.asy";

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

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int rpi : rps.keys)
	{
		NewPad("$x\ung{mm}$");

		string d = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill) + "_stream_" + stream;

		string f_tracks = d + "/output_tracks.root";
		RootObject hist = RootGetObject(f_tracks, "RP " + rps[rpi] + "/h_x", error=false);

		if (!hist.valid)
			continue;

		draw(hist, "vl", blue);

		xlimits(0., 30., Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
