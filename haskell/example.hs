-- example.hs

-- returns the product of a list
-- e.g. myproduct [1,2,3] = 6
myproduct :: Num a => [a] -> a  -- type signature
myproduct []     = 1                -- rule 1 (base case)
myproduct (n:ns) = n * myproduct ns -- rule 2 (recursive case)

-- returns n! = 1 * 2 * ... * n
-- e.g. factorial 4 = 24
factorial :: (Num a, Enum a) => a -> a
factorial n = myproduct [1..n]

-- returns the sum of a list
-- e.g. mysum [1,2,3] = 6
mysum :: Num a => [a] -> a
mysum []     = 0
mysum (n:ns) = n + mysum ns


-- returns the first element of a list
-- e.g. myhead [1,2,3] = 1
-- myhead :: [a] -> a
-- myhead []    = undefined
-- myhead (x:_) = x   -- _ is anonymous variable

-- returns all but the first element of a list
-- e.g. mytail [1,2,3] = [2,3]
mytail :: [a] -> [a]
mytail []     = undefined
mytail (_:xs) = xs


-- returns the last element of a list
-- e.g. mylast [1,2,3] = 3
mylast :: [a] -> a
mylast []     = undefined
mylast [x]    = x
mylast (_:xs) = mylast xs


-- returns the first and last element of a list
-- e.g. ends [1,2,3] = [1,3]
ends :: [a] -> [a]
ends []           = undefined
ends [x]          = [x, x]
ends (first:rest) = [first, mylast rest]
--ends xs  = [myhead xs, mylast xs]

-- returns the length of a list
-- e.g. mylength [1,2,3] = 3
mylength :: [a] -> Int
mylength []     = 0
mylength (x:xs) = 1 + mylength xs

-- returns the average of a list
-- e.g. average [1,2,3] = 2
-- average ns = mysum ns / mylength ns

-- returns the reverse of a list
-- e.g. myreverse [1,2,3] = [3,2,1]
myreverse :: [a] -> [a]
myreverse []     = []
myreverse (x:xs) = myreverse xs ++ [x]

-- returns the lst with the last element removed
-- e.g. myinit [1,2,3] = [1,2]
myinit :: [a] -> [a]
myinit [] = undefined
myinit [x]    = []
myinit (x:xs) = x : myinit xs
-- myinit xs = reverse (mytail (reverse xs))

-- returns the middle elements of a list; the middle of the empty list is the
-- empty list 
-- e.g. middle [1,2,3,4,5] = [2,3,4]
middle :: [a] -> [a]
middle []     = []
middle (_:xs) = myinit xs

-- returns the the string + "s"; if the string ends in "s", returned unchanged; the
-- plural of the empty string is the empty string
-- e.g. pluralize "cat" = "cats", pluralize "cats" = "cats"
pluralize :: String -> String
pluralize "" = ""
pluralize s  = if mylast s == 's'
               then s
               else s ++ "s"

-- returns the sign of a number: "zero", "positive", or "negative"  
-- e.g. sign 0 = "zero", sign 1 = "positive", sign (-1) = "negative"
-- sign 0 = "zero"
-- sign x = if x < 0
--          then "negative"
--          else "positive"
sign :: (Num a, Ord a) => a -> String
sign n | n == 0    = "zero"  -- guarded equation
       | n > 0     = "positive"
       | otherwise = "negative"

--myand :: Bool -> (Bool -> Bool)
myand :: Bool -> Bool -> Bool
myand True True   = True
myand False True  = False
myand True False  = False
myand False False = False

-- multiply 3 Ints
mult :: Int -> Int -> Int -> Int
mult a b c = a * b * c

-- fst: first element of a tuple (x, y)
-- snd: second element of a tuple (x, y)

-- take n lst
-- returns the first n elements of list lst

-- drop n lst
-- returns a copy of lst without the first n elements

-- zip a b: combines two lists into a list of tuples

-- id x: identity function


-- lambda functions
inc :: Int -> Int
inc = \x -> x + 1

--      x      y      x+y
plus :: Int -> Int -> Int
plus = \x y -> x + y

-- operator sections

-- twice function
-- twice f x = f (f x)
twice f = f . f
tail2 = twice tail

-- makeAdder
-- returns a function that adds n to its argument
-- makeAdder :: Int -> (Int -> Int)
makeAdder :: Int -> Int -> Int
makeAdder n = (+ n)

add4 = makeAdder 4

-- flip
-- flip :: (a -> b -> c) -> b -> a -> c
-- flip f x y = f y x

-- map
mymap :: (a -> b) -> [a] -> [b]
mymap _ []     = []
mymap f (x:xs) = (f x) : (mymap f xs)


-- filter

-- all, any

-- takeWhile

-- dropWhile

-- foldr (right fold)

-- function composition

--
-- Sorting
--

-- What's the most general type signature for a function that sorts a list of
-- items?

-- Write a function insert x L that inserts x into the correct position in the
-- sorted list L. Assume L is a sorted list, and x is the same type as items on
-- L.

-- ??

-- Implement insertion_sort lst to that sorts lst using insertion sort (use the
-- insert function to help). Use basic recursion and no higher-order functions.
-- Also write the most general type signature.

-- insertion sort
-- ??

-- Implement insertion_sort' that implements insertion sort using foldr and the
-- insert function from above.
-- ??

--
-- agree f g x is a helper function that checks if functions f and g returns the
-- same value for x; in general, agree f g x returns f x == g x
--
-- For example, to check that f and g return the same value for the same inputs,
-- we could write check = agree insertion_sort insertion_sort'. Then you can run
-- test cases like this:
--
-- > check "pizza"
-- True
-- > check [7,4,2,9,3,5,2,2,1]
--

-- ??

--
-- Implement quicksort
--

-- ??

--
-- all bit strings of length n
-- 
-- bools n returns all bit strings of length n, e.g.
--
-- > bools 3
-- ["000","001","010","011","100","101","110","111"]
--
-- > take 3 (bools 10)
-- ["0000000000","0000000001","0000000010"]
--

-- ??


--
-- range function
--
-- range n returns the list of ints [0,1,...,n-1] (like Python's range
-- function). Implement it in a way that takes advantage of Haskell's lazy
-- evaluation.
--

-- ??


--
-- Prime numbers
--

--
-- Write a function called isPrime :: Int -> Bool that such that isPrime n
-- returns True if n is a prime, and False otherwise.
--

-- idea: if all the numbers from 2 up to and including the square root of n
-- *don't* divide evenly into n, then n must be a prime

-- ??

-- Define primes to be infinite (!) list of all primes [2, 3, 5, 7, 11, ...]

-- ??

-- firstNprimes n returns a list of the first n prime numbers

-- ??

-- primessLessThan n returns a list of all primes less than n

-- ??

-- nthPrime n returns the nth prime, e.g. if n is 1 then 2 is returned; if n is
-- 2 then 3 is returned, ...

-- ??
