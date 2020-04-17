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

	NewPad("fill", "mean of $x\ung{mm}$");

	for (int fi : fills.keys)
	{
		for (int vi : versions.keys)
		{
			version = versions[vi];
			pen p = StdPen(vi + 1);

			string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
				+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output_tracks.root";

			RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h_y", error=false);

			mark m = mCi;
			real mean = 0;

			if (hist.valid)
			{
				mean = hist.rExec("GetMean");
				m = mCi + 3pt;
			} else {
				mean = 0;
				m = mCr + 5pt;
			}

			real x = fi;
			draw((x, mean), m+p);
		}
	}

	DrawFillMarkers(-5, +5);

	limits((-1, -5), (fills.length, +5), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
