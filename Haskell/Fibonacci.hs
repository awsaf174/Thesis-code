{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
import Control.Exception
import Formatting
import Formatting.Clock
import System.Clock
import Control.DeepSeq
import System.IO


fib n = fib' n 0 1
fib' 0 result next = result
fib' n result next = fib' (n-1) next (result + next)


repeater n 0 result = return (result)

repeater n counter result = do
                            start <- getTime Monotonic
                            let !e = fib n
                            end <- getTime Monotonic
                            print e
                            let !newTime = toNanoSecs (diffTimeSpec start end)
                            repeater n (counter-1) (newTime:result)

main = do
    l <- repeater 1000000 1000 []
    outh <- openFile "T1000000" WriteMode
    hPrint outh l
    hClose outh
    return ()
