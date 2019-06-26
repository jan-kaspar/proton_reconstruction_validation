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

	NewPad("fill", "fraction of reco.~protons with timing");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + xangle + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/" + arms[ai] + "/h_n_timing_RPs";
		
			RootObject hist = RootGetObject(f, on, error=false);
			if (!hist.valid)
				continue;
		
			real entries = hist.rExec("GetEntries");
			int empty_bin = hist.iExec("FindBin", 0.);
			real empty = hist.rExec("GetBinContent", empty_bin);
			real non_empty_ratio = (entries > 0) ? (entries - empty) / entries : 0.;

			mark m = mCi+3pt;

			real x = fi;
			draw((x, non_empty_ratio), m+p);
		}
	}

	DrawFillMarkers(0, 1.);

	limits((-1, 0), (fills.length, 1.), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout(hSkip=0mm, vSkip=0mm);
