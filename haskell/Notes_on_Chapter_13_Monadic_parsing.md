---
tags: ["#haskell"]
---
Parsing turns out to be a nice application of monads, and in this chapter a collection of functions for parsing strings is created based on monadic ideas.

## What is a parser?
**Parsing** is the problem of converting a string, such as `"(2+3)*x"` into a some other format, usually one that is easier for a computer to work with. A **parser** is a program that converts a string into this other format.

The output of a parser is often a **syntax tree**. A tree format is often quite useful for internal processing inside a program. In general, we often call the output of a parser a **parse tree**.

Parser used in many different applications. For example, compilers and interpreters must parse their input before executing it. Web pages written in HTML and CSS must be parsed before they are rendered. Computers that read any kind of text file often somehow parse the text into a different internal format.


## Parsers as functions
In Haskell, any function that converts a string to a tree can be thought of as a parser. Such functions might have this type:

```haskell
type Parser = String -> Tree
```

Here `Tree` is some tree-like type that we want to map strings into.

This type is not as useful as it could be. For example, we might parse a string that starts with a number and is followed by a word. In practice this occurs frequently, and so it would be helpful if the parser returns the parse tree for the number, plus the rest of the unparsed string:

```haskell
type Parser = String -> (Tree, String)
```

Another complexity is that a parse might fail. For example, if you are trying to parse a number, but your string is the word "shoe",  then parser fails. Our textbook handles this situation be returning the output as a list:

```haskell
type Parser = String -> [(Tree, String)]
```

The idea is that if the parser returns the empty list, then it has failed. If it succeeds, then it returns one `(Tree, String)` pair in a list.

> **Note** Some parsers return multiple `(Tree, String)` pairs. For instance, a natural language parser for English might return multiple possible parses of a sentence. For simplicity, we will only deal with parsers that return a single parse.

One more detail is useful. While we say in general that a parser returns a tree, it is useful to abstract this away and allow the parser to return whatever type is convenient. So our final parser type is  this:

```haskell
type Parser a = String -> [(a, String)]
```

## Basic Definitions
To make the types work Haskell classes, we define a parser using `newtype`:

```haskell
newtype Parser a = P (String -> [(a, String)])
```

The constructor `P` is requires by `newtype`, and so we call this a  **dummy constructor**.

The `parse` function take a parser and a string, and applies the parser to the string:

```haskell
parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp
```

`item` is a basic building block parser that parses the first `Char` of a string:

```haskell
item :: Parser Char
item = P (\inp -> case inp of
                     []     -> []
                     (x:xs) -> [(x,xs)]
         )
```

For example:

```haskell
> parse item "2+3"
[('2',"+3")]
> parse item "apple"
[('a',"pple")]
> parse item ""
[]
```

## Sequencing parsers
Next we creative instances of `Functor`, `Applicative`, and `Monad` for our parser type:

```haskell

instance Functor Parser where
    -- fmap :: (a -> b) -> Parser a -> Parser b
    fmap g p = P (\inp -> case parse p inp of
                            []         -> []
                            [(v, out)] -> [(g v, out)]
                 )


instance Applicative Parser where
    -- pure :: a -> Parser a
    pure v = P (\inp -> [(v, inp)])

    -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b
    pg <*> px = P ( \inp -> case parse pg inp of
                              []         -> []
                              [(g, out)] -> parse (fmap g px) out
                )

instance Monad Parser where
    -- return :: a -> Parser a
    -- return = pure

    -- (>>=) :: Parser a -> (a -> Parser) -> Parser b
    p >>= f = P ( \inp -> case parse p inp of
                            []         -> []
                            [(v, out)] -> parse (f v) out
              )
```

We'll be writing *monadic parsers*, which means we'll be using the do-notation from provided by the `Monad` instance.

Note that `return` is just `pure`, and `pure` takes any value `x` and gives you a parser that, no matter what string you give it, returns a successful parse with `x` as the value and the entire string as the rest.

For example, here is parser that returns the second and fourth character of a string:

```haskell
ptest1 :: Parser (Char, Char)
ptest1 = do item             -- skip the first char
            second <- item   -- save the second char
            item             -- skip the third char
            fourth <- item   -- save the fourth char
            return (second, fourth)
```

