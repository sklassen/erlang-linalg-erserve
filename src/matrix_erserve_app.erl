-module(matrix_erserve_app).
-behaviour(application).
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
	os:cmd("/usr/lib/R/bin/R CMD /usr/lib/R/site-library/Rserve/libs/Rserve --vanilla"),
	cybot_sup:start_link().

stop(_State) ->
    ok.



