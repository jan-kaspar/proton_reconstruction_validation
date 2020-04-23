#include "TFile.h"
#include "TProfile.h"
#include "TGraphErrors.h"
#include "TF1.h"
#include "TH1D.h"
#include "TH2D.h"

#include <string>
#include <map>

using namespace std;

//----------------------------------------------------------------------------------------------------

unsigned int missing_counter = 0;

TObject* Load(TFile *f, const string &path, bool &process)
{
	TObject *obj = f->Get(path.c_str());

	if (obj == NULL)
	{
	  printf("ERROR: can't load object '%s'.\n", path.c_str());
	  missing_counter++;
	  process = false;
	}

	return obj;
}

//----------------------------------------------------------------------------------------------------

TH1D* SumOverXi(TH2D *h_input, double xi_min, double xi_max)
{
	int bin_min = h_input->GetXaxis()->FindBin(xi_min);
	int bin_max = h_input->GetXaxis()->FindBin(xi_max);

	return h_input->ProjectionY("_proj", bin_min, bin_max);
}

//----------------------------------------------------------------------------------------------------

void ProfileToRMSGraph(TProfile *p, TGraphErrors *g)
{
	for (int bi = 1; bi <= p->GetNbinsX(); ++bi)
	{
		double c = p->GetBinCenter(bi);

		double N = p->GetBinEntries(bi);
		double Sy = p->GetBinContent(bi) * N;
		double Syy = p->GetSumw2()->At(bi);

		double si_sq = Syy/N - Sy*Sy/N/N;
		double si = (si_sq >= 0.) ? sqrt(si_sq) : 0.;
		double si_unc_sq = si_sq / 2. / N;	// Gaussian approximation
		double si_unc = (si_unc_sq >= 0.) ? sqrt(si_unc_sq) : 0.;

		int idx = g->GetN();
		g->SetPoint(idx, c, si);
		g->SetPointError(idx, 0., si_unc);
	}
}

//----------------------------------------------------------------------------------------------------

TF1 *ff_aperture = new TF1("ff_aperture", "[0] + (1 - TMath::Erf((x-[1])/[2])) / 2 * ([3] + [4]*x)");
TF1 *ff_aperture_fit = new TF1("ff_aperture_fit", "(x - [0]) / [1]");

void FitApertureLimitations(TH2D *input)
{
	TGraphErrors *g_aperture = new TGraphErrors();

	for (int byi = 1; byi <= input->GetNbinsY(); byi++)
	{
		const double th_x = input->GetYaxis()->GetBinCenter(byi);
		const double th_x_unc = input->GetYaxis()->GetBinWidth(byi) / 2.;

		if (th_x < -120E-6 || th_x > 150E-6)
			continue;

		char buf[100];
		sprintf(buf, "h_xi_th_x_%.0f", th_x*1E6);

		TH1D *h_xi = input->ProjectionX(buf, byi, byi);

		if (h_xi->GetEntries() < 1000)
			continue;

		const int n_cmp = 5;

		double diff_max = -1E100;
		int bxi_max = -1;

		for (int bxi = n_cmp+1; bxi <= h_xi->GetNbinsX()-n_cmp; ++bxi)
		{
			if (h_xi->GetBinCenter(bxi) < 0.07)
				continue;

			double s_below=0., s_above=0.;
			for (int i = 1; i <= n_cmp; ++i)
			{
				s_below += h_xi->GetBinContent(bxi - i);
				s_above += h_xi->GetBinContent(bxi + i);
			}

			const double avg_diff = (s_below - s_above) / n_cmp;

			if (avg_diff > diff_max)
			{
				diff_max = avg_diff;
				bxi_max = bxi;
			}
		}

		if (bxi_max < 0)
			continue;

		const double xi0 = h_xi->GetBinCenter(bxi_max);
		const double xi0_unc = h_xi->GetBinWidth(bxi_max) / 2.;
		const double xi_min = xi0 - 0.03;
		const double xi_max = xi0 + 0.03;

		ff_aperture->SetParameters(0., xi0, 0.01, diff_max, 0.);
		ff_aperture->SetParLimits(0, 0., diff_max);

		h_xi->Fit(ff_aperture, "Q", "", xi_min, xi_max);

		const double xi1 = ff_aperture->GetParameter(1);
		const double xi1_unc = max(ff_aperture->GetParError(1), xi0_unc);

		//printf("th_x = %+4.0f urad | edge = %.3f --> %.3f\n", th_x * 1E6, xi0, xi1);

		//h_xi->Write();

		if (xi1_unc > 0.02 || xi1 < 0.05 || xi1 > 0.25)
			continue;

		int idx = g_aperture->GetN();
		g_aperture->SetPoint(idx, xi1, th_x);
		g_aperture->SetPointError(idx, xi1_unc, th_x_unc);
	}

	ff_aperture_fit->SetParameters(0.15, -2E2);
	g_aperture->Fit(ff_aperture_fit, "Q");
	g_aperture->Fit(ff_aperture_fit, "Q");
	g_aperture->Write("g_aperture");
}

