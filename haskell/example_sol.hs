-- example_sol.hs

-- returns the product of a list
-- e.g. myproduct [1,2,3] = 6
myproduct :: [Int] -> Int
myproduct []     = 1
myproduct (n:ns) = n * myproduct ns

-- returns n! = 1 * 2 * ... * n
-- e.g. factorial 4 = 24
factorial :: Int -> Int
factorial n = myproduct [1..n]

-- returns the sum of a list
-- e.g. mysum [1,2,3] = 6
mysum :: [Int] -> Int
mysum []     = 0
mysum (n:ns) = n + mysum ns

-- returns the average of a list
-- e.g. average [1,2,3] = 2
-- average [] = undefined
-- average xs = mysum xs / mylength xs

-- returns the first element of a list
-- e.g. myhead [1,2,3] = 1
myhead :: [a] -> a
myhead []    = undefined
myhead (x:_) = x

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
ends []     = undefined
ends [x]    = [x,x]
ends (x:xs) = [x, mylast xs]

-- returns the length of a list
-- e.g. mylength [1,2,3] = 3
mylength :: [a] -> Int
mylength []     = 0
mylength (_:xs) = 1 + mylength xs

-- returns the reverse of a list
-- e.g. myreverse [1,2,3] = [3,2,1]
myreverse :: [a] -> [a]
myreverse []     = []
myreverse (x:xs) = myreverse xs ++ [x]

-- returns the lst with the last element removed
-- e.g. myinit [1,2,3] = [1,2]
myinit :: [a] -> [a]
myinit []     = undefined
myinit [x]    = []
myinit (x:xs) = x : myinit xs

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
pluralize s  = if last s == 's' 
               then s 
               else s ++ "s"

-- returns the sign of a number: "zero", "positive", or "negative"  
-- e.g. sign 0 = "zero", sign 1 = "positive", sign (-1) = "negative"
sign n | n == 0    = "zero"      -- guarded equation
       | n > 0     = "positive"
       | otherwise = "negative"

-- multiply 3 numbers
mult :: Int -> Int -> Int -> Int
mult a b c = a * b * c

-- fst: first element of a tuple (x, y)
-- snd: second element of a tuple (x, y)

-- take n lst
-- returns the first n elements of list lst

-- zip a b: combines two lists into a list of tuples

-- id x: identity function

-- lambda functions

-- operator sections

-- twice function

-- makeAdder

-- flip

-- map

-- filter

-- all, any

-- takeWhile

-- dropWhile

-- foldr (right fold)

-- function composition

--
-- insertion sort
--

-- What's the most general type signature for a function that sorts a list of
-- items?

-- Write a function insert x L that inserts x into the correct position in the
-- sorted list L. Assume L is a sorted list, and x is the same type as items on
-- L.

insert :: Ord a => a -> [a] -> [a]
insert a [] = [a]
insert a (x:xs) | a <= x    = a : x : xs
                | otherwise = x : (insert a xs)

-- Implement insertion_sort lst to that sorts lst using insertion sort (use the
-- insert function to help). Use basic recursion and no higher-order functions.
-- Also write the most general type signature.

-- insertion sort
insertion_sort :: Ord a => [a] -> [a]
insertion_sort []     = []
insertion_sort (x:xs) = insert x (insertion_sort xs)

-- Implement insertion_sort' that implements insertion sort using foldr and the
-- insert function from above.
insertion_sort' :: Ord a => [a] -> [a]
insertion_sort' lst = foldr insert [] lst

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
agree :: Eq b => (a -> b) -> (a -> b) -> a -> Bool
agree f g x = f x == g x

--
-- Implement quicksort
--
quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (pivot:rest) = (quicksort smalls) ++ [pivot] ++ (quicksort bigs)
                         where smalls = filter (<=pivot) rest
                               bigs   = filter (>pivot) rest

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
bools :: Int -> [String]
bools 0 = [[]]
bools n = map ('0':) bs ++ map ('1':) bs
        where bs = bools (n-1)


--
-- range function
--
-- range n returns the list of ints [0,1,...,n-1] (like Python's range
-- function). Implement it in a way that takes advantage of Haskell's lazy
-- evaluation.
--
range :: Int -> [Int]
range n = take n [0..]


--
-- Write a function called isPrime :: Int -> Bool that such that isPrime n
-- returns True if n is a prime, and False otherwise.
--

-- idea: if all the numbers from 2 up to and including the square root of n
-- *don't* divide evenly into n, then n must be a prime
isPrime :: Int -> Bool
isPrime n = n > 1 && all nonDivisor candidates
            where nonDivisor d = n `mod` d /= 0
                  leqSquare d = d * d <= n
                  candidates = takeWhile leqSquare [2 ..]

-- Define primes to be infinite (!) list of all primes [2, 3, 5, 7, 11, ...]
primes = filter isPrime [2..]

-- firstNprimes n returns a list of the first n prime numbers
firstNprimes n = take n primes

-- primessLessThan n returns a list of all primes less than n
primesLessThan n = takeWhile (<n) primes

-- nthPrime n returns the nth prime, e.g. if n is 1 then 2 is returned; if n is
-- 2 then 3 is returned, ...
nthPrime n = primes !! (n - 1)
