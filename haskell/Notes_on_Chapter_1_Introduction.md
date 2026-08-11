# Notes on Chapter 1: Introduction

## Functional Programming

Haskell is a programming language that supports pure functional programming.
This is a style of programming that emphasizes the use of pure functions. In
Haskell, functions are **first class objects**: they can be passed as
parameters, and returned as values. 

As an example of functional programming style, consider creating a list of the
*even* numbers from 1 to 100.

In a language like C++, you might start with an empty list an add even numbers
up to 100:

```cpp
vector<int> nums;
for(int i = 1; i <= 100; i++) {
    if (i % 2 == 0) {
        nums.push_back(i);
    }
}
```

In Haskell you can  do this:

```haskell
> filter even [1..100]
[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,
40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,
76,78,80,82,84,86,88,90,92,94,96,98,100]
```

Both `filter` and `even` are functions. `even n` is true just when `n` is an
even number. `filter` takes two inputs, the function `even` and the expression
`[1..100]` (which generates the numbers from 1 to 100). `filter` is an example
of a **higher-order function**, because it takes another function as input.

In many cases, functional code is shorter and simpler (once you understand it!)
than the equivalent non-functional code. In the Haskell version we:

- **didn't** define any variables
- **didn't** use any if-statements, loops, or recursion
- **didn't** write any types
- **didn't** need as much "punctuation", e.g. we didn't have to type `;` or `}`

## Features of Haskell

### Concise programs

Many Haskell features are explicitly designed with human readability in mind.
Haskell programs can be short and relatively easy to read.

But, to be fair, Haskell programs can sometimes so short and concise that they
are hard to understand if you're not very familiar with the details.

### Powerful type system

Every expression in Haskell has a **type**, and Haskell can find type errors
*before* evaluating code. It also uses **type inference** to, in many cases,
figure out the types of values *without* the programmer needing to *explicitly*
declare types (as in C++ or Java).

### Higher-order functions

Haskell lets you pass functions as values to other functions, and even return
functions as values. Functions that operate on functions is a powerful and
useful technique that gives you new ways to solve many programming problems.

### Effectful functions

Haskell functions are **pure functions**, i.e. the output of Haskell function
depends only on the input to the function, and the function has no side-effects
(such as changing the value of a global variable). This is how mathematical
functions work.

However, pure functions can't do everything. For example, input and output is
fundamentally impure. A function `read_string("story.txt")` that opens the file
`story.txt` and returns its content as a string can't be a pure  because the
returned string depends upon more than just the passed-in name of the file. The
returned value also depends upon the contents of the file itself. It's possible
that every time you call `read_string("story.txt")` you get a different string.

Functions like `read_string` are called **impure functions**.

This is a tough problem, and most programming languages, including [Racket],
just give up and let you write impure functions like `read_string` whenever you
need them. But Haskell takes a different approach, and keeps its functions pure.
To handle impure calculations, it uses clever functional patterns such as
*monads* and *applicatives*.

### Lazy evaluation

An unusual feature of Haskell is how it evaluates function calls like `f(g(2))`.
In most programming languages, first `g(2)` is evaluated, and then the result of
that is passed to `f`.

But in Haskell, `g(2)` is passed to `f` *unevaluated*. Inside of `f` `g(2)` is
only evaluated when its result is *needed*. In other words, Haskell evaluates
`g(2)` **lazily**, i.e. it holds off calculating `g(2)` until the last possible
moment.

This feature has a profound effect. Among other things, lazy evaluation lets us
manipulate infinitely long lists, and implement our own versions of
if-statements or short-circuited logical operators. Other languages either don't
allow you to write such code, or require that you do it using **macros** (which
are not functions).

### Equational Reasoning

Many Haskell programs can be thought of as a series of **equations**. By
examining these equations we can sometimes determine properties they must
satisfy, which can help with understanding and testing. Sometimes it may even be
possible to systematically transform them into equivalent equations that are
simpler, faster, or more general.

## A Bit of History

