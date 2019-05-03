import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(0.05, 0.01);
yTicksDef = RightTicks(0.05, 0.01);

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
		NewPad("$\xi_{\rm single,N}$", "$\xi_{\rm single,F}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "armCorrelationPlots/" + arms[ai] + "/h2_xi_si_F_vs_xi_si_N";
		
		RootObject hist = RootGetObject(f, on, error=true);

		if (!hist.valid)
			continue;

		hist.vExec("Rebin2D", 2, 2);
		
		draw(hist);

		draw((0, 0)--(0.25, 0.25), dashed);

		limits((0., 0.), (0.25, 0.25), Crop);
	}
}

GShipout("xi_si_F_vs_si_N_cmp_fill", hSkip=1mm, vSkip=0mm);
