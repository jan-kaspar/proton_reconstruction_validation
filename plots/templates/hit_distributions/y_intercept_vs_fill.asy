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
AddToLegend("version: " + version);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	NewRow();

	NewPadLabel(rp_labels[rpi]);

	NewPad("fill", "intercept of $y\ung{mm}$");

	for (int fi : fills.keys)
	{
		string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
			+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/do_fits.root";

		RootObject f_y_mode_vs_x = RootGetObject(f, "RP " + rps[rpi] + "/g_y_mode_vs_x|ff_pol1", error=false);

		if (!f_y_mode_vs_x.valid)
			continue;

		real i = f_y_mode_vs_x.rExec("GetParameter", 0);
		real i_unc = f_y_mode_vs_x.rExec("GetParError", 0);
	
		mark m = mCi+3pt;

		real x = fi;
		draw((x, i), m+red);
		draw((x, i - i_unc)--(x, i + i_unc), red);
	}

	DrawFillMarkers(-1, +1);

	limits((-1, -1), (fills.length, +1), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