Recall that the do-notation is just a nicer syntax for repeated use of `Monad` bind operator `(>>=)`. We can use do-notation because of the `instance Monad Parser` definition above.

Here's how it works:

```haskell
> parse ptest1 "123456"
[(('2','4'),"56")]
> parse ptest1 "{a,b}"
[(('a','b'),"}")]
> parse ptest1 "SFU"
[]
```

In the last example the string `"SFU"`, which doesn't have a fourth character, the parser correctly fails by returning `[]`.

## Making choices
Suppose you have two parsers, `p1` and `p2`, and a single string `s` that you want to parse. Often you want to parse `s`, but you don't know if you should use `p1` or `p2`. To solve this problem you could proceed like this:
- Try parsing `s` with `p1`. If that succeeds, you're done.
- If `p1` fails, then try parsing with `p2`. If `p2` succeeds, you're done.
- If both `p1` and `p2` fail, then the entire parse fails.

To assist with implementing this idea, the Haskell standard library provides a class called `Alternative`:

```haskell
class Applicative f => Alternative where
    empty :: f a
    (<|>) :: f a -> f a -> f a
```

For a parser we implement it like this:

```haskell
instance Alternative Parser where
    -- empty :: Parser a
    empty = P ( \inp -> [] )

    -- (<|>) :: Parser a -> Parser a -> Parser a
    p <|> q = P (\inp -> case parse p inp of
                            []         -> parse q inp
                            [(v, out)] -> [(v, out)]

              )
```

`empty` is the empty parser that *always fails*. No matter what string you give `empty`, it returns `[]`. For example:

```haskell
> parse empty "abc"
[]
> parse empty ""
[]
```

The `(<|>)` operator takes two parsers `p` and `q` as input, and first tries parsing `inp` with `p`. If `p` succeeds (i.e. returns a non-empty list), then its result is returned. Otherwise, the result of calling `q` on `inp` is returned.

## Derived Primitives
We can now build a number of small but very useful parsers.

First, `sat` takes a `Char` predicate function `p`, and returns a parser that succeeds just if the first character of the string satisfies `p`:

```haskell
sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item
           if p x 
           then return x
           else empty
```

```haskell
> parse (sat isDigit) "wonder"
[]
> parse (sat isDigit) "1der"
[('1',"der")]
> parse (sat isDigit) "a4"
[]
> parse (sat isDigit) "4"
[('4',"")]
```

With `sat` we can make these single-character parsers:

```haskell
digit :: Parser Char
digit = sat isDigit

lower :: Parser Char
lower = sat isLower

upper :: Parser Char
upper = sat isUpper

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char x = sat (== x)
```

For example, this parser succeeds when the string starts with a 3-character sequence consisting of an upper case letter, a digit, and then a lower case letter:

```haskell
ptest2 :: Parser (Char, Char, Char)
ptest2 = do a <- upper
            b <- digit
            c <- lower
            return (a, b, c)
```

```haskell
> parse ptest2 "A3m"
[(('A','3','m'),"")]
> parse ptest2 "a3m"
[]
> parse ptest2 "A3m25"
[(('A','3','m'),"25")]
```

Now we can write a parser that checks for a given string at the start of the input:

```haskell
string :: String -> Parser String
string []     = return []
string (x:xs) = do char x
                   string xs
                   return (x:xs)
```

```haskell
> parse (string "SFU") "SFU is a university"
[("SFU"," is a university")]
> parse (string "SFU") "Sfu is a university"
[]
```

Note how we are building new parsers out of previous ones. This is one of the nice features of the monadic approach to parsing.

### Two parsers for free: many and some
Since we've made a `Parser` instance of the `Alternative` class, the parses `many` and `some` have been defined for us already.

`many p` repeatedly applies parser `p` to the input string until it fails. For example:

```haskell
> parse (many digit) "123abc"
[("123","abc")]
> parse (many digit) "abc123"
[("","abc123")]
```

The second example shows that `many p` succeeds if the parser succeeds 0 times. So the parser `many p` succeeds if `p` can be applied 0 or more times to the input.

`some p` is almost the same as `many p`, except it succeeds if `p` can be applied 1 or more times to the input:

```haskell
> parse (some digit) "123abc"
[("123","abc")]
> parse (some digit) "abc123"
[]
```

