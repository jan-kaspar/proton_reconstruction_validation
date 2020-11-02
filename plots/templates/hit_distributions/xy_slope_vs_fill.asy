import root;
import pad_layout;
include "../settings.asy";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

for (int vi : versions.keys)
	AddToLegend(versions[vi], mCi+3pt+StdPen(vi + 1));

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	NewRow();

	NewPadLabel(rp_labels[rpi]);

	NewPad("fill", "intercept of $y\ung{mm}$");

	for (int fi : fills.keys)
	{
		for (int vi : versions.keys)
		{
			version = versions[vi];
			pen p = StdPen(vi + 1);

			string f = topDir + "data/" + version + "/" + year + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
				+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/do_fits.root";

			RootObject f_y_mode_vs_x = RootGetObject(f, "RP " + rps[rpi] + "/g_y_mode_vs_x|ff_pol1", error=false);

			if (!f_y_mode_vs_x.valid)
				continue;

			real s = f_y_mode_vs_x.rExec("GetParameter", 1);
			real s_unc = f_y_mode_vs_x.rExec("GetParError", 1);
		
			mark m = mCi+3pt;

			real x = fi;
			draw((x, s), m+p);
			draw((x, s - s_unc)--(x, s + s_unc), p);
		}
	}

	DrawFillMarkers(0.1, 0.5);

	limits((-1, 0.1), (fills.length, 0.5), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
