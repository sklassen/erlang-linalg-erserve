-module(linalg_r_tests). 
-import(linalg_r,[transpose/1,inv/1,matmul/2]).
-include_lib("eunit/include/eunit.hrl").

transpose_1_test() ->
	?assert(transpose([[8.0]])=:=[[8.0]]).

transpose_2_test() ->
	?assert(transpose([[1.0,2.0],[3.0,4.0]])==[[1.0,3.0],[2.0,4.0]]).

transpose_3_test() ->
	?assert(transpose([[1.0,2.0,3.0],[4.0,5.0,6.0]])==[[1.0,4.0],[2.0,5.0],[3.0,6.0]]).

%inv_1_test()->
%	?assertEqual([[0.125]],inv([[8.0]])).
%
%inv_2_test()->
%	?assertEqual([[1.0,0.0],[0.0,0.5]],inv([[1.0,0.0],[0.0,2.0]])).
%
%inv_3_test()->
%	?assertEqual([[-1.0,-1.0,2.0],[-1.0,0.0,1.0],[2.0,1.0,-2.0]],inv([[1.0,0.0,1.0],[0.0,2.0,1.0],[1.0,1.0,1.0]])).


matmul_2_test()->
	?assert(matmul([[1.0,2.0],[3.0,4.0]],[[1.0,3.0],[2.0,4.0]])==[[5.0,11.0],[11.0,25.0]]).

