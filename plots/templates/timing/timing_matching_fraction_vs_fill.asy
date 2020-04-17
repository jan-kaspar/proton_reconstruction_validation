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

	NewPad("fill", "fr.~of timing tr.~matching multi-RP pr.");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle) + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/arm" + arms[ai] + "/h_de_x_match_timing_vs_tracking_ClCo";
		
			RootObject hist = RootGetObject(f, on, error=false);
			if (!hist.valid)
				continue;
		
			real n_no_match = hist.rExec("GetBinContent", 1);
			real n_match = hist.rExec("GetBinContent", 2);
			real den = n_no_match + n_match;

			real ratio = (den > 0) ? n_match / den : 0.;

			mark m = mCi+3pt;

			real x = fi;
			draw((x, ratio), m+p);
		}
	}

	DrawFillMarkers(0, 1.);

	limits((-1, 0), (fills.length, 1.), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout(hSkip=0mm, vSkip=0mm);
