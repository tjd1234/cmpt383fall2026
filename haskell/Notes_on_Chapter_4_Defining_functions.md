# Notes on Chapter 4: Defining functions

Haskell has many different ways to define functions. 

## New from old

Perhaps the most common way to define a new Haskell function is to use a set of
equations. For example:

```haskell
middle1 :: [a] -> [a]  -- type signature
middle1 []     = []
middle1 [x]    = []
middle1 (_:xs) = reverse (tail (reverse xs))
```

```haskell
> middle1 "cow"
"o"
> middle1 [1,2,3,4,5]
[2,3,4]
```

The type signature comes first. It's optional, but we almost always include it
for documentation. The function body is written as a series of **equations**. In
the case of `middle1`, the first equation handles the empty list, the second
equation handles lists with a single element, and the third handles lists with 2
or more elements.

The third equation uses a **cons pattern** to get the first and rest of a list.
`xs` is all the elements *after* the first element of the passed-in list. `_` is
the **wildcard symbol**, and in this case it indicates a variable whose name we
don't care about. Instead of `_` we could have written, say, `x`. But since it
wouldn't be used anywhere `_` is preferred.

### Explain the bug: middle_bug1

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
middle_bug1 :: [a] -> [a]  -- type signature
middle_bug1 []     = []
middle_bug1 [x]    = []
middle_bug1 (_:xs) = reverse tail reverse xs
```

### Challenge: outside

Implement a function called `outside` that takes a list of any type as input,
and returns a *tuple* `(first, last)`, where `first` is the first element of the
list, and last is the last element. If `outside` is passed a list with fewer
than 2 elements, then use the standard Haskell `error msg` function to return a
helpful error message.

As part of your answer, include the most general type signature for `outside`.

For example:

```haskell
> outside "apple"
('a','e')
> outside [2,1,9,4]
(2,4)
> outside ["up","up","and","away"]
("up","away")
> outside [5]
*** Exception: outside: list must have 2 or more elements
...
```

### Challenge: another middle

Re-write `middle1` in a different way *without* using `reverse`. Call this new
function `middle2`. It should have exactly the same type signature as `middle1`,
and they should return the same results for the same inputs.

### Challenge: testing middles

Implement a function called `middle_test m1 m2 x` that takes three inputs:

- `m1` and `m2` are middle functions with the same type signatures as `middle1`
- `x` is any list of elements of type `a`. Importantly, `a` must satisfy the
  `Eq` class so that the list elements can be compared using `==`.

`middle_test m1 m2 x` returns a `Bool`. It returns `True` if `m1 x` and `m2 x`
return the same list, and `False` otherwise.

As part of your answer, include the most general type signature for
`middle_test`. This signature is a bit long!

## Conditional expressions

In Haskell, an expression of the form `if cond then a else b` is called a
**conditional expression**. `cond` must be a `Bool` expression that returns
`True` or `False`. If it's `True`, then the conditional evaluates to `a`, and if
it's `False` it evaluates to `b`.

Importantly, expressions `a` and `b` *must* be the same type.

For example:

```haskell
pluralize1 :: String -> String
pluralize1 "" = ""
pluralize1 s  = s ++ (if last s == 's' then "" else "s")
```

```haskell
> pluralize1 "apple"
"apples"
> pluralize1 "cows"
"cows"
```

### Challenge: another pluralize

Implement a function called `pluralize2` that works the same as  `pluralize1`,
but is implemented in a *different* way, but still using a *conditional
expression*. It should have exactly the same type signature as `pluralize2`, and
should return the same results for the same inputs.

### Challenge: testing pluralization

Implement a function called `pluralize_test p1 p2 s` that takes three inputs:

- `p1` and `p2` are pluralize functions with the same type signatures as
  `pluralize1`
- `s` is any `String`.

`pluralize_test p1 p2 x` returns a `Bool`. It returns `True` if `p1 s` and `p2
s` return the same `String`, and `False` otherwise.

As part of your answer, include the most general type signature for
`pluralize_test`. This signature is a bit long!

### Challenge: better pluralization

The `pluralize1 w` function implements two rules: 

1. If `w` ends with an `'s'`, then return `w` unchanged.
2. Otherwise, return `w` with an `'s'` added to the end.

Implement a function called `pluralize3` that has the same type signature as
`pluralize1`, but also implements this rule in addition to the first two:

3. If `w` ends with a `y`, then remove it and add `"ies"` to the end.

For example:

```haskell
> pluralize3 "cow"
"cows"
> pluralize3 "dry"
"dries"
> pluralize3 "birds"
"birds"
```

## Guarded equations

**Guarded equations** are useful when simple equations are not flexible enough:

```haskell
sign1 n | n == 0    = "zero"
        | n < 0     = "negative"
        | otherwise = "positive"

> sign1 5
"positive"
> sign1 (-5)
"negative"
> sign1 0
"zero"
```

Even though we didn't write a type signature for `sign1`, Haskell inferred one:

```haskell
> :type sign1
sign1 :: (Num a, Ord a) => a -> [Char]
```

In Haskell, strings are just lists of characters.

### Explain the bug: sign_bug1

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
sign_bug1 :: Num a => a -> String
sign_bug1 n | n == 0    = "zero"
            | n < 0     = "negative"
            | otherwise = "positive"
```

