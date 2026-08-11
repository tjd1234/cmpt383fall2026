# The Racket match Form

Please read [Matching](https://docs.racket-lang.org/guide/match.html) from the
[Racket] notes.

## Simple Expressions

`match` is a useful [Racket] form that checks for patterns in almost any
[Racket] expression. To see how it works, consider the problem of recognizing
**simple infix** expressions defined like this:

- numbers, e.g. -2, 4.6, 0, ...

- unary expressions of the form `(op x)`, e.g. `(- 7)`, `(- x)`, `(+ a)`, ...

- binary expressions of the form `(x op y)`, e.g. `(1 + a)`, `(41 / 2)`, ....
  `x` and `y` are always numbers or symbols, and never other expressions.

## Checking Simple Expressions without match

One way to check for simple infix expressions is to build a checking function
out of smaller helper functions:

```lisp
;; returns true iff x is a list of length n
(define (nlist? x n)
  (and (list? x)
       (= n (length x))))

(define all-bin-ops '(+ - * /))
(define all-unary-ops '(- +))

(define (is-basic-expr? x)
  (or (number? x)
      (and (nlist? x 2) (member (first x) all-unary-ops))
      (and (nlist? x 3) (member (second x) all-bin-ops))))

> (is-basic-expr? '(+ 2))
#t

> (is-basic-expr? '(4 + 2))
'(+ - * /)

> (is-basic-expr? '(4 + 2 + 1))
#f
```

`nlist?` is quite useful here, and is how we distinguish between unary and
binary expressions.

## Matching Simple Expressions

Now lets use `match` to write the same function:

```lisp
(define (is-basic-expr2? x)
  (if (number? x) 
       #t  ;; numbers are always basic expressions
      (match x       
        [(list op a)   (member op all-unary-ops)]
        [(list a op b) (member op all-bin-ops)]
        [_             #f]  ;; _ matches anything
    )))  

> (is-basic-expr? '(+ 2))
#t

> (is-basic-expr? '(4 + 2))
'(+ - * /)

> (is-basic-expr? '(4 + 2 + 1))
#f
```

`match` recognizes patterns in lists, or other [Racket] data structures (like
vectors). After `(match x ...` you write `[pattern expr]` lists where `pattern`
describes a possible pattern for `x`, and `expr` is the expression to evaluate
if the pattern matches. This is similar to `cond`, but much more flexible.

Notice that `_` (not `else`!) matches *anything*. We use it as a catch-all when
none of the earlier patterns match.

`(member x lst)` returns `#t` if `x` is an element of `lst`, and `#f` otherwise.

## Matching with Quasiquoting

**Quasiquoting** often works well with `match`. Quasiquoting is like regular
quoting, but you use a *backquote*, and you can *unquote* parts of the
expression using a comma. For example:

```lisp
> '(a (+ 1 2) c)   ;; quoted expression
'(a (+ 1 2) c)

> `(a ,(+ 1 2) c)   ;; quasiquoted expression
'(a 3 c)
```

With `match`, you can use quasiquoting to match parts of the expression:

```lisp
(define (is-basic-expr3? x)
  (or (number? x)
      (match x       
        [`(,op ,a)    (member op all-unary-ops)]
        [`(,a ,op ,b) (member op all-bin-ops)]
        [_            #f]
        )))
```

`` `(,op ,a)`` is the same as `(list op a)`, and visually looks more like the
structure of the list it matches.

Another way write this is to explicitly list every case:

```lisp
(define (is-basic-expr4? x)
  (or (number? x)
      (match x       
        [`(- ,a)    #t]
        [`(+ ,a)    #t]
        [`(,a + ,b) #t]
        [`(,a - ,b) #t]
        [`(,a * ,b) #t]
        [`(,a / ,b) #t]
        [_          #f]
        )))
```

This version shows all the patterns and does away with the `all-unary-ops`
variable. Just by looking at the `match` expression we can see all the
operators. In the pattern `(,a + ,b)`, the `+` does *not* have a comma in front
of it, and so an actual `+` symbol must appear in `x` to match.

Now suppose want to *evaluate* our infix expressions, i.e. `(3 + 6)` evaluates
to 9. With a few small changes to `is-basic-expr4` we get this:

```lisp
(define (basic-eval x)
  (if (number? x) x
      (match x       
        [`(- ,a)    (- a)]
        [`(+ ,a)    (+ a)]
        [`(,a + ,b) (+ a b)]
        [`(,a - ,b) (- a b)]
        [`(,a * ,b) (* a b)]
        [`(,a / ,b) (/ a b)]
        [_ (error "basic-eval: bad expression")])))

> (basic-eval '(4 + 3))
7

> (basic-eval '(4 / 3))
1 1/3

> (basic-eval '(4 ^ 2))
'error
```

If `x` is not a valid expression, then `basic-eval` causes an error using the
`error` function.

Division by 0 causes this error:

```lisp
> (basic-eval '(2 / 0))
. . /: division by zero
```

Suppose we want a customized error message for division by 0. We add that using
another pattern:

```lisp
(define (basic-eval x)
  (if (number? x) x
      (match x       
        [`(- ,a) (- a)]
        [`(+ ,a) (+ a)]
        [`(,a + ,b) (+ a b)]
        [`(,a - ,b) (- a b)]
        [`(,a * ,b) (* a b)]
        [`(,a / 0) (error "basic-eval: div by 0")]
        [`(,a / ,b) (/ a b)]
        [_ (error "basic-eval: bad expression")])))

> (basic-eval '(2 / 0))
. . basic-eval: div by 0
```

The order of the patterns matters here: we must check for division by 0 *before*
regular division.

Now lets generalize `basic-eval` to allow for sub-expressions, i.e. we want to
evaluate full infix expressions like `((4 / 2) - (2 * 3))`. We can do it like
this:

```lisp
(define (arith-eval x)
  (if (number? x) x
      (match x
        [`(- ,a)    (- (arith-eval a))]
        [`(+ ,a)    (+ (arith-eval a))]
        [`(,a + ,b) (+ (arith-eval a) (arith-eval b))]
        [`(,a - ,b) (- (arith-eval a) (arith-eval b))]
        [`(,a * ,b) (* (arith-eval a) (arith-eval b))]
        [`(,a / ,b) (/ (arith-eval a) (arith-eval b))]
        [_ (error "arith-eval: bad expression")])))

> (arith-eval '((1 - 2) * (10 / (2 * 2))))
-2 1/2
```


## Challenge: calculating with history

Implement a function called `(arith-eval2 x)` that is similar to `arith-eval`,
but adds every expression it evaluates, along with it's associated result, to a
global variable named `history`. `history` is a list that records all
calculations done by `arith-eval2` as `(expression value)` pairs. The most
recent values are on the *right end* of `history`.

Assume `history` is defined globally like this:

```lisp
(define history '())
```

Instead of calling the `error` function for invalid expressions, `arith-eval2`
should instead return the symbol `'error`. As shown in the example below, errors
should be recorded on `history`.

Here are some examples of how it should work:

```lisp
> history
'()

> (arith-eval2 '(1 + (3 * 4)))
13

> history
'(((1 + (3 * 4)) 13))

> (arith-eval2 '(5 * 5))
25

> history
'(((1 + (3 * 4)) 13) ((5 * 5) 25))

> (arith-eval2 '(5 * 5 * 5))
'error

> history
'(((1 + (3 * 4)) 13) ((5 * 5) 25) ((5 * 5 * 5) error))
```

**Hint** Use the `(set! var val)` form to change `history`. For example:

```lisp
> (define food '())

> food
'()

> (set! food (cons 'cereal food))

> food
'(cereal)
```

## Matching with Names

Suppose you want to match [Racket] *function definitions*, such as `(define (add
a b) (+ a b))`. When you make a match you want to extract the name, the
parameter list (`(a b)` in this example), and the body of the function.

Here's one way to do it:

```lisp
(define (is-def? e)
  (match e
    [(list 'define (list name params ...) body) 
      (list name params body)]
    [_ #f]))

> (is-def? '(define (inc x) (+ x 1)))
'(inc (x) (+ x 1))

> (is-def? '(inc 5))
#f
```

In the matching expression, `(list name params ...)` matches a list with one, or
more, elements. The first matched element is called `name`, and the rest of the
elements are put in a list called `params`. The `...` indicates that 0, or more,
following elements can occur.


## Challenge: matching lambda functions

Using `match`, implement a function called `(is-lambda? e)` that matches just
lambda functions like `(lambda (n) (* n n))` or `(lambda (a b) (+ a b))`. If `e`
is a lambda function, then return a list containing its parameters followed by
its function body.

For example:

```lisp
> (is-lambda? '(lambda (n) (* n n)))
'((n) (* n n))
> (is-lambda? '(lambda (a b) (+ a b)))
'((a b) (+ a b))

> (is-lambda? '(define (add a b) (+ a b)))
#f
> (is-lambda? 'lambda)
#f
```

[Scheme]: https://en.wikipedia.org/wiki/Scheme_(programming_language)
[Racket]: https://racket-lang.org/
[LISP]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java
