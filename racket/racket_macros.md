# Racket Macros

## Introduction

Regular [Racket] functions evaluate their arguments *before* they're passed into
the function. For example, if `f` is a function then `(f (+ 2 3) (- 4 1))` is
the same as `(f 5 3)`. For most operations, this style of evaluation is
efficient and works well.

But some [Racket] forms don't work this way. For instance, `define` isn't a
function:

```lisp
(define (f a b)
    (* a (+ b 2)))
```

`define` does *not* evaluate its arguments immediately. If it did, then it would
try to evaluate `(f a b)` like a function call, which would cause an error
because `f` is undefined.

Similarly, conditional operations, such as `if`, `cond`, `and`, and `or`, don't
necessarily evaluate all their arguments. For example:

```lisp
(if (equal? code 1)
    (launch-missiles)
    (do-not-launch-missiles)
```

An `if` form evaluates only one possibility, never both. If `if` were a regular
[Racket] function, then no matter the value of `code` both `(launch-missiles)`
and `(do-not-launch-missiles)` would be evaluated.

One last example: `let`-environments introduce new variables into a scope:

```lisp
(let ([a 1]
      [b 2])
   (+ a b))
```

If `let` were a regular function, then `([a 1] [b 2])` would be evaluated, which
would be an error since `a` and `b` are not defined.

These examples show that regular functions *can't* implement some of the forms
we see in [Racket]. Many programmers are okay with this: most other languages
don't let you create new kinds of if-statements, or new ways to define
functions.

But for those programmers who do want to implement such things, [Racket]
provides **macros**. [Racket]'s macros are much more useful than the
string-oriented macros you might have seen in C/C++. If you want to implement
your own language features --- or even your own entire language --- macros will
help you do this.

