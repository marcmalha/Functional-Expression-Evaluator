module Parser where

import Text.Read (readMaybe)

import Control.Applicative
import Data.Maybe (fromJust)
import Data.List (elemIndex)

import BasicParsers
import Def

strToOperator :: Floating a => Char -> Maybe (a -> a -> a)
strToOperator op =  elemIndex op operatorsChars
  >>= \indx -> return $ operatorsFuncs !! indx
    where operatorsFuncs = [(+), (-), (*), (/), (**)]
          operatorsChars = ['+', '-', '*', '/', '^']

parseExpr :: Parser Double
parseExpr = Parser{
  runParser = \str ->
    runParser (parseTerm <|> (parseChar '+' *> parseFloat) <|> parseFloat) str
      >>= \resFloat@(n1, rem1) ->
        case runParser (parseChar '+' <|> parseChar '-') rem1 of
          Nothing -> return resFloat
          Just(opChar, rem2) -> strToOperator opChar
            >>= \op -> runParser parseTerm rem2
              >>= \(n2, rem3) -> 
                if null $ runParser (parseAnyChar "+-") rem3
                then Just(op n1 n2, rem3)
                else runParser parseExpr rem3
                  >>= \(res, rem4) -> Just(op n1 n2 + res, rem4)
}

parseTerm :: Parser Double
parseTerm = Parser{
  runParser = \str ->
    runParser (parseExponent
              <|> (parseChar '*' *> parseFloat)
              <|> ((1/) <$> (parseChar '/' *> parseFloat))
              ) str
      >>= \resFloat@(n1, rem1) ->
        case runParser (parseChar '*' <|> parseChar '/') rem1 of
          Nothing -> return resFloat
          Just(opChar, rem2) -> strToOperator opChar
            >>= \op -> runParser parseExponent rem2
              >>= \(n2, rem3) -> 
                if null $ runParser (parseAnyChar "*/") rem3
                then Just(op n1 n2, rem3)
                else runParser parseTerm rem3
                  >>= \(res, rem4) -> Just(op n1 n2 * res, rem4)
}

parseExponent :: Parser Double
parseExponent = Parser{
  runParser = \str ->
    runParser (parseFactor <|> (parseChar '^' *> parseFloat)) str
      >>= \resFloat@(n1, rem1) ->
        case runParser (parseChar '^') rem1 of
          Nothing -> return resFloat
          Just(opChar, rem2) -> strToOperator opChar
            >>= \op -> runParser parseFactor rem2
              >>= \(n2, rem3) -> 
                if null $ runParser (parseChar '^') rem3
                then Just(op n1 n2, rem3)
                else runParser parseExponent rem3
                  >>= \(res, rem4) -> Just(op n1 n2 ** res, rem4)
}

parseFactor :: Parser Double
parseFactor = Parser{
  runParser = \str ->
    case runParser (parseChar '-' *> parseChar '(') str of
      Just(_, rem) -> runParser (negate <$> (parseExpr <* parseChar ')')) rem
      Nothing -> runParser ((parseChar '(' *> parseExpr <* parseChar ')')
                            <|> parseFloat) str
}