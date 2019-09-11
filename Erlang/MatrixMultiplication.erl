-module(matmultest).
-export([matmul/2, start/4]).

transpose (Matrix) -> rows(Matrix, []).

rows([], Result) ->
          reverse_rows(Result, []);

rows([Row|OtherRows], Result) ->
                NewResult = makecolumn(Row, Result),
                rows(OtherRows, NewResult).

makecolumn([], Result) -> Result;

makecolumn([H|T], []) ->
          [[H] | makecolumn(T, [])];

makecolumn([H|T], [RH|RT]) ->
          [[H|RH] | makecolumn(T, RT)].


reverse_rows([], Result) -> lists:reverse(Result);

reverse_rows([FirstRow|OtherRows], Result) ->
  reverse_rows(OtherRows, [lists:reverse(FirstRow) | Result]).


matmul(MatrixOne, MatrixTwo) -> multiply(MatrixOne, transpose(MatrixTwo)).

multiply([], _) -> [];

multiply([FirstRow|OtherRows], MatrixTwo) ->
                              [calcRow(FirstRow, MatrixTwo)|multiply(OtherRows, MatrixTwo)].

calcRow(_, []) -> [];

calcRow(Row, [MatrixTwoH|T]) -> [calcCol(Row, MatrixTwoH)|calcRow(Row, T)].

calcCol([],[]) -> 0;

calcCol([RH|RT], [ColH|COlT]) -> RH*ColH + calcCol(RT, COlT).


timeit(F, A) ->
        T1 = erlang:monotonic_time(),
        Val = apply(F, A),
        T2 = erlang:monotonic_time(),
        Time = erlang:convert_time_unit(T2 - T1, native, micro_seconds),
        Time.

start(Fmatrix1, Fmatrix2, Counter, Result) ->
   if Counter > 0 ->
           {ok, BinaryList1} = file:consult(Fmatrix1),
           {ok, BinaryList2} = file:consult(Fmatrix2),
           Matrix1 = hd(BinaryList1),
           Matrix2 = hd(BinaryList2),
           NewResult = timeit(fun matmul/2, [Matrix1, Matrix2]),
           start(Fmatrix1, Fmatrix2, Counter-1, [NewResult|Result]);
      true -> Result
   end.
