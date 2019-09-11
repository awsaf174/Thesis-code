-module(sieve).
-export([main/1, start/3]).
main(M) -> [2| primes(M, lists:seq(3, M, 2))].

primes(M, [P|XS]) ->
            primes(M, P, XS).


primes(M, P, XS) when P*P < M -> [P|primes(M, remove(XS, lists:seq(P*P, M, P*2)))];

primes(M, P, XS) when P*P > M -> [P|XS].

remove(A,[]) ->  A;
remove([], B) -> [];

remove([X|XS], [M|MS]) when X < M -> [X|remove(XS, [M|MS])];
remove([X|XS], [M|MS]) when X == M -> remove(XS, MS);
remove ([X|XS], [M|MS]) when X > M -> remove([X|XS], MS).

timeit(F, A) ->
        T1 = erlang:monotonic_time(),
        Val = apply(F, A),
        T2 = erlang:monotonic_time(),
        Time = erlang:convert_time_unit(T2 - T1, native, nano_seconds),
        Time.


start(N, Counter, Result) ->
   if Counter > 0 ->
           NewResult = timeit(fun main/1, [N]),
           start(N, Counter-1, [NewResult|Result]);
      true -> Result
   end.
