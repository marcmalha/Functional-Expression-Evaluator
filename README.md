# Functional EvalExpr

- [Functional EvalExpr](#functional-evalexpr)
  - [Description](#description)
  - [Usage](#usage)
    - [Compile](#compile)
    - [Run](#run)
  - [Technical Details](#technical-details)

## Description

This project was part of the Epitech 3rd year curriculum.
Its purpose is to evaluate a mathematical expression taken as input,
and output the result as a floating-point number.
This project handles the following mathematical operators:
- Addition "`+`" - Subtraction "`-`"
- Multiplication "`*`" - Division "`/`"
- Exponentiation "`^`"
- Subexpressions delimited by parentheses "`(sub_expr)`"

## Usage
### Compile
Done using a Makefile , wrapping the [stack](https://docs.haskellstack.org/en/stable/README/) haskell development tool.\
Type `make` at the root of the project for the project to compile

### Run
The poject binary's usage is as follows: `./funEvalExpr <expr>`\
Where `<expr>` is a valid mathematical expresion.\
Example:\
`$> ./funEvalExpr "(3.5+2.5)*5"`\
`30.00`



## Technical Details

This project was entirely written in [Haskell](https://www.haskell.org/). \
Its general-purpose parsing library was heavily inspired by Professor Graham Hutton's work, \
which is explained in the following [Computerphile video](https://www.youtube.com/watch?v=dDtZLm7HIJs), and whose code can be found [here](http://www.cs.nott.ac.uk/~pszgmh/Parsing.hs).\
It implements a [recursive descent parser](https://en.wikipedia.org/wiki/Recursive_descent_parser#:~:text=In%20computer%20science%2C%20a%20recursive,the%20nonterminals%20of%20the%20grammar.&text=A%20predictive%20parser%20runs%20in%20linear%20time.) which abides by the following grammar:

> In ascending order of precedence of evaluation:
>> `expr     ::= term + expr  | term`\
>> `term     ::= factor * term  | factor`\
>> `factor   ::= (expr) | float`


The grammar for this project, accounting for all the additional operators, becomes:

> In ascending order of precedence of evaluation:
>> `expr     ::= term + term | term - term | term` \
>> `term     ::= exponent * exponent | exponent / exponent | exponent` \
>> `exponent ::= factor ^ factor | factor` \
>> `factor   ::= (expr) | -(expr) | float`
