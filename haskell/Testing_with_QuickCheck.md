## Testing with QuickCheck

To install [QuickCheck], run the following command:

```sh
$ cabal install --lib QuickCheck
```

[QuickCheck] is a that helps you test functions. [QuickCheck] does **property
testing**, i.e. it tests if a function satisfies a given **property**.

For example, consider [quicksort](https://en.wikipedia.org/wiki/Quicksort). A
correct implementation re-arranges items in a list to be in order from smallest
to biggest. Here are a few properties that hold for any sortable list `lst`:
    
- `quicksort (quicksort lst) == quicksort lst` says `quicksort` is
  [idempotent](https://en.wikipedia.org/wiki/Idempotence), i.e. sorting *any*
  list two (or more) times gives the same result as sorting it once
- `quicksort (reverse lst) == quicksort lst`
- `quicksort [1..n] == [1..n]`, for any integer `n` greater than 0
- `length lst == length (quicksort lst)` says that sorting doesn't change the
  size of the list

With these properties in hand, we can now use the [QuickCheck] module to turn
these properties in practical tests:

```haskell
-- quicksort_testing.hs

-- To run all tests, type runTests in the interpreter:
--
-- > runTests

import Test.QuickCheck

quicksort :: Ord a => [a] -> [a]
quicksort []     = []
quicksort (x:xs) = smalls ++ [x] ++ bigs
                 where smalls = quicksort [n | n <- xs, 
                                               n <= x]
                       bigs   = quicksort [n | n <- xs, 
                                               n > x]

-- sorting is idempotent
--
-- in general, a function f is idempotent if 
-- f (f x) = f x for all x, i.e. applying f twice gives 
-- the same result as applying it once
prop_qs1 :: [Int] -> Bool
prop_qs1 lst = quicksort (quicksort lst) == quicksort lst

-- sorting a list, or its reverse, returns the same result
prop_qs2 :: [Int] -> Bool
prop_qs2 lst = quicksort lst == quicksort (reverse lst)

-- sorting [1,2,..n] returns the same list
prop_qs3 :: Int -> Bool
prop_qs3 n = quicksort [1..n] == [1..n]

-- sorting doesn't change the length of a list
prop_qs4 :: [Int] -> Bool
prop_qs4 lst = length lst == length (quicksort lst)

runTests = do
  quickCheck prop_qs1
  quickCheck prop_qs2
  quickCheck prop_qs3
  quickCheck prop_qs4
```

Type `runTests` do the testing:

```haskell
> runTests 
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
```

Each call to `quickCheck` runs 100 *randomly chosen* inputs. If any of these
inputs *don't* satisfy the property, then [QuickCheck] reports the input as
causing a bug. Of course, just because all the tests pass doesn't guarantee
`quicksort` is bug-free, but it gives us more confidence in its correctness. In
practice, random testing often does a good job of catching bugs. Plus, many
programmers find property tests more interesting to create than low-level
(input, output) pairs. The process of coming up with testable properties forces
you to be very clear about what the function should do.

## Example of Finding a Bug
Lets see what happens when [QuickCheck] finds a bug. Consider this incorrect
quicksort:

```haskell
quicksortBuggy :: Ord a => [a] -> [a]
quicksortBuggy []     = []
quicksortBuggy (x:xs) = smalls ++ [x] ++ bigs
                      where smalls = quicksortBuggy [n | n <- xs, n < x] -- oops
                            bigs   = quicksortBuggy [n | n <- xs, n > x]
```

The bug is in the equation for `smalls`: `n < x` is written, when it is meant to
be `n <= x`. Here's the testing:

```haskell
> runTests 
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
*** Failed! Falsifiable (after 10 tests and 4 shrinks):    
[4,4]
```

The first few properties don't catch the bug --- [QuickCheck] can't guarantee to
catch all problems! It's `prop_qs4` that catches the error, i.e. `prop_qs4`
notices that the list returned by `quicksortBuggy` is not always the same length
as the input list. It gives the list `[4,4]` as an example of a list that breaks
the property, and now the programmer can trace through the function with example
to see what's going wrong.

[QuickCheck] said it did "4 shrinks" to get `[4,4]`. **Shrinking** is when
[QuickCheck] uses heuristics (rules of thumb) to change an input that causes a
failure into another input that is shorter, or simpler, and also causes a
failure. Compared to randomly generated inputs, these shrunken inputs are often
much easier for humans to read and use. 

## QuickCheck Example: last item of a list

Let's use [QuickCheck] to test a function called `mylast` that is supposed to
work the same as the standard `last` function (which returns the last element of
a list):

```haskell
mylast :: [a] -> a
mylast []     = error "empty list"
mylast [x]    = x
mylast (_:xs) = mylast xs

-- mylast :: [a] -> a
-- mylast []  = error "empty list"
-- mylast lst = head (drop (n-1) lst)
--              where n = length lst

-- mylast :: [a] -> a
-- mylast []  = error "empty list"
-- mylast lst = head (reverse lst)
```

A couple of alternate implementations are provided in case you want to test
those as well (practice makes perfect!).

First, we need to think of some properties that `mylast` has. Here are three
properties that hold for all *non-empty* lists `a` and `b`:

- `last (a ++ b) == last b`
- `last [x] == x`
- `last (reverse a) == head a`
- `last (map f lst) == f (last lst)`

To see that the last property holds, suppose `lst` is `[a,b,c]`. Then the
left-hand side of the property reduces as follows:

```haskell
  last (map f lst)
= last (map f [a,b,c])
= last [f a, f b, f c]
= f c
```

The right-hand side reduces to this:

```haskell
  f (last lst)
= f (last [a,b,c])
= f (c)
= f c
```

So the left-hand side and the right-hand side reduce to the same thing.

Looking at our implementation of `mylast`, the third property (`last [x] == x`)
doesn't seem very useful because the second equation in `mylast` explicitly
handles that case. So we will not implement it as a property.

You might try writing the first property like this:

```haskell
prop_mylast1_bad :: [Int] -> [Int] -> Bool
prop_mylast1_bad a b = mylast (a ++ b) == mylast b
```

But when you run it you get a failure very quickly:

```haskell
> quickCheck prop_mylast1_bad
*** Failed! (after 1 test):                            
Exception:
empty list
[]
[]
```

The problem is that `prop_mylast1_bad` generates *any* list of `Int` values,
including the empty list `[]`. But our property requires that `b` is non-empty.

There are two ways to fix this. The first is to re-write the test using
[QuickCheck]'s conditional operator, `==>`:

```haskell
prop_mylast1 :: [Int] -> [Int] -> Property
prop_mylast1 a b = b /= [] ==> mylast (a ++ b) == mylast b
```

This test only checks if the property holds when `b` is non-empty. The return
type of `(==>)` is `Property`, and so the return type of `prop_mylast1` must
also be `Property` (instead of `Bool`). Here's a sample run:

```haskell
> quickCheck prop_mylast1
+++ OK, passed 100 tests; 16 discarded.
```

16 of the randomly generated tests were discarded because `b` was empty. So be
careful when using `==>`: if your condition is very restrictive you may not end
up doing many tests.

A second fix is to write the test using the special type `NonEmptyList a`
provided by [QuickCheck] :

```haskell
prop_mylast1b :: NonEmptyList Int -> NonEmptyList Int -> Bool
prop_mylast1b (NonEmpty a) (NonEmpty b) = mylast (a ++ b) == mylast b
```

This ensures the random lists generated by [QuickCheck] to always have at least
one element. Note that the return type is back to `Bool` again.

Finally, we also have this property:

```haskell
prop_mylast3 :: NonEmptyList Int -> Bool
prop_mylast3 (NonEmpty a) = mylast (map inc a) == inc (mylast a)
                            where inc n = n + 1 
```

We use `inc` as the mapping function here because it is simple; you could
replace it with any other function of type `Int -> Int`.

Here are all the tests, plus a helper function to run them:

```haskell
prop_mylast1 :: [Int] -> [Int] -> Property
prop_mylast1 a b = a /= [] && b /= [] ==> mylast (a ++ b) == mylast b

prop_mylast1b :: NonEmptyList Int -> NonEmptyList Int -> Bool
prop_mylast1b (NonEmpty a) (NonEmpty b) = mylast (a ++ b) == mylast b

prop_mylast2 :: [Int] -> Property
prop_mylast2 a = a /= [] ==> mylast (reverse a) == head a

prop_mylast2b :: NonEmptyList Int -> Bool
prop_mylast2b (NonEmpty a) = mylast (reverse a) == head a

prop_mylast3 :: NonEmptyList Int -> Bool
prop_mylast3 (NonEmpty a) = mylast (map inc a) == inc (mylast a)
                            where inc n = n + 1 

runTests = do
    quickCheck prop_mylast1
    quickCheck prop_mylast1b
    quickCheck prop_mylast2
    quickCheck prop_mylast2b
    quickCheck prop_mylast3
```

Here's a sample run:

```haskell
> runTests 
+++ OK, passed 100 tests; 22 discarded.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests; 14 discarded.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
```

In practice, you only need one version of each property; the `==>` versions can
probably be discarded.

### Challenge: testing contains_all
Implement and test the function `contains_all as bs` that returns `True` just
when every element of `as` is also an element of `bs`. Both `as` and `bs` are
lists of `Int`s. If `as` is empty, then `contains_all` returns `False`.

For example, `contains_all` works like this:

```haskell
> contains_all [2,0,1] [9,2,4,1,0]
True
> contains_all [2,0,1] [9,4,1,0]
False
> contains_all [] [9,4,1,0]
True
```

Use [QuickCheck] for the testing. Test `contains_all` with **at least three**
different properties.

### Challenge: testing quicksort

Using `contains_all` from the previous challenge, add two more property tests
for quicksort:

1. Every element of `lst` is a member of `quicksort lst`.
2. Every element of `quicksort lst` is a member of `lst`.

## Final Thoughts

Property testing has proven to be quite popular with some programmers, and
[QuickCheck]-like tools have appeared in other languages. For example, in
[Python] the [Hypothesis](https://hypothesis.readthedocs.io/en/latest/) package
offers [QuickCheck]-like testing for [Python] code.

It's also worth noting that discovering and stating properties of functions can
be good way to better understand a program and how it works. The careful
attention to the details of a function can make you feel more confident that it
is correct and that you understand it.

If you'd like to learning more about [QuickCheck], the [QuickCheck package
page](https://hackage.haskell.org/package/QuickCheck) has more information.

[Scheme]: https://en.wikipedia.org/wiki/Scheme_(programming_language)
[Racket]: https://racket-lang.org/
[LISP]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java_(programming_language)
[Prolog]: https://en.wikipedia.org/wiki/Prolog
[Haskell]: https://en.wikipedia.org/wiki/Haskell_(programming_language)
[Python]: https://en.wikipedia.org/wiki/Python_(programming_language)
[QuickCheck]: https://hackage.haskell.org/package/QuickCheck
