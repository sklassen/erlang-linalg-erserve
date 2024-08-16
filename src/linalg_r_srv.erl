-module(linalg_r_srv).
-export([start/0,start/1, stop/0, rpc/1]).

% Note R is COLMAJOR by default, We are ROWMAJOR, so we convert as required

start() ->
    start([]).

start([]) ->
    application:start(erserve),
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
        false -> start(),rpc(Q)
    end.

stop() -> rpc(stop).

col2row({NR,NC,Vector})->
    col2row({NR,NC-1,lists:nthtail(NR,Vector)},[[X]||X<-lists:sublist(Vector,NR)]).
col2row({_NR,0,[]},Acc)->
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
