import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

//xTicksDef = LeftTicks(0.05, 0.01);

TGraph_errorBar = None;

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

//AddToLegend("data, $y$ mean", red);
AddToLegend("data, $y$ mode", red);
AddToLegend("from optics", black+2pt);

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
		RootObject p_y_vs_x = RootGetObject(f_tracks, "RP " + rps[rpi] + "/p_y_vs_x", error=false);

		string f_fit = d + "/do_fits.root";
		RootObject g_y_mode_vs_x = RootGetObject(f_fit, "RP " + rps[rpi] + "/g_y_mode_vs_x", error=false);
		RootObject f_y_mode_vs_x = RootGetObject(f_fit, "RP " + rps[rpi] + "/g_y_mode_vs_x|ff_pol1", error=false);

		string f_optics = d + "/output_optics.root";
		RootObject g_disp = RootGetObject(f_optics, rps[rpi] + "/h_y_vs_x_disp", error=false);

		if (!p_y_vs_x.valid || !g_y_mode_vs_x.valid || !g_disp.valid)
			continue;

		draw(g_disp, "l", black+2pt);

		//draw(p_y_vs_x, "eb", red);

		TF1_x_min = 0.;
		draw(f_y_mode_vs_x, "l", blue+dashed);

		TF1_x_min = -inf; 
		draw(f_y_mode_vs_x, "l", blue);

		draw(g_y_mode_vs_x, "p", red);

		limits((0, -5.), (25., +5), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
