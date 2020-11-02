all: fit

fit : fit.cc
	g++ --std=c++11 `root-config --libs` -lMinuit `root-config --cflags` -Wall -Werror\
		fit.cc -o fit
