{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
import Control.Exception
import Formatting
import Formatting.Clock
import System.Clock
import Control.DeepSeq
import System.IO

transpose :: [[a]] -> [[a]]
transpose m = rows m []

rows :: [[a]] -> [[a]] -> [[a]]
rows [] result = reverserows result []
rows (row:otherRows) result = let newresult = makecolumn row result in rows otherRows newresult

makecolumn :: [t] -> [[t]] -> [[t]]
makecolumn [] result = result
makecolumn (row:otherRows) [] = [row]:makecolumn otherRows []
makecolumn (row:otherRows) (fResultRow:otherResultRows) = (row:fResultRow): makecolumn otherRows otherResultRows

reverserows :: [[a]] -> [[a]] -> [[a]]
reverserows [] result = reverse result
reverserows (row:otherRows) result = reverserows otherRows (reverse row : result)

matmul :: Num a => [[a]] -> [[a]] -> [[a]]
matmul matrixOne matrixTwo = multiply matrixOne (transpose matrixTwo)

multiply :: Num a => [[a]] -> [[a]] -> [[a]]
multiply [] x = []
multiply (firstRow: otherRows) matrixTwo = calcRow firstRow matrixTwo : multiply otherRows matrixTwo

calcRow :: Num a => [a] -> [[a]] -> [a]
calcRow x [] = []
calcRow row (matrixTwoRow:otherRows) = calcCol row matrixTwoRow : calcRow row otherRows

calcCol :: Num a => [a] -> [a] -> a
calcCol [] [] = 0
calcCol (row: otherRows) (matrixTwoRow:matrixTwootherRows) = row*matrixTwoRow + calcCol otherRows matrixTwootherRows

repeater matrixOne matrixTwo 0 result = return (result)

repeater matrixOne matrixTwo counter result = do
                                      start <- getTime Monotonic
                                      let !e = matmul matrixOne matrixTwo
                                      print(last e)
                                      end <- getTime Monotonic
                                      let newTime = toNanoSecs (diffTimeSpec start end)
                                      repeater matrixOne matrixTwo (counter-1) (newTime:result)
