module Main where

import Test.HUnit
import Parser
import BasicParsersTests
import FunctionalTests

-- assertFailure :: String -> Assertion
-- assertBool :: String -> Bool -> Assertion
-- assertString :: String -> Assertion
-- assertEqual :: (Eq a, Show a) => String -> a -> a -> Assertion

-- A TEST CASE is the unit of test execution.
-- That is, distinct test cases are executed independently.
-- The failure of one is independent of the failure of any other.

-- data Test = TestCase Assertion
--           | TestList [Test]
--           | TestLabel String Test

-- ####################
-- TESTS
-- parseOr (parseChar 'a') (parseChar 'b') "abcd"
-- Just ('a', "bcd")
-- parseOr (parseChar 'a') (parseChar 'b') "bcda"
-- Just ('b', "cda")
-- parseOr (parseChar 'a') (parseChar 'b') "xyz"
-- Nothing
-- ####################

red :: String -> String
red str = "\x1b[1;31m" <> str <> "\x1b[0m"

main :: IO ()
main = (putStrLn . red) "\nRunning Functional Tests"
  >> runTestTT functionalTests >>= (\counts -> putStrLn $ showCounts counts) >> return ()
  >> (putStrLn . red) "Running Parser Library Tests"
  >> runTestTT basicParserTests >>= (\counts -> putStrLn $ showCounts counts) >> return ()
