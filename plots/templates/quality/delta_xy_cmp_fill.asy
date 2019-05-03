import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

//xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);
AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int rpi : rps.keys)
	{
		NewPad("$\De x$, $\De y\ung{mm}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output_validation.root";

		RootObject hist_x = RootGetObject(f, rps[rpi] + "/h_de_x", error=false);
		RootObject hist_y = RootGetObject(f, rps[rpi] + "/h_de_y", error=false);

		if (!hist_x.valid || !hist_y.valid)
			continue;

		real rms_x = hist_x.rExec("GetRMS");
		real rms_y = hist_y.rExec("GetRMS");

		draw(hist_x, "vl", blue, format("$\De x$, RMS = $%.2E$", rms_x));
		draw(hist_y, "vl", red, format("$\De y$, RMS = $%.2E$", rms_y));

		xlimits(-1., 1., Crop);

		AttachLegend();
	}
}

GShipout("delta_xy_cmp_fill", hSkip=0mm, vSkip=0mm);
