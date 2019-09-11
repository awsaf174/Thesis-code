-module(fibonacci).

-export([fibstart/1, start/3]).

fibstart(N) -> fibseq(N, 1, 0).

fibseq(0, Next, Result) -> Result;

fibseq(N, Next, Result) -> fibseq(N-1, Result, Next+Result).


timeit(F, A) ->
        T1 = erlang:monotonic_time(),
        Val = apply(F, A),
        T2 = erlang:monotonic_time(),
        Time = erlang:convert_time_unit(T2 - T1, native, nano_seconds),
        Time.


start(N, Counter, Result) ->
   if Counter > 0 ->
           NewResult = timeit(fun fibstart/1, [N]),
           start(N, Counter-1, [NewResult|Result]);
      true -> Result
   end.
