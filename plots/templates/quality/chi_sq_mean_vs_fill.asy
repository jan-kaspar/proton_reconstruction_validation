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

	NewPad("fill", "$\log_{10}(\ch^2)$ (mean $\pm$ RMS)");

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
				string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle)
					+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";
				string on = "multiRPPlots/arm" + arms[ai] + "/h_log_chi_sq";
			
				RootObject fit = RootGetObject(f, on, error=false);
				if (!fit.valid)
					continue;
			
				real mean = fit.rExec("GetMean");
				real rms = fit.rExec("GetRMS");

				if (rms == 0.)
					continue;


				real x = fi;
				draw((x, mean), m+p);
				draw((x, mean-rms)--(x, mean+rms), p);
			}
		}
	}

	DrawFillMarkers(-15, -5);

	limits((-1, -15), (fills.length, -5), Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
