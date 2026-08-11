# Notes on Chapter 3: Types and classes

A **type** is a collection of related values. For example, the Haskell type
`Bool` has two value, `True` and `False`.

In Haskell, if `v` is a value and `t` is a type, then `v :: t` means `v` is of
type `t`. This is read "`v` has type `t`". 

If `s` is a type and `t` is a type, then `s -> t` is the type of a *function*
that takes a value of type `s` as input and returns a value of type `t` as
output. We say that the functions **maps** an input of type `S` to an output of
type `t`.

`::` can indicate the type of an expression, e.g.:
- `False :: Bool` says `False` has the type `Bool`
- `True :: Bool` says `True` has the type `Bool`
- `not :: Bool -> Bool` says `not` is a function that takes a `Bool` as input
  and returns a `Bool` as output
- `not False :: Bool` says that the expression `not False` evaluates to an
  expression of type `Bool`

Every expression in Haskell has a type, and most types can be checked *before* a
program runs. This is called **static type checking**. Haskell is a **type
safe** language in the sense that there will never be a type error during the
*evaluation* of an expression.

> **Comparison** Python, Racket, and Javascript are languages that are *not*
> type safe in this sense. They can suffer type errors during evaluation.
> Languages like C++ and Java *are* type safe in most cases.

> **Note** For more details about type inference, check out the [Hindley-Milner
> type
> system](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system).

## Type Inference

Haskell also uses **type inference** to determine the type of a value without
the programmer needing to have to explicitly write the type. This is one of the
things that makes Haskell programs so concise.

For instance, suppose `f` is a function that maps an argument of type `a` to a
result of type `b`. We write `f :: a -> b` to indicate this. Suppose also that
`e` is some expression of type `a`, i.e. `e :: a`. Then if `f` is **applied** to
`e`, written `f e`, the result is of type `b`. In other words, `f e :: b`.

Function application is summed up by this rule:

```
    Given: f :: a -> b  and  e :: a
-------------------------------------
Therefore:         f e :: b
```

For example, since `not :: Bool -> Bool` and `True :: Bool`, this rule lets
Haskell automatically infer that `not Bool` has the type `Bool`, i.e. `not Bool
:: Bool`.

It can also help us find **type errors**. For example, 3 is *not* of type
`Bool`, and so `not 3` contains a type error. Haskell catches type errors
*before* it evaluates the expression. 

## Some basic Haskell types

Haskell types always start with a capital letter. Here are a few basic ones that
you should know:

- `Bool`, logical values `True` and `False`
- `Char`, single Unicode characters, such as `'a'`, `'A'`, `'8'`, `'\n'`, ...
- `String`, sequences of characters, such as `""`, `"cat"`, `"hello\nworld!""`, ....
- `Int`, fixed precision integers from $-2^{63}$ to $-2^{63}-1$; you can write
  `25 :: Int` to force a number to be an `Int` instead of some other numeric
  type
- `Integer`, arbitrary-precision integers, i.e. integers that can be as big as
  you need; `25 :: Integer` forces 25 to be of type `Integer`

> **Note** `int` values are typically the ints used by hardware, and so are
> usually more efficient in time and memory than `Integer` values.

> **Comparison** Python and Racket use arbitrary-precision integers by default,
> while the `int` type in C, C++, and Java is fixed-precision.

- `Float`, single-precision floating-point numbers, e.g. 1.3, -0.002, 3.14, ...
- `Double`, double-precision floating-point numbers; they are like `Float`s but
  with more digits of accuracy

> **Note** A literal number such as 5 could be of type `Int`, `Integer`,
> `Float`, or `Double`. Use `::` to force it to be a particular type, e.g. `5 ::
> Float` .

## List types
A Haskell **list** is a sequence of 0 or more elements of the *same* type.

> **Comparison** Lists in Python or Racket can contain values of different
> types. Arrays and vectors in C++ can only contain values of the same type.

If a list has elements of type `t`, the type of the list is `[t]`:
- `[False,False,True] :: [Bool]`
- `['s','h','o','e'] :: [Char]`
- `["red","brown","yellow"] :: [String]`
- `[["one","two"],["three"]] :: [[String]]`

The number of elements in a list is its *length*, or *size*. The empty list `[]`
has length 0, a list with one element, e.g. `[False]` has length 1, and so on.

