import root;
import pad_layout;
include "../settings.asy";
include "eff_common.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

for (int nsi : n_sigmas.keys)
	AddToLegend(n_sigmas[nsi] + " sigma", StdPen(nsi+3));

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
		NewPad("$x_F - x_N\ung{mm}$", "$y_F - y_N\ung{mm}$");

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_efficiency.root";

		string base = "arm " + arms[ai];

		RootObject hist = RootGetObject(f, base + "/h2_de_y_vs_de_x", error=false);

		if (!hist.valid)
			continue;

		if (rebin)
			hist.vExec("Rebin2D", 2, 2);

		draw(hist);

		for (int nsi : n_sigmas.keys)
		{
			RootObject g = RootGetObject(f, base + "/g_de_y_vs_de_x_n_si=" + n_sigmas[nsi]);
			draw(g, "l", StdPen(nsi+3)+1pt);
		}

		limits((-1., -1.), (+1., +1.), Crop);
	}
}

GShipout(hSkip=5mm, vSkip=0mm);
