---
tags: ["#haskell"]
---

> The title of this chapter could be good name for a Haskell talk show.

This chapter discusses three general patterns for processing data in a functional way.

## Monoids
In mathematics, a **monoid** is a kind of algebraic structure defined as follows.

Let $S$ by a non-empty set, and let $\circ$ be a **binary operation** that maps from $S \times S \rightarrow S$. $S$ and $\circ$ form a **monoid** if they satisfy these two rules:
- **Associativity**: For all $a$, $b$, and $c$ in $S$, the equation $(a \circ b) \circ c = a \circ (b \circ c)$ holds.
- **Identity**: There exists an element $e$ in $S$ such that for every element $a$ in $S$, the equations $e \circ a = a$ and $a \circ e = a$ hold.

For example:
- The set of integers $Z$ and the operation $+$ form a monoid. $+$ is associative, and $0$ is the identity element.
- Similarly, the set of integers $Z$ and the operation $*$ form a monoid. $*$ is associative, and $1$ is the identity element.
- The set of all strings in the Python programming language combined with string concatenation is a monoid. Python string concatenation is associative because $(s+t)+u=s+(t+u)$ for all strings $s$, $t$, and $u$. The empty string, "", is the identity element.

The standard Haskell class `Monoid` describes the idea of a monoid in Haskell:

```haskell
class Monoid a where
   mempty :: a
   mappend :: a -> a -> a
   mconcat :: [a] -> a
   mconcat = foldr mappend mempty
```

The value `mempty` is the identity element for the monoid. The function `mappend` is the binary function.

`mconcat` is a convenience function that is easily definable as shown. For example, `mconcat [x,y,z]` is the same as ``x `mappend` (y `mappend` (z `mappend` mempty))``.

The `Monoid` class *cannot* enforce the associativity rule, and it is up to the programmer to ensure these laws hold:
- ``mempty `mappend` x  = x``
- ``x `mappend` mappend = x``
- ``x `mappend` (y `mappend` z) = (x `mappend` y) `mappend` z``

An example of a Haskell monoid is lists. They are already defined in Haskell as a monoid like this:

```haskell
instance Monoid [a] where
	-- mempty :: [a]
	mempty = []

	-- mappend :: [a] -> [a] -> [a]
	mappend = (++)
```

For example:

```haskell
> mappend "cat" "dog"
"catdog"
> mappend "cat" mempty
"cat"
> mconcat ["cat","dog","mouse"]
"catdogmouse"
```

Another example of a Haskell monoid is `Maybe a`:

```haskell
class Monoid a => Monoid (Maybe a) where
	-- mempty :: Maybe a
	mempty = Nothing

	-- mappend :: Maybe a -> Maybe a -> Maybe a
	Nothing `mappend` my       = my
    mx      `mappend` Nothing  = mx
    Just x  `mappend` Just y   = Just (x `mappend` y)
```

For example:

```haskell
> Just "cat" `mappend` Just "dog"
Just "catdog"
> Just "cat" `mappend` Nothing
Just "cat"
> mconcat [Just "cat",Just "dog"]
Just "catdog"
> mconcat [Just "cat",Nothing,Just "dog"]
Just "catdog"
```

The value of the `Monoid` class is that it is extremely general, and works with many common types. For instance, this `mtimes` functions is quite general:

```haskell
-- appends a monoid value to itself n-1 times
mtimes :: Monoid a => Int -> a -> a
mtimes 0 _ = mempty
mtimes n m = m `mappend` mtimes (n-1) m
```

```haskell
> mtimes 5 "cat"
"catcatcatcatcat"
> mtimes 5 [1,2,3]
[1,2,3,1,2,3,1,2,3,1,2,3,1,2,3]
> mtimes 5 Just "stop it"
Just "stop itstop itstop itstop itstop it"
```

## Foldables
One of the applications of a monoid is specifying the `fold` function:

```haskell
fold :: Monoid a => [a] -> a
fold []     = mempty
fold (x:xs) = x `mappend` fold xs
```

This says that folding an empty list returns `mempty`, otherwise for a non-empty list the first element of the list is `mappend`-ed to the fold of the rest of the list. For example, `fold [x,y,z]` evaluates to the same as this:

```haskell
x `mappend` (y `mappend` (z `mappend` mempty))
```

Note that `mconcat [x,y,z]` gives the same result.

One limitation of `fold`-like functions is that they only fold lists. But we might want to fold other data structures. For example, here if a fold on a tree:

```haskell
data Tree a = Leaf a | Node (Tree a) (Tree a)
         deriving Show

fold :: Monoid a => Tree a -> a
fold (Leaf x)   = x
fold (Node l r) = fold l `mappend` fold r
```

The `Foldable` class generalizes (in `Data.Foldable`) this idea to work with any data structure:

```haskell
class Foldable t where
  fold :: Monoid a => t a -> a
  foldMap :: Monoid b => (a -> b) -> t a -> b
  foldr :: (a -> b -> b) -> b -> t a -> b
  foldl :: (a -> b -> a) -> a -> t b -> a
  -- plus a few more helper functions and implementations
```

Here, `t` is the type of the data structure being folded, e.g. a list or a tree. 

The `foldMap` function is a like `fold`, except it takes an extra function that is applied to each element before it is `mapped`-ed to the other elements. In practice, to implement an instance of `Foldable` you only need to implement `foldMap` or `foldr`.

`Foldable` lets you implement some very general-purpose functions. For example, the `Foldable` class includes `sum` and `length`, and so we can write this function:

```haskell
average :: Foldable t => t Int -> Int
average ns = sum ns `div` length ns
```

Here `t` is  the type of the container data structure, such as a list or tree.

The textbook walks through more details of `Foldable`, but we won't cover any more details here.

## Traversables
Traversables are a generalization of the `map` function, and they involve applicative functors. We won't discuss them in this course.
