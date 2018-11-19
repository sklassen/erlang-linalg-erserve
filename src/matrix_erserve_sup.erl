-module(matrix_erserve_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

-spec start_link() -> {ok, pid()}.
start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
    ok.

init([]) ->
	Procs = [
			{matrix_erserve,{matrix_erserve,start,[]},permanent,8000,worker,dynamic}
			],
	{ok, {{one_for_one, 10, 10}, Procs}}.