//----------------------------------------------------------------------------------------------------

double FindMax(TF1 *ff)
{
	const double mu = ff->GetParameter(1);
	const double si = ff->GetParameter(2);

	if (fabs(mu) > 25. || fabs(si) > 25.)
		return 1E100;

	double x_max = 0.;
	double y_max = -1E100;
	for (double x = mu - si; x <= mu + si; x += 0.001)
	{
		double y = ff->Eval(x);
		if (y > y_max)
		{
			x_max = x;
			y_max = y;
		}
	}

	return x_max;
}

//----------------------------------------------------------------------------------------------------

TF1 *ff_fit = new TF1("ff_fit", "[0] * exp(-(x-[1])*(x-[1])/2./[2]/[2]) + [3] + [4]*x");

TGraphErrors* BuildModeGraph(const TH2D *h2_y_vs_x, unsigned int rp)
{
	bool saveDetails = false;
	TDirectory *d_top = gDirectory;

	double y_max_fit = 10.;

	// 2018 settings
	if (rp ==  23) y_max_fit = 3.5;
	if (rp ==   3) y_max_fit = 4.5;
	if (rp == 103) y_max_fit = 4.8;
	if (rp == 123) y_max_fit = 4.8;

	TGraphErrors *g_y_mode_vs_x = new TGraphErrors();

	for (int bix = 1; bix <= h2_y_vs_x->GetNbinsX(); ++bix)
	{
		const double x = h2_y_vs_x->GetXaxis()->GetBinCenter(bix);
		const double x_unc = h2_y_vs_x->GetXaxis()->GetBinWidth(bix) / 2.;

		if (x > 15.)
			continue;

		char buf[100];
		sprintf(buf, "h_y_x=%.3f", x);
		TH1D *h_y = h2_y_vs_x->ProjectionY(buf, bix, bix);

		if (h_y->GetEntries() < 300)
			continue;

		if (saveDetails)
		{
			sprintf(buf, "x=%.3f", x);
			gDirectory = d_top->mkdir(buf);
		}

		double con_max = -1.;
		double con_max_x = 0.;
		for (int biy = 1; biy < h_y->GetNbinsX(); ++biy)
		{
			if (h_y->GetBinContent(biy) > con_max)
			{
				con_max = h_y->GetBinContent(biy);
				con_max_x = h_y->GetBinCenter(biy);
			}
		}

		printf("x = %.3f\n", x);

		ff_fit->SetParameters(con_max, con_max_x, h_y->GetRMS() * 0.75, 0., 0.);
		ff_fit->FixParameter(4, 0.);

		printf("    fit 1: mu = %.2f, si = %.2f\n", ff_fit->GetParameter(1), ff_fit->GetParameter(2));

		double x_min = -2., x_max = y_max_fit;

		h_y->Fit(ff_fit, "Q", "", x_min, x_max);

		printf("    fit 1: mu = %.2f, si = %.2f\n", ff_fit->GetParameter(1), ff_fit->GetParameter(2));

		ff_fit->ReleaseParameter(4);
		double w = min(4., 2. * ff_fit->GetParameter(2));
		x_min = ff_fit->GetParameter(1) - w;
		x_max = min(y_max_fit, ff_fit->GetParameter(1) + w);
		h_y->Fit(ff_fit, "Q", "", x_min, x_max);

		printf("    fit 2: mu = %.2f, si = %.2f\n", ff_fit->GetParameter(1), ff_fit->GetParameter(2));
		printf("        chi^2 = %.1f, ndf = %u, chi^2/ndf = %.1f\n", ff_fit->GetChisquare(), ff_fit->GetNDF(), ff_fit->GetChisquare() / ff_fit->GetNDF());

		if (saveDetails)
			h_y->Write("h_y");

		//printf("x = %.3f mm, %f/%i = %.2f\n", x, ff_fit->GetChisquare(), ff_fit->GetNDF(), ff_fit->GetChisquare() / ff_fit->GetNDF());

		double y_mode = FindMax(ff_fit);
		const double y_mode_fit_unc = ff_fit->GetParameter(2) / 10;
		const double y_mode_sys_unc = 0.030;
		double y_mode_unc = sqrt(y_mode_fit_unc*y_mode_fit_unc + y_mode_sys_unc*y_mode_sys_unc);

		const double normChiSq = (ff_fit->GetNDF() > 0) ? ff_fit->GetChisquare() / ff_fit->GetNDF() : 0.;
		const double normChiSqThreshold = 50.;

		const bool valid = ! (fabs(y_mode_unc) > 5. || fabs(y_mode) > 20. || normChiSq > normChiSqThreshold);

		if (saveDetails)
		{
			TGraph *g_data = new TGraph();
			g_data->SetPoint(0, y_mode, y_mode_unc);
			g_data->SetPoint(1, ff_fit->GetChisquare(), ff_fit->GetNDF());
			g_data->SetPoint(2, valid, 0.);
			g_data->Write("g_data");
		}

		if (!valid)
			continue;

		int idx = g_y_mode_vs_x->GetN();
		g_y_mode_vs_x->SetPoint(idx, x, y_mode);
		g_y_mode_vs_x->SetPointError(idx, x_unc, y_mode_unc);
	}

	gDirectory = d_top;

	return g_y_mode_vs_x;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------

int main(int argc, char **argv)
{
	// parse command line
	string dir = argv[1];

	string fill_str = dir.substr(dir.find("fill_")+5, 4);
	unsigned int fill = atoi(fill_str.c_str());

	// config
	struct Record
	{
	  string dir;
	int arm;
	};

	vector<Record> mu_records = {
	  { "arm0", 0 },
	  { "arm1", 1 },
	};

	vector<Record> si_mu_records;

	if (fill <= 5451) // 2016
		si_mu_records = {
		  { "si_rp2_mu_arm0", 0 },
		  { "si_rp3_mu_arm0", 0 },
		  { "si_rp102_mu_arm1", 1 },
		  { "si_rp103_mu_arm1", 1 },
		};
	else
		si_mu_records = {
		  { "si_rp23_mu_arm0", 0 },
		  { "si_rp3_mu_arm0", 0 },
		  { "si_rp103_mu_arm1", 1 },
		  { "si_rp123_mu_arm1", 1 },
		};

	vector<Record> arm_records = {
	  { "arm0", 0 },
	  { "arm1", 1 },
	};

	//TF1 *ff_pol0 = new TF1("ff", "[0]");
	TF1 *ff_pol1 = new TF1("ff_pol1", "[0] + [1]*x");

	// prepare input
	TFile *f_in = TFile::Open((dir + "/output.root").c_str());
	TFile *f_in_tracks = TFile::Open((dir + "/output_tracks.root").c_str());

	if (!f_in || !f_in_tracks)
	{
	  printf("ERROR: can't open input.\n");
	  return 10;
	}

	// prepare output
	TFile *f_out = TFile::Open((dir + "/do_fits.root").c_str(), "recreate");

	// determine ranges
	map<unsigned int, double> min_xi_diffNF, max_xi_diffNF;
	map<unsigned int, double> min_xi_diffSM, max_xi_diffSM;
	map<unsigned int, double> min_th_x, max_th_x;
	map<unsigned int, double> min_th_y, max_th_y;
	map<unsigned int, double> min_vtx_y, max_vtx_y;

	map<unsigned int, double> min_x, max_x;

	// 2016 pre-TS2
	if (fill >= 4947 && fill < 5393)
	{
		min_xi_diffNF[0] = 0.07; max_xi_diffNF[0] = 0.095;
		min_xi_diffNF[1] = 0.07; max_xi_diffNF[1] = 0.11;

		min_xi_diffSM[0] = 0.06; max_xi_diffSM[0] = 0.095;
		min_xi_diffSM[1] = 0.07; max_xi_diffSM[1] = 0.11;

		min_th_x[0] = 0.065; max_th_x[0] = 0.095;
		min_th_x[1] = 0.07; max_th_x[1] = 0.11;

		min_th_y[0] = 0.07; max_th_y[0] = 0.115;
		min_th_y[1] = 0.07; max_th_y[1] = 0.14;

		min_vtx_y[0] = 0.07; max_vtx_y[0] = 0.11;
		min_vtx_y[1] = 0.06; max_vtx_y[1] = 0.12;

		min_x[2] = 3.0; max_x[2] = 8.;
		min_x[3] = 3.0; max_x[3] = 8.;
		min_x[102] = 3.0; max_x[102] = 7.;
		min_x[103] = 3.0; max_x[103] = 7.;
	}

	// 2016 post-TS2
	if (fill >= 5393 && fill <= 5451)
	{
		min_xi_diffNF[0] = 0.05; max_xi_diffNF[0] = 0.09;
		min_xi_diffNF[1] = 0.05; max_xi_diffNF[1] = 0.09;

		min_xi_diffSM[0] = 0.05; max_xi_diffSM[0] = 0.09;
		min_xi_diffSM[1] = 0.05; max_xi_diffSM[1] = 0.09;

		min_th_x[0] = 0.05; max_th_x[0] = 0.09;
		min_th_x[1] = 0.05; max_th_x[1] = 0.09;

		min_th_y[0] = 0.05; max_th_y[0] = 0.10;
		min_th_y[1] = 0.05; max_th_y[1] = 0.10;

		min_vtx_y[0] = 0.04; max_vtx_y[0] = 0.10;
		min_vtx_y[1] = 0.04; max_vtx_y[1] = 0.10;

		min_x[2] = 4.0; max_x[2] = 12.;
		min_x[3] = 3.5; max_x[3] = 12.;
		min_x[102] = 3.5; max_x[102] = 12.;
		min_x[103] = 3.5; max_x[103] = 12.;
	}

	// 2017
	if (fill >= 5839 && fill <= 6371)
	{
		min_xi_diffNF[0] = 0.06; max_xi_diffNF[0] = 0.095;
		min_xi_diffNF[1] = 0.08; max_xi_diffNF[1] = 0.12;

		min_xi_diffSM[0] = 0.06; max_xi_diffSM[0] = 0.095;
		min_xi_diffSM[1] = 0.08; max_xi_diffSM[1] = 0.12;

		min_th_x[0] = 0.06; max_th_x[0] = 0.10;
		min_th_x[1] = 0.07; max_th_x[1] = 0.115;

		min_th_y[0] = 0.07; max_th_y[0] = 0.14;
		min_th_y[1] = 0.07; max_th_y[1] = 0.14;

		min_vtx_y[0] = 0.07; max_vtx_y[0] = 0.11;
		min_vtx_y[1] = 0.06; max_vtx_y[1] = 0.17;
	}

	// 2018
	if (fill >= 6579  && fill <= 7334)
	{
		min_xi_diffNF[0] = 0.06; max_xi_diffNF[0] = 0.11;
		min_xi_diffNF[1] = 0.07; max_xi_diffNF[1] = 0.13;

		min_xi_diffSM[0] = 0.05; max_xi_diffSM[0] = 0.10;
		min_xi_diffSM[1] = 0.07; max_xi_diffSM[1] = 0.12;

		min_th_x[0] = 0.06; max_th_x[0] = 0.10;
		min_th_x[1] = 0.08; max_th_x[1] = 0.13;

		min_th_y[0] = 0.07; max_th_y[0] = 0.14;
		min_th_y[1] = 0.07; max_th_y[1] = 0.14;

		min_vtx_y[0] = 0.07; max_vtx_y[0] = 0.11;
		min_vtx_y[1] = 0.06; max_vtx_y[1] = 0.17;

		min_x[23] = 3.0; max_x[23] = 8.;
		min_x[3] = 3.0; max_x[3] = 8.;
		min_x[103] = 3.0; max_x[103] = 7.;
		min_x[123] = 3.0; max_x[123] = 7.;
	}

	// process mu
	TDirectory *mu_dir = f_out->mkdir("multiRPPlots");
	for (const auto &rec : mu_records)
	{
	  bool process = true;

	  TProfile *p_th_x_vs_xi = (TProfile *) Load(f_in, "multiRPPlots/" + rec.dir + "/p_th_x_vs_xi", process);
	  TProfile *p_th_y_vs_xi = (TProfile *) Load(f_in, "multiRPPlots/" + rec.dir + "/p_th_y_vs_xi", process);

	  TProfile *p_vtx_y_vs_xi = (TProfile *) Load(f_in, "multiRPPlots/" + rec.dir + "/p_vtx_y_vs_xi", process);

	  TH2D *h2_th_x_vs_xi = (TH2D *) Load(f_in, "multiRPPlots/" + rec.dir + "/h2_th_x_vs_xi", process);
	  TH2D *h2_th_y_vs_xi = (TH2D *) Load(f_in, "multiRPPlots/" + rec.dir + "/h2_th_y_vs_xi", process);

	  if (process)
	  {
	    ff_pol1->SetParameters(0., 0.);
	    p_th_x_vs_xi->Fit(ff_pol1, "Q+", "", min_th_x[rec.arm], max_th_x[rec.arm]);

	    ff_pol1->SetParameters(0., 0.);
	    p_th_y_vs_xi->Fit(ff_pol1, "Q+", "", min_th_y[rec.arm], max_th_y[rec.arm]);

	    ff_pol1->SetParameters(0., 0.);
	    p_vtx_y_vs_xi->Fit(ff_pol1, "Q", "", min_vtx_y[rec.arm], max_vtx_y[rec.arm]);

	    gDirectory = mu_dir->mkdir(rec.dir.c_str());
	    p_th_x_vs_xi->Write("p_th_x_vs_xi");
	    p_th_y_vs_xi->Write("p_th_y_vs_xi");
	    p_vtx_y_vs_xi->Write("p_vtx_y_vs_xi");

	    SumOverXi(h2_th_x_vs_xi, 0., 0.25)->Write("h_th_x_xi_full");
	    SumOverXi(h2_th_x_vs_xi, min_th_x[rec.arm], max_th_x[rec.arm])->Write("h_th_x_xi_safe");

	    SumOverXi(h2_th_y_vs_xi, 0., 0.25)->Write("h_th_y_xi_full");
	    SumOverXi(h2_th_y_vs_xi, min_th_y[rec.arm], max_th_y[rec.arm])->Write("h_th_y_xi_safe");

		FitApertureLimitations(h2_th_x_vs_xi);
	  }

	  //----------

	  process = true;

	  TGraphErrors *g_th_x_RMS_vs_xi = (TGraphErrors *) Load(f_in, "multiRPPlots/" + rec.dir + "/g_th_x_RMS_vs_xi", process);
	  TGraphErrors *g_th_y_RMS_vs_xi = (TGraphErrors *) Load(f_in, "multiRPPlots/" + rec.dir + "/g_th_y_RMS_vs_xi", process);

	  if (process)
	  {
	    ff_pol1->SetParameters(0., 0.);
	    g_th_x_RMS_vs_xi->Fit(ff_pol1, "Q", "", min_th_x[rec.arm], max_th_x[rec.arm]);

	    ff_pol1->SetParameters(0., 0.);
	    g_th_y_RMS_vs_xi->Fit(ff_pol1, "Q", "", min_th_y[rec.arm], max_th_y[rec.arm]);

	    g_th_x_RMS_vs_xi->Write("g_th_x_RMS_vs_xi");
	    g_th_y_RMS_vs_xi->Write("g_th_y_RMS_vs_xi");
	  }

	  //----------

	  process = true;

	  TGraphErrors *g_vtx_y_RMS_vs_xi = (TGraphErrors *) Load(f_in, "multiRPPlots/" + rec.dir + "/g_vtx_y_RMS_vs_xi", process);

	  if (process)
	  {
	    ff_pol1->SetParameters(0., 0.);
	    g_vtx_y_RMS_vs_xi->Fit(ff_pol1, "Q", "", min_vtx_y[rec.arm], max_vtx_y[rec.arm]);

	    g_vtx_y_RMS_vs_xi->Write("g_vtx_y_RMS_vs_xi");
	  }
	}

	// process si_mu
	TDirectory *si_mu_dir = f_out->mkdir("singleMultiCorrelationPlots");
	for (const auto &rec : si_mu_records)
	{
	  bool process = true;

	  TProfile *p = (TProfile *) Load(f_in, "singleMultiCorrelationPlots/" + rec.dir + "/p_xi_diff_si_mu_vs_xi_mu", process);

	  if (process)
	  {
	    ff_pol1->SetParameters(0., 0.);
	    p->Fit(ff_pol1, "Q", "", min_xi_diffSM[rec.arm], max_xi_diffSM[rec.arm]);

	    gDirectory = si_mu_dir->mkdir(rec.dir.c_str());
	    p->Write("p_xi_diff_si_mu_vs_xi_mu");

		TGraphErrors *g_RMS_vs_xi = new TGraphErrors();
		ProfileToRMSGraph(p, g_RMS_vs_xi);

	    ff_pol1->SetParameters(0., 0.);
	    g_RMS_vs_xi->Fit(ff_pol1, "Q", "", min_xi_diffSM[rec.arm], max_xi_diffSM[rec.arm]);

		g_RMS_vs_xi->Write("g_xi_diff_si_mu_RMS_vs_xi_mu");
	  }
	}

	// process arm
	TDirectory *arm_dir = f_out->mkdir("armCorrelationPlots");
	for (const auto &rec : arm_records)
	{
	  bool process = true;

	  TProfile *p = (TProfile *) Load(f_in, "armCorrelationPlots/" + rec.dir + "/p_xi_si_diffNF_vs_xi_mu", process);

	  if (process)
	  {
	    ff_pol1->SetParameters(0., 0.);
	    p->Fit(ff_pol1, "Q", "", min_xi_diffNF[rec.arm], max_xi_diffNF[rec.arm]);

	    gDirectory = arm_dir->mkdir(rec.dir.c_str());
	    p->Write("p_xi_si_diffNF_vs_xi_mu");
	  }
	}

	// process tracks
	vector<unsigned int> rps;
	if (fill <= 5451) // 2016
		rps = { 2, 3, 102, 103 };
	else
		rps = { 23, 3, 103, 123 };

	for (const auto &rp : rps)
	{
		printf("* processing tracks in RP %u\n", rp);

		char buf[100];
		sprintf(buf, "RP %u", rp);
		gDirectory = f_out->mkdir(buf);

		bool process = true;

		sprintf(buf, "RP %u/h2_y_vs_x", rp);
		TH2D *h2_y_vs_x = (TH2D *) Load(f_in_tracks, buf, process);

		if (!process)
			continue;

		TGraphErrors *g_y_mode_vs_x = BuildModeGraph(h2_y_vs_x, rp);

		ff_pol1->SetParameters(0., 0.);
		g_y_mode_vs_x->Fit(ff_pol1, "Q", "", min_x[rp], max_x[rp]);

		g_y_mode_vs_x->Write("g_y_mode_vs_x");
	}

	// clean up
	delete f_in;
	delete f_in_tracks;
	delete f_out;

	if (missing_counter > 0)
	{
	  printf("WARNING: %u plots missing.\n", missing_counter);
	  return 1;
	}

	return 0;
}
