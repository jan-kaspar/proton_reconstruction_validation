import root;
import pad_layout;
include "../settings.asy";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(50., 10.);

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

for (int rpi : rps.keys)
{
	NewRow();

	NewPadLabel(rp_labels[rpi]);

	NewPad("fill", "mean of $\xi_{\rm single} - \xi_{\rm multi}$");

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
					+ "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/do_fits.root";
				string on = "singleMultiCorrelationPlots/si_rp" + rps[rpi]  + "_mu_" + rp_arms[rpi] + "/p_xi_diff_si_mu_vs_xi_mu|ff_pol1";
			
				RootObject fit = RootGetObject(f, on, error=false);
				if (!fit.valid)
					continue;
			
				real x_min = fit.rExec("GetXmin");
				real x_max = fit.rExec("GetXmax");

				real f_min = fit.rExec("Eval", x_min);
				real f_max = fit.rExec("Eval", x_max);

				real d = (f_max + f_min)/2;
				real d_unc = abs(f_max - f_min)/2;

				real x = fi;
				draw((x, d), m+p);
				draw((x, d-d_unc)--(x, d+d_unc), p);
			}
		}
	}

	DrawFillMarkers(-0.02, +0.02);

	limits((-1, -0.02), (fills.length, +0.02), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout(hSkip=1mm, vSkip=0mm);
