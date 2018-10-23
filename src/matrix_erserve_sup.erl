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
	Opt =[{min_size,1},{max_size,1},{max_queue_size,5},{keep_alive,true},{host,"localhost"},{port, 6311}],
	Procs = [
			{erserve,{erserve_pool,start_pool,[matrix_pool,Opt]},permanent,8000,worker,dynamic}
			],
	{ok, {{one_for_one, 10, 10}, Procs}}.

