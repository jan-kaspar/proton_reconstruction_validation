import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[], c_si_rps[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_si_rps.push("rp23");
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_si_rps.push("rp123");

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(50., 10.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);

for (int vi : versions.keys)
	AddToLegend(versions[vi], mCi+3pt+StdPen(vi + 1));

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ci : cols.keys)
{
	NewRow();

	NewPadLabel(c_labels[ci]);

	NewPad("fill", "mean of $\xi_{\rm single} - \xi_{\rm multi}$");

	for (int vi : versions.keys)
	{
		pen p = StdPen(vi + 1);
		string version = versions[vi];

		for (int fi : fills.keys)
		{
			string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + xangle + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream + "/do_fits.root";
			string on = "singleMultiCorrelationPlots/si_" + c_si_rps[ci]  + "_mu_" + cols[ci] + "/p_xi_diff_si_mu_vs_xi_mu|ff";
		
			RootObject obj = RootGetObject(f, on, error=false);
			if (!obj.valid)
				continue;
		
			real d = obj.rExec("GetParameter", 0);
			real d_unc = obj.rExec("GetParError", 0);

			mark m = mCi+3pt;

			real x = fi;
			draw((x, d), m+p);
			draw((x, d-d_unc)--(x, d+d_unc), p);
		}
	}

	DrawFillMarkers(-0.02, +0.02);

	limits((-1, -0.02), (fills.length, +0.02), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout("xi_mu_si_diff_mean_vs_fill", hSkip=1mm, vSkip=0mm);
