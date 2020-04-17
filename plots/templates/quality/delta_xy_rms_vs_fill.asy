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

AddToLegend("$\De x$", mCi+3pt+blue);
AddToLegend("$\De y$", mCi+3pt+red);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	NewRow();

	NewPadLabel(rp_labels[rpi]);

	NewPad("fill", "RMS of $\De x$ or $\De y\ung{mm}$");

	for (int fi : fills.keys)
	{
		string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
			+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output_validation.root";

		RootObject hist_x = RootGetObject(f, rps[rpi] + "/h_de_x", error=false);
		RootObject hist_y = RootGetObject(f, rps[rpi] + "/h_de_y", error=false);

		if (!hist_x.valid || !hist_y.valid)
			continue;

		real rms_x = hist_x.rExec("GetRMS");
		real rms_y = hist_y.rExec("GetRMS");
	
		mark m = mCi+3pt;

		real x = fi;
		draw((x, rms_x), m+blue);
		draw((x, rms_y), m+red);
	}

	DrawFillMarkers(0, 5e-5);

	limits((-1, 0), (fills.length, 5e-5), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
