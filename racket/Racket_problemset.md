# Racket Problem Set

The questions on the Racket quiz will mainly be variations of the questions
below, or questions that are similar. Don't use any loops are built-in functions
that do the same thing: write solutions that use recursion and basic functions
like `first`, `rest`, `empty?`, `cons`, `append`, and `member`, or that use
higher-order functions like `map`, `filter`, and `fold-right`.

Please post your answers to the discussion board to share with other students.

**Important**: *Treat these problem-sets as non-AI activities!* Turn off all AI
support and try to figure them out yourself. Having AI or another student do
this for you will not help you learn. You must do the learning yourself!

## Question 1

Using recursion, implement a function called `(index-of x lst)` that returns the
index location of the *first* occurrence of `x` in `lst`. The first index value
is 0. If `x` is not in `lst`, then return -1.

For example:

```lisp
> (index-of 'a '(a 1 2 3 4))
0
> (index-of 'a '(0 1 2 a a))
3
> (index-of 'a '(one two three four))
-1
```

## Question 2

Implement a function called `(my-subset? lst1 lst2)` that returns true just when
every element of `lst1` is a member of `lst2`. The empty list is considered a
subset of all other lists.

For example:

```lisp
> (my-subset? '() '())
#t
> (my-subset? '() '(1 2))
#t
> (my-subset? '(2 1 1) '(1 2))
#t
> (my-subset? '(2 1 3) '(1 2))
#f
> (my-subset? '(a d (3 1)) '(1 a (3 d)))
#f
> (my-subset? '((1) (2 2)) '((3 3 3) a (2 2) (1)))
#t
```

Racket already has a built-in function called `subset?`. Don't use `subset?`
anywhere in your implementation of `my-subset?`.


## Question 3

Implement a function called `(my-remove-duplicates lst)` that returns a list
that is the same as `lst` except all elements in `lst` that occur 2 or more
times have their extra copies removed. The exact order of the elements on the
returned list doesn't matter.

For example:

```lisp
> (my-remove-duplicates '(1 2 3 2))
'(1 3 2)
> (my-remove-duplicates '(4 4 4))
'(4)
> (my-remove-duplicates '(up up and a way way))
'(up and a way)
```

[Racket] already has a built-in function called `remove-duplicates`. Of course,
don't use it in your function!


## Question 4

A **consed-out** list is a representation of a list using nested calls to
`cons`. For example, the consed-out version of `'(a b c)` is `(cons 'a (cons 'b
(cons 'c '())))`. Any elements of the list that are also lists are also
consed-out, and so on recursively. For example, the consed-out version of `((a)
b c)` is `(cons (cons 'a '()) (cons 'b (cons 'c '()))`.

Implement a function called `(make-consed x)` that returns the consed-out
version of the list `x`. If `x` is not a list, just return `x` without any
change. All nested sub-lists in `x` should be consed-out.

For example:

```lisp
> (make-consed '())
'()

> (make-consed '(a b c))
'(cons a (cons b (cons c ())))

> (make-consed '((a b) c d))
'(cons (cons a (cons b ())) (cons c (cons d ())))
```

When `x` is a list, the value returned by `(make-consed x)` is a quoted list,
and so symbols and the empty list that appear in it are **not** quoted.

## Question 5

Implement your own version of each of these built-int Racket functions (don't
use the built-in functions in your implementation!):

- `(my-map f lst)`

- `(my-filter pred? lst)`

- `(my-fold-right f init lst)`

Make sure to test them on a few inputs to make sure they work correctly.

## Question 6

Using just one call to `fold-right` (as defined in the notes), implement the
function `(my-filter pred? lst)` that works that same as the built-in `filter`
function.

## Question 7

In English, explain the idea of **currying**. Write a Racket function that takes
a 2-argument function as input and returns a curried version of that function,
and use it in an example to show how it works.

## Question 8

a) Define the `M`, `I`, `K`, and `S` combinators as Racket functions.

b) Show how to defined `I` in terms of `S` and `K`.

## Question 9

Write a function that converts a [Racket] `if` form into an equivalent `cond`
form.

For example:

```lisp
> (if-to-cond '(if (= x y) (f x) (g x y)))
'(cond ((= x y) (f x))
       (else (g x y)))
```

## Question 10

a) In Racket, what is the essential difference between functions and macros?

b) Write a Racket macro called `(show-expr e)` that prints (e.g. using `printf`)
like this:

```lisp
> (show-expr '(+ 1 2))
(+ 1 2) evaluates to 3

> (show-expr '(first '(a b c)))
(first '(a b c)) evaluates to a
```

c) What is a **hygienic** macro? Using real Racket code, give an example of a
the problem that hygienic macros solve.
