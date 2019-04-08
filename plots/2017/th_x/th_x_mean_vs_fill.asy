import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string arms[], a_labels[];
arms.push("arm0"); a_labels.push("sector 45 (L)");
arms.push("arm1"); a_labels.push("sector 56 (R)");

//----------------------------------------------------------------------------------------------------

string TickLabels(real x)
{
	if (x >=0 && x < fills.length)
	{
		int ix = (int) x;
		return fills[ix];
	} else {
		return "";
	}
}

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
label("\vbox{\hbox{version: " + version + "}\hbox{stream: " + stream + "}\hbox{xangle: " + xangle + "}\hbox{beta: " + beta + "}}");

for (int ai : arms.keys)
{
	NewRow();

	NewPadLabel(a_labels[ai]);

	NewPad("fill", "mean of $\th^*_x\ung{\mu rad}$");

	for (int fi : fills.keys)
	{
		string f = topDir + "data/" + year + "/" + version + "/fill_" + fills[fi] + "/xangle_" + xangle + "_beta_" + beta + "_stream_" + stream + "/do_fits.root";
		string on = "multiRPPlots/" + arms[ai] + "/p_th_x_vs_xi|ff";
	
		RootObject obj = RootGetObject(f, on, error=false);
		if (!obj.valid)
			continue;
	
		real d = obj.rExec("GetParameter", 0) * 1e6;
		real d_unc = obj.rExec("GetParError", 0) * 1e6;

		mark m = mCi;
		pen p = red;

		real x = fi;
		draw((x, d), m+p);
		draw((x, d-d_unc)--(x, d+d_unc), p);
	}

	limits((-1, -80.), (fills.length, +80.), Crop);

	xaxis(YEquals(0., false), dashed);
}

GShipout("th_x_mean_vs_fill", hSkip=0mm, vSkip=0mm);
