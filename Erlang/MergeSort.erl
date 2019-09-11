-module(mergesort).
-export([mergesort/1, timeit/2, start/3]).

mergesort([])-> [];
mergesort([H]) -> [H];
mergesort(List) ->
            {Lhalf, Rhalf} = lists:split(length(List) div 2,List),
            merge(mergesort(Lhalf), mergesort(Rhalf)).


merge(Lhalf, Rhalf) ->
          merge(Lhalf, Rhalf, []).


merge([], Y, ACC) -> lists:reverse(ACC) ++ Y;
merge(X, [], ACC) -> lists:reverse(ACC) ++ X;
merge([],[], ACC) -> lists:reverse(ACC);

merge([Hl|Tl], [Hr|Tr], ACC) ->
      if Hl < Hr -> merge(Tl, [Hr|Tr], [Hl|ACC]);
        true -> merge([Hl|Tl], Tr, [Hr|ACC])
      end.


timeit(F, A) ->
        T1 = erlang:monotonic_time(),
        Val = apply(F, A),
        T2 = erlang:monotonic_time(),
        Time = erlang:convert_time_unit(T2 - T1, native, micro_seconds),
        Time.

start(FName, Counter, Result) ->
   if Counter > 0 ->
           {ok, BinaryList} = file:consult(FName),
           List = hd(BinaryList),
           NewResult = timeit(fun mergesort/1, [List]),
           start(FName, Counter-1, [NewResult|Result]);
      true -> Result
   end.
