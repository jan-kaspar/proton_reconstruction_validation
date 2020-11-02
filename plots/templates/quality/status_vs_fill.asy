import root;
import pad_layout;
include "../settings.asy";

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

xSizeDef = xSizeDefFill;

//yTicksDef = RightTicks(10., 5.);

//----------------------------------------------------------------------------------------------------

string TickLabelsY(real y)
{
	if (y >=0 && y < xangles.length)
	{
		int iy = (int) y;
		return xangles[iy];
	} else {
		return "";
	}
}

yTicksDef = RightTicks(Label(""), TickLabelsY, Step=1, step=0);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);
AddToLegend("version: " + version);

AttachLegend();

//----------------------------------------------------------------------------------------------------

NewPad("fill", "xangle");

for (int xai : xangles.keys)
{
	string xangle = xangles[xai];

	for (int fi : fills.keys)
	{
		string dir = topDir + "data/" + version + "/" + year + "/fill_" + fills[fi] + "/xangle_" + GetXangle(fills[fi], xangle) + "_beta_" + GetBeta(fills[fi]) + "_stream_" + stream;
		file f_submitted = input(dir + "/submitted", check=false);
		file f_success = input(dir + "/success", check=false);
	
		bool submitted = ! error(f_submitted);
		bool success = ! error(f_success);

		if (submitted && !success)
			draw((fi, xai), mCi+3pt + red);

		if (success)
			draw((fi, xai), mCi+3pt + heavygreen);
	}
}

DrawFillMarkers(-1, xangles.length);

limits((-1, -1), (fills.length, xangles.length), Crop);

GShipout(hSkip=0mm, vSkip=0mm);
