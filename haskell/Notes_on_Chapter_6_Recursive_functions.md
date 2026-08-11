# Notes on Chapter 6: Recursive functions

Since Haskell has no loops, recursion is a fundamental implementation technique.

## Basic concepts

A **recursive function** is a function that calls itself, either directly or indirectly.

For example, the **factorial** of a non-negative integer $n$ is defined to be
$n!=1\cdot 2 \cdot 3 \cdot \ldots \cdot n$, and $0!=1$.

Here is a non-recursive function that calculates it:

```cpp
fact1 :: Integer -> Integer
fact1 n = product [1..n]
```

And here is a recursive function:

```cpp
fact2 :: Integer -> Integer
fact2 0 = 1                -- base case
fact2 n = n * fact2 (n-1)  -- recursive case
```

Recursive functions are normally divided into **base case** and **recursive
case** rules. A base case contains no recursive call, while a recursive case has
one or more recursive calls. 

Bases cases tell a recursive function when to stop. They play a role similar to
the conditional expression in a while-loop in languages like Python or C++. Try
commenting out the base case of `fact1` to see what happens.

### Challenge: recursive squares

Implement a function called `sqr_sum n` that *uses recursion* to calculate the
sum $1^2+2^2+\ldots+n^2$. Assume `n` is an integer greater than 0.

Include the most general type signature for the `sqr_sum`.

### Challenge: odd factorial

Implement a function called `odd_fact n` that *uses recursion* to calculate the
product of the *odd* numbers that are less than, or equal to `n`. For example,
if `n` is odd then $1 \cdot 3 \cdot 5 \ldots n$ is returned, and if `n` is even
then $1 \cdot 3 \cdot 5 \ldots (n-1)$ is returned.

Assume `n` is an `Integer` greater than 0. Include the type signature for
`odd_fact`.

For example:

```scheme
> odd_fact 1
1
> odd_fact 2
1
> odd_fact 3
3
> odd_fact 5
15
> odd_fact 6
15
> odd_fact 10
945
> odd_fact 20
654729075
```

## Recursion on lists
Recursion often applies naturally to lists. For instance, the product of all the
numbers on a list can be calculated like this:

```haskell
myproduct :: Num a => [a] -> a
myproduct []     = 1                 -- base case
myproduct (x:xs) = x * myproduct xs  -- recursive case

> myproduct [1,4,2]
8
> myproduct [1..10]
3628800
```

Here's a recursive implementation of the length of a list:

```haskell
len :: [a] -> Int
len []     = 0
len (_:xs) = 1 + len xs

> len "apple"
5
> len [1..10]
10
```

`rev` reverses the order of the elements in a list:

```haskell
rev :: [a] -> [a]
rev []     = []
rev (x:xs) = rev xs ++ [x]

> rev "camera"
"aremac"
> rev [1..10]
[10,9,8,7,6,5,4,3,2,1]
```

In Haskell, `(++)` appends two lists. We can create our own recursive version
like this:

```haskell
append :: [a] -> [a] -> [a]
append [] ys     = ys
append (x:xs) ys = x : (append xs ys)

> append "apple" "jack"
"applejack"
> append [1.2,8.7] []
[1.2,8.7]
```

Recall that `:` creates a new list by adding an item to the start of a list,
e.g. `6 : [1,2]` evaluates to `[6,1,2]`.

This `insert` function assumes the input list is in ascending sorted order, and
inserts a given element into the correct location so that the list remains
sorted:

```haskell
insert :: Ord a => a -> [a] -> [a]
insert a [] = [a]
insert a (x:xs) | a <= x    = a:x:xs
                | otherwise = x : (insert a xs)

> insert 4 [1..5]
[1,2,3,4,4,5]
> insert 'c' "abde"
"abcde"
```

`insert` lets us implement **insertion sort**:

```haskell
isort :: Ord a => [a] -> [a]
isort []     = []
isort (x:xs) = insert x (isort xs)

> isort "apple"
"aelpp"
> isort [9,2,5,1,9,0,2]
[0,1,2,2,5,9,9]
```

Our aim here is to make functions that are correct, flexible, and easy to read.
We have chosen not to be too concerned with performance. Indeed, recursion plus
Haskell's immutable lists can often result in code that is less efficient than
straightforward loop-based implementations in languages like C++ or Python.

### Challenge: recursive counting

Implement a function called `count a lst` that uses recursion to calculate the
number of times `a` occurs in `lst`. For example:

```haskell
> count 'a' "banana"
3
> count [1,2] [[4,1,2,1],[1,2],[3,4,5],[1,2]]
2
> count ("up","down") [("up","down"),("down","up"),("cat","jump")]
1
```

Include the most general type signature for `count`.

### Challenge: selection sort
Here is a Haskell implementation of selection sort:

```cpp
ssort :: Ord a => [a] -> [a]
ssort [] = []
ssort xs = [m] ++ ssort (remove m xs)
           where m = mymin xs
```

Using recursion, implement your own versions of both `remove m xs` (removes the
*first* occurrence of `m` from `xs`), and `mymin xs` (returns the smallest
element in `xs`).

As part of your answers, include the most general type signature for `remove`
and `mymin`.

### Challenge: unique strings

Call a string **unique** if all pairs of adjacent characters are different. For
example, `""`, `"m"`, `"up"`, `"abab"`, and `"once upon a time"` are all unique
strings. But `"aa"`, `"balloon"`, and `"What??"` are not unique.

Implement the following functions:

1. `is_unique s` returns `True` if `s` is a unique string, and `False`
   otherwise.
2. `uniquify s` returns a unique version of `s`. If `s` is already unique then
   it's returned unchanged. Otherwise, for each consecutive sequence of 2 or
   more identical characters, remove all but one of the characters. For example:

   ```haskell
    > uniquify "aaaabccddd"
    "abcd"
    > uniquify "apple"
    "aple"
    > uniquify "cat"
    "cat"
    > uniquify ""
    ""
   ```

   In general, `is_unique (uniquify s)` always returns `True`.

## Advice on recursion
The textbook provides more examples and advice for writing recursive functions.

Despite their usefulness, in Haskell recursive functions tend to be avoided.
Recursion a somewhat low-level technique, and it is often better to use, say,
list comprehensions or higher-order functions like `map` and `zip`.
