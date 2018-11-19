Erlang Matrix Functions via eRserve
============================

This is an erlang matrix library that runs ontop of R

Installation
-----

The rserve library is availible from CRAN. Ubuntu users can install through apt.

	> sudo apt install r-cran-rserve

	> install.packages('Rserve')

In an R shell, start the Rserve in daemon mode

	> library(Rserve)
	> Rserve()

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



