string year = "2016";

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

string fills[] = {
	// pre-TS2
	"4947",
	"4953",
	"4954",
	"4956",
	"4958",
	"4960",
	"4961",
	"4964",
	"4965",
	"4976",
	"4979",
	"4980",
	"4984",
	"4985",
	"4988",
	"4990",
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
	"5056",
	"5059",
	"5060",
	"5068",
	"5069",
	"5071",
	"5072",
	"5073",
	"5076",
	"5078",
	"5080",
	"5083",
	"5085",
	"5091",
	"5093",
	"5095",
	"5096",
	"5097",
	"5101",
	"5102",
	"5105",
	"5106",
	"5107",
	"5108",
	"5109",
	"5110",
	"5111",
	"5112",
	"5116",
	"5117",
	"5149",
	"5151",
	"5154",
	"5161",
	"5162",
	"5163",
	"5169",
	"5170",
	"5173",
	"5179",
	"5181",
	"5183",
	"5187",
	"5194",
	"5196",
	"5197",
	"5198",
	"5199",
	"5205",
	"5206",
	"5209",
	"5210",
	"5211",
	"5213",
	"5219",
	"5222",
	"5223",
	"5229",
	"5246",
	"5247",
	"5251",
	"5253",
	"5254",
	"5256",
	"5257",
	"5258",
	"5261",
	"5264",
	"5265",
	"5266",
	"5267",
	"5270",
	"5274",
	"5275",
	"5276",
	"5277",
	"5279",
	"5282",
	"5287",
	"5288",

	// post-TS2
	"5393",
	"5394",
	"5395",
	"5401",
	"5405",
	"5406",
	"5412",
	"5416",
	"5418",
	"5421",
	"5422",
	"5423",
	"5424",
	"5426",
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
	real b = 0;
	for (int fi : fills.keys)
	{
		if (fills[fi] == "5393")
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
