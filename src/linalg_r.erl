-module(linalg_r).
-import(linalg_r_srv,[rpc/1]).
-export([version/0, transpose/1, inv/1, matmul/2]).

version() -> 
    rpc("version$version.string").

transpose(M)->
    rpc(io_lib:format("t(~s)",[matrix(M)])).

inv(M)->
    X = io_lib:format("Matrix::chol2inv(chol(~s))",[matrix(M)]),
    io:format("~s",[X]),
    rpc(io_lib:format("Matrix::chol2inv(chol(~s))",[matrix(M)])).

matmul(A,B)->
    rpc(io_lib:format("~s%*%~s",[matrix(A),matrix(B)])).


matrix(M)->
    Xs=[float_to_list(X/1.0,[{decimals, 8}, compact])||X<-lists:flatten(M)],
    NRows=length(M),
    NCols=length(Xs) div NRows,
    string:join(["matrix(c(",string:join(Xs,","),"),",integer_to_list(NRows),",",integer_to_list(NCols),",byrow=TRUE)"],"").
