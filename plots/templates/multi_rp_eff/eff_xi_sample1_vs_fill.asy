import root;
import pad_layout;
include "../settings.asy";
include "eff_common.asy";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

AddToLegend("n sigma: " + n_sigma);
AddToLegend("exp. protons: " + n_exp);

for (int vi : versions.keys)
	AddToLegend(versions[vi], mCi+3pt+StdPen(vi + 1));

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	real xi = 0;
	if (arms[ai] == "0") xi = eff_xi_45_sample1;
	if (arms[ai] == "1") xi = eff_xi_56_sample1;

	NewPad("fill", "efficiency at " + format("$\xi = %#.2f$", xi));

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string fill = fills[fi];

			string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
				+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_efficiency.root";

			string base = "arm " + arms[ai];

			RootObject hist = RootGetObject(f, base + "/exp prot " + n_exp + "/nsi = " + n_sigma + "/p_eff" + method + "_vs_xi_N", error=false);

			if (!hist.valid)
				continue;

			int bi = hist.iExec("FindBin", xi);
			real sample = hist.rExec("GetBinContent", bi);

			mark m = mCi+3pt;

			real x = fi;
			draw((x, sample), m+p);
		}
	}

	DrawFillMarkers(0., 1.);

	limits((-1, 0.), (fills.length, 1.), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
