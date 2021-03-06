import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("xangle: " + xangle);
AddToLegend("beta: " + beta);
AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ai : arms.keys)
	{
		NewPad("$\xi_{\rm multi}$", "$\th^*_x\ung{\mu rad}$");

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle)
			+ "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/arm" + arms[ai] + "/h2_th_x_vs_xi";

		RootObject obj = RootGetObject(f, on, error=true);
		if (!obj.valid)
			continue;

		if (rebin)
			obj.vExec("Rebin2D", 2, 2);

		draw(scale(1., 1e6), obj);

		//real y_min = -300e-6, x_cut_min = c_xi0s[ci] + c_as[ci] * y_min;
		//real y_max = +300e-6, x_cut_max = c_xi0s[ci] + c_as[ci] * y_max;
		//draw((x_cut_min, y_min*1e6)--(x_cut_max, y_max*1e6), magenta+2pt);

		limits((0.00, -300), (0.25, +300), Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
