# Higher Order Functions in Racket

**High order functions** are functions that either take other functions as
input, or return functions as output. For instance, `map`, `filter`, and
`fold-right` are all higher order functions. Here we discuss a few more.

## apply

The usual way of evaluating function calls in [Racket] is like this:

```lisp
> (* 1 2 3)
6
> (cons 'cherry '(ice cream))
'(cherry ice cream)

> (map even? '(2 3 4 5))
'(#t #f #t #f)
```

An alternative way is to use `apply`:

```lisp
> (apply * '(1 2 3))
6

> (apply cons '(cherry (ice cream)))
'(cherry ice cream)

> (apply map (list even? '(2 3 4 5)))
'(#t #f #t #f)
```

`(apply f list-of-args)` takes a function `f` and evaluates it using the items
in `list-of-args` as its input. It's as if `f` is cons-ed onto `args`, and then
that expression is evaluated.

Notice in the example using `map`, `list` was used. A quoted list won't work
here because it treats `even?` as a symbol instead of a function:

```lisp
> (apply map '(even? (2 3 4 5)))
; map: contract violation
;   expected: procedure?
;   given: 'even?
;   argument position: 1st
; [,bt for context]
```

## eval

The `eval` function takes an entire list as input and evaluates it:

```lisp
> (eval '(* 1 2 3))
6
> (eval '(cons 'cherry '(ice cream)))
'(cherry ice cream)
> (eval '(map even? '(2 3 4 5)))
'(#t #f #t #f)
```

`eval` is a very powerful: it is essentially [Racket] implemented in [Racket]!
In practice, it is a bit tricky to use correctly in [Racket] and sometimes
requires setting up namespaces. We won't cover that here, but, in general, you
should avoid using `eval` in most situations.

> It turns out that it is possible to implement the `eval` function using only
> a few elementary [Racket] functions. Such a function is called a
> **meta-circular interpreter**.


## Closures

A **closure** combines two things: a function, and an environment of `(variable
value)` pairs. The function is allowed to use variables from this environment.

For example, consider this code:

```lisp
(define f
    (lambda (n)
        (+ n 1)))

> (f 5)
6
```

`f` is a function, but it's *not* a closure. 

Now consider this:

```lisp
(define (make-adder n)
    (lambda (x) (+ n x))  ;; n is outside the lambda function
)

(define g (make-adder 1))

> (g 5)
6
```

`g` is a closure that includes both a function and a binding for the variable
`n`. By itself, the function `(lambda (x) (+ n x))` can't be evaluated because
`n` is *free*. But, in `g`, `n` is bound to the value 1. The function plus this
binding of `n` is a closure.

Conceptually, you can think of a closure as being a **let over lambda**:

```lisp
(define g1
    (let ([n 1])
        (lambda (x)
            (+ n x))
    )
)

> (g1 5)
6
```

`g1` is not *just* a function, but a function along with variable bindings that
it needs.

**Free variables** are variables that appear in a function but aren't declared
in the function. For example, `n` is free in `(lambda (x) (+ n x))`. Any
programming language that lets you define functions inside functions must decide
how to handle free variables. Closures are a common solution to this problem.
Another is to simply disallow returning functions with free variables, but this
reduces the flexibility of returning functions.

In [Go], a language that supports closures, you can do this:

```go
package main

import "fmt"

type intFunc func(int) int

func makeAdder(n int) intFunc {
    result := func(x int) int { return x + n }
    return result
}

func main() {
    add2 := makeAdder(2)   // add2 is a closure

    fmt.Println(add2(5))
}
```

`add2` is a closure. The `n` inside the `result` function is bound to the value
of `n` passed to `makeAdder`, and it stays bound for the life of the `result`
function. So even after `makeAdder` finishes executing, the `n` in the `result`
is still there and can be used as long as `add2` exists.

As an aside, [Go] is a statically typed language that requires explicit type
declarations, and this tends to make [Go] code longer and more cluttered as
compared to [Racket]. [Racket] is dynamically typed, and so *doesn't* need
explicit type information in its source code.

### Example: Object-oriented Programming with Closures

Using closures, it's possible to simulate object-oriented programming. A closure
can contain both functions and variables, as in this example:

