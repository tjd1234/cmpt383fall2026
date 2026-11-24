-- practice.hs
--
-- Practice problems for the CMPT 383 Haskell quiz. They are similar in style
-- to the problems in example.hs, so if you can do these you should be in good
-- shape.
--
-- Each function is stubbed out with "undefined" so this file loads in GHCi
-- right away. Replace each "undefined" with your own code, then reload and
-- test it against the examples in the comments:
--
--   > :load practice.hs
--   > :reload
--
-- Rules of the game:
--   - Stick to the basic Haskell features used in the notes and example.hs.
--   - Don't use a standard function that solves the problem for you (e.g.
--     don't use maximum to write mymaximum).
--   - Where it says "give the most general type signature", work it out
--     yourself first, then check it with :type in GHCi.
--   - Try these without AI! Working them out yourself is how you learn.
--
-- Solutions are in practice_sol.hs, but try each problem before looking.

---------------------------------------------------------------------------
-- Part 1: Recursion on lists
---------------------------------------------------------------------------

-- 1. returns the largest element of a list; the maximum of an empty list is
-- undefined. Don't use the standard maximum or max functions.
-- e.g. mymaximum [3,8,2,5] = 8
mymaximum :: Ord a => [a] -> a
mymaximum = undefined

-- 2. returns the number of times x appears in a list
-- e.g. count 'a' "banana" = 3, count 5 [1,2,3] = 0
count :: Eq a => a -> [a] -> Int
count = undefined

-- 3. returns True if x is in the list, and False otherwise. Don't use the
-- standard elem function.
-- e.g. myelem 3 [1,2,3] = True, myelem 'z' "cat" = False
myelem :: Eq a => a -> [a] -> Bool
myelem = undefined

-- 4. your own version of take: returns the first n elements of a list. If n is
-- bigger than the length of the list, the whole list is returned.
-- e.g. mytake 2 [5,6,7] = [5,6], mytake 10 "hi" = "hi"
mytake :: Int -> [a] -> [a]
mytake = undefined

-- 5. your own version of zip
-- e.g. myzip [1,2,3] "ab" = [(1,'a'),(2,'b')]
myzip :: [a] -> [b] -> [(a, b)]
myzip = undefined

-- 6. returns every other element of a list, starting with the first
-- e.g. everyOther [1,2,3,4,5] = [1,3,5], everyOther "abcdef" = "ace"
everyOther :: [a] -> [a]
everyOther = undefined

-- 7. your own version of ++, i.e. myappend xs ys = xs ++ ys. Don't use ++.
-- e.g. myappend [1,2] [3,4,5] = [1,2,3,4,5]
myappend :: [a] -> [a] -> [a]
myappend = undefined

-- 8. returns True if a list is the same forwards and backwards
-- e.g. isPalindrome "racecar" = True, isPalindrome [1,2] = False
isPalindrome :: Eq a => [a] -> Bool
isPalindrome = undefined

-- 9. swaps the first and last elements of a list. Lists with 0 or 1 elements
-- are returned unchanged. Hint: middle from example.hs might help.
-- e.g. swapEnds [1,2,3,4] = [4,2,3,1], swapEnds "a" = "a"
swapEnds :: [a] -> [a]
swapEnds = undefined

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
fizzbuzz = undefined

-- 11. the opposite of pluralize from example.hs: if the string ends with 's',
-- remove that 's'; otherwise return it unchanged. The singular of the empty
-- string is the empty string.
-- e.g. singularize "cats" = "cat", singularize "dog" = "dog"
singularize :: String -> String
singularize = undefined

-- 12. your own version of the || operator, similar to myand in example.hs. Use
-- pattern matching, and only *two* equations.
myor :: Bool -> Bool -> Bool
myor = undefined

-- 13. clamp lo hi x returns x if it's in the range lo to hi (inclusive);
-- otherwise it returns lo if x is too small, or hi if x is too big. Use
-- guarded equations, and give the most general type signature.
-- e.g. clamp 0 10 5 = 5, clamp 0 10 (-3) = 0, clamp 0 10 99 = 10

-- clamp :: ??
clamp lo hi x = undefined

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
double' = undefined

isNegative' :: Int -> Bool
isNegative' = undefined

-- 15. thrice f x applies f to x three times, i.e. thrice f x = f (f (f x)).
-- Write it using function composition, like twice in example.hs, and give
-- its most general type.
-- e.g. thrice (+1) 0 = 3, thrice tail "haskell" = "kell"

-- thrice :: ??
thrice f = undefined

-- 16. makeMultiplier n returns a function that multiplies its input by n
-- e.g. (makeMultiplier 3) 5 = 15, map (makeMultiplier 10) [1,2,3] = [10,20,30]
makeMultiplier :: Int -> (Int -> Int)
makeMultiplier = undefined

-- 17. your own version of filter, using plain recursion
-- e.g. myfilter even [1,2,3,4] = [2,4]
myfilter :: (a -> Bool) -> [a] -> [a]
myfilter = undefined

-- 18. your own versions of all and any, using plain recursion
-- e.g. myall even [2,4,6] = True, myany odd [2,4,6] = False
myall :: (a -> Bool) -> [a] -> Bool
myall = undefined

myany :: (a -> Bool) -> [a] -> Bool
myany = undefined

-- 19. countIf p lst returns how many elements of lst satisfy p. Use filter and
-- length (no explicit recursion).
-- e.g. countIf even [1,2,3,4,6] = 3
type Predicate a = a -> Bool

countIf :: Predicate a -> [a] -> Int
countIf = undefined

-- 20. Implement each of these using foldr (no explicit recursion):
--   mysum' xs     -- same as mysum
--   mylength' xs  -- same as mylength
--   mymap' f xs   -- same as map f xs
--   myreverse' xs -- same as reverse xs
mysum' :: Num a => [a] -> a
mysum' = undefined

