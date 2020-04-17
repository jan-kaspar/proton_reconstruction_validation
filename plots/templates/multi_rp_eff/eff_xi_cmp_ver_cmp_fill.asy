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
AddToLegend("n sigma: " + n_sigma);

for (int vi : versions.keys)
	AddToLegend(versions[vi], StdPen(vi + 1));

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

		string base = "arm " + arms[ai];
		
		for (int vi : versions.keys)
		{
			version = versions[vi];

			pen p = StdPen(vi + 1);

			string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
				+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_efficiency.root";

			RootObject hist = RootGetObject(f, base + "/exp prot " + n_exp + "/nsi = " + n_sigma + "/p_eff" + method + "_vs_xi_N", error=false);

			if (!hist.valid)
				continue;

			draw(hist, "vl", p);
		}

		limits((0, 0), (0.25, 1.1), Crop);
	}
}

GShipout(hSkip=5mm, vSkip=0mm);
