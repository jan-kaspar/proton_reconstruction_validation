import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string arms[], a_labels[];
arms.push("arm0"); a_labels.push("sector 45 (L)");
arms.push("arm1"); a_labels.push("sector 56 (R)");

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

for (int vi : versions.keys)
	AddToLegend(versions[vi], mCi+3pt+StdPen(vi + 1));

AttachLegend();


for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	NewPad("fill", "mean of $\th^*_y\ung{\mu rad}$");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + xangle + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/do_fits.root";
			string on = "multiRPPlots/" + arms[ai] + "/p_th_y_vs_xi|ff_pol1";
		
			RootObject fit = RootGetObject(f, on, error=false);
			if (!fit.valid)
				continue;
		
			real x_min = fit.rExec("GetXmin");
			real x_max = fit.rExec("GetXmax");

			real f_min = fit.rExec("Eval", x_min);
			real f_max = fit.rExec("Eval", x_max);

			real d = (f_max + f_min)/2 * 1e6;
			real d_unc = abs(f_max - f_min)/2 * 1e6;

			mark m = mCi+3pt;

			real x = fi;
			draw((x, d), m+p);
			draw((x, d-d_unc)--(x, d+d_unc), p);
		}
	}

	DrawFillMarkers(-50, +50);

	limits((-1, -50.), (fills.length, +50.), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout("th_y_mean_vs_fill", hSkip=0mm, vSkip=0mm);
