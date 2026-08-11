## Equational reasoning

**Equational reasoning** is familiar to anyone who has taken a high school
algebra class. Equational reasoning in algebra assumes a few basics laws, such
as:
- **Commutivity of multiplication** For all numbers $x$ and $y$, $xy=yx$.
- **Associativity of addition** For all numbers $x$, $y$, and $z$, $x + (y + z)
  = (x + y) + z$.
- **Distributivity** For all numbers $x$, $y$, and $z$, $x(y+z)=xy+xz$, and
  $(x+y)z=xz+yz$.

Equational reasoning is what lets us start with some expression, such as $(x +
a)(x + b)$, apply laws of algebra, and then end up with a different expression
that is *equal* to $(x + a)(x + b)$:

```
  (x + a)(x + b)
= (x + a)x + (x + a)b
= x^2 + ax + (x + a)b
= x^2 + ax + xb + ab
= x^2 + ax + bx + ab
= x^2 + (a + b)x + ab
```

Each step applies one basic rule of algebra, so that someone who knows those
rules can see that each step is valid.

Two expressions can be equal, but have a different computational cost. Some
expressions use fewer operations than others. For example, $(x + a)(x + b)$ has
one multiplication and two additions, and $x^2 + (a + b)x + ab$ has three
additions and three multiplications.

## Reasoning about Haskell
Haskell definitions can also be treated as rules. For example:

```haskell
double :; Int -> Int
double x = x + x
```

This *defines* the `double` function, and it also provides a logical property
that says that any occurrence of the expression `double x` can be replaced `x +
x`, and, the other way, that any occurrence of `x + x` can be replaced by
`double x`.

Functions defined by multiple equations need more care. For example:

```haskell
isZero :: Int -> Bool
isZero 0 = True
isZero n = False
```

The equation `isZero 0 = True` can be viewed as a logical property, i.e. any
occurrence of `isZero 0` can be replaced by `True`, and any occurrence of `True`
can be replaced by `isZero 0`.

But you can't replace `isZero n` with `False` because the order in which the
equations are evaluated matters in Haskell. Since `isZero 0 = True` is evaluated
before `isZero n = False`, this second equation is in fact equivalent to this:

```haskell
isZero n | n /= 0 = False
```

In other words, the second equation implicitly includes the constraint that `n`
is not 0. Whenever the order of evaluation of a set of equation matters, there
will be hidden constraints like this. So a more precise way to define `isZero`
is to make the constraints explicit:

```haskell
isZero :: Int -> Bool
isZero 0          = True
isZero n | n /= 0 = False
```

When it doesn't matter what order the patterns of a function definition are
evaluated, they are said to be **non-overlapping**.

### Example: reasoning with reverse
Suppose the `reverse` function is defined like this:

```haskell
reverse []     = []
reverse (x:xs) = reverse xs ++ [x]
```

Using this definition we can prove that for any value `x`, `reverse [x]` =
`[x]`, i.e. reversing a list with one element results in the same list:

```
  reverse [x]
= reverse (x : [])
= reverse [] ++ [x]
= [] ++ [x]
= [x]
```


## Induction on numbers
The proof technique of **mathematical induction** can be used to prove various
properties of functions.

For instance, suppose we define natural numbers like this:

```haskell
data Nat = Zero | Succ Nat
```

The values of `Nat` are:

```haskell
Zero                    -- 0
Succ Zero               -- 1
Succ (Succ Zero)        -- 2
Succ (Succ (Succ Zero)) -- 3
...
```

Any non-negative integer $n$ can be represented as a `Nat`, i.e. 0 is `Zero`,
and every other $n$ is $n$ applications of `Succ` to `Zero`.

Now suppose we define addition on `Nat`s like this:

```haskell
add :: Nat -> Nat -> Nat
add Zero     m = m
add (Succ n) m = Succ (add n m)
```

Clearly, `add Zero m` is equal to `m` for any `Nat` `m`. It is also the case
that, for any `Nat` `m`, `add m Zero` also holds true. This is not as obvious,
but we can prove it by induction:

- **Base case** Show  that `add Zero Zero` evaluates to `Zero`. This is an
  immediate consequence of the first `add` equation.
- **Inductive case** Show that *if* `add n Zero`= `n` holds for any natural
  number `n`, then `add (Succ n) Zero`= `Succ n` also holds. We do this in
  steps:
    ```
      add (Succ n) Zero
    = Succ (add n Zero)
    = Succ n
    ```
    The induction hypothesis lets is replace `add n Zero` with `n`.

## Induction on lists
Just as we can do induction on the natural numbers, there is possible to do
induction on lists. If $P$ is some property about lists, then we can prove that
$P$ holds for all lists if:

- **Base case** Prove that $P$ holds for the empty list `[]`.
- **Inductive case** Prove that *if* $P$ holds for any list `xs`, then for all
  `x` $P$ holds for `x : xs`. Both `x` and `xs` are the appropriate types.

