module BasicParsersTests where

import Test.HUnit
import Def
import BasicParsers

-- assertFailure :: String -> Assertion
-- assertBool :: String -> Bool -> Assertion
-- assertString :: String -> Assertion
-- assertEqual :: (Eq a, Show a) => String -> a -> a -> Assertion

{- STRATEGY:
- Top level "Test" name binding will take as name the name of the .hs file (and thus the `module` above)
- TestList will take individual Tests (in the case of unit testing for functions, each Test in the TestList will be
    a group of TestCases for this function)
- Conclusion from this Strat: Top level binding (which is also the .hs file name) should represent the logical entity
    that groups the tests inside the file -}

-- TestLabel "parseChar tests" testParseChar,
basicParserTests = TestList [TestLabel "parseChar tests: " parseCharTests,
                             TestLabel "parseAnyChar tests: " parseAnyCharTests,
                             TestLabel "parseFloat tests: " parseFloatTests
                            ]

parseCharTests = TestList [parseCharCase1, parseCharCase2, parseCharCase3]
parseCharCase1 = TestCase (assertEqual "paseChar: "
                          (Just('a', "bc")) (runParser (parseChar 'a') "abc")
                          )
parseCharCase2 = TestCase (assertEqual "paseChar: "
                          (Nothing) (runParser (parseChar 'b') "abc")
                          )
parseCharCase3 = TestCase (assertEqual "paseChar: "
                          (Nothing) (runParser (parseChar 'a') "")
                          )


parseAnyCharTests = TestList [parseAnyCharCase1, parseAnyCharCase2, parseAnyCharCase3, parseAnyCharCase4]
parseAnyCharCase1 = TestCase (assertEqual "parseAnyChar: "
                  (Just('a', "bcd")) (runParser (parseAnyChar "abc") "abcd")
                    )
parseAnyCharCase2 = TestCase (assertEqual "parseAnyChar: "
                  (Just('c', "def")) (runParser (parseAnyChar "bca") "cdef")
                    )
parseAnyCharCase3 = TestCase (assertEqual "parseAnyChar: "
                  (Just('a', "bcd")) (runParser (parseAnyChar "bca") "abcd")
                    )
parseAnyCharCase4 = TestCase (assertEqual "parseAnyChar: "
                  (Nothing) (runParser (parseAnyChar "abc") "")
                    )


parseFloatTests = TestList [parseFloatCase1, parseFloatCase2, parseFloatCase3, parseFloatCase4]
parseFloatCase1 = TestCase (assertEqual "1 real digit and multiple decimal digits :"
                            (Just(1.234, "")) (runParser parseFloat "1.234"))
parseFloatCase2 = TestCase (assertEqual "multiple real digits and multiple decimal digits :"
                            (Just(1234.567, "")) (runParser parseFloat "1234.567"))
parseFloatCase3 = TestCase (assertEqual "parsing int as float"
                            (Just(1.0, "")) (runParser parseFloat "1"))
parseFloatCase4 = TestCase (assertEqual "Negative Float "
                            (Just(-0.123, "")) (runParser parseFloat "-0.123"))
