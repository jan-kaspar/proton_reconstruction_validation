import root;
import pad_layout;

string f = "fit.root";

string periods[] = {
	"2016_preTS2",
	"2016_postTS2",
	"2017_preTS2",
	"2017_postTS2",
	"2018",
};

string arms[], a_labels[];
arms.push("arm0"); a_labels.push("sector 45");
arms.push("arm1"); a_labels.push("sector 56");

string q_tags[], q_labels[];
real q_mins[], q_maxs[];
q_tags.push("xi0"); q_labels.push("$\xi_0$"); q_mins.push(0.10); q_maxs.push(0.20);
q_tags.push("a"); q_labels.push("$a\ung{rad^{-1}}$"); q_mins.push(-400); q_maxs.push(-100);

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------
	
NewPad(false);
for (int ai : arms.keys)
	for (int qi : q_tags.keys)
		NewPadLabel(a_labels[ai] + ", " + q_tags[qi]);

for (int pi : periods.keys)
{
	NewRow();
	
	string fills[] = RootGetListOfDirectories(f, periods[pi] + "/arm0");

	NewPad(false);
	AddToLegend("<{\SetFontSizesXX" + replace(periods[pi], "_", " ") + "}");
	for (int fi : fills.keys)
		AddToLegend("fill " + fills[fi], mCi+3pt+StdPen(fi+1));
	AttachLegend();

	for (int ai : arms.keys)
	{
		for (int qi : q_tags.keys)
		{
			NewPad("xangle $\ung{\mu rad}$", q_labels[qi]);

			for (int fi : fills.keys)
			{
				RootObject graph = RootGetObject(f, periods[pi] + "/" + arms[ai] + "/" + fills[fi] + "/g_" + q_tags[qi] + "_vs_xangle");
				pen p = StdPen(fi+1);
				draw(graph, "p", p, mCi+3pt+p);
			}

			string on = periods[pi] + "/" + arms[ai] + "/g_" + q_tags[qi] + "_vs_xangle";
			//RootObject graph = RootGetObject(f, on);
			RootObject fit = RootGetObject(f, on + "|ff", error=false);

			if (fit.valid)
			{
				real p0 = fit.rExec("GetParameter", 0);
				real p1 = fit.rExec("GetParameter", 1);

				string l = "";
				if (q_tags[qi] == "xi0") l = format("$%.3f$", p0) + format(" $%+.2E \cdot xangle$", p1);
				if (q_tags[qi] == "a") l = format("$%.0f$", p0) + format(" $%+.2f \cdot xangle$", p1);

				//draw(graph, "p", mCi+2pt+black);
				draw(fit, "l", black+1pt, l);
			}

			AttachLegend(BuildLegend(S), N);
		}
	}
}
