import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(0.05, 0.01);

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
		NewPad("$\xi_{\rm multi}$", "$\xi_{\rm single,F} - \xi_{\rm single,N}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "armCorrelationPlots/" + arms[ai] + "/h2_xi_si_diffNF_vs_xi_mu";
		
		RootObject hist = RootGetObject(f, on, error=false);

		if (!hist.valid)
			continue;
		
		draw(hist);

		limits((0., -0.02), (0.25, +0.02), Crop);
	}
}

GShipout(hSkip=1mm, vSkip=0mm);