Haskell's intellectual roots go back to the early part of the 20th century, all
the way to mathematicians such as [Moses
Schonfinkel](https://en.wikipedia.org/wiki/Moses_Sch%C3%B6nfinkel), [Alonzo
Church](https://en.wikipedia.org/wiki/Alonzo_Church), [Alan
Turing](https://en.wikipedia.org/wiki/Alan_Turing), and [Haskell
Curry](https://en.wikipedia.org/wiki/Haskell_Curry), who were interested in
studying the foundations of logic and computation.

Haskell can be viewed as an implementation of the typed [lambda
calculus](https://en.wikipedia.org/wiki/Lambda_calculus). Invented in the 1930s,
the [lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus) is a
mathematical formalism that describes computation. It focuses on functions, and
how they are applied to their inputs. It is the heart of functional programming.

Haskell itself was initiated in 1987 by a group of programming language
researchers, and its development continues to this day. While it has not yet
become a mainstream language, Haskell has been a rich source of ideas, with many
of its features adopted by more mainstream languages.

## A Taste of Haskell

### Summing Numbers

A function for summing the numbers in a list can be written in Haskell as two
**equations**:

```haskell
mysum []     = 0
mysum (n:ns) = n + mysum ns
```

This is a recursive definition. The first equation says the sum of the empty
list `[]` is 0, and the second equation says the sum of a non-empty list is the
first element of the list plus the sum of the rest of the list.

`(x:xs)` matches `x` to the first item of the list, and `xs` to the rest of the.
The expression `mysum xs` calls function `mysum` with input argument `xs`.

It's instructive to trace a call to `mysum` by hand:

```
mysum [1,2,3]
= 1 + mysum [2,3]
= 1 + (2 + mysum [3])
= 1 + (2 + (3 + mysum []))
= 1 + (2 + (3 + 0))
= 6
```

Every Haskell expression has a **type**. `mysum` has the type `Num a => [a] ->
a`. This says that `mysum` takes a **list** of values of type `a` as input, and
returns a value of type `a` as output. The type `a` is any number type that
satisfies the **type class** `Num`. `a` could be an integer type, a floating
point type, or a number-like type created by the programmer.

**Tip** In the Haskell interpreter, `:type` or `:t` will tell you the type of an
expression:
```haskell
> :t mysum
mysum :: Num p => [p] -> p
```
The variable `p` happens to be used here instead of `a`. The exact variable name
doesn't matter.

```haskell
> :t (+)
(+) :: Num a => a -> a -> a
```

Haskell can often **infer** the type of an expression from context, and
programmers don't need to write types explicitly in these cases. However, **type
signatures** can provide useful information, and so we'll usually include them
for functions. For instance:

```haskell
mysum :: Num a => [a] -> a  -- type signature
mysum []     = 0
mysum (n:ns) = n + mysum ns
```

The token `::` is read "has type".

We note here that Haskell has no loops. In their place, Haskell uses recursion
and higher-order functions. 

There are also **no** modifiable variables in basic Haskell. Once you assign a
value to variable, it never changes. As with the lack of loops, this can take
some getting used to, and requires different programming strategies for solving
many problems.

## Sorting

This function sorts lists:

```haskell
qsort []     = []
qsort (n:ns) = qsort smalls ++ [n] ++ qsort bigs
             where smalls = [a | a <- ns, a <= n]
                   bigs   = [b | b <- ns, b > n]

> qsort [4,3,5,5,3,3,2,2,2,2,0,9]
[0,2,2,2,2,3,3,3,4,5,5,9]
> qsort "SimonFraserUniversity"
"FSUaeeiiimnnorrrsstvy"
```

`qsort` follows the general sorting strategy as quicksort. But it's not really
quicksort since it makes *copies* of sub-lists instead of modifying them in
place. This makes it much slower than regular quicksort.

But on the plus side, the code is concise and quite understandable one you know
what all the tokens mean. For example, `++` concatenates two lists, and
expressions like `[a | a <- ns, a <= n]` are called **list comprehensions** and
are often a convenient way to make new lists.

Finally, `qsort` works on both numbers and strings:

```haskell
> qsort [4,3,5,5,3,3,2,2,2,2,0,9]
[0,2,2,2,2,3,3,3,4,5,5,9]
> qsort "SimonFraserUniversity"
"FSUaeeiiimnnorrrsstvy"
```

In fact, `qsort` works on any list of values that can be ordered:

```haskell
> :t qsort
qsort :: Ord a => [a] -> [a]
```

`Ord` is a type class for values that can be compared. `qsort` can sort a list
of any values that implement `Ord`, which includes numbers and strings.
