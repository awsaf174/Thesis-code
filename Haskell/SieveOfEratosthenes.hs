{-# LANGUAGE BangPatterns #-}
import Control.Exception
import Formatting
import Formatting.Clock
import System.Clock
import Control.DeepSeq
import System.IO

primes m = 2 : primes' m [3,5 ..m] [] where
primes' m !integers@(p : xs) !acc   | p*p>m =  reverse acc ++ integers
                                  | True  = primes' m (xs `remove` [p*p, p*p+2*p..m]) (p:acc)

remove !integers@(x:xs) !multiples@(y:ys) | x < y = x : remove xs multiples
                                        | x == y =    remove xs ys
                                        | x > y =     remove integers ys

remove !integers !multiples = integers


repeater m 0 result = return (result)

repeater m counter result = do
                            start <- getTime Monotonic
                            let !e = primes m
                            print (last e)
                            end <- getTime Monotonic
                            let newTime = toNanoSecs (diffTimeSpec start end)
                            repeater m (counter-1) (newTime:result)

main = do
    !l <- repeater 1000 1000 []
    outh <- openFile "sievetimings0000" WriteMode
    hPrint outh l
    hClose outh
    return ()
