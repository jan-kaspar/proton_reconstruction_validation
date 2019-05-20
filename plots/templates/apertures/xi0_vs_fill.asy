import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(10., 5.);

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

	NewPad("fill", "$\xi_0$");

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
				string on = "multiRPPlots/" + arms[ai] + "/g_aperture|ff_aperture_fit";
				RootObject fit = RootGetObject(f, on, error=false);
				if (!fit.valid)
					continue;
			
				real xi0 = fit.rExec("GetParameter", 0);
				real xi0_unc = fit.rExec("GetParError", 0);

				real x = fi;
				draw((x, xi0), m+p);
				draw((x, xi0-xi0_unc)--(x, xi0+xi0_unc), p);
			}
		}
	}

	DrawFillMarkers(0.10, 0.20);

	limits((-1, 0.10), (fills.length, +0.20), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
