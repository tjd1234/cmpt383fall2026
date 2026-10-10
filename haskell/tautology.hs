import qualified Control.Applicative as E.g
-- Tautology checker example from chapter 8 of Programming in Haskell,
-- Graham Hutton, Cambridge University Press, 2016.

--
-- TJD: added some annotations
--

-- Propositions

data Prop = Const Bool
          | Var Char
          | Not Prop
          | And Prop Prop
          | Imply Prop Prop
    deriving (Show, Eq)

--
-- sample propositions for testing
--
p1 :: Prop -- A and not A 
p1 = And (Var 'A') (Not (Var 'A'))

p2 :: Prop -- (A and B) implies A
p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')

p3 :: Prop -- A implies (A and B)
p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))

p4 :: Prop -- (A and (A implies B)) implies B
p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')

-- Substitutions

--
-- The Assoc key val type represents an *association list*, which is a list of
-- key-value pairs. Finding, adding, and removing pairs is done using standard
-- list functions.
--
-- In many other languages, a *map* (e.g. dictionaries in Python) would be used
-- instead. While association lists are simple, they are inefficent compared to
-- maps, i.e. association lists are O(n) for finding, adding, and removing
-- pairs, while maps are O(1) for those operations.
--
-- Haskell does have similarly efficient data structures, e.g. check the
-- Data.Map module.
--

--
-- A substitution consists of a character representing a variable, and a boolean
-- value for that variable.
--
type Subst = Assoc Char Bool

type Assoc k v = [(k,v)]

find :: Eq k => k -> Assoc k v -> v
find k t = head [v | (k',v) <- t, k == k']

-- Tautology checker

--
-- Given a substitution list and a proposition, evaluate the proposition. The
-- variables in the proposition are replaced their corresponding boolean values
-- from the substitution list.
--
eval :: Subst -> Prop -> Bool
eval _ (Const b)   = b
eval s (Var x)     = find x s
eval s (Not p)     = not (eval s p)
eval s (And p q)   = eval s p && eval s q
eval s (Imply p q) = eval s p <= eval s q  -- <= means logical implication when used with Bools

--
-- Given a proposition, return the list of variables in the proposition.
--
vars :: Prop -> [Char]
vars (Const _)   = []
vars (Var x)     = [x]
vars (Not p)     = vars p
vars (And p q)   = vars p ++ vars q
vars (Imply p q) = vars p ++ vars q

--
-- Generate all lists of Bools of length n.
--
bools :: Int -> [[Bool]]
bools 0 = [[]]
bools n = map (False:) bss ++ map (True:) bss
          where bss = bools (n-1)

--
-- Remove duplicate values from a list.
--
rmdups :: Eq a => [a] -> [a]
rmdups []     = []
rmdups (x:xs) = x : filter (/= x) (rmdups xs)

--
-- Returns a list of all possible substitutions for the variables in the
-- proposition.
--
-- E.g.
-- > substs p2
-- [
--  [('A',False),('B',False)],
--  [('A',False),('B',True)],
--  [('A',True),('B',False)],
--  [('A',True),('B',True)]
-- ]
--
substs :: Prop -> [Subst]
substs p = map (zip vs) (bools (length vs))
           where vs = rmdups (vars p)

--
-- Generate all possible substitutions for the variables in the proposition and
-- check that the proposition is true for all of them.
--
-- `and lst` returns True if all elements of the list are True, and False
-- otherwise.
--
-- It runs in time O(2^n), where n is the number of variables in the
-- proposition, so is inefficient for propositions with many variables.
--
isTaut :: Prop -> Bool
isTaut p = and [eval s p | s <- substs p]