```lisp
;; (set! x val) assigns val to x, i.e. it actually
;; changes what x refers to
(define (make-counter name)
  (let ([n 0])
    (list (lambda (a) (set! n (+ a n))) ;; setter
          (lambda () n)                 ;; getter
          (lambda (n) (set! name n))    ;; setter
          (lambda () name)              ;; getter
          )))

(define object (make-counter "num frogs"))

(define add (first object))
(define show-count (second object))
(define set-name (third object))
(define show-name (fourth object))

> (show-count)
0

> (add 2)

> (show-count)
2

> (show-name)
"num frogs"

> (set-name "frog count")

> (show-name)
"frog count"
```

The functions `add`, `show-count`, `set-name`, and `show-name` all share the
same `name` and `n` variables. This is similar to how methods work in an
objected-oriented language like C++ or Java. `name` and `n` are truly private
variables that can only be accessed through functions.

## Composing Functions

Another interesting feature of [Racket] is **composing** functions. Recall how
function composition works in mathematics. Suppose you have these two functions:

$$
\begin{align*}
f(x) &= x^2 \\
g(x) &= 2x + 1
\end{align*}
$$

The composition of $f$ and $g$ is:

$$
\begin{align*}
f(g(x)) &= g(x)^2 \\
        &= (2x + 1)^2 \\
        &= 4x^2 + 4x + 1
\end{align*}
$$

$\circ$ is the function composition operator:

$$
\begin{align*}
(f \circ g)(x) &= (2x + 1)^2 \\
               &= 4x^2 + 4x +1
\end{align*}
$$

In [Racket], we can compose functions directly by calling them:

```lisp
(define (f x) (* x x))
(define (g x) (+ (* 2 x) 1))

;; h composes f and g
(define (h x) (f (g x)))

> (f 2)
4
> (g 2)
5
> (f (g 2))
25
> (h 2)
25
```

We can also write a function that returns a composed function. For instance, the
`comp` function takes two single-input functions as input and returns their
composition:

```lisp
(define (comp f g)
    (lambda (x) (f (g x))))
```

This lets us define `h` from above without explicitly using `x`:

```lisp
(define h (comp f g))

> (h 2)
25
```

Here we define a function that returns the second element of a list:

```lisp
(define my-second (comp first rest))
```

The list parameter to `my-second` is mentioned anywhere --- it's *implicit*. We
can think of this as saying that `my-second` is a function that first applies
`rest` to its input, and then applies `first` to the result of that.

The `twice` function takes a function, `f`, as input and returns `f` composed
with itself, i.e. $f \circ f$:

```lisp
(define (twice f) (comp f f))
```

For instance:

```lisp
(define garnish 
    (twice (lambda (x) (cons 'cheese x)))
)

> (garnish '(1 2 3))
(cheese cheese 1 2 3)
```

We can generalize `comp` as follows:

```lisp
(define (compose-n f n)
    (if (= n 1)
        f
        (comp f (compose-n f (- n 1)))))

(define triple-cherry 
   (compose-n (lambda (lst) (cons 'cherry lst)) 3))

> (triple-cherry '(vanilla))
'(cherry cherry cherry vanilla)


(define (inc n) (+ n 1))

> ((compose-n inc 5) 1)    
6
```

`compose-n` returns a new function that we could refer to as "`f` to the power
of `n`", where function composition is used instead of multiplication.


## Composing Multiple Functions

[Racket]'s built-in `compose` function lets you compose 2 or more functions.
It's instructive to implement our own version of this, so lets write a function
called `(compose-all f1 f2 ... fn)` that returns the composition of `f1` to
`fn`, i.e. `(f1 (f2 ... (fn x)))`.

A neat feature of this function is that it has a variable number of arguments.
Instead of writing `(compose-all (list f1 f2 ... fn))`, we write `(compose-all
f1 f2 ... fn)`. It works using a `.` like this:

```lisp
(define (compose-all . fns)  ;; fns is the list of arguments
  ;; ...
)
```

`compose-all` is the function name, and `fns` is a list containing all the
arguments passed to it. So when `(compose-all f1 f2 f3)` is called, `fns` is
`(list f1 f2 f3)`.

To write this function, lets look at a concrete example. Suppose we have three
functions `h`, `g`, and `f` (each take 1 input and return 1 output). Using the
$\circ$ operator, we can write the composition of all three as $h \circ g \circ
f$, which is the same as $h \circ (g \circ f)$. This has the structure of a
right fold. 

Recall that right fold has the form `(foldr op init lst)`. What would be `init`
for composition? The answer is the **identity function**, which is a function
that returns whatever you pass it, i.e. $I(x) = x$. For example, $f \circ I =
f$, e.g. $(f \circ I)(x) = f(I(x)) = f(x)$.

