import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

string cols[], c_labels[], c_si_rps[];
cols.push("arm0"); c_labels.push("sector 45 (L)"); c_si_rps.push("rp23");
cols.push("arm1"); c_labels.push("sector 56 (R)"); c_si_rps.push("rp123");

xTicksDef = LeftTicks(100., 50.);

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
		NewPad("$\th^*_x\ung{\mu rad}$");

		for (int xai : xangles_short.keys)
		{
			string xangle = xangles_short[xai];

			string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/" + cols[ci] + "/h_th_x";
			
			RootObject hist = RootGetObject(f, on, error=false);

			if (!hist.valid)
				continue;
			
			draw(scale(1e6, 1), hist, "vl", xa_pens[xai]);
		}

		xlimits(-200., +200., Crop);
	}
}

GShipout(hSkip=1mm, vSkip=0mm);
