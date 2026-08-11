# Notes on Chapter 2: First steps

When you run Haskell it automatically loads a standard set of basic functions
called the **standard prelude**. You can replace this with a different prelude,
but we won't don't do that in this course.

## Some Standard Functions

Here are a few standard Haskell functions:

`head lst` returns the first element of list `lst`:

```haskell
> head [3,2,1]
3
> head "person"
'p'
> head ["cat","bird","shoe"]
"cat"
```

`tail lst` returns a list that is the same as `lst`, except the first element is
removed:

```haskell
> tail [3,2,1]
[2,1]
> tail "person"
"erson"
> tail ["cat","bird","shoe"]
["bird","shoe"]
```

`last lst` returns the last element of a list:

```haskell
> last [9,1,4]
4
> last "apple"
'e'
> last []
*** Exception: Prelude.last: empty list
```

`length lst` returns the length of a list:

```haskell
> length []
0
> length [2,0,0]
3
> length "road"
4
```

`lst !! n` returns the item at location `n` of `lst`:

```haskell
> [8,3,5] !! 0
8
> [8,3,5] !! 1
3
> [8,3,5] !! 2
5
> [8,3,5] !! 3
*** Exception: Prelude.!!: index too large
```

`take n lst` returns a list of the first `n` elements of `lst`:

```haskell
> take 2 [9,3,2,1]
[9,3]
> take 3 [9,3,2,1]
[9,3,2]
> take 10 [9,3,2,1]
[9,3,2,1]
> take 0 [9,3,2,1]
[]
> take 2 "SFU"
"SF"
```

`drop n lst` returns a list that is the same as `lst` except the first `n`
elements are removed:

```haskell
> drop 2 [9,3,2,1]
[2,1]
> drop 3 [9,3,2,1]
[1]
> drop 10 [9,3,2,1]
[]
> drop 3 "juggler"
"gler"
```

`sum lst` returns the sum of a list of numbers:

```haskell
> sum [2,10,-4]
8
> sum []
0
```

`product lst` returns the product of a list of numbers:

```haskell
> product [2,10,-4]
-80
> product []
1
```

`lst1 ++ lst2` appends two lists:

```haskell
> [2,7] ++ [0,0,9]
[2,7,0,0,9]
> "red " ++ "popper"
"red popper"
> "the " ++ "big " ++ "story"
"the big story"
```

`reverse lst` reverses a list:

```haskell
> reverse [1,2,3,4,5]
[5,4,3,2,1]
> reverse "orchestra"
"artsehcro"
> reverse "racecar"
"racecar"
```

`[lo..hi]` returns a list of numbers from `lo` to `hi`:

```haskell
> [1..5]
[1,2,3,4,5]
> [22..27]
[22,23,24,25,26,27]
```

## Applying Functions

Calling and evaluating functions in Haskell is a little different than most
languages. Suppose function `g` takes a single input. You call it on value `x`
by writing `g x`. We say that `g` is **applied** to `x`, and the entire
expression is an example of **function application**. No brackets are needed,
although we will sometimes write `(g x)` to prevent ambiguity.

Suppose function `f` takes three inputs. You call it by writing `f a b c`.
Again, no brackets are needed, and spaces (not commas) are used to separate the
inputs. The **order of evaluation** is the same as if we'd written `((f a) b)
c)`. In other words, when `f a b c` means first apply `f` to `a`, and then apply
the result of that to `b`, and then apply the result of that to `c`. Function
application is **left associative**.

Order of evaluation is especially important when you are dealing with multiple
functions. Suppose you want to evaluate $g(g(x))$. In Haskell, you'd write `g (g
x)`. The brackets are necessary to force `g x` to be evaluated first. If you
wrote `g g x`, then Haskell would call `(g g) x`, i.e. it would first apply `g`
to `g`, and then apply the result of that to `x`. This is not what we want in
this case!

## Naming Requirements

Haskell has a few rules and conventions for names you should be aware of.

Functions and variables *must* start with a **lowercase** letter:

```haskell
> e = 2.718
> e
2.718
> E = 2.718
<interactive>:18:1: error: Not in scope: data constructor ‘E’
```

After the first letter you can use lowercase or uppercase letters, digits, the
underscore `_`, or even the single-quote character `'`. The quote is often used
to indicate related functions, e.g. `f` and `f'` are both valid Haskell function
names.

It is conventional (but not required) that names of *list* variables end with an
*s*. For example, a list of floating point numbers might be called `xs`. We can
then use the name `x` to refer to an individual number.

## The Layout Rule

Similar to Python, indentation is meaningful in Haskell. Related equations
should be grouped at the same level of indentation, e.g.:

```haskell
f = b + c
    where 
       b = 1
       c = 2
d = 2 * f
```

The indentation in this expression is necessary and tells Haskell that the
equations for `b` and `c` are part of the `where` clause, while the equation for
`d` is not.

If necessary, curly braces and semi-colons can be used to make this more explicit:

```haskell
f = b + c
    where 
       {b = 1;
       c = 2}
d = 2 * f
```

In practice, the layout rule is usually easier for people to read, and we'll
rarely use braces or semi-colons.

**Be careful with tabs!** Tabs in your source code can confuse Haskell, and so
it is best that you use spaces instead of tab characters.

## Source Code Comments

`--` are single line comments in Haskell, e.g.:

```haskell
sum [1..100]  -- sum the numbers from 1 to 100
```

`{-` and `-}` are for multi-line comments, e.g.:

```haskell
{- The following expression calculates the 
   sum of the numbers from 1 to 100.
-}
sum [1..100]
```

## A Few Simple Function  Definitions
```haskell
-- returns 2*x
double x = x + x

-- returns 4*x
quadruple x = double (double x)

-- returns n!
factorial n = product [1..n]

-- returns the average of a list of numbers
average ns = sum ns `div` length ns

-- returns a list with the first and last element
ends1 lst = [head lst, last lst]

ends2 lst = [head lst] ++ [last lst]
```

## Practice Question: Implementing last

**Question** Implement your own version of `last` called `mylast` that returns
the last element of a list without using  `last`. Do it two different ways.

**Solution 1** Drop the first n-1 elements of the list:

```haskell
mylast1 lst = head (drop (length lst - 1) lst)
```

**Solution 2** Reverse the list and use `head`:

```haskell
mylast2 lst = head (reverse lst)
```

## Practice Question: Implementing init

**Question** The standard Haskell function `init lst` returns a copy of `lst`
with the last element removed:

```haskell
> init [1,2,3,4]
[1,2,3]
> init "shoebox"
"shoebo"
```

Implement your own version called `myinit` (without using `init`). Do it two
different ways.

**Solution 1** Take the first n-1 elements:

```haskell
myinit1 lst = take (length lst - 1) lst
```

**Solution 2** Use `reverse` and `tail`:

```haskell
myinit2 lst = reverse (tail (reverse lst))
```