Macros are a relatively complex feature of [Racket], and here we will only
discuss a few basic examples. If you are curious to learn more, check out some
on-line resources such as [Let Over Lambda](https://letoverlambda.com/) and
[Beautiful Racket](https://beautifulracket.com/).

## A First Macro: assert

The following example is from [Macros and Languages in
Racket](http://rmculpepper.github.io/malr/basic.html).

Suppose we want to implement the form `(assert bool-expr)` that does *nothing*
if `bool-expr` evaluates to `#t`, but, if `expr` evaluats to `#f`, prints an
error message with the *unevaluated* `bool-expr` in it. Such a macro can be
useful during program development.

Implementing it as a [Racket] function doesn't work:

```lisp
(define (assert-bad expr)
    (when (not expr)
        (error 'assert "assertion fail: ~s" expr))

> (assert-bad (= 2 2))  ;; does nothing if expr is #t
> (assert-bad (= 1 2))
. . assert: assertion fail: #f
```

> The form `(when <test> <body>)` evaluates to `body` if `test` is `#t`, and
> does nothing if `test` is `#f`. It's a kind of conditional form that only
> evaluates to a useful value if `test` is `#t`.

The problem is the error message in the second call: it prints `#f`, when
instead what we want to see is the unevaluated expression `(= 1 2)`. But
`assert-bad` can't possibly print `(= 1 2)` because it gets passed `#f`, the
value of  `(= 1 2)`.

You could add a second parameter to get the right error message:

```lisp
(define (assert-also-bad expr quoted-expr)
    (when (not expr)
        (error 'assert "assertion fail: ~s" quoted-expr)))

> (assert-also-bad (= 1 2) '(= 1 2))
. . assert: assertion fail: (= 1 2)
```

This requires the programmer to pass in *two* copies of the expression, one
quoted and one not quoted. That's both error-prone and messy, and not much of an
improvement.

A macro solves the problem:

```lisp
(define-syntax-rule (assert expr)
  (when (not expr)
    (error 'assert "assertion failed: ~s" (quote expr))))

> (assert (= 1 2))
. . assert: assertion failed: (= 1 2)
```

Here, a single non-quoted instance of `(= 1 2)` is passed in, and both its
evaluated and non-evaluated form can be used. In the body of `assert`, you can
see that `expr` is evaluated, but `(quote expr)` is not: the programmer decides
which form of `expr` to use.

Using the same idea, here's a macro for printing an expression and its
evaluation:

```lisp
(define-syntax-rule (print-val expr)
  (printf "~a ==> ~a" (quote expr) expr))

> (print-val (+ 1 2))
(+ 1 2) ==> 3

> (print-val (cons 'a '(1 2 3)))
(cons 'a '(1 2 3)) ==> (a 1 2 3)

> (define x 14)
> (print-eval x)
x ==> 14

> (print-eval even?)
even? ==> #<procedure:even?>
```

This macro could be used for debugging, or in a program that makes quiz
questions to help beginning programmers evaluate [Racket] expressions.

In the call `(print-val (+ 1 2))`, `(+ 1 2)` is *not* quoted. If it was, we'd
get this:

```lisp
> (print-val '(+ 1 2))
'(+ 1 2) ==> (+ 1 2)
```

Here's one more example. This macro prints a message *before* evaluating an
expression:

```lisp
(define-syntax-rule (noisy expr)
  (begin
    (printf "evaluating ~a ...\n" (quote expr))
    expr))

> (noisy (filter odd? '(1 2 3 4 5)))
evaluating (filter odd? '(1 2 3 4 5)) ...
'(1 3 5)
```

The form `(begin expr_1 expr_2 ... expr_n)` evaluates each of `expr_1` to
`expr_n` in the order they occur, and then returns the value of `expr_n`.

## Basic Macro Expansion

To better understand macros, it's useful to trace how macros get called. For
example, when we call `(assert (= 1 2))`, we can imagine that it gets *expanded*
into this expression:

```lisp
(when (not (= 1 2))
  (error 'assert "assertion failed: ~s" (quote (= 1 2))))
```

This expression then gets *evaluated* to give the final result of calling
`(assert (= 1 2))`.

If you look at the body of the `assert` macro, you can see that the expanded
form is essentially a search-and-replace operation, i.e. every occurrence of
`expr` gets replaced with `(= 1 2)`.

In general, macro calls always go through this two-step procedure: first
*expansion*, and then *evaluation* of the expanded form.


## Hygienic Macros

Suppose we wanted to write our own `or` macro. For simplicity, lets restrict it
to exactly two inputs ([Racket]s built-in `or` takes 0 or more inputs). Here's a
first attempt:

```lisp
(define-syntax-rule (my-or-bad e1 e2)
  (if e1 e1 e2))
```

Logically, this is correct: it returns true if `e1` or `e2`, or both, evaluate
to `#t`. It is even short-circuited, i.e. if `e1` is `#t` then `e2` is not
evaluated.

However, it has a fatal flaw: `e1` might be **evaluated twice**. Not only is
that inefficient, but it could be incorrect when `e1` has side-effects (such as
printing to the screen or opening a file).

To fix this problem, we can use `let` to ensure that `e1` is evaluated only
once:

```lisp
(define-syntax-rule (my-or e1 e2)
  (let ([x e1])
    (if x x e2)))
```

This works! 

What's interesting is that if you think about how this macro expands, you might
think it ought to *fail* in some cases. Consider this:

```lisp
> (define x 5)       ;; global x
> (my-or #f (= x 5))
#t
```

`(my-or #f (= x 5))` would seem to expand to this:

```lisp
(let ([x #f])
  (if x x (= x 5)))
```

When this form is evaluated, each `x` in the `if` statement is replaced by `#f`,
and so returns the same value as:

```lisp
(if #f #f (= #f 5))  ;; error!
```

This returns the value of `(= #f 5)`, which is an error (`=` only works with
numbers). This is an example of **variable capture**: the local `x` variable in
`my-or` "captured" the passed-in variable `x` with the same name, and phenomenon
that can cause subtle bugs in programs.

So it seems `(my-or #f (= x 5))` *should* cause an error. But it doesn't: it
*correctly* returns `#t`.

What's happening here is that [Racket] has automatically *renamed* the `x`
variable in the `assert` macro to a name different than any other variable in
`expr`. It does this precisely to avoid having a local variable "capture" a
passed-in variable with the same name as has happened in this example.

Since the macro system in [Racket] *automatically* does this renaming, [Racket]
macros are called **hygienic macros**. With hygienic macros, you don't need to
worry about variable name clashes.

How does [Racket] get a new variable name that is not used anywhere else?
Conceptually, you can imagine that [Racket] uses the built-in `gensym` function:

```lisp
> (gensym)
'g12792

> (gensym)
'g12808
```

Every time `gensym` is called, it returns a new **uninterned** symbol, i.e. a
symbol that is not yet used anywhere in [Racket] and thus is guaranteed to be
unique. So the local `x` in `my-or` can be thought of as being renamed to a new
`gensysm`-created variable.

## Example: Non-hygienic Macros in C++

In C++, macros are *not* hygienic. Consider this example from [the Wikipedia
article on hygienic macros](https://en.wikipedia.org/wiki/Hygienic_macro):

```cpp
#define INCI(i) do { int a = 0; ++i; } while (0)

int main(void)
{
    int a = 4, b = 8;
    INCI(a);
    INCI(b);
    printf("a is now %d, b is now %d\n", a, b);
}
```

The pre-processor expands the `INCI` macro giving this code:

```cpp
int main(void)
{
    int a = 4, b = 8;
    do { int a=0; ++a; } while(0);  // oops: a defined in main is never changed!
    do { int a=0; ++b; } while(0);
    printf("a is now %d, b is now %d\n", a, b);
}

// a is now 4, b is now 9
```

Since `INCI` happens to use `a` as its index variable, the first do-loop doesn't
actually modify the `a` variable defined in `main`. Of course, you could fix
this by renaming the variable `a` in `INC` to, say, `i`. But then you'll get the
same problem if you call `INC(i)`.

[Racket]: https://racket-lang.org/
