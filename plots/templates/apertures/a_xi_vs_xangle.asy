import root;
import pad_layout;
include "../settings.asy";

TH2_palette = Gradient(blue, heavygreen, yellow, red);

//xTicksDef = LeftTicks(0.05, 0.01);

TGraph_errorBar = None;

int q_idxs[];
string q_labels[];
real q_mins[], q_maxs[];
q_idxs.push(0); q_labels.push("$\xi_0$"); q_mins.push(0.10); q_maxs.push(0.20);
q_idxs.push(1); q_labels.push("$a\ung{rad^{-1}}$"); q_mins.push(-400); q_maxs.push(-100);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("year: " + year);
AddToLegend("version: " + version);
AddToLegend("stream: " + stream);
AddToLegend("beta: " + beta);

for (int fi : fills_short.keys)
{
	AddToLegend("fill " + fills_short[fi], StdPen(fi));
}

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int qi : q_idxs.keys)
{
	NewRow();

	NewPad(false);

	for (int ai : arms.keys)
	{
		NewPad("xangle", q_labels[qi]);

		for (int fi : fills_short.keys)
		{
			string fill = fills_short[fi];
			pen p = StdPen(fi);

			guide g;

			for (int xai : xangles.keys)
			{
				string xangle = xangles[xai];
				real xangle_real = (real) xangle;

				string d = topDir + "data/" + version + "/" + year + "/fill_" + fill + "/xangle_" + GetXangle(fill, xangle) + "_beta_" + GetBeta(fill) + "_stream_" + stream;
				string f_fit = d + "/do_fits.root";
				RootObject f_aperture = RootGetObject(f_fit, "multiRPPlots/arm" + arms[ai] + "/g_aperture|ff_aperture_fit", error=false);

				if (!f_aperture.valid)
					continue;
				
				real q = f_aperture.rExec("GetParameter", q_idxs[qi]);
				real q_unc = f_aperture.rExec("GetParError", q_idxs[qi]);

				draw((xangle_real, q), mCi+3pt+p);	

				g = g -- (xangle_real, q);
			}

			if (length(g) > 1)
				draw(g, p);
		}

		ylimits(q_mins[qi], q_maxs[qi], Crop);
	}
}

GShipout(hSkip=0mm, vSkip=0mm);
