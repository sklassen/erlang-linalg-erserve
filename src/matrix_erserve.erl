-module(matrix_erserve).
-export([init/0,
		version/0,
		transpose/1,
		multiply/2
%		inverse/1,
%		svd/1,
		]).
-on_load(init/0).

init() ->
	"".

version() -> 
	exec("version$version.string").

transpose(_)->
	exit(nif_library_not_loaded).

multiply(_,_)->
	exit(nif_library_not_loaded).

%inverse(_)->
%	exit(nif_library_not_loaded).

%svd(_)->
%	exit(nif_library_not_loaded).


exec(R)->
	try erserve_pool:get_connection(matrix_pool) of
    	{timeout,_} -> erlang:error(timeout);
    	{ok, Conn} -> try erserve:eval(Conn,R) of
			{ok, Rdata} ->
				%io:format("OK: ~p~n",[Rdata]),
				erserve_pool:return_connection(matrix_pool, Conn),
                case erserve:type(Rdata) of
                   	xt_array_str-> erserve:parse(Rdata);
                   	_  -> erserve:parse(Rdata)
                end
        catch
            _:_ -> erlang:error(error)
        end
    catch
        _:_ -> erlang:error(no_connection)
    end.

