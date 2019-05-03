import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

xTicksDef = LeftTicks(100., 50.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);

for (int xai : xangles_short.keys)
	AddToLegend("xangle = " + xangles_short[xai], xa_pens[xai]);

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
		NewPad("$\th^*_y\ung{\mu rad}$");

		for (int xai : xangles_short.keys)
		{
			string xangle = xangles_short[xai];

			string f = topDir + "data/" + year + "/" + version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + GetBeta(fill) + "_stream_" + stream + "/output.root";
			string on = "multiRPPlots/" + arms[ai] + "/h_th_y";
			
			RootObject hist = RootGetObject(f, on, error=false);

			if (!hist.valid)
				continue;
			
			draw(scale(1e6, 1), hist, "vl", xa_pens[xai]);
		}

		xlimits(-200., +200., Crop);
	}
}

GShipout(hSkip=1mm, vSkip=0mm);