A few facts about Haskell lists:
- The type of a list tells you *nothing* about its length.
- The elements of list must all be of the same type `t`, but there is no
  restriction on what `t` can be.
- Because Haskell uses **lazy evaluation**, lists can be infinite.

## Tuple types

A **tuple** is a *finite sequence* of 0 or more values, and the values *can* be
of different types. Haskell use `()`-brackets to indicate tuples and their
types:
- `(False,True) :: (Bool,Bool)`
- `(False,'-',True) :: (Bool,Char,Bool)`
- `("Yep",True,'z','!') :: (String,Bool,Char,Char)`

The number of values in a tuple is called its **arity**, and the empty tuple
`()` has arity 0. Tuples of arity 1, such as `(2 + 3)` are *not* permitted,
since they cannot be distinguished from arithmetic expressions, e.g. `(2 + 3)`
is `2 + 3` in brackets.

> **Comparison** In Python, tuples of arity 1 can be written with a trailing
> comma, e.g. `(2+3,)` is a tuple, while `(2+3)` is an arithmetic expression.

A few facts about tuples:
- The type of a tuples tells you its arity. 
- The values in a tuple can be of any type, with no restrictions.
- Tuple arities must be finite.

## Function types

A **function** is a *mapping* from one type to another. `a -> b` is the type of
a function that takes a value of type `a` as input and returns a value of type
`b` as output. For example:

- `not :: Bool -> Bool`
- `even :: Int -> Bool` (tests if a number is even)

The input type and result type can be any types, including lists, tuples, or
even other functions. For example:

```haskell
add :: (Int, Int) -> Int   -- type signature
add (x, y) = x + y

range :: Int -> [Int]      -- type signature
range n = [0..n]

twice :: (Int -> Int) -> Int -> int -- type signature
twice f x = f (f x)
```

The notation `[0..n]` creates a list of the values from 0 to `n`, e.g.:

```haskell
> [0..4]
[0,1,2,3,4]
```

A function that returns a result for *all* values of its input type is called a
**total function**. For example, `add` from above is total. Haskell does *not*
require functions be total, i.e. some input values to a function could have an
undefined result:

```haskell
> head []
*** Exception: Prelude.head: empty list
```

`head` returns the first element of a list. But the empty list `[]` has no
elements, and so `head []` causes an error.

## Curried  functions

Consider this definition:

```haskell
add' :: Int -> (Int -> Int)
add' x y = x + y
```

The type signature tells us `add'` takes an `Int` as input, and returns a
function of type `Int -> Int` as output. Usually, addition takes two inputs, but
when defined like this Haskell lets you pass in just one parameter and returns a
function that is ready to accept the second parameter.

`add' 5` returns a function that takes an `Int` as input, and returns 5 plus
that `int` as a result:

```haskell
> (add' 5) 2
7
> plus5 = add' 5
> plus5 2
7
```

This function returns the product of three integers:

```haskell
mult :: Int -> (Int -> (Int -> Int))
mult x y z = x * y * z
```

Currying lets you pass the inputs to `mult` one at a time:
- `mult 8` returns a function that takes an `Int` as input and has the type `Int
  -> (Int -> Int)`
- `mult 8 7` returns a function that takes an `Int` as input that has type `Int
  -> Int`
- `mult 8 7 1` returns the `Int` 56

`mult` is a **curried function** because it can take 0, 1, 2, or 3 inputs. If
less than 3 inputs are provided, a (curried) function that expects the next
inputs is returned.

Haskell functions are curried by default. Two significant uses of currying are
conveniently making new functions out of old ones, and, letting us treat *all*
Haskell functions as if they have a single input.

The types for curried functions are usually written *without* brackets. The type
signature `mult :: Int -> (Int -> (Int -> Int))` is the same as:

```haskell
mult :: Int -> Int -> Int -> Int
```

Type signatures of functions are bracketed starting at the *right*, i.e. `->` is
said to be **right associative**. The right-most type is the type of the
function's output, and the others are the types of the input values.

> **Comparison** Haskell's built-in support of curried functions contrasts with
> non-curried functions in almost all other popular languages. For example, in
> Python or C++, if `f(x, y)` is a function that takes two numbers as inputs, it
> is an *error* to call `f(8)`.

