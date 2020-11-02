1) Initialise CMSSW environment of your choice. NB: this CMSSW version will be re-used for processing the data.

1) Go to the directory of the proton-validation package (where `submit` file is).

1) Run `./submit --help` to check the available options.

1) Run `./submit` with desired options, minimally `./submit -o some_version_tag`. This will generate jobs under `data/some_version_tag`.

1) Review the generated configs if you like. Use the HTCondor command printed on screen to submit the jobs.

1) Make sure that all jobs finished successfully - each directory should contain `success` file. This could be done e.g. by running
`./wd_control -wd data/some_version_tag -s failed print` - this will print the failed jobs. They can be resubmitted by running
`./wd_control -wd data/some_version_tag -s failed resubmit`. Run `./wd_control --help` for more options.

1) Run `./do_fits_multiple <data/some_version_tag>`.
