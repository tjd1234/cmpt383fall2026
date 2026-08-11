# Notes on Chapter 8: Declaring Types and Classes

Haskell has extensive support for types, and allows programmers to create new
types in a number of useful ways.

## Type declarations

A **type declaration** uses the `type` keyword, and creates a *synonym* for an
existing type. For example, the Haskell prelude has this type declaration:

```haskell
type String = [Char]
```

This says `String` is just another name for a list of characters. The types
`String` and `[Char]` can be used interchangeably.

> **Comparison** Type declarations like this are similar to `typedef` statements
> in C/C++.

Here's another example, this time using a type variable:

```haskell
type Predicate a = a -> Bool
```

Here, `a` is a type variable that can be any type. For instance, `Predicate Int`
is the type of a function that takes an `Int` and returns a `Bool`, e.g. a
function with the signature `Int -> Bool`.

Using `Predicate a` in a type signature can improve readability:

```haskell
remove_if :: Predicate a -> [a] -> [a]
remove_if p lst = filter (not . p) lst
```

```haskell
> remove_if even [1..10]
[1,3,5,7,9]
```

Note the use of composition on the expression `not . p`. This is equivalent to
the function application `not (p x)`, where `x` is any value of type `a`. Using
the composition operator `.` lets us write it in the briefer form `not . p`,
which can be read as "the negation of predicate `p`". Using composition in this
way is a common pattern in Haskell.

Finally, we note that type declarations using `type` *cannot* be *recursive*,
the type being defined with `type` cannot refer to itself. For example, this
type is *not* allowed:

```haskell
type Tree = (Int, [Tree]) -- Error! Recursion not allowed here
```

## Data declarations

**Data declarations** create completely new types, as opposed to just synonyms
for existing types. For example, the `Bool` type in the standard prelude is
defined like this:

```haskell
data Bool = True | False
```

This defines a new type named `Bool`, and says that it has exactly two values,
`True` and `False`. The `|` can be read "or", and so a `Bool` value is either
`True` or `False`.

> **Comparison** Data declarations in Haskell are similar to enumeration types
> in languages like C++ or Java, but with stronger type guarantees.

Here's a data declaration that might be useful for modeling a traffic light:

```haskell
data Light = Red | Yellow | Green
  deriving (Eq, Show)
```

The three values of `Light` are `Red`, `Yellow`, and `Green`. They are called
**constructors** for the type.

> **Careful** The term *constructor* is also used in object-oriented programming
> (OOP) for a method that creates a new object. While the idea is conceptually
> similar, i.e. both Haskell and OOP constructors create new values, the details
> are quite different. You should *not* think of Haskell data declarations as
> OOP.

Both the name of new data type and its constructors *must* start with capital
letters.

The line `deriving (Eq, Show)` tells Haskell to provide default `==`, `/=`, and
`show` functions for `Light`. `==` and `/=` test if `Light` values are equal or
not equal, and `show` converts `Light` values to strings, making them usable in
the interpreter:

```haskell
> Green
Green
> Green == Green
True
> Green /= Red
True
```

Here's a function that shows how the colors of a traffic light might change:

```haskell
change :: Light -> Light
change Red    = Green
change Yellow = Red
change Green  = Yellow
```

```haskell
> change Green
Yellow
> change Yellow
Red
> change Red
Green
> change2 = change . change
> change2 Red
Yellow
```

Constructors in a data declaration can also take inputs. For example:

```haskell
data Shape = Circle Float | Rect Float Float
    deriving Show
```

```haskell
> Circle 2.7
Circle 2.7
> Rect 8 2
Rect 8.0 2.0
```

`Circle` and `Rect` are constructor functions, e.g.:

```haskell
> :type Circle
Circle :: Float -> Shape
> :type Rect
Rect :: Float -> Float -> Shape
```

You can write functions to calculate the area and perimeter of shapes:

```haskell
area :: Shape -> Float
area (Circle r) = pi * r^2
area (Rect w h) = w * h

perimeter :: Shape -> Float
perimeter (Circle r) = 2 * pi * r
perimeter (Rect w h) = 2 * (w + h)
```

```haskell
> area (Circle 2.2)
15.205309
> area (Rect 3 4)
12.0
> perimeter (Rect 3 4)
14.0
```

> **Comparison** In an object-oriented programming language like C++ or Java,
> you might implement similar code by creating `Circle` and `Rect` classes that
> inherit from a `Shape` base class. Haskell is different: there is no
> inheritance happening here.

## Parameterized Data Declarations

