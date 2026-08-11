# Combinators

**Combinators** are higher-order functions that are **pure functions**, i.e.
functions without side-effects (such as changing global values, printing to the
screen, opening a file, etc.), and whose result is always the same for the same
input. Interestingly, they can be combined to build many other functions, and
are of interest in theoretical computer science.

## The I Combinator

`(I x)` is the **identity function**, and it returns whatever you pass it:

```scheme
(define (I x) x)

> (I 4)
4
> (I '(a b c))
'(a b c)
> (I I)
#<procedure:I>
```

`I` is a little bit like the number 1 in multiplication: $1 \cdot x$ is always
$x$.

## The K Combinator

The function `(K x)` returns a function that takes a single input `y`, and for
any value of `y` returns `x`. In other words, it returns a *constant* function
that always returns `x`:

```scheme
(define (K x) (lambda (y) x))
```

## The S Combinator
Function `S3` takes 3 inputs:

```scheme
(define (S3 x y z)
  ((x z) (y z)))
```

`S` is a curried version of `S3`. You can pass 0, 1, 2, or 3 arguments to `S`
(you must always pass exactly 3 arguments to `S3`):

```scheme
(define S (curry S3))
```

Intuitively, you can think of `S` as a generalization of regular function
calling: `S` calls `x` on `y`, but *first* it calls `x` on `z` and `y` on `z`.

## I in Terms of S and K

Interestingly, the identity function `I` can be defined in terms of `S` and
`K` like this:

```scheme
(define (I x) ((S K K) x))
```

To see why this is true, consider `(S K K)`. This calls `S` with two
arguments, `K` and `K`, and is equivalent to this function:

```scheme
(lambda (z) ((K z) (K z)))
```

`(K z)` is a function that takes one input, and no matter what that input is
the return value will be `z`. So `((K z) (K z))` evaluates to `z`, and we can
re-write the lambda function for `(S K K)` as:

```scheme
(lambda (z) z)
```

This is the identity function: it returns unchanged whatever you pass it.

## Completeness of S and K

Surprisingly, `S` and `K` can be combined to define *any* other pure function.
Of course, the resulting function might not be efficient or readable, but it
can be done.

We won't go through the proof here, but check out [the Wikipedia page on
combinatory
logic](https://en.wikipedia.org/wiki/Combinatory_logic#Completeness_of_the_S-K_basis)
if you're curious.

> It turns out there is a single function, called `X`, that can implement both `S` and `K`:
>  ```scheme
>  (define (X x) ((x S) K))
>  ```
> Thus, *all* pure functions can be implemented in terms of the single
> function `X`! Again, check out [the Wikipedia page on combinatory
> logic](https://en.wikipedia.org/wiki/Combinatory_logic#One-point_basis) if
> you are curious about the details.

## The M Combinator
The function `(M x)` takes a function `x` as input, and calls `x` on itself:

```scheme
(define (M x) (x x))

> (M list)
'(#<procedure:list>)
> (M symbol?)
#f
> (M I)
#<procedure:I>
> (M 4)
. . application: not a procedure;
 expected a procedure that can be applied to arguments
  given: 4
  arguments...:
```

The expression `(M M)` is interesting: it is an infinite loop that never
returns a value. When you call `(M M)`, the argument `M` replaces `x` in the
body of function `M`, i.e. `(x x)` becomes `(M M)`. This evaluates to `(M M)`,
and the same thing happens again and again forever.

We could write `M` as a lambda function:

```scheme
(lambda (x) (x x))
```

Then the call `(M M)` is the same as:

```scheme
((lambda (x) (x x)) (lambda (x) (x x)))
```

Just like `(M M)`, this expression never returns a value and loops forever.
There's no explicit loop or recursion here. It shows the non-obvious fact that
you can create an infinite loop just from calling lambda functions.
