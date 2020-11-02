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

	NewPad("fill", "fraction of invalid multi-RP protons");
	scale(Linear, Log);

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
				string f = topDir + "data/" + version + "/" + year + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
					+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";
				string on = "multiRPPlots/arm" + arms[ai] + "/h_valid";
			
				RootObject hist = RootGetObject(f, on, error=false);
				if (!hist.valid)
					continue;

				int bin_0 = hist.iExec("FindBin", 0.);
				real n_0 = hist.rExec("GetBinContent", bin_0);

				int bin_1 = hist.iExec("FindBin", 1.);
				real n_1 = hist.rExec("GetBinContent", bin_1);
			
				real n = n_0 + n_1;

				if (n <= 0. || n_0 <= 0.)
					continue;

				real frac = n_0 / n;

				real x = fi;
				draw(Scale((x, frac)), m+p);
			}
		}
	}

	DrawFillMarkers(-8, 0);

	limits((-1, 1e-8), (fills.length, 1e0), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
