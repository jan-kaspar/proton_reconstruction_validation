import root;
import pad_layout;
include "../settings.asy";
include "eff_common.asy";

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

AddToLegend("exp. protons: " + n_exp);
AddToLegend("n sigma: " + n_sigma);
AddToLegend("version: " + version);

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
		NewPad("$x_N\ung{mm}$", "$y_N\ung{mm}$");

		string base = "arm " + arms[ai];
		
		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_efficiency.root";

		RootObject prof = RootGetObject(f, base + "/exp prot " + n_exp + "/nsi = " + n_sigma + "/p_eff" + method + "_vs_x_N_y_N", error=false);

		if (!prof.valid)
			continue;

		TH2_z_min = 0.5;
		TH2_z_max = 1.0;

		draw(prof);

		limits((0, -15), (25., +15.), Crop);
	}
}

GShipout(hSkip=5mm, vSkip=0mm);
