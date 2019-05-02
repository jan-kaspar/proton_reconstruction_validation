import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string arms[], a_labels[];
arms.push("arm0"); a_labels.push("sector 45 (L)");
arms.push("arm1"); a_labels.push("sector 56 (R)");

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

for (int vi : versions.keys)
	AddToLegend(versions[vi], mCi+3pt+StdPen(vi + 1));

AttachLegend();


for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	NewPad("fill", "$\log_{10}(\ch^2)$ (mean $\pm$ RMS)");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + xangle + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/" + arms[ai] + "/h_log_chi_sq";
		
			RootObject fit = RootGetObject(f, on, error=false);
			if (!fit.valid)
				continue;
		
			real mean = fit.rExec("GetMean");
			real rms = fit.rExec("GetRMS");

			if (rms == 0.)
				continue;

			mark m = mCi+3pt;

			real x = fi;
			draw((x, mean), m+p);
			draw((x, mean-rms)--(x, mean+rms), p);
		}
	}

	DrawFillMarkers(-15, -5);

	limits((-1, -15), (fills.length, -5), Crop);
}

GShipout("chi_sq_mean_vs_fill", hSkip=0mm, vSkip=0mm);
