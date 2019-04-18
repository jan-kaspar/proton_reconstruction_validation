string year = "2017";

string version = "version4";
string versions[] = {
	//"version1-fix",
	"version4",
};

string stream = "DoubleEG";

string xangle = "120";
string xangles[] = {
	"120",
	"130",
	"140",
	"150",
};

string xangles_short[];
mark xa_marks[];
xangles_short.push("150"); xa_marks.push(mTU);
xangles_short.push("120"); xa_marks.push(mTD);

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

string fills_short[] = {
	"5849",
	"6053",
	"6189",
	"6240",
	"6303",
	"6371",
};

string fills[] = {
	"5839",
	"5840",
	"5842",
	"5845",
	"5848",
	"5849",
	"5856",
	"5859",
	"5860",
	"5861",
	"5862",
	"5864",
	"5865",
	"5868",
	"5870",
	"5871",
	"5872",
	"5873",
	"5874",
	"5876",
	"5878",
	"5880",
	"5882",
	"5883",
	"5885",
	"5887",
	"5919",
	"5920",
	"5929",
	"5930",
	"5933",
	"5934",
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
	"5970",
	"5971",
	"5974",
	"5976",
	"5979",
	"5980",
	"5984",
	"5985",
	"6001",
	"6005",
	"6006",
	"6009",
	"6012",
	"6014",
	"6015",
	"6016",
	"6018",
	"6019",
	"6020",
	"6021",
	"6024",
	"6026",
	"6030",
	"6031",
	"6034",
	"6035",
	"6036",
	"6039",
	"6041",
	"6044",
	"6046",
	"6047",
	"6048",
	"6050",
	"6052",
	"6053",
	"6054",
	"6055",
	"6057",
	"6060",
	"6061",
	"6072",
	"6079",
	"6082",
	"6084",
	"6086",
	"6089",
	"6090",
	"6091",
	"6092",
	"6093",
	"6094",
	"6096",
	"6097",
	"6098",
	"6104",
	"6105",
	"6106",
	"6110",
	"6114",
	"6116",
	"6119",
	"6123",
	"6130",
	"6132",
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
	"6164",
	"6165",
	"6167",
	"6168",
	"6169",
	"6170",
	"6171",
	"6173",
	"6174",
	"6175",
	"6176",
	"6177",
	"6179",
	"6180",
	"6181",
	"6182",
	"6183",
	"6184",
	"6185",
	"6186",
	"6189",
	"6191",
	"6192",
	"6193",
	"6194",
	"6195",
	"6230",
	"6236",
	"6238",
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
	"6295",
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
	"6336",
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

void DrawFillMarkers(real y_min, real y_max)
{
	real b = 0;
	for (int fi : fills.keys)
	{
		if (fills[fi] == "6230")
		{
			b = fi - 0.5;
		}
	}

	draw((b, y_min)--(b, y_max), magenta+2pt);
	label("post-TS2", (b, y_max), SE, magenta);
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
