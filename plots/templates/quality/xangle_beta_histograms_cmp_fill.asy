import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);

for (int xai : xangles.keys)
	AddToLegend("xangle " + xangles[xai], StdPen(xai+1));

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int fi : fills_short.keys)
{
	string fill = fills_short[fi];

	NewRow();

	NewPadLabel("fill: " + fill);

	//--------------------

	NewPad("(half) crossing angle$\ung{\mu rad}$", xTicks=LeftTicks(10., 5.));

	for (int xai : xangles.keys)
	{
		string xangle = xangles[xai];

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill)
			+ "_stream_" + stream + "/output_lhcInfo.root";
	
		string on = "h_xangle";

		RootObject hist = RootGetObject(f, on, error=false);
		if (!hist.valid)
			continue;

		draw(hist, "vl", StdPen(xai+1));
	}

	xlimits(110, 190, Crop);

	//--------------------

	NewPad("$\be^*\ung{cm}$", xTicks=LeftTicks(5., 1.));

	for (int xai : xangles.keys)
	{
		string xangle = xangles[xai];

		string f = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill)
			+ "_stream_" + stream + "/output_lhcInfo.root";
	
		string on = "h_betaStar";

		RootObject hist = RootGetObject(f, on, error=false);
		if (!hist.valid)
			continue;

		draw(scale(100, 1), hist, "vl", StdPen(xai+1));
	}

	xlimits(20, 50, Crop);
}

GShipout(hSkip=0mm, vSkip=0mm);
