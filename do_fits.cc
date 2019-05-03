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

	vector<Record> si_mu_records = {
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
	if (!f_in)
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

	// 2016
	if (fill >= 4947 && fill <= 5393)
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

	// clean up
	delete f_in;
	delete f_out;

	if (missing_counter > 0)
	{
	  printf("WARNING: %u plots missing.\n", missing_counter);
	  return 1;
	}

	return 0;
}
