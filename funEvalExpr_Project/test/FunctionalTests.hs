module FunctionalTests where

import Test.HUnit
import Def
import BasicParsers
import Parser



functionalTests = TestList [ TestLabel "Addition Tests" additionTests,
                              TestLabel "Subtraction Tests" subtractionTests,
                              TestLabel "Addition and Subtraction" addAndSubtractTests
                            ]


additionTests = TestList [additionCase1, additionCase2, additionCase3, additionCase4]
additionCase1 = TestCase (assertEqual "Two floats"
                            (Just(3.5801, "")) (runParser parseExpr "1.1234+2.4567"))
additionCase2 = TestCase (assertEqual "Two zeros"
                            (Just(0.00, "")) (runParser parseExpr "000+0000000"))
additionCase3 = TestCase (assertEqual "Two ints"
                            (Just(323596876.00, "")) (runParser parseExpr "74648582+248948294"))
additionCase4 = TestCase (assertEqual "Multiple ints"
                            (Just(15.00, "")) (runParser parseExpr "1+2+3+4+5"))


subtractionTests = TestList  [subtractionCase1,
                              subtractionCase2,
                              subtractionCase3,
                              subtractionCase4,
                              subtractionCase5,
                              subtractionCase6,
                              subtractionCase7]
subtractionCase1 = TestCase (assertEqual "Two floats"
                            (Just(0.00, "")) (runParser parseExpr "2.1234-2.1234"))
subtractionCase2 = TestCase (assertEqual "Negative from negative"
                            (Just(-3.33, "")) (runParser parseExpr "-1.11-2.22"))
subtractionCase3 = TestCase (assertEqual "Smaller from bigger"
                            (Just(174299712.41955, "")) (runParser parseExpr "248948294.543-74648582.12345"))
subtractionCase4 = TestCase (assertEqual "Bigger from smaller"
                            (Just(-174299712.41955, "")) (runParser parseExpr "74648582.12345-248948294.543"))
subtractionCase5 = TestCase (assertEqual "Multiple numbers"
                            (Just(2.00, "")) (runParser parseExpr "12-3-3-4"))
subtractionCase6 = TestCase (assertEqual "Multiple sub-expressions"
                            (Just(-2.00, "")) (runParser parseExpr "((((((((((((((((((((((2-2)-2)))))))))))))))))))))"))
subtractionCase7 = TestCase (assertEqual "Multiple consecutive minus signs"
                            (Just(-5.00, "")) (runParser parseExpr "-3---2"))

addAndSubtractTests = TestList [addSubCase1, addSubCase2]
addSubCase1 = TestCase (assertEqual "First mix"
                            (Just(7.2566, "")) (runParser parseExpr "12-0.1234+0.5-5.12"))
addSubCase2 = TestCase (assertEqual "Consecutive plus and minus signs"
                            (Just(2.0, "")) (runParser parseExpr "3+-1"))