Now we can, for instance, define a parser that matches programming language identifiers that start with a lowercase letter, and are followed by 0 or more alpha-numeric characters:

```haskell
ident :: Parser String
ident = do first <- lower
           rest <- many alphanum  -- many is 0 or more
           return (first:rest)
```

```haskell
> parse ident "a1M45"
[("a1M45","")]
> parse ident "A1M45"
[]
> parse ident "1M45"
[]
> parse ident "a1M45 is an identifier"
[("a1M45"," is an identifier")]
```

`nat` parses non-negative integers:

```haskell
nat :: Parser Int
nat = do xs <- some digit  -- some is 1 or more
         return (read xs)
```

```haskell
> parse nat "38"
[(38,"")]
> parse nat "38.343"
[(38,".343")]
> parse nat "38+2"
[(38,"+2")]
> parse nat "three"
[]
```

Using `<->`, we can parse integers like this:

```haskell
int :: Parser Int
int = do char '-'
         n <- nat
         return (-n)
      <|> nat
```

```haskell
> parse int "274 is big"
[(274," is big")]
> parse int "-9009 is small"
[(-9009," is small")]
> parse int "twelve"
[]
```

`space` parses 0 or more spaces at the start of a string:

```haskell
space :: Parser ()
space = do many (sat isSpace)  -- many is 0 or more
           return ()
```

The type of `space` is `()`, and so the parsed spaces are discarded:

```haskell
> parse space "   "
[((),"")]
> parse space "   cat"
[((),"cat")]
> parse space ""
[((),"")]
```

## Handling spacing
Many kinds of parsing allow extra spaces to appear around tokens. For example, `"2+3"`, `"2 + 3"`, and `"     2+    3  "` should all parse to the same thing.

The `token` function takes a parser and returns a new parser that does the same thing, except extra spaces at the beginning and end are discarded:

```haskell
token :: Parser a -> Parser a
token p = do space
             v <- p
             space
             return v
```

We can now write "tokenized" versions of our earlier parsers:

```haskell
identifier :: Parser String
identifier = token ident

natural :: Parser Int
natural = token nat

integer :: Parser Int
integer = token int

symbol :: String -> Parser String
symbol xs = token (string xs)
```

For example:

```haskell
> parse integer "  -92 "
[(-92,"")]
> parse integer "  -92.22 "
[(-92,".22 ")]
> parse (symbol "+") "  +   12"
[("+","12")]
```

The `nats` function parses a list of natural numbers:

```haskell
nats :: Parser [Int]
nats = do symbol "["
          n <- natural
          ns <- many (do symbol "," 
                         natural)
          symbol "]"
          return (n:ns)
```

```haskell
> parse nats "   [1  ,   2,   3  ]    "
[([1,2,3],"")]
> parse nats "[1]"
[([1],"")]
> parse nats "[]"
[]
```

### Challenge: the empty list
The `nats` function fails when parsing an empty list:

```haskell
> parse nats "  [  ] "
[]
```

Recall that when a parser returns `[]`, it has not parsed its input.

Write a function called `nats2` that is a modification `nats` that successfully parses the empty list.  For example:

```haskell
> parse nats2 "  [  ] "
[([],"")]
```

`nats2` should work the same as `nats` for all other inputs.

## Example: Arithmetic Expressions
Parsing arithmetic expressions is an important and useful problem. Given a string like "2 + 3 * 5", we would like to evaluate it as 17.

The first step in creating an expression parser is to define precisely what expressions we consider to be valid. We do that using a **grammar**:

```
expr ::=  expr "+" expr
        | expr "*" expr
        | "(" expr ")"
        | nat

nat  ::= "0" | "1" | "2" | "3" | ...
```

Symbols like `::=` and `|` are part of the grammar language, and don't appear in the strings being parsed. Quoted strings, like `"+"` and `"("`, can actually appear in expressions.

The symbol `|` can be read "or". It indicates a choice. The `::=` is used to define a new expression.

This grammar consists of two rules. For example, the `nat` rule says that a `nat` is either 0, or a 1, or a 2, and so on. The `expr` says that a valid expression has one of four possible formats:
1. expression + expression, i.e. any two expressions added together
2. expression * expression, i.e. any two expressions multiplied together
3. ( expression ), i.e. any expression written in parentheses
4. a natural number, i.e. all natural numbers are considered to be expressions

