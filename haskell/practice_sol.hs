-- practice_sol.hs
--
-- Solutions to practice.hs, for the CMPT 383 Haskell quiz.
--
-- These solutions stick to the basic Haskell features used in the notes and in
-- example.hs. Many problems have more than one good answer; if yours is
-- different, test it in GHCi and compare it against the examples given.
--
-- Load this file in GHCi with:
--
--   > :load practice_sol.hs
--

---------------------------------------------------------------------------
-- Part 1: Recursion on lists
---------------------------------------------------------------------------

-- 1. returns the largest element of a list; the maximum of an empty list is
-- undefined. Don't use the standard maximum or max functions.
-- e.g. mymaximum [3,8,2,5] = 8
mymaximum :: Ord a => [a] -> a
mymaximum []     = undefined
mymaximum [x]    = x
mymaximum (x:xs) = if x > m then x else m
                   where m = mymaximum xs

-- 2. returns the number of times x appears in a list
-- e.g. count 'a' "banana" = 3, count 5 [1,2,3] = 0
count :: Eq a => a -> [a] -> Int
count _ []     = 0
count x (y:ys) | x == y    = 1 + count x ys
               | otherwise = count x ys

-- 3. returns True if x is in the list, and False otherwise. Don't use the
-- standard elem function.
-- e.g. myelem 3 [1,2,3] = True, myelem 'z' "cat" = False
myelem :: Eq a => a -> [a] -> Bool
myelem _ []     = False
myelem x (y:ys) = x == y || myelem x ys

-- 4. your own version of take: returns the first n elements of a list. If n is
-- bigger than the length of the list, the whole list is returned.
-- e.g. mytake 2 [5,6,7] = [5,6], mytake 10 "hi" = "hi"
mytake :: Int -> [a] -> [a]
mytake _ []     = []
mytake n (x:xs) | n <= 0    = []
                | otherwise = x : mytake (n - 1) xs

-- 5. your own version of zip
-- e.g. myzip [1,2,3] "ab" = [(1,'a'),(2,'b')]
myzip :: [a] -> [b] -> [(a, b)]
myzip [] _          = []
myzip _ []          = []
myzip (x:xs) (y:ys) = (x, y) : myzip xs ys

-- 6. returns every other element of a list, starting with the first
-- e.g. everyOther [1,2,3,4,5] = [1,3,5], everyOther "abcdef" = "ace"
everyOther :: [a] -> [a]
everyOther []       = []
everyOther [x]      = [x]
everyOther (x:_:xs) = x : everyOther xs

-- 7. your own version of ++, i.e. myappend xs ys = xs ++ ys. Don't use ++.
-- e.g. myappend [1,2] [3,4,5] = [1,2,3,4,5]
myappend :: [a] -> [a] -> [a]
myappend []     ys = ys
myappend (x:xs) ys = x : myappend xs ys

-- 8. returns True if a list is the same forwards and backwards
-- e.g. isPalindrome "racecar" = True, isPalindrome [1,2] = False
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = xs == reverse xs

-- 9. swaps the first and last elements of a list. Lists with 0 or 1 elements
-- are returned unchanged. Hint: middle from example.hs might help.
-- e.g. swapEnds [1,2,3,4] = [4,2,3,1], swapEnds "a" = "a"
swapEnds :: [a] -> [a]
swapEnds []  = []
swapEnds [x] = [x]
swapEnds xs  = [last xs] ++ middle xs ++ [head xs]

-- middle, as in example.hs
middle :: [a] -> [a]
middle []     = []
middle (_:xs) = init xs

---------------------------------------------------------------------------
-- Part 2: Guards, if-then-else, and pattern matching
---------------------------------------------------------------------------

-- 10. fizzbuzz n returns "FizzBuzz" if n is divisible by both 3 and 5, "Fizz"
-- if it's divisible by just 3, "Buzz" if it's divisible by just 5, and
-- otherwise n as a string (use show). Use guarded equations.
-- e.g. fizzbuzz 9 = "Fizz", fizzbuzz 30 = "FizzBuzz", fizzbuzz 7 = "7"
fizzbuzz :: Int -> String
fizzbuzz n | n `mod` 15 == 0 = "FizzBuzz"
           | n `mod` 3 == 0  = "Fizz"
           | n `mod` 5 == 0  = "Buzz"
           | otherwise       = show n

-- 11. the opposite of pluralize from example.hs: if the string ends with 's',
-- remove that 's'; otherwise return it unchanged. The singular of the empty
-- string is the empty string.
-- e.g. singularize "cats" = "cat", singularize "dog" = "dog"
singularize :: String -> String
singularize "" = ""
singularize s  = if last s == 's'
                 then init s
                 else s

