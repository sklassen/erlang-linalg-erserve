-module(matrix_erserve).
-export([
		version/0,
		transpose/1,
		multiply/2
		]).

version() -> 
	exec("version$version.string").


transpose(M)->
	exec(io_lib:format("t(~s)",[matrix(M)])).

multiply(A,B)->
	exec(io_lib:format("~s%*%~s",[matrix(A),matrix(B)])).

matrix(X)->
	"matrix(c(1,2,3,4),2,2)".

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

