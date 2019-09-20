import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

xTicksDef = LeftTicks(0.05, 0.01);

TGraph_errorBar = None;

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
		NewPad("$\xi_{\rm multi}$", "$\th^*_x\ung{\mu rad}$");

		string d = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill) + "_stream_" + stream;

		string f_output = d + "/output.root";
		RootObject hist = RootGetObject(f_output, "multiRPPlots/" + arms[ai] + "/h2_th_x_vs_xi", error=false);

		string f_fit = d + "/do_fits.root";
		RootObject g_aperture = RootGetObject(f_fit, "multiRPPlots/" + arms[ai] + "/g_aperture", error=false);
		RootObject f_aperture = RootGetObject(f_fit, "multiRPPlots/" + arms[ai] + "/g_aperture|ff_aperture_fit", error=false);

		if (!hist.valid)
			continue;

		if (rebin)
			hist.vExec("Rebin2D", 2, 2);

		draw(scale(1., 1e6), hist);

		if (f_aperture.valid)
		{
			draw(scale(1., 1e6), g_aperture, "p", black);
			draw(scale(1., 1e6), f_aperture, magenta+1pt);
		}

		limits((0.00, -300), (0.25, +300), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