Now we can write `compose-all` as a right fold:

```lisp
(define (compose-all . fns)
  (foldr comp
         (lambda (x) x)   ;; identity function
         fns))
```

Here's an example of how this works:

```lisp
(define (f x) (append x (list 'f)))
(define (g x) (append x (list 'g)))
(define (h x) (append x (list 'h)))

(define fgh (compose-all f g h))

> (seq1 '(test))
`(test h g f)
```

This shows that the functions are applied in *reverse* order, which most humans
find counter-intuitive. So lets write a variation of `compose-all` that applies
the functions in the order they are given:

``lisp
(define (pipeline . fns)
  (apply compose-all (reverse fns)))
```

This lets us write the functions in the order they're applied:

```lisp
(define seq2 (pipeline f g h))

> (seq2 '(test))
'(test f g h)
```

Pipelines of function can be quite useful in practice. For example:

```lisp
;; helper functions

;; sort is a built-in function
(define (sort-increasing lst) (sort lst <=))
(define (keep-positives lst) (filter (lambda (x) (> x 0))
                                     lst))

;; functions are applied in the order they are given
(define seq (pipeline
             keep-positives
             sort-increasing
             remove-duplicates))

> (seq '(1 8 8 7 2 2 1 -2 -3))
'(1 2 7 8)
```

## Curried Functions

The idea of **currying** is to treat a function that takes more than 1 input as
a series of functions that take 1 input each.

Here are two different ways to write the addition function:

```lisp
(define add_a          ;; uncurried
    (lambda (x y)
        (+ x y)))

> (add_a 3 4)
7

(define add_b          ;; curried
    (lambda (x)
        (lambda (y)
            (+ x y))))

> ((add_b 3) 4)
7
```

`add_a` takes two inputs, and immediately returns an answer. `add_b` takes only
one input and returns a function. This returned function takes the second input
and returns the sum of the two inputs.

The nice thing about `add_b` is that if we give it only a single input `n`, 
we get a function that can be useful:

```lisp
(define add5 (add_b 5))
```

In [Racket], most functions are *not* written in a curried style. We can write a
function that converts a non-curried function into a curried one:

```lisp
;; given a 2-parameter uncurried function, returns a curried version
(define (curry2 f)
  (lambda (x)
    (lambda (y)
      (f x y))))
```

`curry2` assumes `f` takes exactly 2 inputs:

```lisp
(define add5 ((curry2 +) 5))

> (add5 3)
8
```

`+` is a pre-defined 2-argument function, and so `(curry2 +)` is equivalent to
this:

```lisp
(lambda (x)    ;; curried version of +
  (lambda (y)
    (+ x y)))
```

Thus `((curry2 +) 5)` is this:

```lisp
(lambda (y)
  (+ 5 y))
```

Here's a another example. Recall that `(filter pred? lst)` returns a new list
containing just the elements of `lst` that satisfy the predicate `pred?`:

```lisp
> (filter odd? '(1 2 3 4 5))
'(1 3 5)
```

We could write a curried version like this:

```lisp
(define keep-odds ((curry2 filter) odd?))

> (keep-odds '(1 2 3 4 5))
(1 3 5)
```

Any function that takes 2 inputs can be curried. For example:

```lisp
;; curried versions of some standard functions
(define c_+ (curry2 +))
(define c_cons (curry2 cons))
(define c_filter (curry2 filter))

;; some definitions that use curried functions
(define inc (c_+ 1))
(define f (c_filter odd?))
(define add-cherry (c_cons 'cherry))
```