-- 12. your own version of the || operator, similar to myand in example.hs. Use
-- pattern matching, and only *two* equations.
myor :: Bool -> Bool -> Bool
myor False False = False
myor _     _     = True

-- 13. clamp lo hi x returns x if it's in the range lo to hi (inclusive);
-- otherwise it returns lo if x is too small, or hi if x is too big. Use
-- guarded equations, and give the most general type signature.
-- e.g. clamp 0 10 5 = 5, clamp 0 10 (-3) = 0, clamp 0 10 99 = 10
clamp :: Ord a => a -> a -> a -> a
clamp lo hi x | x < lo    = lo
              | x > hi    = hi
              | otherwise = x

---------------------------------------------------------------------------
-- Part 3: Lambdas, sections, and higher-order functions
---------------------------------------------------------------------------

-- 14. double and isNegative are written with lambdas. Rewrite them as double'
-- and isNegative' using operator sections instead.
double :: Int -> Int
double = \x -> 2 * x

isNegative :: Int -> Bool
isNegative = \x -> x < 0

double' :: Int -> Int
double' = (2 *)       -- (* 2) also works

isNegative' :: Int -> Bool
isNegative' = (< 0)

-- 15. thrice f x applies f to x three times, i.e. thrice f x = f (f (f x)).
-- Write it using function composition, like twice in example.hs, and give
-- its most general type.
-- e.g. thrice (+1) 0 = 3, thrice tail "haskell" = "kell"
thrice :: (a -> a) -> a -> a
thrice f = f . f . f

-- 16. makeMultiplier n returns a function that multiplies its input by n
-- e.g. (makeMultiplier 3) 5 = 15, map (makeMultiplier 10) [1,2,3] = [10,20,30]
makeMultiplier :: Int -> (Int -> Int)
makeMultiplier n = (* n)

-- 17. your own version of filter, using plain recursion
-- e.g. myfilter even [1,2,3,4] = [2,4]
myfilter :: (a -> Bool) -> [a] -> [a]
myfilter _ []     = []
myfilter p (x:xs) | p x       = x : myfilter p xs
                  | otherwise = myfilter p xs

-- 18. your own versions of all and any, using plain recursion
-- e.g. myall even [2,4,6] = True, myany odd [2,4,6] = False
myall :: (a -> Bool) -> [a] -> Bool
myall _ []     = True
myall p (x:xs) = p x && myall p xs

myany :: (a -> Bool) -> [a] -> Bool
myany _ []     = False
myany p (x:xs) = p x || myany p xs

-- 19. countIf p lst returns how many elements of lst satisfy p. Use filter and
-- length (no explicit recursion).
-- e.g. countIf even [1,2,3,4,6] = 3
type Predicate a = a -> Bool

countIf :: Predicate a -> [a] -> Int
countIf p lst = length (filter p lst)

-- 20. Implement each of these using foldr (no explicit recursion):
--   mysum' xs     -- same as mysum
--   mylength' xs  -- same as mylength
--   mymap' f xs   -- same as map f xs
--   myreverse' xs -- same as reverse xs
mysum' :: Num a => [a] -> a
mysum' xs = foldr (+) 0 xs

mylength' :: [a] -> Int
mylength' xs = foldr (\_ acc -> 1 + acc) 0 xs

mymap' :: (a -> b) -> [a] -> [b]
mymap' f xs = foldr (\x acc -> f x : acc) [] xs

myreverse' :: [a] -> [a]
myreverse' xs = foldr (\x acc -> acc ++ [x]) [] xs

-- 21. Write these as one-line *point-free* functions using composition (.):
--
--   countEvens lst returns how many even numbers are in lst
--   e.g. countEvens [1,2,3,4,6] = 3
--
--   countLongWords lst returns how many strings in lst have more than 3
--   characters
--   e.g. countLongWords ["a","haskell","is","cool"] = 2
--
--   sumDoubledEvens lst doubles each even number in lst and returns the sum
--   e.g. sumDoubledEvens [1,2,3,4] = 12
countEvens :: [Int] -> Int
countEvens = length . filter even

countLongWords :: [String] -> Int
countLongWords = length . filter ((> 3) . length)

sumDoubledEvens :: [Int] -> Int
sumDoubledEvens = sum . map (* 2) . filter even

---------------------------------------------------------------------------
-- Part 4: Sorting
---------------------------------------------------------------------------

-- 22. returns True if a list is in ascending order, and False otherwise.
-- Include the most general type signature.
-- e.g. isSorted [1,2,2,5] = True, isSorted "cab" = False
isSorted :: Ord a => [a] -> Bool
isSorted []       = True
isSorted [_]      = True
isSorted (x:y:ys) = x <= y && isSorted (y:ys)