Haskell also lets you create **parameterized data declarations** that take one
or more type variables. For example, the type `Maybe a` is this:

```haskell
data Maybe a = Nothing | Just a
```

`a` is any type, and `Maybe a` has two values: `Nothing`, and `Just a`. You
could think of `Maybe a` as a box that is either empty, or it contains a value
of type `a`. 

`Maybe` can be useful as a way to deal with errors. For example, the standard
Haskell `head` functions causes an error if you give it an empty list:

```haskell
> head []
```

Using `Maybe`, we can handle the empty list in a way that does not cause an
error. For instance:

```haskell
safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x
```

```haskell
> safeHead "apple"
Just 'a'
> safeHead ""
Nothing
```

`safeHead` *might* return a value of type `a`, or it might not. But it always
returns some value, and so it doesn't crash on `[]` like standard `head`.

```haskell
> safeHead []
Nothing
> head []
*** Exception: Prelude.head: empty list
```

The standard `minimum` function also crashes on an empty list:

```haskell
> minimum [8,2,5,1,0]
0
> minimum []
*** Exception: Prelude.minimum: empty list
```

So we could create a `safeMin` function like this:

```haskell
safeMin :: Ord a => [a] -> Maybe a
safeMin [] = Nothing
safeMin xs = Just (minimum xs)

> safeMin []
Nothing
> safeMin [1,8,0,2]
Just 0
```

`safeMin lst` *might* return a value that is the minimum of `lst`. If it's
empty, then `Nothing` is returned.

### Challenge: Safe Inversion

Write a function `safeInvert :: Double -> Maybe Double` that returns the inverse
of a number, except for 0 `Nothing` is returned:

```haskell
> safeInvert 4
Just 0.25
> safeInvert 0
Nothing
```

### Arithmetic with Maybe Numbers

Dealing with `Maybe` values can be tricky, and you need to write code that says
what to do in different cases.

For example, suppose you want to add two `Maybe Double`s together. One way to do
it is to return a `Double`:

```haskell
add1 :: Maybe Double -> Maybe Double -> Double
add1 Nothing  Nothing  = 0
add1 Nothing  (Just n) = n
add1 (Just n) Nothing  = n
add1 (Just m) (Just n) = m + n

> add1 (Just 2) (Just 4)
6.0
> add1 Nothing (Just 5)
5.0
> add1 Nothing Nothing
```

This treats `Nothing` as 0, which in some applications might be a reasonable
choice, since `Nothing` is indeed nothing.

But in other cases, it might make more sense for `Nothing` values to remain as
`Nothing`. To make that work you need to return a `Maybe Double`:

```haskell
add2 :: Maybe Double -> Maybe Double -> Maybe Double
add2 Nothing  Nothing  = Nothing
add2 Nothing  (Just n) = Nothing
add2 (Just n) Nothing  = Nothing
add2 (Just m) (Just n) = Just (m + n)

> add2 (Just 2) (Just 4)
Just 6.0
> add2 (Just 2) Nothing
Nothing
```

Whether `add1` or `add2` --- or some other add-like function --- is better
depends on the situation.

> The code for `add` and `add2` is repetitive and a bit tedious, i.e. it just
> lists all cases one by one. Haskell does provide a number of ways to write
> this sort of code more concisely, but we will not cover them here.

## Recursive types

Data declarations can be *recursive*. For example:

```haskell
data Nat = Zero | Succ Nat
    deriving (Eq, Show)
```

`Nat` is a standard mathematical definition of a natural number. A natural
number is either `Zero`, or the *successor* of a natural number. The values of
`Nat` are `Zero`, `Succ Zero`, `Succ (Succ Zero)`, ....  `Zero` is 0, `Succ
Zero` is 1, `Succ (Succ Zero)` is 2, etc.

The number of calls to `Succ` corresponds to the natural number, and so we can
convert `Nat`s to and from `Int`s:

```haskell
nat2int :: Nat -> Int
nat2int Zero     = 0
nat2int (Succ n) = 1 + nat2int n

int2nat :: Int -> Nat
int2nat 0 = Zero
int2nat n = Succ (int2nat (n-1))

> nat2int (Succ (Succ Zero))
2
> int2nat 5
Succ (Succ (Succ (Succ (Succ Zero))))
> nat2int (int2nat 5)
5
```

