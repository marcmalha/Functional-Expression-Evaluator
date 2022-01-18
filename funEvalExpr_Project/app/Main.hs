module Main where

import System.Environment (getArgs)
import System.Exit (exitWith, ExitCode(ExitFailure))

import BasicParsers
import Def
import Parser

import Numeric (showFFloat)


synopsis :: String
synopsis = "USAGE \n\
\    ./evalExpr expr \n\
\\n\
\DESCRIPTION \n\
\    expr    mathematical expression to be evaluated \n\
\            Valid operators are \"+\" \"-\" \"*\" \"/\" \"^\" and \"()\""


main :: IO ()
main = do
  args <- getArgs
  if length args /= 1
    then exitWith $ ExitFailure(84)
    else if (args !! 0) == "-h" || (args !! 0) == "--help"
          then putStrLn synopsis
          else case runParser parseExpr (filter (/= ' ') (args !! 0)) of
            Nothing -> putStrLn "Expression not valid" >> exitError
            Just(res, rem) -> if null rem
                              then putStrLn $ showFFloat (Just 2) res ""
                              else putStrLn "Expression not valid" >> exitError
  where exitError = exitWith $ ExitFailure(84)