> [Racket] has built-in functions
> [curry](https://docs.racket-lang.org/reference/procedures.html#%28def._%28%28lib._racket%2Ffunction..rkt%29._curry%29%29)
> and
> [curryr](https://docs.racket-lang.org/reference/procedures.html#%28def._%28%28lib._racket%2Ffunction..rkt%29._curryr%29%29)
> that you should use if you want to curry functions in your programs.

Finally, the `uncurry2` function takes a 2-argument *curried* function as input
and returns a non-curried version of it:

```lisp
;; converts a 2-argument curried function to a non-curried
;; function
(define (uncurry2 f)
  (lambda (x y)
    ((f x) y)))
```

Since functions are non-curried by default, uncurrying isn't common in [Racket].

## Combinators

Lets take a look at some simple higher-order functions called **combinators**.
They are **pure functions**, i.e. functions that don't have any side-effects
(such as changing global values, printing to the screen, opening a file, etc.),
and whose result is always the same for the same input. They can be combined to
build many other functions, and are of interest in theoretical computer science.

### The I Combinator

`(I x)` is the **identity function**, and it returns whatever you pass it:

```lisp
(define (I x) x)

> (I 4)
4
> (I '(a b c))
'(a b c)
> (I I)
#<procedure:I>
```

### The M Combinator

The function `(M x)` takes a function `x` as input, and calls `x` on itself:

```lisp
(define (M x) (x x))

> (M list)       ;;  (list list)
'(#<procedure:list>)
> (M symbol?)    ;;  (symbol? symbol?)
#f
> (M I)          ;;  (I I)
#<procedure:I>
> (M 4)          ;;  (4 4)
. . application: not a procedure;
 expected a procedure that can be applied to arguments
  given: 4
  arguments...:
```

The expression `(M M)` is interesting: it is an *infinite loop* that never
returns a value. When you call `(M M)`, the argument `M` replaces `x` in the
body of function `M`, i.e. `(x x)` becomes `(M M)`. This evaluates to `(M M)`,
and the same thing happens again and again forever.

We could write `M` as a lambda function:

```lisp
(lambda (x) (x x))
```

Then the call `(M M)` is the same as:

```lisp
((lambda (x) (x x)) (lambda (x) (x x)))
```

Just like `(M M)`, this expression never returns a value and loops forever.
There's no explicit loop or recursion here. It shows the non-obvious fact that
you can create an infinite loop just from calling lambda functions.


### The K Combinator

The function `(K x)` returns a function that takes a single input `y`, and for
any value of `y` returns `x`. In other words, it returns a *constant* function
that always returns `x`:

```lisp
(define (K x) (lambda (y) x))

> ((K 'pizza) 'ignored)
'pizza

> (map (K 5) '(a b c d))
'(5 5 5 5)
```

### The S Combinator

Function `S3` takes 3 inputs:

```lisp
(define (S3 x y z)
  ((x z) (y z)))
```

This is pretty weird! `x` and `y` are functions, and `z` is an argument to both.
`x` must also return a function that can be applied to the output of `y`. Here
is an example of calling it:

```lisp
;; helper functions
(define (make-add a) (lambda (n) (+ n a)))
(define (times2 n) (* 2 n))

> (S3 make-add times2 3)
9
```

The call to `S3` is evaluated like this:

- `(S3 make-add times2 3)`
- `((make-add 3) (times2 3))`
- `((make-add 3) 6)`
- `((lambda (n) (+ n 3)) 6)`
- `(+ 6 3)`
- `9`

Intuitively, `S3` can be thought of as a generalization of function composition.
`(S3 x y z)` composes `x` and `y` --- but first it calls `x` on `z` and `y` on
`z` (and composes the results).

`S` is a curried version of `S3`. You can pass 0, 1, 2, or 3 arguments to `S`
(you must always pass exactly 3 arguments to `S3`):

```lisp
(define S (curry S3)) ;; curry is a built-in function
```

This lets us pass 0, 1, 2, or 3 arguments to `S`, which is useful for combining
combinators.

### I in Terms of S and K

Interestingly, the identity function `I` can be defined in terms of `S` and `K`
like this:

```lisp
(define (I a) ((S K K) a))

> (I 4)
4
> (I '(a b c))
'(a b c)
> (I I)
#<procedure:I>
```

To see why this is true, let's evaluate `((S K K) 'a)`.  Since `S` is curried,
`(S K K)` is a evaluates to a function that takes one argument, which in this
case is `'a`. Thus `((S K K) 'a)` evaluates to the same thing as `(S3 K K 'a)`.

Following the definition of `S3`, `(S3 K K 'a)` evaluates to `((K 'a) (K 'a))`.
`(K 'a)` returns a function that always returns `'a` so `((K 'a) (K 'a))`
evaluates to `'a`. And so `((S K K) 'a)` evaluates to `'a`, which means `(S K
K)` is the identity function.

### Completeness of S and K

Most programmers quite naturally wonder about the purpose of small functions
like `S` and `K`. Why bother? They don't seem very useful.

Surprisingly, functions `S` and `K` can be combined to define *any* other pure
function. You could think of `S` and `K`  like a low-level assembly language for
pure functions, or as the atoms of computation. Of course, the function might
not be efficient or readable, but it can be done.

We won't cover the proof here, but check out [the Wikipedia page on
combinatory
logic](https://en.wikipedia.org/wiki/Combinatory_logic#Completeness_of_the_S-K_basis)
if you're curious.

# Optional: The Scope of Names: Static Scoping vs Dynamic Scoping

The **scope** of a name is where it is visible. A **local variable** is a
variable whose scope is restricted to the block of code where it was declared. A
**nonlocal variable** is visible outside of the block in which it was declared.
**Global variables** are nonlocal variables that can be used anywhere in a
program.

Most modern languages, including [Racket], are **statically scoped** (or
**lexically scoped**). This means that a variable's scope can be determined
*before* the program runs just by examining the source code. Static scoping
helps programmers to read source code and determine what values names are bound
to without the need to run the code.

Consider this [Racket] code:

```lisp
(define x 1)
(define f (lambda (x) (g 2)))
(define g (lambda (y) (+ x y)))  ;; Which x does this refer to?
```

[Racket] is statically scoped, and so if you evaluate `(f 5)` the answer is 3
(because the `x` in `g` refers to the `x` whose value is 1). If [Racket] were
instead dynamically scoped, i.e. if the most recently encountered variable named
`x` was used in `g`, then the answer would be 7.

It is useful to trace this in some detail. Before `(f 5)` is called, `x` was
bound to 1 by the first `define`. When `(f 5)` is called, the 5 is bound to
`x` in the lambda expression for `f`. Then `(g 2)` is called, and the 2 is
bound `y` in the lambda expression for `g`. So at this point, there are three
bound variables: `x` bound to 1, `x` bound to 5, and `y` bound to 2. In `g`s
body expression `(+ x y)`, what value should be used for `x`? Should it be 1,
or should it be 2? [Racket] is statically scoped, and so it decides on
bindings *before* the code runs, which means it must use the `x` bound to 1.
However, in a **dynamically scoped** language, the most recently bound value
of `x` is used. If [Racket] were dynamically scoped, then `(f 5)` would print
7.

Here's a  [JavaScript] example of static scoping:

```javascript
function big() {
    function sub1() {
        var x = 7;   // hides the x defined in big
        sub2();
    }

    function sub2() {
        var y = x;      // which x does this refer to?
    }
    var x = 3;
    sub1();
}
```

[JavaScript] is statically scoped, and so the `x` in `sub2` is the `x` with the
value 3 that is defined in `big`. If [JavaScript] were dynamically scoped, then
`x` would refer to the most recently bound `x` at runtime, i.e. the `x` bound to
7.

Dynamic scoping is an alternative to static scoping that has largely fallen out
of favor. Most examples of dynamic scoping occur in older languages, such as
[APL](https://en.wikipedia.org/wiki/APL_(programming_language)),
[SNOBOL](https://en.wikipedia.org/wiki/SNOBOL), and early versions of [LISP].
Some languages, such as [Perl], let you optionally declare variables that follow
dynamic scoping rules.

The idea of dynamic scoping is that the meaning of a variable depends upon the
value of the most recent variable with the same name in the current function
call stack (as opposed to the enclosing block of source code).

Here is one more example showing the difference between static and dynamic
scoping using a C++-like language:

```cpp
const int b = 5;    

int foo()
{
   int a = b + 5;  // What is b?
   return a;
}
 
int bar()
{
   int b = 2;
   return foo();
}
 
int main()
{
   foo(); // returns 10 for static scoping; 10 for dynamic scoping
   bar(); // returns 10 for static scoping; 7 for dynamic scoping
}
```

In general, dynamic scoping makes it harder to reason about the meaning of
programs from their source code alone. Under dynamic scoping, you can't always
tell for sure what a variable refers to until the code runs, because the order
in which functions are called matters.

Another problem with dynamic scoping is that it exposes the local variables of a
function to other functions, thus allowing the possibility that they could be
modified. This breaks function encapsulation.

On the plus side, dynamic scoping is easier to implement than static scoping.


[Scheme]: https://en.wikipedia.org/wiki/Scheme_(programming_language)
[Racket]: https://racket-lang.org/
[LISP]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java
[JavaScript]: https://en.wikipedia.org/wiki/JavaScript
[EBNF]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
[Go]: https://golang.org/
[Perl]: https://en.wikipedia.org/wiki/Perl
