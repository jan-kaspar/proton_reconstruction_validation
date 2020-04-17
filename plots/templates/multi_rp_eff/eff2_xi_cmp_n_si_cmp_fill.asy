import root;
import pad_layout;
include "../settings.asy";
include "eff_common.asy";

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

AddToLegend("exp. protons: " + n_exp);

for (int nsi : n_sigmas.keys)
	AddToLegend(n_sigmas[nsi] + " sigma", StdPen(nsi));

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
		NewPad("$\xi_{si,N}$", "efficiency");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_efficiency.root";

		string base = "arm " + arms[ai];

		for (int nsi : n_sigmas.keys)
		{
			RootObject hist = RootGetObject(f, base + "/exp prot " + n_exp + "/nsi = " + n_sigmas[nsi] + "/p_eff2_vs_xi_N", error=false);

			if (!hist.valid)
				continue;

			draw(hist, "vl", StdPen(nsi));
		}

		limits((0, 0), (0.25, 1.1), Crop);
	}
}

GShipout(hSkip=5mm, vSkip=0mm);
