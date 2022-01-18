module BasicParsers where

import Text.Read (readMaybe)
import Def

parseChar :: Char -> Parser Char
parseChar c = Parser{
  runParser = \str -> case str of
    "" -> Nothing
    (x:xs) -> if c == x
                then Just (c, xs)
                else Nothing
}


parseAnyChar :: String -> Parser Char
parseAnyChar "" = Parser{runParser = (\_ -> Nothing)}
parseAnyChar (x:xs) = Parser{
  runParser = \str ->
    case runParser (parseChar x) str of
      Nothing -> runParser (parseAnyChar xs) str
      result -> result
}

parseMany :: Parser a -> Parser [a]
parseMany psr = Parser{
  runParser = \str ->
    case str of
      "" -> Just([], "")
      str -> case runParser psr str of
              Nothing -> Just([], str)
              Just(tok1, rem1) -> case runParser (parseMany psr) rem1 of
                                    Nothing -> Just([tok1], rem1)
                                    Just(tok2, rem2) -> Just(tok1:tok2, rem2)
}

parseSome :: Parser a -> Parser [a]
parseSome psr = Parser{
  runParser = \str ->
    runParser psr str
      >>= \(tok, rem) -> case runParser (parseMany psr) rem of
                            Just([], rem) -> Just([tok], rem)
                            Just(toks, rem2) -> Just(tok:toks, rem2)
}

parseUInt :: Parser Int
parseUInt = Parser{
  runParser = \str ->
    runParser (parseSome (parseAnyChar ['0'..'9'])) str
      >>= \(tok, rem) -> (readMaybe tok :: Maybe Int)
        >>= \uint -> Just(uint, rem)
}

parseInt :: Parser Int
parseInt = Parser{
  runParser = \str ->
    case str of
      ('-':xs) -> (\(tok, rem) -> (-1*tok, rem)) <$> (runParser parseUInt xs)
      str -> runParser parseUInt str
}

parseFloat :: Parser Double
parseFloat = Parser{
  runParser = \str -> case str of
    ('-':xs) -> runParser (negate <$> parseFloat) xs
    str -> runParser parseInt str
      >>= \(real, rem1) ->
        case runParser (parseChar '.') rem1 of
          Nothing -> Just(realToFrac real, rem1)
          Just(_, rem2) -> runParser parseUInt rem2
            >>= \(frac, rem3) -> Just(consFloat real frac, rem3)
}
  where shiftR n = (realToFrac n) / (10.0 ** (realToFrac $ length $ show n))
        consFloat real frac = (realToFrac real) + (shiftR frac)