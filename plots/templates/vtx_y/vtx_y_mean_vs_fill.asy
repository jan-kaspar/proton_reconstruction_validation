import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);

for (int xai : xangles_short.keys)
	AddToLegend("xangle = " + xangles_short[xai], xa_marks[xai] + 3pt);

for (int vi : versions.keys)
	AddToLegend(replace(versions[vi], "_", "\_"), StdPen(vi + 1)+1pt);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	NewPad("fill", "mean of $y^*\ung{\mu m}$");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int xai : xangles_short.keys)
		{
			string xangle = xangles_short[xai];
			mark m = xa_marks[xai]+3pt;

			for (int fi : fills.keys)
			{
				string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + xangle + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/do_fits.root";
				string on = "multiRPPlots/" + arms[ai] + "/p_vtx_y_vs_xi|ff_pol1";
			
				RootObject fit = RootGetObject(f, on, error=false);
				if (!fit.valid)
					continue;
			
				real x_min = fit.rExec("GetXmin");
				real x_max = fit.rExec("GetXmax");

				real f_min = fit.rExec("Eval", x_min);
				real f_max = fit.rExec("Eval", x_max);

				real d = (f_max + f_min)/2 * 1e4;
				real d_unc = abs(f_max - f_min)/2 * 1e4;

				real x = fi;
				draw((x, d), m+p);
				draw((x, d-d_unc)--(x, d+d_unc), p);
			}
		}
	}

	DrawFillMarkers(-100, +100);

	limits((-1, -100.), (fills.length, +100.), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout(hSkip=0mm, vSkip=0mm);
