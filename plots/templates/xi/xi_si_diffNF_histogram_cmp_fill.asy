import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[], c_si_rps[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_si_rps.push("rp23");
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_si_rps.push("rp123");

xTicksDef = LeftTicks(0.01, 0.005);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);

for (int xai : xangles_short.keys)
	AddToLegend("xangle = " + xangles_short[xai], xa_pens[xai]);

AttachLegend();

for (int ci : cols.keys)
	NewPadLabel(c_labels[ci]);

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	for (int ci : cols.keys)
	{
		NewPad("$\xi_{\rm single,F} - \xi_{\rm single,N}$");

		for (int xai : xangles_short.keys)
		{
			string xangle = xangles_short[xai];

			string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
			string on = "armCorrelationPlots/" + cols[ci] + "/h_xi_si_diffNF";
			
			RootObject hist = RootGetObject(f, on, error=false);

			if (!hist.valid)
				continue;
			
			draw(hist, "vl", xa_pens[xai]);
		}

		xlimits(-0.02, +0.02, Crop);
	}
}

GShipout("xi_si_diffNF_histogram_cmp_fill", hSkip=1mm, vSkip=0mm);