## Some proofs with `reverse`
### Distributivity of reverse
For example, induction on lists can be used to prove a *distributivity* law that
`reverse (xs ++ ys)` = `reverse ys ++ reverse xs` for any lists `xs` and `ys`.
Here is the definition of `reverse`:

```haskell
reverse []     = []
reverse (x:xs) = reverse xs ++ [x]
```

We use induction on the first list `xs`. First we prove the base case, that
`reverse ([] ++ ys)` = `reverse ys ++ reverse []`:

```
  reverse ([] ++ ys)
= reverse ys               -- [] ++ ys = ys
= reverse ys ++ []         -- xs = xs + []
= reverse ys ++ reverse [] -- eqn 1 of reverse
```

To prove the inductive case, we proof that if `reverse (xs ++ ys)` = `reverse ys
++ reverse xs` for any non-empty lists `xs` and `ys`, then `reverse ((x:xs) ++
ys)` = `reverse ys ++ reverse (x:xs)` holds for all elements `x`:

```
  reverse ((x:xs) ++ ys)
= reverse (x:(xs ++ ys))            -- def of : and ++
= reverse (xs ++ ys) ++ [x]         -- eqn 2 of reverse
= (reverse ys ++ reverse xs) ++ [x] -- inductive hypothesis
= reverse ys ++ (reverse xs ++ [x]) -- ++ associativity
= reverse ys ++ reverse (x:xs)      -- def of ++
```

### Reversing a List Twice
Now lets prove that `reverse (reverse xs)` = `xs` for lists `xs`. 

The first step is to show that the base case holds, i.e. that when `xs` is the
empty list `reverse (reverse [])` evaluates to the empty list:

```
  reverse (reverse [])
= reverse []  -- eqn 1 of reverse
= []          -- eqn 1 of reverse
```

For the inductive step, we assume that `reverse (reverse xs)` = `xs` holds for
all non-empty lists `xs`, and show that for any element `x`, `reverse (reverse
(x:xs))` = `x:xs`:

```
  reverse (reverse (x:xs))
= reverse (reverse xs ++ [x])         -- eqn 2 of reverse
= reverse [x] ++ reverse (reverse xs) -- distributivity
= [x] ++ reverse (reverse xs)         -- reverse [x] = [x]
= [x] ++ xs                           -- inductive hypothesis
= x : xs                              -- def of :
```

### Proving the functor laws for lists
Recall that `map f lst` applies function `f` to every element of `lst`. `fmap`
is a generalization of `map` that works on any data type for which is defined.
The standard version Haskell's `fmap` satisfy these two laws, which in
mathematics are known as the **functor laws**:

```haskell
fmap id      = id
fmap (g . h) = fmap g . fmap h
```

`id` is the identity function, i.e. for any value `x` we have `id x = x`. `.` is
function composition.

Here is the definition of `fmap` for lists:

```haskell
fmap :: (a -> b) -> [a] -> [b]
fmap g []     = []
fmap g (x:xs) = g x : fmap g xs
```

Using induction on lists we can prove that the two functor laws hold.

For the first law, `fmap id = id`,  we start by proving the empty list base
case:

```
  fmap id []
= []          -- eqn 1 of fmap
```

The base case proof is a single step because it is handle by the first equation
in `fmap`.

Next we prove the inductive case for `fmap id = id`. We assume that `fmap id xs
= xs` for all non-empty lists `xs`, and our goal is to show `fmap id (x:xs)` =
`x:xs` for all elements `x`:

```
  fmap id (x:xs)
= id x : fmap id xs  -- eqn 2 of fmap
= x : fmap id xs     -- def of id
= x : xs             -- induction hypothesis
```

Now lets prove that the second functor law, `fmap (g . h) xs = fmap g xs . fmap
h xs`, holds for the list version of `fmap`. Using the definition of `.`, this
simplifies to `fmap (g . h) xs = fmap g (fmap h xs)`.

We start by proving the base case, that `fmap (g . h) []` = `fmap g (fmap h
[])`:

```
  fmap (g . h) []
= fmap g []           -- eqn 1 of fmap
= fmap g (fmap h [])  -- eqn 1 of fmap
```

For the inductive case, we assume that `fmap (g . h) xs = fmap g (fmap h xs)`
holds for all non-empty lists `xs`, and show that `fmap (g . h) (x:xs)` = `fmap
g (fmap h (x:xs))` for all elements `x`:

```
  fmap (g . h) (x:xs)
= (g . h) x : fmap (g . h) xs  -- eqn 1 of fmap
= g (h x) : fmap (g . h) xs    -- def of .
= g (h x) : fmap g (fmap h xs) -- induction hypothesis
= fmap g (h x : fmap h xs)     -- eqn 2 of fmap
= fmap g (fmap h (x:xs))       -- eqn 2 of fmap
```

## Rest of the Chapter
The rest of the chapter shows an example of how adding extra parameters to
certain functions can make them run faster. The final section is about reasoning
about the correctness of a compiler.
