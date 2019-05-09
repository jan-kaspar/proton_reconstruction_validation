string year = "2016";

string arms[], a_labels[], a_nr_rps[], a_fr_rps[];
arms.push("arm0"); a_labels.push("sector 45 (L, z+)"); a_nr_rps.push("2"); a_fr_rps.push("3");
arms.push("arm1"); a_labels.push("sector 56 (R, z-)"); a_nr_rps.push("102"); a_fr_rps.push("103");

string rps[], rp_labels[], rp_arms[];
rps.push("2"); rp_labels.push("45-210-nr"); rp_arms.push("arm0");
rps.push("3"); rp_labels.push("45-210-fr"); rp_arms.push("arm0");
rps.push("102"); rp_labels.push("56-210-nr"); rp_arms.push("arm1");
rps.push("103"); rp_labels.push("56-210-fr"); rp_arms.push("arm1");

string version = "version1";
string versions[] = {
	"version1",
};

//string stream = "SingleMuon";
string stream = "ZeroBias";

string xangle = "185";
string xangles[] = {
	"185",
	"140",
};

string xangles_short[];
mark xa_marks[];
pen xa_pens[];
xangles_short.push("185"); xa_marks.push(mTU); xa_pens.push(blue);
xangles_short.push("140"); xa_marks.push(mTD); xa_pens.push(red);

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
	"5394",
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
	// TS1
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
	// TS2
	"5393",
	"5395",
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

void DrawFillMarkers(real y_min, real y_max)
{
	real b_TS1 = 0;
	real b_mit = 0;
	real b_TS2 = 0;
	for (int fi : fills.keys)
	{
		if (fills[fi] == "5005")
			b_TS1 = fi - 0.5;
		if (fills[fi] == "5261")
			b_mit = fi - 0.5;
		if (fills[fi] == "5393")
			b_TS2 = fi - 0.5;
	}

	draw((b_TS1, y_min)--(b_TS1, y_max), magenta+2pt);
	label("TS1", (b_TS1, y_max), SE, magenta);

	draw((b_mit, y_min)--(b_mit, y_max), magenta+2pt);
	label("radiation-damage mitigation", (b_mit, y_max), SE, magenta);

	draw((b_TS2, y_min)--(b_TS2, y_max), magenta+2pt);
	label("TS2", (b_TS2, y_max), SE, magenta);
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
