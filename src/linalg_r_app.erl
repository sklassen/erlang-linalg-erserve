-module(linalg_r_app).
-behaviour(application).
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
	%os:cmd("/usr/lib/R/bin/R CMD /usr/lib/R/site-library/Rserve/libs/Rserve --vanilla"),
	linalg_r_sup:start_link().

stop(_State) ->
    ok.



