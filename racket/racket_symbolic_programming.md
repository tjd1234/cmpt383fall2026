# Symbolic Programming in Racket

One of the original uses of [LISP] was for **symbolic programming**, doing
algebra and logic. Still today it is a good tool for such problems, so lets look
at some example.

## Propositional Logic Examples

Lets write some functions that process a language of **literal boolean
propositional expressions** like `(t and (not f))` and `((f or f) and ((not t)
and f))`. The symbols `t` and `f` stand for *true* and *false*, and, at least to
start, we will not have any variables. We are *not* using the built-in [Racket]
boolean values (`#t` and `#f`) since this is our own little language different
from [Racket].

## Checking Valid Expressions

We'll code two different solutions: one using many small helper functions, and
the second way using `match`.

The first implementation relies on these helper functions:

```lisp
#lang racket

(define (is-true? e) (equal? e 't))
(define (is-false? e) (equal? e 'f))

(define (is-literal? e)
  (or (is-false? e)
      (is-true? e)))

;; returns true iff lst is a list of length n
(define (nlist? n lst)
  (and (list? lst) 
       (= n (length lst))))

;; (not expr)
(define (is-not? e)
  (and (nlist? 2 e)
       (equal? 'not (first e))))

;; (p op q)
(define (is-bin-op? e op)
  (and (nlist? 3 e)
       (equal? op (second e))))
 
(define (is-and? e) (is-bin-op? e 'and))  ;; (p and q)
(define (is-or? e) (is-bin-op? e 'or))    ;; (p or q)
```

These are all non-recursive functions that check only the top-level form of an
expression. They *don't* check if expressions inside sub-lists are valid.

With these helper function we can now write a recursive function that tests for
valid expressions:

```lisp
(define (is-expr? e)
    (cond
      [(is-literal? e) 
         #t]
      [(is-not? e) 
         (is-expr? (second e))]
      [(is-and? e)
         (and (is-expr? (first e))
              (is-expr? (third e)))]
      [(is-or? e)
         (and (is-expr? (first e))
              (is-expr? (third e)))]
      [else 
         #f]))

> (is-expr? '(t and (not f)))
#t

> (is-expr? '((f or f) and ((not t) and f)))
#t

> (is-expr? '((f or a) and t))
#f
```

### Challenge: checking expressions with or

Implement `(is-expr2? e)` that does the same thing as `'is-expr`, but instead of
`cond` use `or`.

## Evaluating Propositions

Given a valid propositional expression, `eval-prop-bool` determines if it is
true or false:

```lisp
(define (eval-prop-bool e)
    (cond
      [(is-literal? e)
         (is-true? e)]
      [(is-not? e)
         (not (eval-prop-bool (second e)))]
      [(is-and? e)
         (and (eval-prop-bool (first e)) 
              (eval-prop-bool (third e)))]
      [(is-or? e)
         (or (eval-prop-bool (first e)) 
             (eval-prop-bool (third e)))]
      [else 
         #f]))

(define (eval-prop e)
   (if (eval-prop-bool e) 't 'f))

> (eval-prop '((not t) and (t or (not f))))
f
```

`eval-prop-bool` returns [Racket] boolean values, i.e. `#t` and `#f`. We do this
for convenience so that we can use the built-in [Racket] forms `and`, `or`, and
`not`. If instead we returned `'t` and `'f`, we'd have to write special-purpose
versions of `and`, `or`, and `not` that work with `'t` and `'f`.

### Checking Propositional Expressions Using match

`is-expr?` and `eval-prop` can be implemented using `match`:

```lisp
(define (is-expr2? e)
  (match e
    ['t           #t]
    ['f           #t]
    [`(not ,a)    (is-expr2? a)]
    [`(,a or ,b)  (and (is-expr2? a)
                       (is-expr2? b))]
    [`(,a and ,b) (and (is-expr2? a)
                       (is-expr2? b))]
    [_            #f]
    ))