The grammar is recursive in the sense that *any* occurrence of `expr` can be replaced by one of the 4 valid expression formats. For example, if you start with `expr + expr`, you could replace the first expression with `5` to get `5 + expr`, and you could replace the second expression with `(expr)` to get `5 + (expr)`. Continuing like this, you could now replace `expr` with, say, `expr * expr`, giving you `5 + (expr * expr)`. You can continue with such replacements as many steps as you like, which allows you to build up complex expressions.

Here are some examples of **valid** expressions:

- 8
- 2 + 3
- (2 + 3)
- 9 + (4 * 16)
- (((5)))

And some **invalid** expressions:

- 8.0
- 3 - 2
- (2 + 3
- * 4 16

As described in the textbook, the grammar can be used to create a **parse tree** for any valid expression. Parse trees are a common internal representation for the result of parsing an expression that are much easier to work with programmatically than a string of characters.

Unfortunately, the grammar we use above is **ambiguous**, i.e. it allows for more than one way to successfully parse some expressions. For example, the expression `"2*3+4"` could be parse in a way that means $(2 \cdot 3) + 4$, or $2 \cdot (3 + 4)$. Only the first parse is correct, since multiplication is always done before addition (when there is a choice).

So we need to re-write the grammar in way that avoids this kind of ambiguity. We won't go into the details here, but this grammar is unambiguous:

```
expr   ::=  term ("+" expr | "" )
term   ::=  factor ("*" term | "" )
factor ::=  "(" expr ")" | nat
nat    ::=  "0" | "1" | "2" | "3" | ...
```

For instance, with this grammar there is only way (the correct way) to parse `"2*3+4"`. It also properly handles associativity, i.e. an expressions like `"1+2+3+4"` means `"((1+2)+3)+4"`.

With this unambiguous grammar in hand, it is now relatively straightforward to convert it into a Haskell functional parser:

```haskell
-- expr   ::=  term ("+" expr | "" )
expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return (t + e)
           <|> return t

-- term   ::=  factor ("*" term | "" )
term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             return (f * t)
           <|> return f


-- factor ::=  "(" expr ")" | nat
factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
          <|> natural

eval :: String -> Int
eval xs = case (parse expr xs) of
             [(n,[])]  -> n
             [(_,out)] -> error ("Unused input " ++ out)
             []        -> error "Invalid input"
```

Instead of returning a parse tree, this parser returns the evaluation of the expression itself (which is what we want in the end).

## Example: Calculator
See textbook example, which includes details for making a nice ASCII display of the calculator in the terminal.

However, it is useful to look at a simpler interactive calculator to help improve our understanding of Haskell.

Consider this `chat` function, which prints whatever the user types:

```haskell
quote :: String -> String
quote s = "\"" ++ s ++ "\""

-- This functions shows the basic structure for an interactive command-line.
chat :: IO ()
chat = do putStr "--> "
          line <- getLine
          putStrLn ("You said: " ++ quote line)
          chat
```

We can modify `chat` to use the parser from the second example at the end of chapter 13:

```haskell
--
-- Below is the expression parser from the second 
-- calculator example in the. It can parse more 
-- expressions than the previous one.
--

expr :: Parser Int
expr = do t <- term
          do symbol "+"
             e <- expr
             return (t + e)
           <|> do symbol "-"
                  e <- expr
                  return (t - e)
           <|> return t

term :: Parser Int
term = do f <- factor
          do symbol "*"
             t <- term
             return (f * t)
           <|> do symbol "/"
                  t <- term
                  return (f `div` t)
           <|> return f

factor :: Parser Int
factor = do symbol "("
            e <- expr
            symbol ")"
            return e
          <|> integer

evaluate :: String -> String
evaluate s = case parse expr s of
                 [(n,[])] -> show n
                 _        -> "error!"

calc :: IO ()
calc = do putStr "--> "
          line <- getLine
          putStrLn (evaluate line)
          calc
```

### Challenge: quitting the calculator
Write a function called `calc2` that works the same as `calc`, except when the user types "done", the function prints the message "Goodbye!" and exists the function. For example:

```haskell
> calc
--> done
> calc
--> 8-10
-2
--> Done
error!
--> done
> 
```
