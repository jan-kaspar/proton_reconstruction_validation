import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);

for (int xai : xangles_short.keys)
	AddToLegend("xangle = " + xangles_short[xai], xa_pens[xai]);

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
		NewPad("$\xi_{\rm multi}$", "mean of $\th^*_y\ung{\mu rad}$");

		for (int xai : xangles_short.keys)
		{
			string xangle = xangles_short[xai];
			pen p = xa_pens[xai];

			string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/do_fits.root";
			string on = "multiRPPlots/arm" + arms[ai] + "/p_th_y_vs_xi";

			RootObject hist = RootGetObject(f, on, error=false);
			RootObject fit = RootGetObject(f, on + "|ff_pol1", error=false);
			if (!hist.valid)
				continue;

			draw(scale(1., 1e6), hist, "d0,eb", p);

			if (fit.valid)
			{
				string l = format("slope = %#.3f", fit.rExec("GetParameter", 1) * 1e6);
				draw(scale(1., 1e6), fit, "def", p+1pt);
			}
		}

		limits((0.00, -300), (0.25, +300), Crop);

		AttachLegend();
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