-- 23. merge two sorted lists into one sorted list
-- e.g. merge [1,4,7] [2,3,9] = [1,2,3,4,7,9]
merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys) | x <= y    = x : merge xs (y:ys)
                    | otherwise = y : merge (x:xs) ys

-- 24. Implement mergesort using merge. Split the list in half using take,
-- drop, and length.
-- e.g. mergesort [5,2,8,1,9] = [1,2,5,8,9]
mergesort :: Ord a => [a] -> [a]
mergesort []  = []
mergesort [x] = [x]
mergesort xs  = merge (mergesort left) (mergesort right)
                where half  = length xs `div` 2
                      left  = take half xs
                      right = drop half xs

-- 25. Modify quicksort from example.hs so that it sorts in *descending* order
-- e.g. quicksortDesc [3,1,4,1,5] = [5,4,3,1,1]
quicksortDesc :: Ord a => [a] -> [a]
quicksortDesc []           = []
quicksortDesc (pivot:rest) = quicksortDesc bigs ++ [pivot] ++ quicksortDesc smalls
                             where smalls = filter (<= pivot) rest
                                   bigs   = filter (> pivot)  rest

---------------------------------------------------------------------------
-- Part 5: Lazy evaluation and infinite lists
---------------------------------------------------------------------------

-- 26. Define evens to be the infinite list [0,2,4,6,...] using filter. Then
-- write firstNEvens n, which returns the first n even numbers.
-- e.g. firstNEvens 4 = [0,2,4,6]
evens :: [Int]
evens = filter even [0..]

firstNEvens :: Int -> [Int]
firstNEvens n = take n evens

-- 27. squaresLessThan n returns all the perfect squares 1, 4, 9, ... that are
-- less than n. Use an infinite list.
-- e.g. squaresLessThan 50 = [1,4,9,16,25,36,49]
squaresLessThan :: Int -> [Int]
squaresLessThan n = takeWhile (< n) (map (^ 2) [1..])

-- 28. Define powersOf2 to be the infinite list [1,2,4,8,16,...]
-- e.g. take 5 powersOf2 = [1,2,4,8,16]
powersOf2 :: [Integer]
powersOf2 = map (2 ^) [0..]

-- 29. Similar to bools/bits in example.hs: ternary n returns all strings of
-- length n made from the characters '0', '1', and '2', in order.
-- e.g. ternary 2 = ["00","01","02","10","11","12","20","21","22"]
--      length (ternary 5) = 243
ternary :: Int -> [String]
ternary 0 = [[]]
ternary n = map ('0':) ts ++ map ('1':) ts ++ map ('2':) ts
            where ts = ternary (n - 1)

-- 30. divisors n returns all the positive numbers less than n that divide
-- evenly into n. A number is *perfect* if it equals the sum of its divisors.
-- Write isPerfect n, and then define perfects to be the infinite list of all
-- perfect numbers.
-- e.g. divisors 12 = [1,2,3,4,6], isPerfect 28 = True, take 3 perfects =
-- [6,28,496]
divisors :: Int -> [Int]
divisors n = filter (\d -> n `mod` d == 0) [1 .. n - 1]

isPerfect :: Int -> Bool
isPerfect n = n > 0 && sum (divisors n) == n

perfects :: [Int]
perfects = filter isPerfect [1..]

-- 31. Using isPrime and primes from example.hs (copied below), write goldbach
-- n, which returns the first pair of primes (p, q) with p <= q and p + q == n.
-- Assume n is an even number greater than 2.
-- e.g. goldbach 28 = (5,23), goldbach 4 = (2,2)
isPrime :: Int -> Bool
isPrime n = n > 1 && all nonDivisor candidates
            where nonDivisor d = n `mod` d /= 0
                  leqSquare d  = d * d <= n
                  candidates   = takeWhile leqSquare [2..]

primes :: [Int]
primes = filter isPrime [2..]

goldbach :: Int -> (Int, Int)
goldbach n = head (filter (\(_, q) -> isPrime q) pairs)
             where pairs = map (\p -> (p, n - p)) (takeWhile (<= n `div` 2) primes)

---------------------------------------------------------------------------
-- Part 6: Data types and Maybe
---------------------------------------------------------------------------

-- 32. Declare a data type Direction with constructors North, East, South, and
-- West, deriving Eq and Show. Write turnRight (North -> East -> South -> West
-- -> North) and turnLeft. Then write opposite *without* pattern matching,
-- using turnRight and composition.
-- e.g. turnRight West = North, turnLeft North = West, opposite East = West
data Direction = North | East | South | West
  deriving (Eq, Show)

turnRight :: Direction -> Direction
turnRight North = East
turnRight East  = South
turnRight South = West
turnRight West  = North

