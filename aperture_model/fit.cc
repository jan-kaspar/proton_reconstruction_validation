#include "TFile.h"
#include "TGraphErrors.h"
#include "TF1.h"

#include <string>
#include <map>

using namespace std;

//----------------------------------------------------------------------------------------------------

int main(int argc, char **argv)
{
	struct Entry
	{
		string label;
		string year;
		string version;
		vector<string> fills;
		vector<string> xangles;
		string beta;
		string stream;
	};

	vector<Entry> entries;

	entries.push_back({
		"2016_preTS2",
		"2016",
		"version3",
		{"4953", "5052", "5276"},
		{"185"},
		"0.30",
		"ALL"
	});

	entries.push_back({
		"2016_postTS2",
		"2016",
		"version4",
		{"5393", "5427", "5451"},
		{"140"},
		"0.30",
		"ALL"
	});

	entries.push_back({
		"2017_preTS2",
		"2017",
		"version10",
		{"5849", "6053", "6189"},
		{"120", "130", "140", "150"},
		"0.40",
		"ALL"
	});

	entries.push_back({
		"2017_postTS2",
		"2017",
		"version10",
		{"6240", "6303", "6371"},
		{"120", "130", "140", "150"},
		"0.30",
		"ALL"
	});

	entries.push_back({
		"2018",
		"2018",
		"version5",
		{"6617", "6729", "6923", "7039", "7137", "7315"},
		{"130", "140", "150", "160"},
		"0.30",
		"ALL"
	});

	vector<string> arms = {
		"arm0",
		"arm1"
	};

	//data/2018/version5/fill_6617/xangle_160_beta_0.30_stream_ALL
	//do_fits.root
	//multiRPPlots/arm0/g_aperture|ff_aperture_fit
	// 0-->xi0, 1-->a (rad^-1)

	TFile *f_out = TFile::Open("fit.root", "recreate");

	TF1 *ff = new TF1("ff", "[0] + [1]*x");
	
	for (const auto &entry : entries)
	{
		printf("--------------------------------------------------\n");
		printf("%s\n", entry.label.c_str());

		TDirectory *d_entry = f_out->mkdir(entry.label.c_str());

		for (const auto &arm : arms)
		{
			TDirectory *d_arm = d_entry->mkdir(arm.c_str());

			TGraphErrors *g_xi0_vs_xangle = new TGraphErrors();
			TGraphErrors *g_a_vs_xangle = new TGraphErrors();

			for (const auto &fill : entry.fills)
			{
				TGraphErrors *g_xi0_vs_xangle_fill = new TGraphErrors();
				TGraphErrors *g_a_vs_xangle_fill = new TGraphErrors();

				for (const auto &xangle : entry.xangles)
				{
					const double xangle_d = atof(xangle.c_str());

					TFile *f_in = TFile::Open(("../data/" + entry.year + "/" + entry.version + "/fill_" + fill + "/xangle_" + xangle + "_beta_" + entry.beta + "_stream_" + entry.stream + "/do_fits.root").c_str());
					if (!f_in)
						continue;

					TGraph *g_in = (TGraph *) f_in->Get(("multiRPPlots/"+arm+"/g_aperture").c_str());
					if (!g_in)
						continue;

					TF1 *fit = (TF1*) g_in->GetListOfFunctions()->At(0);
					if (!fit)
						continue;

					double xi0 = fit->GetParameter(0), xi0_unc = fit->GetParError(0);
					double a = fit->GetParameter(1), a_unc = fit->GetParError(1);

					xi0_unc = sqrt(xi0_unc*xi0_unc + 2E-4*2E-4);
					a_unc = sqrt(a_unc*a_unc + 5.*5.);

					int idx = g_xi0_vs_xangle->GetN();

					g_xi0_vs_xangle->SetPoint(idx, xangle_d, xi0);
					g_xi0_vs_xangle->SetPointError(idx, 0., xi0_unc);

					g_a_vs_xangle->SetPoint(idx, xangle_d, a);
					g_a_vs_xangle->SetPointError(idx, 0., a_unc);

					idx = g_xi0_vs_xangle_fill->GetN();

					g_xi0_vs_xangle_fill->SetPoint(idx, xangle_d, xi0);
					g_xi0_vs_xangle_fill->SetPointError(idx, 0., xi0_unc);

					g_a_vs_xangle_fill->SetPoint(idx, xangle_d, a);
					g_a_vs_xangle_fill->SetPointError(idx, 0., a_unc);
				}

				gDirectory = d_arm->mkdir(fill.c_str());
				g_xi0_vs_xangle_fill->Write("g_xi0_vs_xangle");
				g_a_vs_xangle_fill->Write("g_a_vs_xangle");
			}

			// do fits
			if (entry.xangles.size() < 2)
				ff->FixParameter(1, 0.);
			else
				ff->ReleaseParameter(1);

			ff->SetParameters(0.13, 0.);
			g_xi0_vs_xangle->Fit(ff, "Q");

			const double xi0_int = ff->GetParameter(0);
			const double xi0_slp = ff->GetParameter(1);

			ff->SetParameters(-150., 0.);
			g_a_vs_xangle->Fit(ff, "Q");

			const double a_int = ff->GetParameter(0);
			const double a_slp = ff->GetParameter(1);

			// save graphs
			gDirectory = d_arm;

			g_xi0_vs_xangle->Write("g_xi0_vs_xangle");
			g_a_vs_xangle->Write("g_a_vs_xangle");

			// print out summary in python format
			string lhcSector = (arm == "arm0") ? "45" : "56";

			printf("ctppsDirectProtonSimulation.empiricalAperture%s_xi0_int = %.3f\n", lhcSector.c_str(), xi0_int);
			printf("ctppsDirectProtonSimulation.empiricalAperture%s_xi0_slp = %.3E\n", lhcSector.c_str(), xi0_slp);
			printf("ctppsDirectProtonSimulation.empiricalAperture%s_a_int = %.1f\n", lhcSector.c_str(), -a_int);
			printf("ctppsDirectProtonSimulation.empiricalAperture%s_a_slp = %.3f\n", lhcSector.c_str(), -a_slp);
		}
	}

	delete f_out;

	return 0;
}
