{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
import Control.Exception
import Formatting
import Formatting.Clock
import System.Clock
import Control.DeepSeq
import System.IO
mergesort [] = []
mergesort [x] = [x]
mergesort xs = let (lhalf, rhalf) = splitAt (length xs `div` 2) xs
               in merge' (mergesort lhalf) (mergesort rhalf)

merge' lhalf rhalf = merge lhalf rhalf []

merge [] [] acc = reverse acc
merge [] y acc = reverse acc ++ y
merge x [] acc = reverse acc ++ x

merge (l:ls) (r:rs) acc
        | l < r = merge ls (r:rs) (l:acc)
        | otherwise = merge rs (l:ls) (r:acc)

toList :: String -> [Integer]
toList input = read ("[" ++ input ++ "]")

repeater unsortedlist 0 result = return (result)

repeater unsortedlist counter result = do
                            start <- getTime Monotonic
                            let !e = mergesort unsortedlist
                            print (last e)
                            end <- getTime Monotonic
                            let newTime = toNanoSecs (diffTimeSpec start end)
                            repeater unsortedlist (counter-1) (newTime:result)

main = do
    file <- getLine
    contents <- readFile file
    let !unsortedlist = (toList contents)
    !l <- repeater unsortedlist 1000 []
    outh <- openFile "T750" WriteMode
    hPrint outh l
    hClose outh
    return ()
