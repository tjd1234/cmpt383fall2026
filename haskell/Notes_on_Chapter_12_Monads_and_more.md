# Notes on Chapter 12 Monads and more

Chapter 12 discusses a number of useful functional programming patterns:
*functors*, *applicatives*, and *monads*. They can be overwhelming the first
time you learn about them, and so in these notes we will touch upon just a few
illustrative examples and ideas. For more details, see chapter 12 of the
textbook.

## ($): the Application Operator

The expression `f x` is an example of **function application**: the function `f`
is applied to the value `x`, and a result is returned.

In Haskell, all functions take a single argument and return a single value.

`($)` is the **function application** operator, and using it you can write `($)
f x` instead of just `f x`. You could also use it in infix style, `f $ x`. The
three expression `f x`, `($) f x`, and `f $ x` are all different ways of
applying `f` to `x`.

The type signature of `($)` is:

```haskell
($) :: (a -> b) -> a -> b
```

The main practical use of `($)` is to get rid of brackets. The **precedence
level** of `($)` is *lower* than regular application without `($)`, and this can
make some expressions more concise. For example:

```haskell
> head (tail ["cat","dog"])
"dog"
```

The brackets are necessary. If you leave them out you get an error:

```haskell
> head tail ["cat","dog"]
... error ...
```

But using the `($)` operator lets you skip the brackets:

```haskell
> head $ tail ["cat","dog"]
"dog"
```

`($)` has lower precedence than regular application, and so `tail ["cat","dog"]`
is evaluated first. This gives `head $ ["dog"]`, which returns `'d'`.

You never *need* to use this trick, but many Haskell programmers prefer it to
writing extra brackets.

## More About map

The standard `map` function can be thought of in a couple of different ways.

### map as Generalized Application

Let's compare the type signature of `($)` to the type signature of the standard
`map` function:

```haskell
map :: (a -> b) -> [a] -> [b]

($) :: (a -> b) -> a   -> b
```

This suggests we could think of `map` as a generalization of function
application: regular application applies a function to a *single* value and
returns a *single* output, while `map` applies a single function to a *list* of
values and returns a *list* of result.

### map as a Function Constructor

Another way to think about `map` is it that takes a *function* of type `a -> b`
as input and returns a *function* of type `[a] -> [b]` as output:

```haskell
map :: (a -> b) -> [a] -> [b]
```

This perspective lets us define some useful functions. For example:

```haskell
squareAll = map (^2)

> squareAll [2,1,4]
[4,1,16]

heads = map head

> heads ["cat","dog","bird"]
"cdb"

plurals = map (++"s")

> plurals ["cat","dog","bird"]
["cats","dogs","birds"]
```

### Functors: Generalizing map

Many data structures other than lists that can contain elements. For instance,
trees, matrices, and stacks all contain values. We'll refer to such data
structures as **containers**.

The standard `map` function applies a function to every element of a *list*. We
could also apply a function to every element of some other kind of container.
For each different container, we can define a map-like function that applies a
function to every element it contains.

To support the creation of such map-like functions, Haskell provides the
`Functor` type class:

```haskell
class Functor f where
	fmap :: (a -> b) -> f a -> f b
```

`f` is the name of the container class. The name of the function is `fmap`
instead of `map` because `map` is already the name of the list mapping unction.

You could think of `fmap` in this way: given a function `g` that applies to a
*single* value of type `a`, `fmap g` is a function that applies to an `f a`, a
container of values of type `a`. `g` is applied to every element in the
container.

> **Aside** In addition to `fmap`, [Haskell]'s `Functor` type class also defines
> the operator `<$`:
> ```haskell
> (<$) :: a -> f b -> f a
> (<$) = fmap . const
> ```
> This replaces each element in a container with a constant value, e.g.:
> ```haskell
> > 5 <$ [1,2,3]
> [5,5,5]
> > "cat" <$ [1,2,3]
["cat","cat","cat"]
> ```
> We won't cover `(<$)` further in these notes.

### Examples of Functors

Suppose you define a tree data type like this:

```haskell
-- binary tree
data Tree a = Leaf a | Node (Tree a) (Tree a)
```

In this particular tree definition, only the leaves contain values.

You could implement an `fmap` function for it like this:

```haskell
instance Functor Tree where
-- fmap :: (a -> b) -> Tree a -> Tree b
   fmap f (Leaf x)   = Leaf (f x)
   fmap f (Node l r) = Node (fmap f l) (fmap f r)
```

This `fmap` applies the function `f` to every value in the tree.

