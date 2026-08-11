# Haskell Problem Set

The questions on the Haskell quiz will mainly be variations of the questions
below, or questions that are similar. In your answers, please stick to basic
Haskell features and code as used in the notes. There are many more-advanced
functions you can find online, but please don't use them in your answers.

Please post your answers to the discussion board to share with other students.

**Important**: *Treat these problem-sets as non-AI activities!* Turn off all AI
support and try to figure them out yourself. Having AI or another student do
this for you will not help you learn. You must do the learning yourself!

## Question 1: Predicting output

Without running GHCi, work out what each expression evaluates to:

```haskell
> take 3 (drop 2 [10,20,30,40,50,60])
> reverse (tail "haskell")
> zip [1,2,3] "xyz"
```

## Question 2: Second-to-last

Implement a function `secondLast lst` that returns the second-to-last element of
a list, without using `!!`. You can assume the list has at least two elements.
Include the most general type signature.

```haskell
> secondLast [1,2,3,4]
3
> secondLast "quiz"
'i'
```

## Question 3: Working out types

Give the most general type signature for each of the following. Try to work it
out yourself before checking with `:type` in GHCi.

a. `('a', True, "cat")`

b. `(:)`

c. `\x y -> x : y`

d. `filter`

## Question 4: Currying

In your own words, explain what *currying* is and how it works in Haskell. Give
two examples of new functions created by currying the existing functions `map`
and `filter`.

Make your explanation as clear and concise as possible for someone who knows how
to program in, say, C++, but not is not familiar with Haskell.

## Question 5: Grading with guards

Write a function `letterGrade score` that uses guarded equations to convert a
numeric score from 0 to 100 into a letter grade: 90 or above is `"A"`, 80-89 is
`"B"`, 70-79 is `"C"`, 60-69 is `"D"`, and anything below 60 is `"F"`. Include
the type signature.

## Question 6: Taking and Dropping

Write your own versions of the `takeWhile` and `dropWhile` functions (don't use
them in your implementation!). Include the type signatures.

## Question 7: Explain the bug

In your own words, explain what's wrong with the following code, and how you
would fix it:

```haskell
average :: [Int] -> Int
average xs = sum xs / length xs
```

AI can, of course, trivially answer this question for you. But try it yourself
first. Going through the process of trying to figure it out yourself is an
important part of learning.

## Question 8: Lambdas and sections

Rewrite `addOne = map (\x -> x + 1)` as an equivalent one-liner that uses an
**operator section** instead of a lambda. Then use `map` and a section to
write a function `halves` that divides every number in a list by 2.

## Question 9: Pythagorean triples

Use a *list comprehension* to write a function `triples n` that returns all
Pythagorean triples `(a,b,c)` with `1 <= a < b < c <= n` and `a^2 + b^2 =
c^2`. Include the type signature.

```haskell
> triples 20
[(3,4,5),(5,12,13),(6,8,10),(8,15,17),(9,12,15),(12,16,20)]
```

## Question 10: Comprehension with guards

Write a function `notDivisible n` that returns all the numbers from 1 to `n`
that are **not** evenly divisible by 3 or by 5.

Do it in two different ways: one *with* a list comprehension, and *without* a
list comprehension.

## Question 11: Recursive power

Implement `myPower base ex` using *recursion* (don't use `^` or `**`) that
computes `base` raised to a non-negative integer exponent `ex`. Include the
type signature, and be sure to handle the base case.

```haskell
> myPower 2 5
32
> myPower 3 0
1
```

## Question 12: A point-free pipeline

Write a one-line, **point-free** function `sumSquaresOdd` that takes a list of
`Int`s, keeps only the odd ones, squares each of them, and returns the sum.
Use function composition (`.`) rather than a lambda. Include the type
signature.

```haskell
> sumSquaresOdd [1,2,3,4,5]
35
```

## Question 13: Folding to a Bool

Using `foldr` (not plain recursion, and not the standard `all` function),
implement `allPositive :: [Int] -> Bool`, which returns `True` if every number
in the list is strictly greater than 0, and `False` otherwise. An empty list
should return `True`.

## Question 14: A new data type

Declare a new data type `Season` with four constructors: `Spring`, `Summer`,
`Fall`, and `Winter`, deriving `Eq` and `Show`. Then write a function
`nextSeason :: Season -> Season` that returns the season that follows the one
given (`Winter` wraps back around to `Spring`).

```haskell
> nextSeason Summer
Fall
> nextSeason Winter
Spring
```

## Question 15: Letter Frequencies

Write a function `letterFrequency :: String -> [(Char, Int)]` that returns a
list of length 26 that contains (letter, frequency) pairs for the lowercase
letters `a` to `z`.

For example:

```haskell
> letterFrequency "apple"
[('a',1),('b',0),('c',0),('d',0),('e',1),('f',0),('g',0),('h',0),
('i',0),('j',0),('k',0),('l',1),('m',0),('n',0),('o',0),('p',2),
('q',0),('r',0),('s',0),('t',0),('u',0),('v',0),('w',0),('x',0),
('y',0),('z',0)]
```