mylength' :: [a] -> Int
mylength' = undefined

mymap' :: (a -> b) -> [a] -> [b]
mymap' = undefined

myreverse' :: [a] -> [a]
myreverse' = undefined

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
countEvens = undefined

countLongWords :: [String] -> Int
countLongWords = undefined

sumDoubledEvens :: [Int] -> Int
sumDoubledEvens = undefined

---------------------------------------------------------------------------
-- Part 4: Sorting
---------------------------------------------------------------------------

-- 22. returns True if a list is in ascending order, and False otherwise.
-- Include the most general type signature.
-- e.g. isSorted [1,2,2,5] = True, isSorted "cab" = False

-- isSorted :: ??
isSorted xs = undefined

-- 23. merge two sorted lists into one sorted list
-- e.g. merge [1,4,7] [2,3,9] = [1,2,3,4,7,9]
merge :: Ord a => [a] -> [a] -> [a]
merge = undefined

-- 24. Implement mergesort using merge. Split the list in half using take,
-- drop, and length.
-- e.g. mergesort [5,2,8,1,9] = [1,2,5,8,9]
mergesort :: Ord a => [a] -> [a]
mergesort = undefined

-- 25. Modify quicksort from example.hs so that it sorts in *descending* order
-- e.g. quicksortDesc [3,1,4,1,5] = [5,4,3,1,1]
quicksortDesc :: Ord a => [a] -> [a]
quicksortDesc = undefined

---------------------------------------------------------------------------
-- Part 5: Lazy evaluation and infinite lists
---------------------------------------------------------------------------

-- 26. Define evens to be the infinite list [0,2,4,6,...] using filter. Then
-- write firstNEvens n, which returns the first n even numbers.
-- e.g. firstNEvens 4 = [0,2,4,6]
evens :: [Int]
evens = undefined

firstNEvens :: Int -> [Int]
firstNEvens = undefined

-- 27. squaresLessThan n returns all the perfect squares 1, 4, 9, ... that are
-- less than n. Use an infinite list.
-- e.g. squaresLessThan 50 = [1,4,9,16,25,36,49]
squaresLessThan :: Int -> [Int]
squaresLessThan = undefined

-- 28. Define powersOf2 to be the infinite list [1,2,4,8,16,...]
-- e.g. take 5 powersOf2 = [1,2,4,8,16]
powersOf2 :: [Integer]
powersOf2 = undefined

-- 29. Similar to bools/bits in example.hs: ternary n returns all strings of
-- length n made from the characters '0', '1', and '2', in order.
-- e.g. ternary 2 = ["00","01","02","10","11","12","20","21","22"]
--      length (ternary 5) = 243
ternary :: Int -> [String]
ternary = undefined

-- 30. divisors n returns all the positive numbers less than n that divide
-- evenly into n. A number is *perfect* if it equals the sum of its divisors.
-- Write isPerfect n, and then define perfects to be the infinite list of all
-- perfect numbers.
-- e.g. divisors 12 = [1,2,3,4,6], isPerfect 28 = True, take 3 perfects =
-- [6,28,496]
divisors :: Int -> [Int]
divisors = undefined

isPerfect :: Int -> Bool
isPerfect = undefined

perfects :: [Int]
perfects = undefined

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
goldbach = undefined

---------------------------------------------------------------------------
-- Part 6: Data types and Maybe
---------------------------------------------------------------------------

-- 32. Declare a data type Direction with constructors North, East, South, and
-- West, deriving Eq and Show. Write turnRight (North -> East -> South -> West
-- -> North) and turnLeft. Then write opposite *without* pattern matching,
-- using turnRight and composition.
-- e.g. turnRight West = North, turnLeft North = West, opposite East = West
--
-- (Uncomment these lines once you've declared Direction.)

-- data Direction = ??

-- turnRight :: Direction -> Direction
-- turnRight = undefined

-- turnLeft :: Direction -> Direction
-- turnLeft = undefined

-- opposite :: Direction -> Direction
-- opposite = undefined

-- 33. Using the Shape type from example.hs (copied below), write perimeter,
-- and totalArea, which returns the sum of the areas of a list of shapes.
-- e.g. perimeter (Rect 2 3) = 10.0, totalArea [Rect 2 3, Rect 1 1] = 7.0
data Shape = Circle Float | Rect Float Float
  deriving Show

area :: Shape -> Float
area (Circle r) = pi * r ^ 2
area (Rect w h) = w * h

perimeter :: Shape -> Float
perimeter = undefined

totalArea :: [Shape] -> Float
totalArea = undefined

-- 34. safeLast returns Nothing for an empty list, and Just the last element
-- otherwise.
-- e.g. safeLast [1,2,3] = Just 3, safeLast "" = Nothing
safeLast :: [a] -> Maybe a
safeLast = undefined

-- 35. safeDiv m n returns Nothing if n is 0, and Just (m `div` n) otherwise
-- e.g. safeDiv 7 2 = Just 3, safeDiv 7 0 = Nothing
safeDiv :: Int -> Int -> Maybe Int
safeDiv = undefined

-- 36. sumMaybes adds up all the Just values in a list, ignoring the Nothings
-- e.g. sumMaybes [Just 3, Nothing, Just 4] = 7, sumMaybes [] = 0
sumMaybes :: [Maybe Int] -> Int
sumMaybes = undefined

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

-- 38. Give the most general type of each of the following. Work it out
-- yourself before checking with :type in GHCi.
--
--   a. (++)
--   b. \x -> [x]
--   c. map fst
--   d. zip
--   e. (True, "x", 'x')

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
