-module(matrix_erserve).
-export([start/0,start/1, stop/0]).
-export([version/0, transpose/1, multiply/2]).
-export([col2row/1, matrix/1]).

% Note R is COLMAJOR by default, We are ROWMAJOR, so we 

start() ->
	start(,[]).
start([]) ->
    case lists:member(?MODULE,registered()) of
        true -> {ok,whereis(?MODULE)};
        false -> register(?MODULE, spawn(fun() -> init() end)),{ok,whereis(?MODULE)}
    end.

init() ->
	try erserve:open("localhost", 6311) of
		Conn -> loop(Conn)
    catch
        _:_ -> erlang:error(no_connection)
    end.

rpc(Q) ->
    case lists:member(?MODULE,registered()) of
        true -> ?MODULE!{self(),Q},
                receive
                    {?MODULE, error} -> erlang:error(error);
                    {?MODULE, Reply} -> Reply
                end;
        false -> erlang:error(not_ruuning)
    end.

stop() -> rpc(stop).

version() -> 
	rpc("version$version.string").

transpose(M)->
	rpc(io_lib:format("t(~s)",[matrix(M)])).

multiply(A,B)->
	rpc(io_lib:format("~s%*%~s",[matrix(A),matrix(B)])).


matrix(M)->
	Xs=[float_to_list(X/1.0,[{decimals, 8}, compact])||X<-lists:flatten(M)],
	NRows=length(M),
	NCols=length(Xs) div NRows,
	string:join(["matrix(c(",string:join(Xs,","),"),",integer_to_list(NRows),",",integer_to_list(NCols),",byrow=TRUE)"],"").

col2row({NR,NC,Vector})->
	col2row({NR,NC-1,lists:nthtail(NR,Vector)},[[X]||X<-lists:sublist(Vector,NR)]).
col2row({NR,0,[]},Acc)->
	[lists:reverse(R)||R<-Acc];
col2row({NR,NC,Vector},Acc) ->
	col2row({NR,NC-1,lists:nthtail(NR,Vector)},[[H|T]||{H,T}<-lists:zip(lists:sublist(Vector,NR),Acc)]).

parse(Rdata)->
	case erserve:type(Rdata) of
         unsupported -> case Rdata of
							 {xt_has_attr,{{xt_list_tag,[{{xt_str,<<"dim">>},
                             {xt_array_int,[NCol,NRow]}}]},
              				 {xt_array_double,Vector}}} -> col2row({NCol,NRow,Vector});
							 Rdata -> Rdata
						end;
         xt_array_str -> erserve:parse(Rdata);
         _  -> erserve:parse(Rdata)
    end.

exec(Conn,R)->
    try erserve:eval(Conn,R) of
		{ok, Rdata} -> parse(Rdata)
    catch
        _:_ -> error
    end.

loop(Conn) ->
    receive
        {From, stop} -> From!{?MODULE, stopped};
        {From, List} when is_list(List) -> From!{?MODULE, exec(Conn,List)},loop(Conn);
        {From, _} -> From!{?MODULE,unknown}
    end.
