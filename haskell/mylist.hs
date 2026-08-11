-- mylist.hs

-- List a is a recursive data representing a list of values of type a
data List a = Nil | Cons a (List a)
    deriving (Eq, Show)

lst1 = Cons 5 (Cons 2 (Cons 6 Nil))
lst2 = Cons "cat" (Cons "dog" (Cons "bird" (Cons "cow" Nil)))

-- TODO 1: get the first element of a list
first :: List a -> a
first Nil        = error "first: Nil list"
first (Cons x _) = x

-- TODO 2: get the rest of a mylist
rest :: List a -> List a
rest Nil         = Nil
rest (Cons _ xs) = xs

-- TODO 3: get the length of a mylist
len :: List a -> Int
len Nil         = 0
len (Cons x xs) = 1 + len xs

-- TODO 4: convert a regular Haskell list to a mylist
to_List :: [a] -> List a
to_List = foldr Cons Nil

-- TODO 5: convert a mylist to a regular Haskell list (using recursion)
to_hlist :: List a -> [a]
to_hlist Nil         = []
to_hlist (Cons x xs) = x : (to_hlist xs)

-- TODO 6: fold right for a mylist
foldright :: (a -> b -> b) -> b -> List a -> b
foldright _  init Nil         = init
foldright op init (Cons x xs) = x `op` (foldright op init xs)

-- TODO 7: convert a mylist to a regular Haskell list (using fold right)
to_hlist' :: List a -> [a]
to_hlist' = foldright (:) []
