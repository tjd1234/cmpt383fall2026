An unusual feature of Haskell is how it evaluates expressions in a **lazy** way.
Among other things, lazy evaluation is what lets Haskell work with infinite
lists.

## Introduction
Here's an example that demonstrates the key idea of lazy evaluation:

```haskell
inc :: Int -> Int
inc n = n + 1
```

We can evaluate `inc (2*3)` in a non-lazy way like this:

```
  inc (2*3)  -- evaluate 2*3
= inc 6      -- call inc
= 6 + 1
= 7
```

Or we could evaluate it in a lazy way:

```
  inc (2*3)  -- call inc
= (2*3) + 1  -- evaluate 2*3
= 6 + 1
= 7
```

We get the same answer both ways. 

Most programming languages use the first approach, non-lazy evaluation. Haskell,
instead, uses the second approach, lazy evaluation, by default.

When you call a function in a non-lazy language, first the argument expressions
are evaluated, and then their results are passed to the function. Lazy
evaluation passes the arguments *unevaluated* to the function, only evaluating
them if needed.

## Evaluation strategies
A **reducible expression**, or **redex** for short, is an expression that has
the form of a function applied to one or more arguments that can be "reduced" by
performing the application.

For example, consider this function:

```haskell
mult :: (Int,Int) -> Int
mult (x,y) = x * y
```

The expression `mult (1+2,2+3)` has three redexes: `1+2`, `2+3`, and `mult
(1+2,2+3)` itself. `2` is not a redex because it cannot be reduced further.

For expressions with more then one redex you must decide in what order to reduce
them. One order is called the **innermost evaluation** strategy, where you
reduce an expression by always first reducing a redex that has no redex inside
of it. If there's more than one such redex, choose the left-most one. Here's an
example:

```
  mult (1+2,2+3)   -- innermost reduction
= mult (3,2+3)
= mult (3,5)
= 3*5
= 15
```

Innermost reduction evaluates function arguments *before* they are passed to the
function, and so it is sometimes called **pass by value**.

The **outermost evaluation** reduction strategy works by first evaluating the
redex that is *not* contained in any other redex. If there's more than one such
redex, choose the left-most one. For example:

```
  mult (1+2,2+3)   -- outermost reduction
= (1+2)*(2+3)
= 3*(2+3)
= 3*5
= 15
```

When evaluating a function application with outermost evaluation, the arguments
are passed to the function *without* being evaluated. This is sometimes called
**pass by name**.

Some built-in Haskell functions, like `+` and `*` for numbers, must be called
using pass by value. Functions that require their arguments be passed by value
are called **strict** functions.

###  Lambda Expressions
Consider this curried version of `mult`:

```haskell
mult :: Int -> Int -> Int
mult x = \y -> x * y
```

Here is the innermost reduction of `mult (1+2) (2+3)`:

```
  mult (1+2) (2+3)     -- innermost reduction
= mult 3 (2+3)
= (\y -> 3 * y) (2+3)  -- careful!
= (\y -> 3 * y) 5
= 3 * 5
= 15
```

Haskell's reduction follows a special rule with lambda functions: redexes inside
the body of a lambda function are **not** selected, i.e. "no reduction under
lambdas". Any redexes in the lambda are reduced *after* function application:

```
  mult (1+2) (2+3)        -- outermost reduction
= (\y -> (1+2) * y) (2+3) -- (1+2) in lambda, not reduced
= (1+2) * (2+3)
= 3 * (2+3)
= 3 * 5
15
```

The "no reduction under lambdas" rule used with innermost reduction is called
**call-by-value**, and the "no reduction under lambdas" rule used with outermost
reduction is called **call-by-name**.

## Termination
Some functions run forever when you evaluate them:

```haskell
inf :: Int
inf = 1 + inf
```

It reduces like this:

```
  inf
= 1 + inf
= 1 + (1 + inf)
= 1 + (1 + (1 + inf))
...
```

Consider the expression `fst (0, inf)`. When evaluated, does it run forever, or
does it return 0? The answer depends upon the evaluation strategy used.

