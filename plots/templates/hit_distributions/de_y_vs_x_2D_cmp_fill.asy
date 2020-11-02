import root;
import pad_layout;
include "../settings.asy";

xTicksDef = LeftTicks(5., 1.);

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

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ai : arms.keys)
	{
		NewPad("$x_N\ung{mm}$", "$y_F - y_N\ung{mm}$");
		//scale(Linear, Linear, Log);

		string d = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill) + "_stream_" + stream;

		string f_tracks = d + "/output_tracks.root";
		RootObject h2_de_y_vs_x = RootGetObject(f_tracks, "arm " + arms[ai] + "/h2_de_y_vs_x", error=false);

		string f_optics = d + "/output_optics.root";
		RootObject g_disp = RootGetObject(f_optics, "arm " + arms[ai] + "/g_de_y_vs_x_disp", error=false);

		if (!h2_de_y_vs_x.valid || !g_disp.valid)
			continue;

		if (rebin)
			h2_de_y_vs_x.vExec("Rebin2D", 2, 2);

		draw(h2_de_y_vs_x);

		draw(scale(10, 10), g_disp, "l", black+2pt); // conversion from cm to mm

		limits((0, -1.), (25., +1), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
