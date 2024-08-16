-module(linalg_r_sup).
-behaviour(supervisor).
-export([start_link/0, stop/1]).
-export([init/1]).

-spec start_link() -> {ok, pid()}.
start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
    ok.

init([]) ->
  Procs = [
           {linalg_r,{linalg_r_srv,start,[]},permanent,8000,worker,dynamic}
          ],
  {ok, {{one_for_one, 10, 10}, Procs}}.

