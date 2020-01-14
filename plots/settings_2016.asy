string year = "2016";

string arms[], a_labels[], a_nr_rps[], a_fr_rps[];
arms.push("arm0"); a_labels.push("sector 45 (L, z+)"); a_nr_rps.push("2"); a_fr_rps.push("3");
arms.push("arm1"); a_labels.push("sector 56 (R, z-)"); a_nr_rps.push("102"); a_fr_rps.push("103");

string rps[], rp_labels[], rp_arms[];
rps.push("2"); rp_labels.push("45-210-nr"); rp_arms.push("arm0");
rps.push("3"); rp_labels.push("45-210-fr"); rp_arms.push("arm0");
rps.push("102"); rp_labels.push("56-210-nr"); rp_arms.push("arm1");
rps.push("103"); rp_labels.push("56-210-fr"); rp_arms.push("arm1");

string version = "version6";
string versions[] = {
	"version6",
};

//string stream = "ZeroBias";
string stream = "ALL";

string xangle = "AUTO";
string xangles[] = {
	"185",
	"140",
};

string xangles_short[];
mark xa_marks[];
pen xa_pens[];
xangles_short.push("185"); xa_marks.push(mTU); xa_pens.push(blue);
xangles_short.push("140"); xa_marks.push(mTD); xa_pens.push(red);

string GetXangle(string fill_str, string xangle)
{
	if (xangle != "AUTO")
		return xangle;

	int fill = (int) fill_str;

	if (fill >= 5393)
		return "140";
	else
		return "185";
}

string beta = "0.30";

string GetBeta(string fill_str)
{
	return beta;
}

real xSizeDefFill = 80cm;

bool rebin = true;

string fills_short[] = {
	// pre-TS2
	"4953",
	"5052",
	"5276",

	// post-TS2
	"5393",
	"5427",
	"5451",
};

// only with good RP data (from my table)
string fills[] = {
	// pre-TS2
	"4947",
	"4953",
	"4961",
	"4964",
	"4976",
	"4985",
	"4988",
	"4990",

	// ----- TS1

	"5005",
	"5013",
	"5017",
	"5020",
	"5021",
	"5024",
	"5026",
	"5027",
	"5028",
	"5029",
	"5030",
	"5038",
	"5043",
	"5045",
	"5048",
	"5052",
	// radiation damage mitigation
	"5261",
	"5264",
	"5265",
	"5266",
	"5267",
	"5274",
	"5275",
	"5276",
	"5277",
	"5279",
	"5287",
	"5288",

	// ----- TS2

	"5393",
	//"5395", // not in CMS&RP JSON
	"5401",
	"5405",
	"5406",
	"5418",
	"5421",
	"5423",
	"5424",
	"5427",
	"5433",
	"5437",
	"5439",
	"5441",
	"5442",
	"5443",
	"5446",
	"5448",
	"5450",
	"5451",
};

int GetIndexBefore(int f)
{
	for (int fi : fills.keys)
	{
		int fill_int = (int) fills[fi];
		if (f <= fill_int)
			return fi;
	}

	return 0;
}

void DrawLine(int f, string l, pen p, bool u, real y_min, real y_max)
{
	real b = GetIndexBefore(f) - 0.5;

	draw((b, y_min)--(b, y_max), p);

	if (u)
		label("{\SetFontSizesXX " + l + "}", (b, y_max), SE, p);
	else
		label("{\SetFontSizesXX " + l + "}", (b, y_min), NE, p);
}

void DrawFillMarkers(real y_min, real y_max)
{
	DrawLine(5005, "TS1", magenta, true, y_min, y_max);
	DrawLine(5261, "radiation-damage mitigation", magenta, true, y_min, y_max);
	DrawLine(5393, "TS2", magenta, true, y_min, y_max);

	//DrawLine(4851, "2016A", magenta, false, y_min, y_max);
	DrawLine(4879, "2016B", magenta, false, y_min, y_max);
	DrawLine(5038, "2016C", magenta, false, y_min, y_max);
	//DrawLine(5072, "2016D", magenta, false, y_min, y_max);
	//DrawLine(5096, "2016E", magenta, false, y_min, y_max);
	//DrawLine(5134, "2016F", magenta, false, y_min, y_max);
	DrawLine(5199, "2016G", magenta, false, y_min, y_max);
	DrawLine(5289, "2016H", magenta, false, y_min, y_max);
}	

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