turnLeft :: Direction -> Direction
turnLeft North = West
turnLeft West  = South
turnLeft South = East
turnLeft East  = North

opposite :: Direction -> Direction
opposite = turnRight . turnRight

-- 33. Using the Shape type from example.hs (copied below), write perimeter,
-- and totalArea, which returns the sum of the areas of a list of shapes.
-- e.g. perimeter (Rect 2 3) = 10.0, totalArea [Rect 2 3, Rect 1 1] = 7.0
data Shape = Circle Float | Rect Float Float
  deriving Show

area :: Shape -> Float
area (Circle r) = pi * r ^ 2
area (Rect w h) = w * h

perimeter :: Shape -> Float
perimeter (Circle r) = 2 * pi * r
perimeter (Rect w h) = 2 * (w + h)

totalArea :: [Shape] -> Float
totalArea shapes = sum (map area shapes)

-- 34. safeLast returns Nothing for an empty list, and Just the last element
-- otherwise.
-- e.g. safeLast [1,2,3] = Just 3, safeLast "" = Nothing
safeLast :: [a] -> Maybe a
safeLast []  = Nothing
safeLast [x] = Just x
safeLast (_:xs) = safeLast xs

-- 35. safeDiv m n returns Nothing if n is 0, and Just (m `div` n) otherwise
-- e.g. safeDiv 7 2 = Just 3, safeDiv 7 0 = Nothing
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv m n = Just (m `div` n)

-- 36. sumMaybes adds up all the Just values in a list, ignoring the Nothings
-- e.g. sumMaybes [Just 3, Nothing, Just 4] = 7, sumMaybes [] = 0
sumMaybes :: [Maybe Int] -> Int
sumMaybes []             = 0
sumMaybes (Nothing : xs) = sumMaybes xs
sumMaybes (Just n : xs)  = n + sumMaybes xs

---------------------------------------------------------------------------
-- Part 7: No coding: predict, explain, and work out types
---------------------------------------------------------------------------

-- 37. Without running GHCi, work out what each expression evaluates to:
--
--   a. map (* 2) (filter odd [1..10])
--   b. takeWhile (< 10) (map (^ 2) [1..])
--   c. dropWhile even [2,4,5,6,8]
--   d. twice tail "haskell"         -- twice as defined in example.hs
--   e. zip "abc" [1..]
--   f. ((+ 1) . (* 2)) 5
--   g. foldr (-) 0 [1,2,3]
--
-- Answers:
--   a. [2,6,10,14,18]
--   b. [1,4,9]
--   c. [5,6,8]          -- dropWhile stops dropping at the first odd number
--   d. "skell"
--   e. [('a',1),('b',2),('c',3)]   -- zip stops at the shorter (finite) list
--   f. 11               -- (* 2) is applied first, then (+ 1)
--   g. 2                -- 1 - (2 - (3 - 0)) = 1 - (2 - 3) = 1 - (-1) = 2

-- 38. Give the most general type of each of the following. Work it out
-- yourself before checking with :type in GHCi.
--
--   a. (++)
--   b. \x -> [x]
--   c. map fst
--   d. zip
--   e. (True, "x", 'x')
--
-- Answers:
--   a. (++) :: [a] -> [a] -> [a]
--   b. \x -> [x] :: a -> [a]
--   c. map fst :: [(a, b)] -> [a]
--   d. zip :: [a] -> [b] -> [(a, b)]
--   e. (True, "x", 'x') :: (Bool, String, Char)  -- String is [Char]

-- 39. Explain what's wrong with each of these, and how to fix it:
--
--   a. mylength :: [a] -> Int
--      mylength []     = 0
--      mylength (x:xs) = 1 + mylength x
--
--   b. isEven :: Int -> Bool
--      isEven n = if n mod 2 == 0 then True
--
--   c. myinit :: [a] -> [a]
--      myinit []     = []
--      myinit (x:xs) = x : myinit xs
--
-- Answers:
--   a. The recursive call is on x (a single element), not on xs (the rest of
--      the list), so it's a type error. Fix: mylength (x:xs) = 1 + mylength xs.
--      (Better still, use _ instead of x, since x isn't used.)
--
--   b. Two problems. In Haskell, if-then-else must always have an else part,
--      since every expression must have a value. Also, mod is a regular
--      prefix function, so it must be written as mod n 2, or with backticks
--      as n `mod` 2. Fix: isEven n = n `mod` 2 == 0 (no if needed at all).
--
--   c. There's no case for a one-element list, so the recursion never drops
--      anything: myinit just copies the whole list. Fix: add the equation
--      myinit [x] = [] before the (x:xs) equation (and the empty list case
--      should arguably be undefined, as in example.hs).
