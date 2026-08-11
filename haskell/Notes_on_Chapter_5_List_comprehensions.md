# Notes on Chapter 5: List comprehensions

## Basic concepts

Haskell **list comprehensions** are a useful way to create lists. They're based
on mathematical set notation.

For example, this comprehension returns the squares of the numbers 1 to 5:

```haskell
> [x^2 | x <- [1..5]]
[1,4,9,16,25]
```

[1..5]]` can be read "the list of all numbers `x^2` where `x` is drawn from
The `|` can be read "such that", and the `<-` "is drawn from".  So `[x^2 | x <-
`[1..5]`". The expression `x <- [1..5]` is called a **generator**.

An equivalent expression is this:

```haskell
> map (^2) [1..5]
[1,4,9,16,25]
```

`map f lst` applies function `f` to every element of `lst`. For example, `map f
[a,b,c]` is `[f a, f b, f c]`. `(^2)` is an operator section that squares its
input. 

The `map` expression is little shorter than the comprehension in this case. But
comprehensions can often be simpler. For instance, suppose you want the square
of a number plus 1:

```haskell
> [x^2 + 1 | x <- [1..5]]
[2,5,10,17,26]
```

With `map`, you need to define another function:

```haskell
> map (\x -> x^2 + 1) [1..5]
[2,5,10,17,26]
```

Or:

```haskell
> f x = x^2 + 1
> map f [1..5]
[2,5,10,17,26]
```

Both `map` solutions are longer than the comprehension. Arguably, the
comprehensions is also easier to read.

Comprehensions can be used with multiple generators. For example:

```haskell
> [(x,y) | x<-[1..4], y<-[1..3]]
[(1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3),(4,1),(4,2),(4,3)]
```

`[(x,y) | x<-[1..4], y<-[1..3]]` calculates the [Cartesian
product](https://en.wikipedia.org/wiki/Cartesian_product) of `[1,2,3,4]` and
`[1,2,3]`. For example, this generates all bit patterns of length 3:

```haskell
> [(a,b,c) | a<-[0,1], b<-[0,1], c<-[0,1]]
[(0,0,0),(0,0,1),(0,1,0),(0,1,1),(1,0,0),(1,0,1),(1,1,0),(1,1,1)]
```

### Challenge: bit patterns of length 4

Write a list comprehension that evaluates to a list containing all 16
bit-patterns of length 4.

### Challenge: ab-patterns of length 4

Implement a function named `patterns4 s t` that takes values `s` and `t` as
input and returns the list of all 16 4-tuples of combinations of `s` and `t`. 

For example:

```haskell
> patterns4 "cat" "mouse"
[("cat","cat","cat","cat"),("cat","cat","cat","mouse"),
("cat","cat","mouse","cat"),("cat","cat","mouse","mouse"),
("cat","mouse","cat","cat"),("cat","mouse","cat","mouse"),
("cat","mouse","mouse","cat"),("cat","mouse","mouse","mouse"),
("mouse","cat","cat","cat"),("mouse","cat","cat","mouse"),
("mouse","cat","mouse","cat"),("mouse","cat","mouse","mouse"),
("mouse","mouse","cat","cat"),("mouse","mouse","cat","mouse"),
("mouse","mouse","mouse","cat"),("mouse","mouse","mouse","mouse")]
```

Include the most general type signature of `patterns4`.

## Concatenation

The standard `concat` function takes a list of lists as input, and returns a
list with all the lists combined into a single list. For example:

```haskell
> concat [[1,2],[],[3,4,5],[6]]
[1,2,3,4,5,6]
```

`concat` can be implemented using a list comprehension, e.g.:

```haskell
concat :: [[a]] -> [a]
concat xss = [x | xs <- xss, x <- xs]
```

The second generator `x <- xs` uses the variable in the first generator. The
idea is that `xs` is a list from the list of lists `xss`, and the generator `x
<- xs` generates all the elements from it.

Here's a trick for finding the length of a list using a generator:

```haskell
len :: [a] -> Int
len xs = sum [1 | _ <- xs]
```

The wildcard `_` is used because the final list only contains 1s, and so there
is no need for a named variable. 

### Challenge: some sums 1

Write a list comprehension that returns a list of `Int`s with the sums of all
100 pairs of numbers from 1 to 10, e.g. 1+1, 1+2, ..., 1+10, 2+1, 2+2, ... 2+10,
..., 10+1, 10+2, ..., 10+10.

### Challenge: some sums 2

Re-do the previous question, but this time the elements of the list are 3-tuples
of `Int`s of the form (x, y, x+y).

## Guards

List comprehensions can use **guards** to filter-out values. For example:

```haskell
> [n | n <- [1..10], n `mod` 2 == 0]
[2,4,6,8,10]
```

The expression ``n `mod` 2 == 0`` is a guard, and only values of `n` that make
it true (i.e. even numbers) are included in the list. 

Multiple guards can be combined using a comma. Here is a list of numbers from 1
to 100 that are evenly divisible by both 2 and 3:

```haskell
> [n | n <- [1..100], n `mod` 2 == 0, n `mod` 3 == 0]
[6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96]
```

This comprehension has two guards, and *both* must be satisfied. 

### Challenge: sums to n
Implement a function called  `sums_to n` that uses a *list comprehension* to
calculate all the pairs of integers `(a,b)` such that:
- `a` is less than, or equal to, `b`
- `a+b` equals `n`
- neither `a` nor `b` is a multiple of 5

You can assume `n` is an integer greater than 0. Include the type signature for
`sums_to`.

For example:

```haskell
> sums_to 1
[]
> sums_to 10
[(1,9),(2,8),(3,7),(4,6)]
> sums_to 100
[(1,99),(2,98),(3,97),(4,96),(6,94),(7,93),(8,92),(9,91),
(11,89),(12,88),(13,87),(14,86),(16,84),(17,83),(18,82),
(19,81),(21,79),(22,78),(23,77),(24,76),(26,74),(27,73),
(28,72),(29,71),(31,69),(32,68),(33,67),(34,66),(36,64),
(37,63),(38,62),(39,61),(41,59),(42,58),(43,57),(44,56),
(46,54),(47,53),(48,52),(49,51)]
```

### Prime Numbers
This comprehension calculates all factors of an integer:

```haskell
factors :: Int -> [Int]
factors n = [d | d <- [1..n], n `mod` d == 0]
```

```haskell
> factors 10
[1,2,5,10]
> factors 11
[1,11]
> factors 12
[1,2,3,4,6,12]
```

If `n` is a prime number, then it's only factors are 1 and `n`, and so we can
test for prime numbers like this:

```haskell
is_prime :: Int -> Bool
is_prime n = factors n == [1,n]

> is_prime 10
False
> True
> is_prime 12
False
```

With this we can now describe the set of all prime numbers:

```haskell
primes :: [Int]
primes = [n | n <- [2..], isPrime n]
```

`primes` is an **infinite list**. If you try to evaluate the whole thing you'll
get stuck in an infinite loop since it will never terminate. But, since Haskell
is a **lazy language**, it's possible to only evaluate a *finite part* of
`primes`.

For instance, here is a function that returns the first `n` primes:

```haskell
firstNprimes n = take n primes

> firstNprimes 20
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71]
```

`take` is a standard function that returns the first `n` items of a list, even
if it's infinite. When you call `firstNprimes n`, Haskell only evaluates enough
of `primes` to get the the first `n` numbers needed by `take`. The rest of the
list is not evaluated.

Here's another example that returns a list of all the primes *less than* `n`:

```haskell
primesLessThan n = takeWhile (<n) primes

> primesLessThan 100
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]
```

`takeWhile pred lst` is another standard function the returns the a list of all
the elements at the start of `lst` that satisfy the predicate `pred`.

While this is not the most efficient way of generating primes, it is remarkable
how simple the code is (assuming you understand comprehensions!). There are no
loops, if-statements, or recursive calls. Each function is a single line long,
and built from standard functions.

### Challenge: number of primes

Write a function called `numPrimesUpto n` that returns the number of primes less
than, or equal to, `n`. For example:

```haskell
> numPrimesUpto 100
25
> numPrimesUpto 1000
168
```

Include the type signature for the function.

> **Note** In mathematics `numPrimesUpto n` is often denoted $\pi (n)$. It is
> [one of the most famous functions in
> mathematics](https://en.wikipedia.org/wiki/Prime-counting_function).

## Finding Values

This `find` function searches a simple kind of database we'll call a **look-up
table**:

```haskell
find :: Eq a => a -> [(a,b)] -> [b]
find key table = [v | (k, v) <- table, k == key]
```

```haskell
> find "Bob" [("Mei",20),("Bob",10),("Kel", 19),("Bob",15)]
[10,15]
```

The type `a` in the function signature must satisfy `Eq a`, because `==` is used
in the guard to test if keys are equal.

Again, while this is not the most efficient way to look-up values in a table
(hash tables are much faster!), it is short and simple.

### Challenge: lookup table keys

Implement a function called `keys table` that uses a list comprehensions to
return a list of just the *keys* in a lookup table. The table is a list of
(key,value) pairs as in `find`.

For example:

```haskell
> keys [("Mei",20),("Bob",10),("Kel", 19),("Bob",15)]
["Mei","Bob","Kel","Bob"]
```

Include the type signature for the function.

### Challenge: lookup table values

Implement a function called `values table` that uses a *list comprehension* to
return a list of just the *values* in a lookup table. The table is a list of
(key,value) pairs as used in `find`.

For example:

```haskell
> values [("Mei",20),("Bob",10),("Kel", 19),("Bob",15)]
[20,10,19,15]
```

Include the type signature for `values`.

## Example: Fizz buzz

The [Fizz Buzz problem](https://en.wikipedia.org/wiki/Fizz_buzz) is a well-known
programming puzzle:

> Print integers 1 to n, but print “Fizz” if an integer is divisible by 3,  “Buzz” if an integer is divisible by 5, and “FizzBuzz” if an integer is divisible by both 3 and 5.

One way to solve this puzzle is to write a function that, for any integer `n`,
returns the string for that number:

```haskell
fb_rule :: Int -> String
fb_rule n | n `mod` 3 == 0 && n `mod` 5 == 0 = "FizzBuzz"
          | n `mod` 3 == 0                   = "Buzz"
          | n `mod` 5 == 0                   = "Fizz"
          | otherwise                        = show n
```

```haskell
> fb_rule 14
"14"
> fb_rule 15
"FizzBuzz"
> fb_rule 27
"Buzz"
> fb_rule 300
"FizzBuzz"
> fb_rule 200
"Fizz"
```

Recall that `show n` converts the integer `n` to a string.

Now we can use a list comprehension to apply `fb_rule` to numbers from 1 to n:

```haskell
fizzbuzz :: Int -> [String]
fizzbuzz n = [fb_rule a | a <- [1..n]]
```

```haskell
> fizzbuzz 20
["1","2","Buzz","4","Fizz","Buzz","7","8","Buzz","Fizz","11","Buzz",
 "13","14","FizzBuzz","16","17","Buzz","19","Fizz"]
```

## The zip function

The expression `zip lst1 lst2` returns a list of pairs of the corresponding
elements in `lst1` and `lst2`:

```haskell
> zip [1,2,3] ["Bob","Bill","Jaya"]
[(1,"Bob"),(2,"Bill"),(3,"Jaya")]
> zip [1,2] ["Bob","Bill","Jaya"]
[(1,"Bob"),(2,"Bill")]
> zip [1,2,3] ["Bob","Bill"]
[(1,"Bob"),(2,"Bill")]
```

We can use `zip` to implement a function that return all pairs of *adjacent*
items in a list:

```haskell
pairs :: [a] -> [(a,a)]
pairs xs = zip xs (tail xs)

> pairs [4,9,1,1,2]
[(4,9),(9,1),(1,1),(1,2)]
```

`tail lst` returns all items of `lst` except for the first item, just like
`rest` in Racket.

A list of numbers is in **ascending sorted order** just when, for each adjacent
pair of numbers, the first number is less than, or equal to, the second number:

```haskell
is_sorted :: Ord a => [a] -> Bool
is_sorted xs = and [x <= y | (x,y) <- pairs xs]

> is_sorted [4,1,7,2]
False
> is_sorted [1,2,4,7,7]
True
```

The  list comprehension `[x <= y | (x,y) <- pairs xs]` returns a list of
`True`/`False` values. The function `and lst` returns `True` when `lst` has no
`False` elements.

Another clever use of `zip` is in the function `positions x lst`, which returns
a list of the index positions of all occurrences of `x` in `lst`:

```haskell
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..],
                      x == x']

> positions 'p' "apple"
[1,2]
> positions 4 [4,1,2,3,4]
[0,4]
> positions 4 [1,2,3]
[]
```

The expression `[0..]` is the **infinite list** of integers `[0,1,2,3,...]`.
Since Haskell uses *lazy evaluation* for expressions, i.e. it doesn't evaluate
an expression until it is needed. `zip` only extracts enough elements of `[0..]`
to match the length of `xs`. Since `xs` is finite, `zip xs [0..]` returns a
finite list.

### Challenge: twin primes

Implement a function called `twinPrimesUpto n` that uses `zip` and `primesUpto`
from above to generate all pairs of [twin
primes](https://en.wikipedia.org/wiki/Twin_prime) less than or equal to `n`. The
pair of ints ($p$, $q$) is a [twin
prime](https://en.wikipedia.org/wiki/Twin_prime) if both $p$ and $q$ are primes,
and $q = p +2$.

Include the type signature for the function.

For example:

```haskell
> twinPrimesUpto 30
[(3,5),(5,7),(11,13),(17,19)]
> twinPrimesUpto 31
[(3,5),(5,7),(11,13),(17,19),(29,31)]
> twinPrimesUpto 100
[(3,5),(5,7),(11,13),(17,19),(29,31),(41,43),
 (59,61),(71,73)]
```

## String comprehensions

In Haskell, strings are list of characters, and so you can use comprehensions
with strings.

## Example: Cracking the Caesar cipher

It's instructive to carefully read through the code for the Caesar cipher from
the end of chapter 5. It makes good use of comprehensions and a number of the
functions defined in the chapter.

Notice the use of `where` in a couple of the functions. `where` lets you compute
a value and store it in a variable. This can make the main code shorter and
easier to read.

```haskell
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..],
                      x == x']
                      
lowers :: String -> Int
lowers xs = length [x | x <- xs, x >= 'a' && x <= 'z']

count :: Char -> String -> Int
count c s = length [c' | c' <- s, c == c']

--
-- Caesar cipher
--

-- assumes c is a lower case letter, a to z
-- a is 0, b is 1, ..., z is 25
let2int :: Char -> Int
let2int c = ord c - ord 'a'

-- assumes 0 <= n <= 25
int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

-- Returns the encoding of c, which is n characters to the right of c in the
-- alphabet (wrapping back around to a if you go past z)
shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c+n) `mod` 26)
          | otherwise = c

encode :: Int -> String -> String
encode n cs = [shift n c | c <- cs]

-- frequency table of letters a to z generated from sample text
--
-- a occurs 8.1% of the time, b 1.5% of the time, ..., z 1% of the time
table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
         0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0,
         6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

-- helper function returns the ratio of two integers as a percentage; if 0 <=
-- n <= m, then the result is from 0 to 100
percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

freqs msg = [percent (count c msg) n | c <- ['a'..'z']]
            where n = lowers msg

-- calculates he Chi-square statistics of two lists of numbers;
-- the smaller this number, the more similar the lists
chisqr :: [Float] -> [Float] -> Float
chisqr as bs = sum [((a-b)^2)/b | (a,b) <- zip as bs]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

crack :: String -> String
crack s = encode (-factor) s
        where 
         factor = head (positions (minimum chitab) chitab)
         chitab = [chisqr (rotate n table') table | n<-[0..25]]
         table' = freqs s
```