> **Comparison** Racket does *not* curry functions by default, but it does have
> a built-in `curry` function that can convert non-curried functions into
> curried ones.

> **Comparison** JavaScript does *not* curry functions by default, but there are
> libraries that provide that feature, such as [Ramda](https://ramdajs.com/).

> **History** Curried functions are named after the mathematician [Haskell
> Curry](https://en.wikipedia.org/wiki/Haskell_Curry) (who also has a
> programming language named after him!), who helped make them famous. They also
> appear in the work of earlier mathematicians, such as [Moses
> Schonfinkel](https://en.wikipedia.org/wiki/Moses_Sch%C3%B6nfinkel), and
> [Gottlob Frege](https://en.wikipedia.org/wiki/Gottlob_Frege).

## Polymorphic types

Some list functions, such as `head`, work with lists of *any* type of elements:

```haskell
> :type head
head :: [a] -> a
```

 `head`'s type is `[a] -> a`, where `a` is a **type variable** that can be
 replaced by *any* type. Type variables must always be written in *lowercase*.

When written by hand, Greek letters are often used for type variables, e.g.
$[\alpha] \rightarrow \alpha$.

A type with one or more type variables is called a **polymorphic type**. Here
are a few more examples of polymorphic types:

- `fst :: (a, b) -> a` is a function that takes a tuple of arity 2 as input,
  where the tuple values can be of any type. `fst` returns the **first** value
  of the tuple, so it's return type is `a`.
- `snd :: (a, b) -> b` is similar to `fst`, but returns the **second** value of
  the tuple, and so it's return type is `b`.
- `take :: Int -> [a] -> [a]` is a function that returns the first n elements of
  a list:

  ```haskell
  > take 3 [4,7,7,8,2]
  [4,7,7]
  ```

- `zip :: [a] -> [b] -> [(a,b)]` takes any two lists as input, and returns a
  list of 2-tuples of the elements of the list, e.g.:

  ```haskell
  > zip [1,2,3] ["cat","dog","bird"]
  [(1,"cat"),(2,"dog"),(3,"bird")]
  ```

- `id :: a -> a` is the **identity function**, and it takes one value of any
  type and returns the same value, e.g.:

  ```haskell
  > id 7.5
  7.5
  > id ["a","b","c"]
  ["a","b","c"]
  > id "pets"
  "pets"
  ```

Functions are values, and so you can pass them to `id`, e.g. `id head` returns
the function `head`, and `id id` returns the `id` function. By default, GHCi
can't display functions, so you get an error if you evaluate a function in the
interpreter.

## Overloaded types

Haskell's `+` function works with any numeric type, and it's type signature
looks like this:

```haskell
> :type (+)
(+) :: Num a => a -> a -> a
```

The first arrow is `=>`, a "fat" arrow. The expression `Num a` is called a
**class constraint**, and says that the type variable `a` must satisfy *all* the
constraints in the `Num` class. `Int`, `Integer`, and `Double` all satisfy
`Num`, and so you can use `(+)` with those types of numbers, e.g.:

```haskell
> 23 + 40
63
> 2.3 + 4.0
6.0
```

Literal numeric values can have different concrete types depending upon the
context, e.g.:

```haskell
> :type 4
4 :: Num p => p
```

In contrast, the `String` types does *not* satisfy `Num`, and so you cannot
"add" strings with `(+)`:

```haskell
> "cat" + "dog"

<interactive>:25:1: error:
    • No instance for (Num [Char]) arising from a use of ‘+’
    • In the expression: "cat" + "dog"
      In an equation for ‘it’: it = "cat" + "dog"
```

Instead, use `(++)` to combine strings:

```haskell
> "cat" ++ "dog"
"catdog"
```

`(++)` has this type:

```haskell
> :type (++)
(++) :: [a] -> [a] -> [a]
```

`(++)` is the **concatenation** operator. It takes two lists as input, both
containing values of the same type, and returns a new list of consisting of all
the values of the first list followed by all the values of the second list.

## Basic classes

Haskell provides a number of pre-defined type classes used throughout the
standard prelude. Classes must always start with a capital letter.

`Eq` is for **equality types**. These are types that can be compared using
`(==)` and `(/=)` (not equal):

```haskell
(==) :: a -> a -> Bool
(/=) :: a -> a -> Bool
```

Numbers, strings, characters, and bools all satisfy `Eq`. A list of type `[t]`
satisfies `Eq` just when type `t` satisfies `Eq`. Functions, in general, do
*not* satisfy `Eq`.

`Ord` is for **ordinal types**, that is, types that can be compared using `<`,
`<=`, etc.:

```haskell
 (<) :: a -> a -> Bool
(<=) :: a -> a -> Bool
 (>) :: a -> a -> Bool
(>=) :: a -> a -> Bool
 min :: a -> a -> a
 max :: a -> a -> a
```

Numbers, strings, characters, and bools all satisfy `Ord`. A list of type `[t]`
satisfies `Ord` just when type `t` satisfies `Eq`. Comparisons on strings and
lists are **lexicographical**, i.e. they check order value-by-value starting at
the left and moving right. For strings, lexicographical are the standard
alphabetic comparisons.

The `:info` command displays information about type classes:

```haskell
> :info Num
class Num a where
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
  {-# MINIMAL (+), (*), abs, signum, fromInteger, (negate | (-)) #-}
  	-- Defined in ‘GHC.Num’
instance Num Word -- Defined in ‘GHC.Num’
instance Num Integer -- Defined in ‘GHC.Num’
instance Num Int -- Defined in ‘GHC.Num’
instance Num Float -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
```

Notice that all the type signatures are listed at the start. The `instance`s at
the bottom show what Haskell types satisfy the type class.

`Show` is for types whose values can be **converted to a string**. To satisfy
`Show` a type `a` must implement this function:

```haskell
show :: a -> String
```

For example:

```haskell
> show 3.14
"3.14"
> show '\n'
"'\\n'"
> show 'a'
"'a'"
> show [1,2,3]
"[1,2,3]"
> show "off"
"\"off\""
```

`Read` is for types that can be **read from a string**. For instance:

```haskell
> (read "[8,-2,6]") :: [Int]
[8,-2,6]
> read "[8,-2,6]" :: [Int]
[8,-2,6]

> (read "5.22") :: Float
5.22
> read "5.22" :: Float
5.22

> (read "5") :: Float
5.0
> read "5" :: Float
5.0

> (read "5") :: Int
5
> read "5" :: Int
5
```

In some situations Haskell can't infer what type of value `read` should return,
and so it's necessary to use `::` as shown to explicitly give the type.

`Num` is for **numeric types**, and any numeric type `a` must work with these
functions:

```haskell
(+) :: a -> a -> a
(-) :: a -> a -> a
(*) :: a -> a -> a
negate :: a -> a
abs :: a -> a
signum :: a -> a
```

For example, `signum` returns -1 if the number is less than 0, 1 if it's greater
than 0, and 0 if it's 0:

```haskell
> signum 3
1
> signum 0
0
> signum (-3)
-1
```

The last example shows a syntax quirk of Haskell. We must write `(-3)` in
brackets, otherwise Haskell interprets `signum -3` as `signum` minus `3`:

```haskell
> signum -3

<interactive>:16:1: error:
    • Non type-variable argument in the constraint: Num (a -> a)
      (Use FlexibleContexts to permit this)
    • When checking the inferred type
        it :: forall a. (Num a, Num (a -> a)) => a -> a
```

To avoid this confusion we often need to put negative numbers in brackets.

`Integral` is for **integer types**. These types zrequire all the functions of
`Num`, plus two more:

```haskell
div :: a -> a -> a
mod :: a -> a -> a
```

For example:

```haskell
> div 8 3
2
> 8 `div` 3
2
> mod 10 3
1
> 10 `mod` 3
1
```

We can use `mod` and `div` in **prefix** style, e.g. `div 8 3`, or **infix**
style, e.g. ``8 `div` 3``.

`Fractional` is for **fractional types**. These types require all the functions
of `Num`, plus two more:

```haskell
(/) :: a -> a -> a
recip :: a -> a      -- reciprocal
                     -- e.g. 1/x is the reciprocal of x
```

For instance:

```haskell
> 2 / 3
0.6666666666666666
> 3 / 2
1.5
> 4 / 0
Infinity
> 0 / 0
NaN
> recip 10
0.1
> recip 0
Infinity
```
