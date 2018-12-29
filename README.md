Erlang Matrix Functions via eRserve
============================

This is an Erlang matrix library that runs on top of R

Prerequisites
-----

For Ubuntu users, eRserve can install through apt. This will start the daemon automatically.

	> sudo apt install r-cran-rserve

Alternatively, the rserve library is available from CRAN. In an R shell, start the Rserve in daemon mode

	> install.packages('Rserve')
	> library(Rserve)
	> Rserve()

Either way, the app expects reserve to respond on port 6311

Installation
-----

Then, install the erserve.git

	> rebar get-deps

Then, in the top directory, compile using rebar

	> rebar compile

Usage
-----

Only two functions are supported, transpose/1 and multiply/2

	>  erl -pa ebin -pa deps/erserve/ebin/ -eval "application:start(matrix_erserve)"

	Erlang R16B03 (erts-5.10.4) [source] [64-bit] 

	Eshell V5.10.4  (abort with ^G)
	1> matrix_erserve:transpose([[1.0,2.0],[3.0,4.0]]).

	2> matrix_erserve:multiply([[1.0,2.0],[3.0,4.0]],[[1.0,2.0,3.0],[4.0,5.0,6.0]]).



