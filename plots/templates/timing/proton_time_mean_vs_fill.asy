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

for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	NewPad("fill", "mean proton time");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string f = topDir + "data/" + version + "/" + year + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle) + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/arm" + arms[ai] + "/h_time";
		
			RootObject hist = RootGetObject(f, on, error=false);
			if (!hist.valid)
				continue;

			int bins = hist.iExec("GetNbinsX");
		
			// entries without under- and over-flow
			real entries = hist.rExec("GetEntries") - hist.rExec("GetBinContent", 0) - hist.rExec("GetBinContent", bins);

			real mean = hist.rExec("GetMean");

			mark m = (entries > 0) ? mCi+3pt : mCr + 5pt;

			real x = fi;
			draw((x, mean), m+p);
		}
	}

	DrawFillMarkers(-1., 1.);

	limits((-1, -1.), (fills.length, 1.), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