> **Note** The line `-- fmap :: (a -> b) -> Tree a -> Tree b` is a commented-out
> type signature for `fmap`. It's usually a good idea to write type signatures
> when writing instances. Unfortunately, the `instance` structure doesn't allow
> explicit type signatures.

Haskell's standard list type already has `map`, but `fmap` works as well and is
defined like this:

```haskell
instance Functor [] where
-- fmap :: (a -> b) -> [a] -> [b]
   fmap = map
```

Notice that standard lists use `[a]`-style notation, which is different than
other container types like `Tree`, which are written `Tree a`. For consistency,
you can put the `[]` in front of the `a` and `b`:

```haskell
instance Functor [] where
-- fmap :: (a -> b) -> [] a -> [] b
   fmap = map
```

Another interesting example of a functor occurs with `Maybe`:

```haskell
data Maybe a = Nothing | Just a
```

Intuitively, you can think of `Maybe` as a container that is either empty, or
has a single value. Here is the standard `fmap` for `Maybe`:

```haskell
instance Functor Maybe where
-- fmap :: (a -> b) -> Maybe a -> Maybe b
fmap _ Nothing  = Nothing
fmap f (Just x) = Just (f x)

> fmap (+1) (Just 2)
Just 3
> fmap (+1) Nothing
Nothing
```

If you map a function `f` onto `Nothing`, then you get `Nothing`. If you map it
onto a `Just x`, then the `f` is applied to the `x` inside `Just`.

### Functor Laws

To guarantee that a functor works in the way we expect a `map`-like function to
work, it needs to obey these two mathematical laws:

```haskell
fmap id      = id                    -- law 1
fmap (g . h) = (fmap g) . (fmap h)   -- law 2
```

The first law says that mapping `id` (the identity function, i.e. `id x = x`) is
always the same as just calling `id`. For example, with regular list mapping:

```haskell
  fmap id [1,2,3,4]
= [id 1,id 2,id 3,id 4]
= [1,2,3,4]
= id [1,2,3,4]
```

The second law says that `fmap` *distributes* over `(.)` (function composition).
Here' an example with regular list mapping:

```haskell
  fmap (g . h) [x, y, z]
= [(g. h) x, (g . h) y, (g . h) z]
= [g (h x), g (h y), g (h z)]
= map g [h x, h y, h z]
= map g (map h [x, y, z])
= (map g) . (map h) [x, y, z]
```

[Haskell] can't enforce these laws, so it's up to the programmer to make sure
they hold. See chapter 12 of the textbook for more information.

> **Aside** The first functor law logically implies the second functor law. So
> in practice you only need to check that the first law holds.

## Applicative Functors

Functors are useful, but they only map functions with a *single* argument.
**Applicative functors** are a generalization of functors that let you do
something similar to mapping with functions that take two, or more, arguments.

Here is the `Applicative` type class:

```haskell
class Functor f => Applicative f where
	pure :: a -> f a
	(<*>) :: f (a -> b) -> f a -> f b
```

`class Functor f => Applicative` means that `Applicative` to implement
`Applicative` you must also implement `fmap` from `Functor`.

The `pure` function converts a value of type `a` into a value of type `f a`.

`(<*>)` can be seen as a generalization of function application: regular
function application applies a function to an input and returns an output, while
`(<*>)` takes a function *inside* an `f`, and an input value inside another `f`,
and then returns the result inside a third `f`.

To make this concrete, here's the `Applicative` for `Maybe`:

```haskell
instance Applicative Maybe where
-- pure :: a -> Maybe a
   pure = Just

-- (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
   Nothing  <*> _  = Nothing
   (Just f) <*> mx = fmap f mx
```

The `pure` function takes any value and puts it in a `Just`.

`(<*>)` has two rules. The first says if the `Maybe` that is might contain your
function is `Nothing`, then there is no function to apply and so `Nothing` is
returned. The second rule says if there is a function `f`, then apply `f` to the
value inside `mx` using `fmap`. We are allowed to use `fmap` because the
definition of the `Applicative` class requires that `Maybe` implement `Functor`.
 
By combining `pure` and `<*>`, we can do calculations like this:

```haskell
> pure (+1) <*> Just 3
Just 4
> pure (+) <*> Just 3 <*> Just 4
Just 7
```

Notice that the second example uses `(+)`, a function that takes two inputs. We
can use the same style with a three-argument function:

```haskell
> f x y z = x + y*z - 1
> f 1 2 3
6
> pure (f) <*> Just 3 <*> Just 4 <*> Just 5
Just 22
> pure (f) <*> Just 3 <*> Nothing <*> Just 5
Nothing
```

In this way you can think of applicatives as a generalization of `fmap` to work
with functions with more than a single input.

