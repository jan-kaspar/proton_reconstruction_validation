import root;
import pad_layout;
include "../settings.asy";

//xTicksDef = LeftTicks(0.05, 0.01);

TH2_palette = Gradient(blue, heavygreen, yellow, red);

TH2_x_min = 0;
TH2_x_max = 25;
TH2_y_min = -7.;
TH2_y_max = +7.;

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

		string d = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill) + "_stream_" + stream;

		string f_tracks = d + "/output_tracks.root";
		RootObject h2_y_vs_x = RootGetObject(f_tracks, "RP " + rps[rpi] + "/h2_y_vs_x", error=false);

		string f_optics = d + "/output_optics.root";
		RootObject g_disp = RootGetObject(f_optics, rps[rpi] + "/h_y_vs_x_disp", error=false);

		if (!h2_y_vs_x.valid || !g_disp.valid)
			continue;

		if (rebin)
			h2_y_vs_x.vExec("Rebin2D", 2, 2);

		draw(h2_y_vs_x);

		draw(scale(10, 10), g_disp, "l", black+2pt); // conversion from cm to mm

		limits((0, -7.), (25., +7), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
