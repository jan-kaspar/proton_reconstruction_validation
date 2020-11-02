1) Initialise CMSSW environment of your choice. NB: this CMSSW version will be re-used for processing the data.

1) Go to the directory of the proton-validation package (where `submit` file is).

1) Run `./submit --help` to check the available options.

1) Run `./submit` with desired options, minimally `./submit -o some_version_tag`. This will generate jobs under `data/some_version_tag`.

1) Review the generated configs if you like. Use the HTCondor command printed on screen to submit the jobs.

1) Make sure that all jobs finished successfully - each directory should contain `success` file. This could be done e.g. by running
`./wd_control -wd data/some_version_tag -s failed print` - this will print the failed jobs. They can be resubmitted by running
`./wd_control -wd data/some_version_tag -s failed resubmit`. Run `./wd_control --help` for more options.

1) Run `./do_fits_multiple <data/some_version_tag>`.

1) If you have the Asymptote package, you can build the standar plots by:
  * going to `plots` directory
  * edditing the `settings_*.asy` files to use the `some_version_tag` version.
  * and running `./make_links`
  * and running `./make_multiple 2016 2017 2018`

1) Eventually, the standard "reports" can be produced by:
  * going to the `summaries` directory
  * and running `./make_multiple 2016 2017 2018`
