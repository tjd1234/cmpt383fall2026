-- demo.hs

-- import Data.List (sort)

-- -- equational definiton
-- middle :: [a] -> [a]
-- middle []     = []
-- middle [_]    = []
-- middle (_:xs) = reverse (tail (reverse xs))

-- pluralize :: String -> String
-- pluralize "" = ""
-- pluralize x  = x ++ (if last x == 's' 
--                      then "" 
--                      else "s")

-- -- guarded equations
-- sign n | n == 0    = "zero"
--        | n < 0     = "negative"
--        | otherwise = "positive"

-- coin :: Int -> String
-- coin 1  = "penny"
-- coin 5  = "nickel"
-- coin 10 = "dime"
-- coin 25 = "quarter"
-- coin _  = "unknown"

-- nand :: Bool -> Bool -> Bool
-- nand True True = False
-- nand _    _    = True 
-- nand False False = True
-- nand False True  = True
-- nand True  False = True
-- nand True  True  = False
-- truth table 

-- get_expr :: [String] -> String
-- get_expr [_,"+",_] = "addition"
-- get_expr [_,"-",_] = "subtraction"
-- get_expr _         = "unknown"

-- firsts :: [a] -> [b] -> (a, b)
-- firsts (x:_) (y:_) = (x, y)


-- twice f x = f (f x)

-- makeAdder :: Int -> (Int -> Int)
-- makeAdder n = (+) n

-- makeAdder' :: Int -> Int -> Int
-- makeAdder' n = (+) n

-- myfilter _ []     = []
-- myfilter p (x:xs) = if p x
--                     then x : (filter p xs)
--                     else filter p xs

-- mytakeWhile _ []     = []
-- mytakeWhile p (x:xs) = if p x
--                        then x:(mytakeWhile p xs)
--                        else []

-- mysum :: Num a => [a] -> a
-- mysum = foldr (+) 0  -- pointfree style
-- mysum []     = 0
-- mysum (x:xs) = x + mysum xs

-- myprod :: Num a => [a] -> a
-- myprod = foldr (*) 1
-- myprod []     = 1
-- myprod (x:xs) = x * myprod xs

-- mymap :: (a -> b) -> [a] -> [b]
-- mymap f xs = foldr op [] xs
--              where op x accum = (f x) : accum

-- myreverse :: [a] -> [a]
-- myreverse xs = foldr op [] xs
--                where op x accum = accum ++ [x]

-- myfilter :: (a -> Bool) -> [a] -> [a]
-- myfilter p xs = foldr op [] xs
--                 where op x accum = if p x
--                                    then x : accum
--                                    else accum

-- f n = n^2
-- g n = 3*n+1
-- h = f . g

-- twice :: (a -> a) -> a -> a
-- -- twice f x = f (f x)
-- -- twice f x = (f . f) x
-- twice f = f . f

-- This shows a sequence of functions that can be applied to a list by calling
-- sumSquaresEven lst. The functions are applied from right to left, i.e. first
-- filter even, then map (^2), then sum.
--
-- In general, a composed expresison like h . g . f means apply f, then g, then
-- h.
-- sumSquaresEven = sum . map (^2) . filter even

-- do f, then g, then h
-- h . g . f

-- type Predicate a = a -> Bool

-- remove_if :: Predicate a -> [a] -> [a]
-- remove_if p lst = filter (not . p) lst

-- data MyBool = True | False
-- my_and :: MyBool -> MyBool -> MyBool
-- my_and False False = False
-- my_and False True = False
-- my_and True False = False
-- my_and True True = False

data Light = Red | Yellow | Green
  deriving (Eq, Show)

change :: Light -> Light
change Red    = Green
change Yellow = Red
change Green  = Yellow

-- sum type
data Shape = Circle Float | Rect Float Float
    deriving Show

area :: Shape -> Float
area (Circle r) = pi * r^2
area (Rect w h) = w * h

perimeter :: Shape -> Float
perimeter (Circle r) = 2 * pi * r
perimeter (Rect w h) = 2 * (w + h)

--
-- The Maybe type is pre-defined in the Haskell prelude. It is used to represent
-- optional values, which can be useful in error checking.
--
-- data Maybe a = Nothing | Just a
--

safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x 

-- add :: Maybe Double -> Maybe Double -> Double
-- add Nothing  Nothing  = 0
-- add Nothing  (Just n) = n
-- add (Just n) Nothing  = n
-- add (Just m) (Just n) = m + n

add :: Maybe Double -> Maybe Double -> Maybe Double
add Nothing  Nothing  = Nothing
add Nothing  (Just n) = Nothing
add (Just n) Nothing  = Nothing
add (Just m) (Just n) = Just (m + n)


-- Nat is a recursive data type representing the natural numbers 0, 1, 2, ...
data Nat = Zero | Succ Nat
    deriving (Eq, Show)

-- convert a Nat to an int
nat2int :: Nat -> Int
nat2int Zero     = 0
nat2int (Succ n) = 1 + nat2int n

-- convert an int to a Nat
int2nat :: Int -> Nat
int2nat 0 = Zero
int2nat n = Succ (int2nat (n-1))
