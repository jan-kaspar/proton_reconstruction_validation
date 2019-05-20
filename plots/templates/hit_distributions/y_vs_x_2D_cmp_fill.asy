import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

//xTicksDef = LeftTicks(0.05, 0.01);

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

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int rpi : rps.keys)
	{
		NewPad("$x\ung{mm}$", "$y\ung{mm}$");
		scale(Linear, Linear, Log);

		string d = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream;

		string f_tracks = d + "/output_tracks.root";
		RootObject h2_y_vs_x = RootGetObject(f_tracks, "RP " + rps[rpi] + "/h2_y_vs_x", error=false);

		string f_optics = d + "/output_optics.root";
		RootObject g_disp = RootGetObject(f_optics, rps[rpi] + "/h_y_vs_x_disp", error=false);

		if (!h2_y_vs_x.valid || !g_disp.valid)
			continue;

		if (rebin)
			h2_y_vs_x.vExec("Rebin2D", 3, 3);

		draw(h2_y_vs_x);
		draw(g_disp, "l", black+2pt);

		limits((0, -5.), (25., +5), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