The textbook gives examples of `Applicative`s for lists and `IO`, and also
states mathematical laws that define what it means for applicatives to behave
sensibly. See chapter 12 of the textbook for more details.

## Monads

**Monads** are a generalization of applicatives and functors that have special
importance in Haskell : any type that implements a monad can be used with
**do**-notation. The name *monad* comes from [category
theory](https://en.wikipedia.org/wiki/Category_theory), the branch of
mathematics that inspired this whole approach.

Here is the `Monad` type class:

```haskell
class Applicative m => Monad m where
	return :: a -> m a
	(>>=) :: m a -> (a -> m b) -> m b  -- bind operator

	return = pure
```

`Monad` implements all the functions in `Applicative`, and so every monad has
`fmap` and `<*>`.

The `return` function is another name for `pure`. You can think of `return` as
putting an element of type `a` into a container `m`. Concretely, think of `m` as
being a list, or `Maybe`.

`(>>=)` is called the **bind operator**, and it takes two arguments: a container
of type `m a`, and a function that converts a value of type `a` into a container
`m b` of type `b`. The result is an `m b`, a container holding values of type
`b`. 

### Intuition for Monads

So why is this definition so useful? To get some intuition for it, lets work
through an example that builds up to do-notation.

Consider the function `transform` that works like this:

```haskell
> transform [1,2,3] (\x -> [x, x])
[1,1,2,2,3,3]
> transform [1,2,3] (\x -> [show x, show x])
["1","1","2","2","3","3"]

-- replicate n x returns a list of n copies of x
> transform [1,2,3] (\n -> replicate n n)
[1,2,2,3,3,3]
```

`transform` applies a function to every element of a list, resulting in a list
of lists. These lists are then all concat-ed together to give one a list of
value. We could implement it like this:

```haskell
transform :: [a] -> (a -> [b]) -> [b]
transform xs f = concat (map f xs)
```

Read the type signature carefully, and make sure you understand why it has to be
that.

A **monad** generalizes `transform` to work with container types other than
lists. So lets do that. Both `concat` and `map` are list-specific functions, and
so we need general-purpose versions of them that work with any container. `fmap`
from the `Functor` class gives us generalized `map`, and the general version of
`concat` is called `join :: m (m a) -> m a`. Intuitively, `join` *flattens* a
monad, i.e. takes a container of containers, and returns a container of all the
values. For lists, `join` is the same as `concat`. For every other type `m`, you
need to define a `join` function for it.

> **Note** The signature for `join`, and implementations of `join` for standard
> types, can be found in Haskell's `Control.Monad` library. Put `import
> Control.Monad` at the top of your file to import them into your code.

Now we can write a version of `transform` that uses `Maybe a` and `Maybe b`
instead `[a]` and `[b]`:

```haskell
join :: Maybe (Maybe a) -> Maybe a
join Nothing   = Nothing
join (Just mx) = mx

transform :: Maybe a -> (a -> Maybe b) -> Maybe b
transform xs f = join (fmap f xs)

> transform (Just 5) (\n -> Just (n+1))
Just 6
> transform Nothing (\n -> Just (n+1))
Nothing
```

The `join` function for `Maybe` takes a value like `Just (Just x)` and returns
`Just x`, i.e. it removes one level of the `Maybe` wrapper.

Since `transform` returns a `Maybe b`, we can apply `transform` to the output of
a `transform`. For example, this increments and doubles a number in a `Maybe`:

```haskell
> transform (transform (Just 5) (\n -> Just (n+1))) (\n -> Just (2*n))
Just 12
```

The order of the functions matters. We get a different result if we double and
then increment:

```haskell
> transform (transform (Just 5) (\n -> Just (2*n))) (\n -> Just (n+1))
Just 11
```

A `Maybe` could have the value `Nothing`, and `transform` handles that:

```haskell
> transform (transform Nothing (\n -> Just (2*n))) (\n -> Just (n+1))
Nothing
> transform (transform (Just 5) (\n -> Nothing)) (\n -> Just (n+1))
Nothing
> transform (transform (Just 5) (\n -> Just (2*n))) (\n -> Nothing)
Nothing
```

Once a `Nothing` value is returned anywhere in the computation, all following
values are `Nothing`. This is useful behaviour: it is one way to catch errors
in a computation.

Now lets generalize our two `transform` functions into a single function:

```haskell
transform :: m a -> (a -> m b) -> m b  -- error!
transform xs f = join (fmap f xs)
```

This version of `transform` *doesn't* compile because Haskell knows nothing
about `m`, and so cannot be sure that a `join` and `fmap` function have been
defined for it. To ensure `m` has those functions, we must say that `m`
implements the `Monad` type class:

```haskell
import Control.Monad  -- gets the join function signature

transform :: Monad m => m a -> (a -> m b) -> m b
transform xs f = join (fmap f xs)
```

This works! Now this single `transform` function works for both lists and
`Maybe`s (and any other type that implements `Monad`):

```haskell
> transform [1,2,3] (\n -> [n,n])
[1,1,2,2,3,3]
> transform (Just 5) (\n -> Just (n+1))
Just 6
```

### do-expressions

Haskell's `Monad` class *doesn't* use the name `transform`. Instead, it names it
`(>>=)`, which is called the **bind operator**:

```haskell
(>>=) :: Monad m => m a -> (a -> m b) -> m b  -- bind
xs >>= f  = join (fmap f xs)
```

You can use `(>>=)` in prefix position by replacing `transform`:

```haskell
> (>>=) [1,2,3] (\n -> [n,n])
[1,1,2,2,3,3]
> (>>=) (Just 5) (\n -> Just (n+1))
Just
```

Or, more commonly, it is used as an infix operator:

```haskell
> [1,2,3] >>= (\n -> [n,n])
[1,1,2,2,3,3]
> (Just 5) >>= (\n -> Just (n+1))
Just
```

An advantage of the infix version is that it makes combining multiple calls a
little easier to read:

```haskell
> (>>=) ((>>=) (Just 5) (\n -> Just (2*n))) (\n -> Just (n+1))
Just 11

> (Just 5) >>= (\n -> Just (2*n)) 
           >>= (\n -> Just (n+1))
Just 11
```

We used `n` as the variable in both lambda functions, we could also use
different variables without changing the meaning of the expression:

```haskell
(Just 5) >>= (\a -> Just (2*a)) 
         >>= (\b -> Just (b+1))
```

One more useful change to make is to *nest* the second function inside the first
one:

```haskell
Just 5 >>= \a -> 
    Just (2*a) >>= \b -> 
        Just (b+1)
```

The expression is formatted in this unusual way to make it easier to see the
nesting. 

A useful consequence of this nesting is that variable `a` is now usable
everywhere after `\a`. For instance, this expression adds two `Maybe`s together:

```haskell
Just 5 >>= \a ->
    Just 3 >>= \b ->
        Just (a+b)
```

Usually, the last value is written using `return`. The `Maybe` monad is
implemented like this:

```haskell
instance Monad Maybe where
-- (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
   Nothing  >>= _  = Nothing
   (Just x) >>= f  = f x
   
   -- return x = Just x
```

So we can write this:

```haskell
Just 5 >>= \a ->
    Just 3 >>= \b ->
        return (a+b)
```

In this expression, `a` is assigned the value 5, and `b` is assigned the value
3. `a` and `b` act like local variables within the expression. If you replace
`Just 5` or `Just 3` with `Nothing`, then the expression correctly evaluates to
`Nothing`.

We can generalize the expression into a function that adds two `Maybe`s:

```haskell
madd1 :: Maybe Int -> Maybe Int -> Maybe Int
madd1 mx my = mx >>= \a ->
                my >>= \b ->
                  return (a+b)

> madd1 (Just 2) (Just 3)
Just 5
> madd1 Nothing (Just 3)
Nothing
> madd1 (Just 2) Nothing
Nothing
```

While `madd1` is clever, the syntax makes it difficult to read. So Haskell
provides **do-notation**, that looks like this:

```haskell
do x1 <- m1
   x2 <- m2
   ...
   xn <- mn
   f x1 x2 ... xn
```

This is equivalent to:

```haskell
 m1 >>= \x1 ->
   m2 >>= \x2 ->
     ...
       mn >>= \xn ->
          f x1 x2 ... xn
```

Re-writing `madd1` with do-notation results in a function that is easier to
read:

```haskell
madd2 :: Maybe Int -> Maybe Int -> Maybe Int
madd2 mx my = do a <- mx  
                 b <- my
                 return (a+b)

> madd2 (Just 2) (Just 3)
Just 5
> madd2 Nothing (Just 3)
Nothing
> madd2 (Just 2) Nothing
Nothing
```

### Final Note

Our purpose here is to gain some intuition for why monads are useful, and why
they are defined the way they are. This is just the beginning of monads, and
there are many related ideas.

In practice, the most important `Monad` type is `IO`, since all of Haskell's
standard input and output is done with `IO`. Input and output is typically done
inside do-expressions.

There are also mathematical laws for good monad behaviour that should be
followed. We won't go into the details here, but see Chapter 12 if you are
interested.