> Recall that `fst` returns the first value of a 2-tuple, e.g. `fst (7, 4)` is 7.

Here, `fst (0, inf)` is evaluated using *call-be-value*, i.e. arguments are
evaluated *before* being passed:

```
  fst (0, inf)
= fst (0, 1 + inf)
= fst (0, 1 + (1 + inf))
= fst (0, 1 + (1 + (1 + inf)))
...
```

This evaluation never terminates.

Now here is `fst (0, inf)` evaluated using *call-by-name*:

```
  fst (0, inf)
= 0
```

In call-by-name, the arguments are *not* evaluated, and so `inf` is never
called. The first element of the pair is returned.

This example demonstrates a fundamental property of call-by-name: if there is a
reduction of an expression that terminates, then call-by-name will terminate for
the expression and return the same final result. 

## Number of reductions
Consider this function:

```haskell
square :: Int -> Int
square n = n * n
```

Here is `square (1+2)` evaluated using call-by-value:

```
  square (1+2)
= square 3
= 3 * 3
= 9
```

And using call-by-name:

```
  square (1+2)
= (1+2) * (1+2)
= 3 * (1+2)
= 3 * 3
= 9
```

Call-by-name needs one more reduction step than call-by-value because `(1+2)` is
evaluated twice. In general, call-by-name may evaluate the passed-in arguments
many times.

In practice, Haskell does not evaluate arguments multiple times, but evaluates
them only once (if needed) and uses pointers to that value to avoid
re-evaluating them. The two `(1+2)` expressions share the same value.

**Lazy evaluation** is call-by-name implemented using this sharing trick.

##  Infinite structures
Lazy evaluation can be used with infinite structures. For example:

```haskell
ones :: [Int]
ones = 1 : ones
```

If you evaluate `ones` it won't terminate:

```
  ones
= 1 : ones
= 1 : 1 : ones
= 1 : 1 : 1 : ones
...
```

This is the infinite list `[1,1,1,...]`.

Now consider the expression `head ones`, where `head` returns the first element
of the list. 

If we evaluate `head ones` using call-by-value, then it will first try to
evaluate `ones`, and so never terminate.

But if we instead use lazy evaluation, we get this:

```
  head ones
= head (1 : ones)
= 1
```

It terminates and returns 1. Lazy evaluation doesn't evaluate any part of the
list after the first element.

## Modular programming
The function `take n lst` returns the first `n` elements of list `lst`. It can
be used with infinite lists:

```
> take 3 ones
[1,1,1]
```

This separates the *stopping condition*, i.e. "stop after the first three
elements", from the code that generates the list. Functions that generate
infinite lists can sometimes be simpler than ones that generate finite lists
because the infinite lists don't need to handle the stopping condition.

### Generating primes
Here's an elegant use of infinite lists to generate prime numbers:

```haskell
primes :: [Int]
primes = sieve [2..]

sieve :: [Int] -> [Int]
sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
```

The method used here is called the [Sieve of
Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes). The idea is
that it begins with `[2..]`,  the infinite list of integers starting at 2. 2 is
a prime, and then all multiples of 2 are removed. The first number of what
remains is 3, which is also a prime. Then all multiples of 3 are removed, which
leaves 5 as the first number of the list, and the next prime.

Thanks to Haskell's lazy evaluation, we can use `take` to get the first few
primes:

```haskell
> take 10 primes
[2,3,5,7,11,13,17,19,23,29]
```

`takeWhile` can give us all primes less than some value, e.g. here all the
primes less than 100:

```haskell
> takeWhile (<100) primes
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,
 53,59,61,67,71,73,79,83,89,97]
```

## Strict evaluation
Haskell uses lazy evaluation by default, but it also provides a **strict
application** operator, `($!)` for when you don't want lazy evaluation. The
expression `f x` is lazy evaluation, and `f $! x` is strict evaluation.

We merely mention its existence here, and refer the interested reader to section
15.7 of the textbook for more information.
