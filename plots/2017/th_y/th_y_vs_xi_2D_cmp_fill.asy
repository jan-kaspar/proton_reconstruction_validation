import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[];
real c_xi0s[], c_as[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_xi0s.push(0.153); c_as.push(-230);
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_xi0s.push(0.19); c_as.push(-330);

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//----------------------------------------------------------------------------------------------------

NewPad(false);
label("\vbox{\hbox{version: " + version + "}\hbox{stream: " + stream + "}\hbox{xangle: " + xangle + "}\hbox{beta: " + beta + "}}");

for (int ci : cols.keys)
	NewPadLabel(c_labels[ci]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ci : cols.keys)
	{
		NewPad("$\xi_{\rm multi}$", "$\th^*_y\ung{\mu rad}$");

		string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
		string on = "multiRPPlots/" + cols[ci] + "/h2_th_y_vs_xi";

		RootObject obj = RootGetObject(f, on, error=false);
		if (!obj.valid)
			continue;

		obj.vExec("Rebin2D", 2, 2);

		draw(scale(1., 1e6), obj);

		real y_min = -300e-6, x_cut_min = c_xi0s[ci] + c_as[ci] * y_min;
		real y_max = +300e-6, x_cut_max = c_xi0s[ci] + c_as[ci] * y_max;

		//draw((x_cut_min, y_min*1e6)--(x_cut_max, y_max*1e6), magenta+2pt);

		limits((0.00, -300), (0.25, +300), Crop);
	}
}

GShipout("th_y_vs_xi_2D_cmp_fill", hSkip=0mm, vSkip=0mm);