### Explain the bug: Nat successor

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
nat2int_bad :: Nat -> Int
nat2int_bad Zero = 0
nat2int_bad n    = 1 + nat2int_bad n
```

### The List Type

An interesting recursive type is `List a`:

```haskell
data List a = Nil | Cons a (List a)
```

This says that a list of type `a` is either empty (`Nil`), or a single value of
type `a` and another value of type `List a`. The constructors `Cons` is the
traditional name for a list value that contains both a value and reference to
the rest of a list.

> **Comparison** The name "Cons" comes from [LISP programming
> language](https://en.wikipedia.org/wiki/Lisp_(programming_language)). It was
> one of the first languages to make extensive used of linked lists, and it
> called the list nodes **cons cells**.

Here are some functions that operate on `List a`:

```haskell
first :: List a -> a
first Nil        = error "first: empty list"
first (Cons x _) = x

rest :: List a -> List a
rest Nil         = Nil
rest (Cons _ xs) = xs

len :: List a -> Int
len Nil         = 0
len (Cons _ xs) = 1 + len xs


> first (Cons 1 (Cons 2 (Cons 3 Nil)))
1
> rest (Cons 1 (Cons 2 (Cons 3 Nil)))
Cons 2 (Cons 3 Nil)
> len Nil
0
> len (Cons 1 (Cons 2 (Cons 3 Nil)))
3
```

The literal form of a `List a` is similar to the consed-out form of a regular
Haskell list. For example, `[1,2,3]` in consed-out form is `1 : (2 : (3 : []))`,
which is similar to `Cons 1 (Cons 2 (Cons 3 Nil))`. If we write `Cons` as an
operator,  then it becomes ``1 `Cons` (2 `Cons` (3 `Cons` Nil))``. Recalling how
`foldr` works, this observation shows how to convert regular Haskell list to a
`List a`:

```haskell
hlist2list :: [a] -> List a
hlist2list = foldr Cons Nil

> hlist2list [1,2,3]
Cons 1 (Cons 2 (Cons 3 Nil))
> hlist2list "apple"
Cons 'a' (Cons 'p' (Cons 'p' (Cons 'l' (Cons 'e' Nil))))
```

Since `List a` doesn't have a fold right function defined for it, we can write
one:

```haskell
foldright :: (a -> b -> b) -> b -> (List a) -> b
foldright _ init Nil          = init
foldright op init (Cons x xs) = x `op` (foldright op init xs)
```

We can convert a `List` to a regular Haskell list with recursion:

```haskell
list2hlist :: List a -> [a]
list2hlist Nil         = []
list2hlist (Cons x xs) = x : (list2hlist xs)
```

Or using `foldright`:

```haskell
list2hlist :: List a -> [a]
list2hlist = foldright (:) []
 
> list2hlist (Cons 'a' (Cons 'p' (Cons 'p' (Cons 'l' (Cons 'e' Nil)))))
"apple"
```

## Example: Tautology checker

The example given in the text shows how a data declaration can help make a
"little language", in this case for propositional logic. Many functions for
processing it mirror the structure the data declaration. [Here is the tautology
checker code](tautology.hs).

[tautology.hs](tautology.hs) gives a nice solution to the problem of generating
all bit strings of a given length:

```haskell
bools :: Int -> [String]
bools 0 = [[]]
bools n = map ('0':) bs ++ map ('1':) bs
        where bs = bools (n-1)

> bools 3
["000","001","010","011","100","101","110","111"]

> take 3 (bools 10)
["0000000000","0000000001","0000000010"]
```

It's a nice example of succinct piece of code that uses recursion and
higher-order functions to make a concise solution to a problem.

However, not all programmers like this style of programming. They argue that
such code is difficult to read and debug, especially for beginners. For
instance, it's not easy to trace the code by, say, adding print statements to
see what's happening.

### Explain the bug: Nat successor

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
bools_bug :: Int -> [String]
bools_bug 0 = [[]]
bools_bug n = map ("0":) n1bits ++ map ("1":) n1bits
        where n1bits = bools_bug (n-1)
```

The function is *intended* to return a list of all bit strings of length `n`,
e.g. `bools_bug 3` should return `["000", "001", "010", "011", "100", "101",
"110", "111"]`.

### Challenge: modified bit strings

Modify `bools2` below so that `bools2 0` returns the empty list `[]`, and for
all other values of `n` `bools2 n` returns the same result as `bools n`:

```haskell
bools2 :: Int -> [String]
bools2 0 = [[]]
bools2 n = map ('0':) bs ++ map ('1':) bs
         where bs = bools2 (n-1)
```

The type signature should stay the same.

## Example: Abstract Machine

See text.