### Challenge: sign with conditionals

Re-write `sign1` *without* using guards, and instead using `if ... then ...
else`.  It should have exactly the same type signature as `sign1`. Call it
`sign2`. `sign1` and `sign2` should return the same results for the same inputs.

### Challenge: Heron's formula

[Heron's formula](https://en.wikipedia.org/wiki/Heron%27s_formula) calculates
the area of a triangle given the lengths of its sides. Implement the function
`heron_area a b c`, where `a`, `b`, and `c` are the lengths of the sides of a
triangle. If any of `a`, `b`, or `c` are 0, or less, then use the standard
Haskell `error msg` function to print a helpful error message.

For example:

```haskell
> heron_area 4 13 15
24.0
> heron_area 4 (-13) 15
*** Exception: heron_area: b must be positive
...
```

It's possible for `a`, `b`, and `c` to all be positive, but to *not* form a
triangle. For example, there is no triangle with side lengths 1, 2, and 4. You
do *not* need to check for such cases in this function.

## Pattern matching

Haskell uses simple **pattern matching** to match function inputs. For example:

```haskell
coin1 :: Int -> String
coin1 1  = "penny"
coin1 5  = "nickel"
coin1 10 = "dime"
coin1 25 = "quarter"
coin1 _  = "unknown"  -- _ matches everything
```

```haskell
> coin1 25
"quarter"
> coin1 28
"unknown"
> coin1 1
"penny"
```

The first 4 equations in `coin1` match specific integers.  The final equation
uses the **wildcard** symbol `_`, which in this case matches *any* value.

### Challenge: a better coin

Implement a function called `coin2` that works like `coin1`, but the wildcard
equation returns a string that includes the value of the coin.  For example,
`coin2 28` should return a string like `"28 is an unknown coin"`.

`coin2` should have exactly the same type signature as `coin1`. 

### Explain the bug: coin_bug1

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
coin_bug1 :: Int -> String
coin_bug1 n | 1         = "penny"
            | 5         = "nickel"
            | 10        = "dime"
            | 25        = "quarter"
            | otherwise = "unknown"
```

### Explain the bug: same_bug1

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
same_bug1 :: Int -> Int -> Bool
same_bug1 _ _ = False
same_bug1 a a = True
```

The intention is that the function return `True` when its two inputs are the
same, and `False` otherwise. However, it doesn't work correctly.

### Example: nand

The **nand** function is basic logical operator that it is often used in
hardware. Nand-gates can be used to construct every other kinds of logical
function, and so nand is all you need.

Logically, nand is defined by this truth-table:

|   x   |   y   | x nand y |
|:-----:|:-----:|:--------:|
| False | False |   True   |
| False |  True |   True   |
|  True | False |   True   |
|  True |  True |   False  |

In Haskell, the definition is almost the same:

```haskell
nand :: Bool -> Bool -> Bool
nand False False = True
nand False True  = True
nand True  False = True
nand True  True  = False
```

This is pretty close the same form as the truth-table. 

Using wildcard `_` symbols, we can shorten the definition to this:

```haskell
nand :: Bool -> Bool -> Bool
nand True True = False
nand _    _    = True
```

Each `_` matches *any* value. They do not need to match the same values.

## Tuple Patterns

```haskell
get_x :: (Double, Double) -> Double
get_x (x, _) = x

get_y :: (Double, Double) -> Double
get_y (y, _) = y
```

## List patterns

Functions that process lists often use list patterns. For example:

```haskell
is_expr :: [String] -> String
is_expr [_, "+", _] = "addition"
is_expr [_, "-", _] = "subtraction"
is_expr ["-", _]    = "negation"
is_expr [_, op,  _] = "unknown operator " ++ op
is_expr _           = "unknown expression"

> is_expr ["4","+","2"]
"addition"
> is_expr ["4","-","2"]
"subtraction"
> is_expr ["4","/","2"]
"unknown operator /"
> is_expr ["4","/","2","=","2"]
"unknown expression"
```

The first three equations match lists of size 3, and the last equation with the
`_` matches any list. `_` is also used in the list patterns for values that we
don't want to give a name to.

Another way to match a list is to use **cons patterns** of the form `(x:xs)`.
`:` is the **cons operator**, and can be used in pattern matching like this:

```haskell
firsts1 :: [a] -> [b] -> (a, b)
firsts1 (x:xs) (y:ys) = (x, y)

> firsts1 "hello" "there"
('h','t')
> firsts1 [1,2,3] ["cat","dog"]
(1,"cat")
```

Since neither `xs` nor `ys` is used on the right-hand side of the equation, we
could also write this:

```haskell
firsts2 :: [a] -> [b] -> (a, b)
firsts2 (x:_) (y:_) = (x, y)
```

Without `:` we could write it like this:

```haskell
firsts3 :: [a] -> [b] -> (a, b)
firsts3 xs ys = (head xs, head ys)
```

`(x:xs)` *doesn't* match empty lists, and so you need to handle the empty list
separately, e.g.:

```haskell
firsts_list1 :: [a] -> [a] -> [a]
firsts_list1 [] _        = []
firsts_list1 _ []        = []
firsts_list1 (x:_) (y:_) = [x, y]
```

`:` can match multiple items at the *start* of a list:

```haskell
remove812 :: [Int] -> [Int]
remove812 (8:1:2:xs) = xs
remove812 xs         = xs
```

`:` also creates lists. The expression `4:[2,6,1]` evaluates to the list
`[4,2,6,1]`, i.e. `x:xs` returns a new list that is the same as `xs` but with
`x` added as the first element. Lists can be constructed from multiple
applications of `:` like this:

```haskell
> 1:[]
[1]
> 6:1:[]
[6,1]
> 2:6:1:[]
[2,6,1]
> 4:2:6:1:[]
[4,2,6,1]
```

`[4,2,6,1]` can be seen as a convenient shorthand for the expression
`4:2:6:1:[]`. We will sometimes call lists written in the form `4:2:6:1:[]` the
**consed-out** form of the list. 

> **Comparison** `cons`  in Racket works the same was `:` in this case.

### Challenge: length of short lists

Implement a function called `short_length lst` that returns 0 if `lst` is empty,
1 if it is has a single element, 2 if it has two elements, and 3 if it has three
elements. For lists of any other length, return -1.

Implement `short_length lst` using just pattern matching, and without using
`length` or other helper functions.

Also write the most general type signature. The return value is `Int`.

### Challenge: consed-out apple

Write "apple" in consed-out form. Strings in Haskell are just lists of
characters. Use single-quotes for characters, e.g. `'a'` is a character.

### Explain the bug: same_bug1

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
diff_heads_bug1 :: [a] -> [a] -> Bool
diff_heads_bug1 [] _        = True
diff_heads_bug1 _ []        = True
diff_heads_bug1 (x:_) (y:_) = False
diff_heads_bug1 _ _         = True
```

The intention is that `diff_heads_bug1 a b` returns  `False` if the heads of the
lists are the same, and `True` in every other case.

## Lambda expressions

**Lambda expressions**, or **lambda functions**, can be thought of as functions
without names. In practice they can be useful when you need a small function
that is only used once or twice.

For example, `\x -> x*x` is a lambda expression. It's a function that takes a
single input, `x`, and then returns its square:

```haskell
> (\x -> x*x) 3
9
```

Like any Haskell function, lambda functions can return other functions. This
lambda expression multiplies two numbers:

```haskell
> (\x -> (\y -> x * y)) 3 4
12
```

When this is evaluated, `x` in the outer lambda function is associated with 3,
and returns the function `\y -> 3 * y`. This is clever! This is called a
**closure** because the 3 is bound to the `x`, and Haskell automatically keeps
track of this for you. A closure can be thought of as function plus an
environment of bindings of values to variables that appear in the function.

Continuing with the evaluation of the expression, after `\y -> 3 * y` is
returned, it is applied to 4, and so this evaluates to `3 * 4`, i.e. 12.

If you like, you can use lambda expressions in regular function definitions. For
example:

```haskell
inc1 :: Num a => a -> a
inc1 = \n -> n + 1
```

```haskell
> inc1 5
6
```

This style of defining functions has little more punctuation, i.e. an extra `\`
and `->`.

## Operator sections

Binary operators such as `+` or `*` are usually written in **infix** style with
the operator going *between* its arguments, e.g. `2 + 5`. They can also be
written in **prefix** style using ()-brackets, e.g. `(+) 2 5`. Both styles can
be useful, depending upon the situation.

In prefix style, you can also write one of the parameters inside the brackets to
get what is called a **section**. For example, `(2+)` is a section that adds 2
to its input:

```haskell
> (2+) 4
6
```

This can be useful with functions such as `map f lst`. `map` applies the
function `f` to every element in `lst`, e.g.:

```haskell
> (2+) 4
6
> map (2+) [1,2,3,4]
[3,4,5,6]
```

The position of the parameter in the section can make a difference. For example,
`(/2)` divides its input by 2:

```haskell
> map (/2) [2,4,6,8]
[1.0,2.0,3.0,4.0]
```

`(2/)` divides 2 by its input:

```haskell
> map (2/) [2,4,6,8]
[1.0,0.5,0.3333333333333333,0.25]
```

### Challenge: reciprocals

Write an expression that uses `map` and an appropriate operator section to
calculate the reciprocals of a list of numbers. For example, the reciprocal of 5
is 1/5.

### Challenge: fourth powers

Write a function called `h n` that returns $h(n)=1^4 + 2^4 + 3^4 + \ldots n^4$,
the sum of the fourth powers up to `n`. Use an *operator section* in your
answer. If `n` is 0 or less, then use the standard Haskell `error msg` function
to return a helpful error message.

For example:

```haskell
> h 1
1
> h 2
17
> h 3
98
> h 100
2050333330
*Main> h 0
*** Exception: h: n must be positive
...
```