(define (eval-prop-bool2 expr)
  (match expr
    ['t           #t]
    ['f           #f]
    [`(not ,a)    (not (eval-prop-bool2 a))]
    [`(,a or ,b)  (or (eval-prop-bool2 a)
                      (eval-prop-bool2 b))]
    [`(,a and ,b) (and (eval-prop-bool2 a)
                       (eval-prop-bool23 b))]
    [_ (error "eval-prop-bool3: syntax error")]
    ))
```

We no longer need the helper functions, since `match` takes care of recognizing
the expressions.


## EBNF: Extended Backus-Naur Form

`is-expr?` is a precise definition of what is, and isn't, a valid boolean
literal expression. It defines the legal expressions of a small language.

A more common way to specify a language is to use [Extended Backus-Naur
Formalism](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form), or
[EBNF] for short. [EBNF] is designed for precisely defining the *syntax* (not
semantics!) of programming languages.

**Syntax** is the grammatical structure of the language. For example, `(define x
3)` is a syntactically valid [Racket] expression, but `define x 3)` and `(x is
3)` are not syntactically valid. The **semantics** of a language is it's
meaning. For example, the semantics of `(define x 3)` is something like "make a
new variable called `x` and initialize it to 3".

An [EBNF] description consists of a series of named **productions**, which are
rules of this general form:

```
production-name = body .
```

Whenever you see a `production-name` in an [EBNF] rule, you can replace it with
the `body` of its rule. The `.` at the end marks the end of the rule. A set of
productions is called a **grammar**, and grammars can precisely define the
syntax of a language. This greatly aids in the creation of language processing
tools like
[tokenizers](https://en.wikipedia.org/wiki/Lexical_analysis#Tokenization) and
[parsers](https://en.wikipedia.org/wiki/Parsing).

We'll use the [Go EBNF notation](https://golang.org/ref/spec#Notation), which is
designed specifically for use in text. For example, here is the production that
[Go] uses to define its assignment operator:

```
assign_op = [ add_op | mul_op ] "=" .
```

Anything in ""-marks indicates a **token** or symbol that appears as-is in the
language. So in this production, the `"="` at the end means a `=` character
appears in the [Go] program, while the `=` near the start is part of the [EBNF]
rule.

Two other [EBNF] operators appear in this production. `|` is the
**alternation** operator, and indicates a choices between two alternatives.
`add_op | mul_op` means you can chose either `add_op` or `mul_up` (but not
both). `add_op` is also defined with the alternation operator:

```
add_op = "+" | "-" | "|" | "^" .
```

This production, named `add_op`, says that an `add_op` is either `+`, `-`, `|`,
or `^`. `add_op` is defined by listing all the possible alternatives.

The `[]` operator indicates an **optional** expression that can occur 0, or 1,
times. The expression `[ add_op | mul_op ]` means that the entire expression can
appear, or not appear. If it does occur, then, because of the `|`, either
`add_op` or `mul_op` is chosen.

Another [EBNF] operator is `{}`, which indicates **repetition** 0, or more,
times. For example:

```
identifier     = letter { letter | unicode_digit } .
letter         = unicode_letter | "_" .

decimal_digit  = "0" ... "9" .
decimal_digits = decimal_digit { [ "_" ] decimal_digit } .
```

This describes legal identifiers in [Go], i.e. the legal names for variables,
functions, structs, types, and so on. It says that an identifier must start with
a `letter`, and then be followed by 0 or more letters or digits.

In [the Go EBNF notation](https://golang.org/ref/spec#Notation)] `...` is an
informal short-hand that indicates an "obvious" pattern. So the `decimal_digit`
production is understood to be equivalent to this:

```
decimal_digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
```

The `identifier` rule lets us check if a sequence of characters is a legal
identifier name. For example, `up2` is a legal [Go] identifier. We can verify
this by tracing the `identifier` production. The first character, `u`, is a
valid `letter`, and the next character is a valid `letter`. The 2 is a valid
digit, and so the entire identifier is valid.

Now consider `4xyz`, which is *not* a valid [Go] identifier. It starts with `4`,
but according to the `letter` production `4` is *not* a valid starting letter.
So `4xyz` is *not* an `identifier`.

The `unicode_letter` production allows all characters marked as "Letter" by
Unicode. There are thousands of such characters, so they are not listed
explicitly.


## Example: EBNF Rules for Literal Propositional Expressions

Now lets write an [EBNF] grammar to describe the boolean literal expressions
recognized by `(is-expr? e)`:

```
        expr =  bool-literal | not-expr 
              | and-expr     | or-expr .

bool-literal = "t" | "f" .

    not-expr = "(" "not" expr ")" .

    and-expr = "(" expr "and" expr ")" .

     or-expr = "(" expr "or" expr ")" .
```

This [EBNF] grammar closely mimics the implementation of `is-expr?`, and so if
you start with the grammar it is often straightforward to create the
corresponding checking function.

[EBNF] *doesn't* require the productions to appear in any particular order. But,
for humans, we usually group related productions together, and often put them in
order from either from most general to specific, or most specific to general.

The syntax of this propositional expression language is very [Racket]-like, and
every expression is fully-bracketed. This means we don't need to define the
precedence of operators, since the brackets always make that explicit.


### Example: Parsing

Consider the `not-expr` production. It is recursive because it expands into an
expression involving `expr`, which could expand into another `not-expr`, and so
on. This allows us to show that an expression like `(not (not t))` is valid as
follows:

```lisp
expr = not-expr
     = "(" "not" expr ")"
     = "(" "not" not-expr ")"
     = "(" "not" "(" "not" expr ")" ")"
     = "(" "not" "(" "not" bool-literal ")" ")"
     = "(" "not" "(" "not" "t" ")" ")"
```

Each step expands one part of the expression, and, by making the right choice of
rules, eventually we get the exact expression we want. A program that does this
automatically is called a **parser**.


## Example: EBNF for Racket cond Expressions

Here's an [EBNF] description for a [Racket] `cond` expression:

```lisp
cond-expr = "(" "cond" { test-val } [else-val] ")" .

test-val  = "(" bool value ")" .

else-val  = ("else" | "#t") value .

bool      = any Racket expression that evaluates to 
            #t or #f .

value     = any Racket expression that evaluates to 
            a value .
```

Note that the ()-brackets in the `else-val` production are *not* in "-marks.
Unquoted ()-brackets are used for **grouping** in Go's [EBNF], and in `else-val`
they are needed to precisely indicate the right structure:

```lisp
else-val  = ("else" | "#t") value .    // right

else-val  = "else" | ( "#t" value ) .  // wrong 

else-val  = "else" | "#t" value .      // ambiguous
```

This is *not* the official definition of a [Racket] `cond`. See the
[documentation on if-statements](https://docs.racket-lang.org/reference/if.html)
for the official syntax. [Racket] uses a different formal notation for
describing syntax, but it is conceptually very similar to what we're using.


## Example: nand-only Expressions

In [propositional logic](https://en.wikipedia.org/wiki/Propositional_calculus),
`nand` is one of the standard logical operators. `(p nand q)` is true just when
`p` and `q` are not both *true*, and false otherwise. In other words, `(p nand
q)` is logically equivalent to `(not (p and q))`.

Here's an [EBNF] description of a nand-only language:

```
expr = "t" | "f" | nand .

nand = "(" expr "nand" expr ")" .
```

This is simple enough to be written as one rule:

```
expr =   "t"
       | "f"
       | "(" expr "nand" expr ")" .
```

Both grammars describe the same language. The second one relies on formatting to
help avoid ambiguity, i.e. each of the 3 lines in the production describe one
kind of string.

Now let's implement some helper functions based on this grammar. First,
`(is-nand? expr)` tests if `expr` is a valid nand-only expression:

```lisp
(define (is-nand? expr)
  (match expr
    ['t            #t]
    ['f            #t]
    [`(,a nand ,b) (and (is-nand? a)
                        (is-nand? b))]
    [_             #f]
    ))

> (is-nand? '((t nand f) nand (t nand t)))
#t 

> (is-nand? '((t and f) nand (t nand t)))
#f
```

And here's a function that *evaluates* a nand-only expression:

```lisp
(define (eval-nand expr)
  (match expr
    ['t            #t]
    ['f            #f]
    [`(,a nand ,b) (not (and (eval-nand a)
                             (eval-nand b)))]
    [_ (error "eval-nand: syntax error")]
    ))

> (eval-nand '((t nand f) nand (t nand t)))
#t
```

## Rewriting Racket Code

The following examples show how [Racket] can **rewrite** code. Compared to most
other programming languages, this is relatively easy to do since [Racket] is
[homoiconic](https://en.wikipedia.org/wiki/Homoiconicity), i.e. [Racket]
programs are represented as [Racket] lists, and [Racket] has good support for
list processing.


### Rewriting an Expression Using Just nand

An interesting fact about propositional logic is that *any* expression can be
re-written as a logically equivalent one using only the `nand` operator.

We need three rules to convert a propositional logic expression into an
equivalent `nand`-only expression:

- `(not p)` is logically equivalent to `(p nand p)`

- `(p and q)` is logically equivalent to `((p nand q) nand (p nand q))`

- `(p or q)` is logically equivalent to `((p nand p) nand (q nand q))`

By repeatedly apply these rules we can transform any propositional expression
into a logically equivalent one using only `nand`.

Here we will *allow* variables, like `p` or `q`, in expressions we want to
simplify:

```lisp
(define (make-nand a b) (list a 'nand b))

;; converts a propositional logic expression into a 
;; logically equivalent one that uses only nand
(define (to-nand expr)
  (if (symbol? expr) 
      expr  ;; if expr is a symbol, return it unchanged
      (match expr
        [`(not ,a)    (let ([na (to-nand a)])
                        (make-nand na na))]
        [`(,a or ,b)  (let* ([na (to-nand a)]
                             [nb (to-nand b)]
                             [nana (make-nand na na)]
                             [nbnb (make-nand nb nb)])
                        (make-nand nana nbnb))]     
        [`(,a and ,b) (let* ([na (to-nand a)]
                             [nb (to-nand b)]
                             [nanb (make-nand na nb)])
                        (make-nand nanb nanb))]
        [_ (error "nand-rewrite syntax error")]
        )))

> (to-nand '(p and q))
'((p nand q) nand (p nand q))

> (to-nand '((p and q) or ((not p) or q)))
'((((p nand q) nand (p nand q)) nand ((p nand q) nand (p nand q)))
  nand
  ((((p nand p) nand (p nand p)) nand (q nand q)) nand (((p nand p) nand (p nand p)) nand (q nand q))))
```

We say that `to-nand` **compiles** a propositional logic into a `nand`-only
expression, and so `to-nand` is an example of a compiler.

> In general, a **compiler** is a program that translates one language into
> another. For example, a C++ compiler translates C++ into machine code.

Together, `to-nand` and `eval-nand` can implement `eval-prop-bool`:

```lisp
(define (eval-prop-bool e)
  (eval-nand (to-nand e)))
  
> (eval-prop-bool '(t or f))
#t

> (eval-prop-bool '((f or t) and (not (t or f))))
#f
```

This version compiles the expression to a nand-only one, and then evaluates that
using `eval-nand`.

### Simplifying a Propositional Expression

Sometimes we can rewrite a propositional expression as a shorter but logically
equivalent expression. For example, the **double negation elimination rule**
says that any expression of the form `(not (not p))` is logically equivalent to
`p`.

Lets write an **expression simplifier** that applies this one particular rule to
propositional expressions:

```lisp
;; double negation elimination
;; (not (not expr)) <==> expr
(define (simplify expr)
  (match expr
    ['t              't]
    ['f              'f]
    [`(not (not ,a)) (simplify a)]
    [`(not ,a)       (list 'not (simplify a))]
    [`(,a or ,b)     (list (simplify a) 'or (simplify b)) ]
    [`(,a and ,b)    (list (simplify a) 'and (simplify b))]
    [_ (error "simplify: syntax error")]
    ))

> (simplify '((not (not t)) and (not (not t))))
(t and t)

> (simplify '(t or ((not (not f)) and t)))
'(t or (f and t))
```

The `match` form clearly specifies the double-negation pattern. Also, the order
in which the matching is done matters: we have to check for `(not (not a))`
before `(not a)`.


### Converting `cond` to `if`

After you've written a few [Racket] programs, you may have noticed that these
two expressions are equivalent:

```lisp
(cond (test val1)
      (else val2))

;; same as 

(if test val1 val2)
```

If-expressions are often preferred because they are a little simpler. But when
writing code you don't always know for sure if you have only one test, and so
it's wise to use `cond` everywhere. After your program is done you could always
go back and re-write single-condition `cond`s as equivalent if-expressions, but
that is tedious and error-prone.

Lets write a [Racket] function to do the work for us. We'll call
single-condition `cond` expressions **simple conds**:

```lisp
;; Deeply change all occurrences of 
;; (cond (test val1) (else val2)) to (if test val1 val2)
(define (rewrite-simple-cond expr)
  (if (not (list? expr)) expr
      (match expr
        [`(cond (,test ,val1)
                (else ,val2)) (map rewrite-simple-cond 
                                   (list 'if test val1 val2))]
        [`(cond (,test ,val1)
                (#t ,val2))   (map rewrite-simple-cond 
                                   (list 'if test val1 val2))]
        [_ (map rewrite-simple-cond expr)])))


> (rewrite-simple-cond '(cond ((= x y) (f x))
                              (else  (g x y))))
'(if (= x y) (f x) (g x y))
```

`(rewrite-simple-cond expr)` first checks if `expr` is a list; if it's *not* a
list, then `expr` is returned unchanged. If `expr` is a list, then `match`
checks if it has the form of a simple `cond`. There are two cases depending on
whether the else-clause uses `else` or `#t`. If `expr` is not a simple `cond`,
then we use `map` to call `rewrite-simple-cond` on each value in `expr`.

When `expr` is a simple cond, it is returned as an if-statement. We call
`rewrite-simple-cond` on `val1` and `val2` using a small trick:
`rewrite-simple-cond` is called on every element of the resulting if-list, even
the `'if` symbol. We know from how `rewrite-simple-cond` works that any non-list
is returned unchanged, and so the `'if` is returned as `'if`. Without using this
trick, we would have had to have used this longer expression:

```lisp
(list 'if (rewrite-simple-cond test) 
          (rewrite-simple-cond val1)
          (rewrite-simple-cond val2))
```

### Challenge: if to cond

Write a function that converts a [Racket] `if` form into an equivalent `cond`
form.

For example:

```lisp
> (if-to-cond '(if (= x y) (f x) (g x y)))
'(cond ((= x y) (f x))
       (else (g x y)))
```

[Scheme]: https://en.wikipedia.org/wiki/Scheme_(programming_language)
[Racket]: https://racket-lang.org/
[LISP]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java
[EBNF]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
[Go]: https://golang.org/
