module Def where

import Control.Applicative

import Text.Read

data Parser a = Parser {runParser :: String -> Maybe (a, String)}

instance Functor Parser where
  -- fmap :: (a -> b) -> f a -> f b
  fmap f psr = Parser{
    runParser = \str ->
      runParser psr str >>= (\(a, rem) -> Just(f a, rem))
  }

instance Alternative Parser where
  -- empty :: Parser a
  empty = Parser{
    runParser = (\_ -> Nothing)
  }
  -- <|> :: Parser a -> Parser a -> Parser a
  psr1 <|> psr2 = Parser{
    runParser = \str -> case runParser psr1 str of
        Nothing -> runParser psr2 str
        result -> result
  }

instance Applicative Parser where
  -- pure :: a -> Parser a
  pure appPsr = Parser{
    runParser = \str -> Just(appPsr, str)
  }
  -- <*> :: Parser (a -> b) -> Parser a -> Parser b
  f <*> ap = Parser{
    runParser = \str ->
      (runParser f str)
        >>= (\(f', rem) -> runParser (f' <$> ap) rem)
  }
