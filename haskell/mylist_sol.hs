-- mylist.hs

data List a = Nil | Cons a (List a)
    deriving (Eq, Show)

lst1 = Cons 5 (Cons 2 (Cons 6 Nil))
lst2 = Cons "cat" (Cons "dog" (Cons "bird" (Cons "cow" Nil)))

-- get the first element of a list
first :: List a -> a24tennis
first Nil        = error "first: empty list"
first (Cons x _) = x

-- get the rest of a mylist
rest :: List a -> List a
rest Nil         = Nil  -- or error if you prefer
rest (Cons _ xs) = xs

-- get the length of a mylist
len :: List a -> Int
len Nil         = 0
len (Cons _ xs) = 1 + len xs 

-- convert a regular Haskell list to a mylist
to_mylist :: [a] -> List a
to_mylist = foldr Cons Nil

-- convert a mylist to a regular Haskell list (using recursion)
to_hlist :: List a -> [a]
to_hlist Nil = []
to_hlist (Cons x xs) = x : (to_hlist xs)

-- fold right for a mylist
foldright :: (a -> b -> b) -> b -> (List a) -> b
foldright _  init Nil         = init
foldright op init (Cons x xs) = x `op` (foldright op init xs)

-- convert a mylist to a regular Haskell list (using fold right)
to_hlist' :: List a -> [a]
to_hlist' = foldright (:) []
