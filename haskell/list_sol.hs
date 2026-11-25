-- list_sol.hs

data List a = Nil | Cons a (List a) 
    deriving (Show, Eq)

nums :: List Int
nums = Cons 3 (Cons 5 (Cons 2 (Cons 6 Nil)))

names :: List String
names = Cons "Bob" (Cons "Mei" (Cons "Di" (Cons "Effy" Nil)))

-- first lst
-- first lst returns the first element of a List
first :: List a -> a
first Nil        = undefined
first (Cons x _) = x

-- rest lst
-- rest lst returns the list without the first element
rest :: List a -> List a
rest Nil         = undefined
rest (Cons _ xs) = xs

-- len lst
-- len lst returns the length of a List
len :: List a -> Int
len Nil         = 0
len (Cons _ xs) = 1 + len xs

-- mysum lst
-- mysum lst returns the sum of a List of Ints
mysum :: List Int -> Int
mysum Nil         = 0
mysum (Cons x xs) = x + mysum xs

-- mymap f lst
-- mymap returns a new List with f applied to each element of lst
mymap :: (a -> b) -> List a -> List b
mymap _  Nil        = Nil
mymap f (Cons x xs) = Cons (f x) (mymap f xs)

-- toString lst
-- toString lst converts a List to a String in a simple way (could be improved)
toString :: Show a => List a -> String
toString Nil         = ""
toString (Cons x xs) = show x ++ " " ++ toString xs

-- toList lst
-- convert a List to a Haskell list
toList :: List a -> [a]
toList Nil         = []
toList (Cons x xs) = x : toList xs

-- fromList lst
-- convert a Haskell list to a List
fromList :: [a] -> List a
fromList []     = Nil
fromList (x:xs) = Cons x (fromList xs)

-- foldrList op init list
-- does a right fold on a List
foldrList :: (a -> b -> b) -> b -> List a -> b
foldrList _ init Nil          = init
foldrList op init (Cons x xs) = x `op` (foldrList op init xs)
