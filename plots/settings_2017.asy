string year = "2017";

string arms[], a_labels[], a_nr_rps[], a_fr_rps[];
arms.push("arm0"); a_labels.push("sector 45 (L, z+)"); a_nr_rps.push("3"); a_fr_rps.push("23");
arms.push("arm1"); a_labels.push("sector 56 (R, z-)"); a_nr_rps.push("103"); a_fr_rps.push("123");

string rps[], rp_labels[], rp_arms[];
rps.push("23"); rp_labels.push("45-220-fr"); rp_arms.push("arm0");
rps.push("3"); rp_labels.push("45-210-fr"); rp_arms.push("arm0");
rps.push("103"); rp_labels.push("56-210-fr"); rp_arms.push("arm1");
rps.push("123"); rp_labels.push("56-220-fr"); rp_arms.push("arm1");

string version = "version13";
string versions[] = {
	"version13",
};

//string stream = "DoubleEG";
string stream = "ALL";

string xangle = "150";
string xangles[] = {
	"120",
	"130",
	"140",
	"150",
};

string xangles_short[];
mark xa_marks[];
pen xa_pens[];
xangles_short.push("150"); xa_marks.push(mTU); xa_pens.push(blue);
//xangles_short.push("140"); xa_marks.push(mTL); xa_pens.push(blue);
//xangles_short.push("130"); xa_marks.push(mTR); xa_pens.push(blue);
xangles_short.push("120"); xa_marks.push(mTD); xa_pens.push(red);

string GetXangle(string fill_str, string xangle)
{
	return xangle;
}

string beta = "AUTO";

string GetBeta(string fill_str)
{
	if (beta != "AUTO")
		return beta;

	int fill = (int) fill_str;

	if (fill >= 6230)
		return "0.30";
	else
		return "0.40";
}


real xSizeDefFill = 80cm;

bool rebin = true;

string fills_short[] = {
	"5849",
	"6053",
	"6189",
	"6240",
	"6303",
	"6371",
};

// fills from JSON: CMS golden & RPs inserted
string fills[] = {
	"5839",
	"5840",
	"5842",
	"5845",
	"5848",
	"5849",
	"5856",
	"5864",
	"5865",
	"5868",
	// TS1
	"5942",
	"5946",
	"5950",
	"5952",
	"5954",
	"5958",
	"5960",
	"5962",
	"5963",
	"5965",
	"5966",
	"5971",
	"5974",
	"5976",
	"5979",
	"5984",
	"6019",
	"6020",
	"6024",
	"6026",
	"6030",
	"6031",
	"6035",
	"6041",
	"6044",
	"6046",
	"6048",
	"6050",
	"6052",
	"6053",
	"6054",
	"6055",
	"6057",
	"6060",
	"6061",
	"6084",
	"6086",
	"6089",
	"6090",
	"6091",
	"6093",
	"6094",
	"6096",
	"6097",
	"6098",
	"6106",
	"6110",
	"6114",
	"6116",
	"6119",
	"6123",
	"6136",
	"6138",
	"6140",
	"6141",
	"6142",
	"6143",
	"6146",
	"6147",
	"6152",
	"6155",
	"6156",
	"6158",
	"6159",
	"6160",
	"6161",
	"6165",
	"6167",
	"6168",
	"6169",
	"6170",
	"6171",
	"6174",
	"6175",
	"6176",
	"6177",
	"6179",
	"6180",
	"6182",
	"6185",
	"6186",
	"6189",
	"6191",
	"6192",
	"6193",
	// TS2
	"6239",
	"6240",
	"6241",
	"6243",
	"6245",
	"6247",
	"6252",
	"6253",
	"6255",
	"6258",
	"6259",
	"6261",
	"6262",
	"6263",
	"6266",
	"6268",
	"6269",
	"6271",
	"6272",
	"6275",
	"6276",
	"6278",
	"6279",
	"6283",
	"6284",
	"6285",
	"6287",
	"6288",
	"6291",
	"6297",
	"6298",
	"6300",
	"6303",
	"6304",
	"6305",
	"6306",
	"6307",
	"6308",
	"6309",
	"6311",
	"6312",
	"6313",
	"6314",
	"6315",
	"6317",
	"6318",
	"6323",
	"6324",
	"6325",
	"6337",
	"6341",
	"6343",
	"6344",
	"6346",
	"6347",
	"6348",
	"6349",
	"6351",
	"6355",
	"6356",
	"6358",
	"6360",
	"6362",
	"6364",
	"6370",
	"6371",
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
	DrawLine(5900, "TS1", magenta, true, y_min, y_max);
	DrawLine(6239, "TS2", magenta, true, y_min, y_max);

	//DrawLine(5677, "2017A", magenta, false, y_min, y_max);
	DrawLine(5838, "2017B", magenta, false, y_min, y_max);
	DrawLine(5961, "2017C", magenta, false, y_min, y_max);
	DrawLine(6147, "2017D", magenta, false, y_min, y_max);
	DrawLine(6222, "2017E", magenta, false, y_min, y_max);
	DrawLine(6294, "2017F", magenta, false, y_min, y_max);
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
