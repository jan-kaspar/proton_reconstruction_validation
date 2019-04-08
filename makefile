all: do_fits

do_fits : do_fits.cc
	g++ --std=c++11 `root-config --libs` -lMinuit `root-config --cflags` -Wall -Werror\
		do_fits.cc -o do_fits
