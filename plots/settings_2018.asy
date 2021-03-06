string topDir = "/afs/cern.ch/work/j/jkaspar/work/analyses/ctpps/proton_reconstruction_validation/";

string year = "2018";

string arms[], a_labels[], a_nr_rps[], a_fr_rps[];
arms.push("0"); a_labels.push("sector 45 (L, z+)"); a_nr_rps.push("3"); a_fr_rps.push("23");
arms.push("1"); a_labels.push("sector 56 (R, z-)"); a_nr_rps.push("103"); a_fr_rps.push("123");

string rps[], rp_labels[], rp_arms[];
rps.push("23"); rp_labels.push("45-220-fr"); rp_arms.push("arm0");
rps.push("3"); rp_labels.push("45-210-fr"); rp_arms.push("arm0");
rps.push("103"); rp_labels.push("56-210-fr"); rp_arms.push("arm1");
rps.push("123"); rp_labels.push("56-220-fr"); rp_arms.push("arm1");

string version = "version-20";
string versions[] = {
	"version-20",
};

string stream = "ALL";

string xangle = "160";
string xangles[] = {
	"130",
	"140",
	"150",
	"160",
};

string xangles_short[];
mark xa_marks[];
pen xa_pens[];
xangles_short.push("160"); xa_marks.push(mTU); xa_pens.push(blue);
xangles_short.push("130"); xa_marks.push(mTD); xa_pens.push(red);

string GetXangle(string fill_str, string xangle)
{
	return xangle;
}

string beta = "0.30";

string GetBeta(string fill_str)
{
	return beta;
}

real xSizeDefFill = 80cm;

bool rebin = true;

real eff_xi_45_sample1 = 0.03, eff_xi_45_sample2 = 0.09, eff_xi_45_sample3 = 0.13;
real eff_xi_56_sample1 = 0.05, eff_xi_56_sample2 = 0.12, eff_xi_56_sample3 = 0.17;

string fills_short[] = {
	"6617",
	"6738", // used to be 6729 which is not anymore in the JSON

	"6923",
	"7039",
	"7137",

	"7315",
};

// fills from RP-OK JSON file
string fills[] = {
	"6583",
	"6584",
	"6595",
	"6611",
	"6614",
	"6615",
	"6617",
	"6618",
	"6621",
	"6624",
	"6629",
	"6636",
	"6638",
	"6639",
	"6640",
	"6641",
	"6642",
	"6643",
	"6645",
	"6646",
	"6648",
	"6650",
	"6654",
	"6659",
	"6662",
	"6663",
	"6666",
	"6672",
	"6674",
	"6675",
	"6677",
	"6681",
	"6683",
	"6688",
	"6690",
	"6693",
	"6694",
	"6696",
	"6700",
	"6702",
	"6706",
	"6709",
	"6710",
	"6711",
	"6712",
	"6714",
	"6719",
	"6724",
	"6729",
	"6731",
	"6733",
	"6737",
	"6738",
	"6741",
	"6744",
	"6747",
	"6749",
	"6751",
	"6752",
	"6755",
	"6757",
	"6759",
	"6761",
	"6762",
	"6763",
	"6768",
	"6770",
	"6772",
	"6773",
	"6774",
	"6776",
	"6778",
	"6854",
	"6858",
	"6860",
	"6874",
	"6901",
	"6904",
	"6909",
	"6911",
	"6912",
	"6919",
	"6921",
	"6923",
	"6924",
	"6925",
	"6927",
	"6929",
	"6931",
	"6939",
	"6940",
	"6942",
	"6944",
	"6946",
	"6953",
	"6956",
	"6957",
	"6960",
	"6961",
	"6998",
	"7003",
	"7005",
	"7006",
	"7008",
	"7013",
	"7017",
	"7018",
	"7020",
	"7024",
	"7026",
	"7031",
	"7033",
	"7035",
	"7036",
	"7037",
	"7039",
	"7040",
	"7042",
	"7043",
	"7045",
	"7047",
	"7048",
	"7052",
	"7053",
	"7055",
	"7056",
	"7058",
	"7061",
	"7063",
	"7065",
	"7069",
	"7078",
	"7080",
	"7083",
	"7087",
	"7088",
	"7090",
	"7091",
	"7092",
	"7095",
	"7097",
	"7098",
	"7099",
	"7101",
	"7105",
	"7108",
	"7109",
	"7110",
	"7112",
	"7114",
	"7117",
	"7118",
	"7120",
	"7122",
	"7123",
	"7124",
	"7125",
	"7127",
	"7128",
	"7131",
	"7132",
	"7133",
	"7135",
	"7137",
	"7139",
	"7144",
	"7145",
	"7213",
	"7217",
	"7218",
	"7221",
	"7234",
	"7236",
	"7239",
	"7240",
	"7242",
	"7245",
	"7252",
	"7253",
	"7256",
	"7259",
	"7264",
	"7265",
	"7266",
	"7270",
	"7271",
	"7274",
	"7308",
	"7309",
	"7310",
	"7314",
	"7315",
	"7317",
	"7320",
	"7321",
	"7324",
	"7328",
	"7331",
	"7333",
	"7334",
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
	DrawLine(6854, "TS1", magenta, true, y_min, y_max);
	DrawLine(7213, "TS2", magenta, true, y_min, y_max);

	DrawLine(6615, "2018A", magenta, false, y_min, y_max);
	DrawLine(6734, "2018B", magenta, false, y_min, y_max);
	DrawLine(6893, "2018C", magenta, false, y_min, y_max);
	DrawLine(6992, "2018D", magenta, false, y_min, y_max);
	//DrawLine(7350, "2018E", magenta, false, y_min, y_max);
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
