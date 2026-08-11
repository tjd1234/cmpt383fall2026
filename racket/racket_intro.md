# Introduction to Racket

[Racket] is a modern dialect of [Scheme], and [Scheme] is a dialect of [Lisp].
[Lisp] is a computer programming language originally developed in the 1950s and
1960s by [John
McCarthy](https://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist)) and
his students.

[Lisp] has some distinctive features:

- **Lists** are the main [Lisp] data structure, and functions and expressions
  are represented as lists. This makes it relatively easy for [Lisp] to process
  its own code.

- It is **dynamically typed**, meaning that the types of most values are checked
  at run-time. Languages like [Python] and [JavaScript] are also dynamically
  typed.

- Functions are **first class** objects. This means that functions can be passed
  as arguments to functions, and functions can return functions. [Lisp] also
  supports **closures**, which are functions plus an associated environment of
  values and variables.

- Support for **functional programming**, a style of programming that emphasizes
  the use of **higher order functions** (i.e. functions that take other
  functions as input, or return functions). Functional programming has proven to
  be a popular way to organize programs since it often results in clear, short
  code. [JavaScript] for instance, has many features and libraries inspired by
  functional programming.

- Support for **macros**, which are like functions but instead pass their
  arguments *unevaluated* to the macro body. Macros can be used to implement
  features like if-statements and definition environments, which are not usually
  implementable in other languages.

While [Lisp] hasn't had mainstream success, it has been a rich source of ideas,
for other programming languages, and so it is well worth learning.

## Getting Racket

The easiest way to use [Racket] is with the graphical DrRacket IDE that comes
with it.

[Racket] supports multiple languages, and in these notes we will always be using
the base [Racket] language. To ensure you are using the correct language, make
sure that all your [Racket] programs have this at the top:

```lisp
#lang racket
```

You can find lots of documentation and support for [Racket] online. In
particular, you should bookmark [the Racket
Guide](https://docs.racket-lang.org/guide/index.html), which is a good overview
of [Racket], and also [the Racket
Reference](https://docs.racket-lang.org/reference/index.html), which documents
all its standard functions and features. For instance, all the standard list
processing functions are here [this reference
page](https://docs.racket-lang.org/reference/pairs.html).

## Running Racket

Once it's installed, you can run [Racket] by launching the DrRacket IDE. The IDE
shows a *text window* at the top, and *interaction window* at the bottom. The
idea is that your write functions in the text window, and use the interaction
window to test them.

Here are a few useful keyboard shortcuts:

- ctrl-*E* opens/closes the interaction window
- ctrl-*D* opens/closes the definitions window
- ctrl-*S* saves the current definitions
- ctrl-*I* re-indents all the code in the definitions window 
- ctrl-*R* runs the current definitions in the interaction window
- ESC-*p* copies the previous interaction window expression

`>` is the **interpreter prompt**, and means the interactive interpreter is
waiting for you to type something, e.g.:

```lisp
> (* 2 3)
6
```

## Using Racket's Interactive Interpreter

[Racket]'s' interactive interpreter is sometimes called a **REPL**, which stands
for **read-eval-print loop**. It lets you evaluate expressions one at a time.
For example:

```lisp
> (+ 3 2)
5
> (* 10 4)
40
> (- 5 8)
-3
> (/ 6 2)
3
> (/ 5 2)
2 1/2       ;; 1/2 is written as a fraction in DrRacket
```

An interactive REPL is a significant feature of most Lisp-like languages. You
typically use it to test small examples, or to run only one part of your
program.

### Basic Elements of Racket

You will see the following in [Racket] programs we write for this course:

- **Numbers**, e.g. `5`, `3.14`, `1/2`; we will mostly stick to integers and
  sometimes floating-point numbers. Interestingly, [Racket] has built-in support
  for rational numbers and complex numbers.

- **Strings**, e.g. `"hello"`, `"world"`; strings are sequences of characters.
  We will rarely use them since they are well-supported by other languages.

- **Boolean Values**, `#t` (for true), `#f` (for false); for example, `(= 2 3)`
  evaluates to `#f`, `(= 2 2)` evaluates to `#t`, and `(not (= 2 3))` evaluates
  to `#t`.

- **Symbols**, e.g. `'a`, `'mustard`, `'color-of-first-shape`; symbols are
  *like* strings, but are used quite differently. The `'` is called a
  **single-quote**, or **quote** for short, and is essential for distinguishing
  symbols from variables, e.g. `x` is a variable, while `'x` is a symbol.

- **Quoted Lists**, e.g. `'(a b 1 (2 3) ())`; quoted lists are lists that are
  sequences of values. They are just data, and evaluate to themselves. For
  example, `'(+ 2 3)` is a list of three values, and it evaluates to itself.

- **Functions**, e.g. `(+ 3 2)` calls the function `+` with the arguments 3 and 2.
  Functions are called using **prefix** notation: the function is written first,
  followed by the arguments.

  Important: `(+ 2 3)` is a function call that evaluates to 5, but `'(+ 2 3)` is
  just a list that evaluates to itself.

- **Special Forms**, e.g. `(define (x) 5)`, `(if (x) y z)`. Special forms are
  similar to functions, but the arguments are *not* evaluated immediately.
  Special forms are used for things like definitions, if-statements, and loops.
  In [Racket], special forms can be implemented using macros.


### Basic Arithmetic

[Racket] functions use **prefix** notation: the function is written first,
followed by the arguments. For example, in [Racket] `(+ 3 2)` adds 3 and 2
together. 

Expressions are written as **lists** delineated by **parentheses**: `(` marks
the start of a list, and  `)` marks the end. We'll sometimes call these **round
brackets**, or just **brackets** . 

To help with readability, [Racket] lets you use **square brackets**, `[` and
`]`,  in place of parentheses if you like.

Prefix notation lets you write expressions like this:

```lisp
> (+ 3 2 4 5)
14
> (* 1 2 3 4 5)
120
> (/ 100 10 5)
2
> (- 1 2 3)
-4
```

A nice feature of prefix notation is that you don't need any special rules for
the order of operations. For example, to evaluate the *infix* expression $1
+ 2 \cdot 3$, you need to know the special rule that multiplication is done
*before* addition (e.g. [PEDMAS or
BEDMAS](https://en.wikipedia.org/wiki/Order_of_operations#Mnemonics)). With
infix notation, if you want to do addition first you need brackets, e.g. $(1 +
2) \cdot 3$. 

However, with prefix notation, the order is always made explicit with brackets:

```lisp
> (+ 1 (* 2 3))    ;; 1 + 2 * 3
7
> (* (+ 1 2) 3)    ;; (1 + 2) * 3
9
```

Prefix notation can take some getting used to, so here are a few more examples.
To calculate $1^2+2^2+3^2$, you can do this:

```lisp
> (+ (* 1 1) (* 2 2) (* 3 3))  ;; 1^2 + 2^2 + 3^2
14
```

$(1+2)(3+4)(5+6)$ is this:

```lisp
> (* (+ 1 2) (+ 3 4) (+ 5 6))  ;; (1+2)(3+4)(5+6)
231
```

The formula for the volume of a sphere is $\frac{4}{3}\pi r^3$, and a sphere of
radius 5.2 has volume $\frac{4}{3}\pi 5.2^3$:

```lisp
> (* 4/3 pi 5.2 5.2 5.2)      ;; 4/3 * pi * 5.2^3
588.9774131146049

> (* (/ 4 3) pi 5.2 5.2 5.2)  ;; 4/3 * pi * 5.2^3
588.9774131146049
```

`pi` is a pre-defined [Racket] constant:

```lisp
> pi
3.141592653589793
```

### Challenge: arithmetic expressions in Racket

Write each of the following as a [Racket] expression:

1. $2 - 1 + 3$

2. The number of seconds in one year: $60 \cdot 60 \cdot 24 \cdot 365$.

3. The sum of the first 5 Harmonic numbers: $\frac{1}{1} + \frac{1}{2} +
   \frac{1}{3} + \frac{1}{4} + \frac{1}{5}$. Give your answer as a rational
   number.

4. $\frac{1}{2 - 1 + 3 * \frac{6}{2}}$

5. $2^3 - 5\cdot 1.1 + \frac{2 \cdot 2 + 3}{10}$
 

## Simple Values

Please read [Racket
Essentials](https://docs.racket-lang.org/guide/to-scheme.html). The following
are some comments on that section.


## Symbols and Quoting

**Symbols** are not found in many other mainstream languages. [Racket] symbols
start with a `'`, i.e . a **single-quote** (or **quote** for short), followed by
one or more characters. For example, `'a`, `'x28`, `'hamster`, and
`'color-of-first-shape` are all examples of symbols.

`symbol?` tests if a value is a symbol:

```lisp
> (symbol? 'a)
#t
> (symbol? 'x28)
#t
> (symbol? 'hamster)
#t
> (symbol? 'color-of-first-shape)
#t

> (symbol? 4)      ;; 4 is a number
#f
> (symbol? odd?)   ;; odd? is a function
#f

> (symbol? x)      ;; missing '
. . x: undefined;
 cannot reference an identifier before its definition
```

Symbols look like strings, but they are intended to be used quite differently.
Symbols aren't meant to store text, but rather to be used as simple values. You
usually shouldn't need to access the individual characters they're made from. If
you do, use a string instead.

> [Racket] has functions `symbol->string` and `string->symbol` to convert
  between symbols and strings. They can be helpful if you want to, say, restrict
  the format of symbols. For example, some functions might want to treat symbols
  that end with a `?` specially, and by using `symbol->string` you can convert
  the symbol to a string and check if the last character is a `?`.

A `'` in front of symbols is important because it means the symbol is data. For
example, `x` is a variable, while `'x` is a symbol:

```lisp
> (symbol? 'x)
#t
> (symbol? x)
. . x: undefined;
 cannot reference an identifier before its definition
```

The expression `(symbol? x)` can't be evaluated because [Racket] applies
`symbol?` to the value *bound* to `x`. But in this case, `x` is not bound to
anything, so there's an error.

Like numbers, symbols evaluate to themselves:

```lisp
> 'a
'a
> 'cat
'cat
```

In contrast, variables evaluate to the value they're bound to.

### Quoted Lists

You can also quote lists, e.g.:

```lisp
> (+ 2 3)
5
> '(+ 2 3)
'(+ 2 3)
```

`'(+ 2 3)` is *not* a symbol. Instead, it's a list:

```lisp
> (symbol? '(+ 2 3))
#f
> (list? '(+ 2 3))
#t
```

If you don't put a `'` in front of the list, then it evaluates to 5:

```lisp
> (list? (+ 2 3))   ;; same as (list? 5)
#f
```

The unquoted expression `(+ 2 3)` is a call to the function `+`. It's *code*
that runs and evaluates to 5. But `'(+ 2 3)` is just *data*, and it doesn't run.
`'(+ 2 3)` is just a list of three values, and it evaluates to itself.

Another way of quoting expressions in [Racket] is to use `quote`:

```lisp
> (quote (+ 2 3))
'(+ 2 3)
```

`(+ 2 3)` does *not* get evaluated inside of a `quote`. Thus, `quote` is an
example of a **special form**: it does *not* evaluate its argument.

In general, `(quote x)` is the same as `'x`. The single-quote form is usually
preferred because it has fewer brackets and is easier to read, e.g.:

```lisp
> (symbol? (quote (+ 2 3)))
#f
> (list? (quote (+ 2 3)))
#t

> (symbol? '(+ 2 3))
#f
> (list? '(+ 2 3))
#t
```

### Challenge: quoted lists

For each of the following expressions, try to evaluate them first in your head,
and then check your answer in the [Racket] interpreter. Some are quite tricky!

1. `(* 1 (+ 2 3))`
2. `'(* 1 (+ 2 3))`
3. `(* 1 '(+ 2 3))`
4. `(quote (+ 2 3))`
5. `''a`
6. `'(quote (+ 2 3))`
7. `(quote '(+ 2 3))`
8. `(quote (quote (+ 2 3)))`
9. `(quote quote)`
10. `(+ 2 (quote 3))`
11. `'(+ 2 (quote 3))`

## Calling Functions

Expressions such as `(+ 2 3)` and `(symbol? '(+ 2 3))` are examples of
**function calls**. [Racket] function calls have the form `(fn arg1 arg2 ...
argn)`.

Some functions, such as `+` and `*`, can take a varying number of arguments.
Other functions, such as `symbol?` and `list?`, take a fixed number of arguments
(both `symbol?` and `list?` take one argument).

Since the function comes first in a function call, the first value of a list
needs to be either a function, or an expression that evaluate to a function.
These are some examples of errors in evaluation:

```lisp
> (2 3 +)
. . application: not a procedure;

> ((+ 2 3) 4)  ;; same as (5 4)
. . application: not a procedure;
```

[Racket]'s function calling syntax is consistent and simple, and some
programmers come to like it (once they get used to it!). But using prefix
instead of infix is a significant downside for many programmers. Why give up all
the work they did learning the rules of infix? 

## Simple Definitions

The `(define var val)` form is used to define identifiers and functions.

We can use `define` to give identifiers a value:

```lisp
(define scale 4.5)
(define lunch '(sandwich soup apple))
```

These two lines can be typed into the **definitions window** of DrRacket. After
clicking "Run" (or typing ctrl-*R*), you can use `scale` and `title` in
expressions:

```lisp
> (* scale 5)
22.5
> (length lunch)
3
```

Function definitions typically use this form:

```lisp
(define (inc n) 
   (+ 1 n)
)
```

This defines a function named `inc` that takes one input called `n`, and returns
a new value that is one more than `n`. It is up to the programmer to make sure
that only numbers are passed to `inc`, otherwise you get an error:

```lisp
> (inc 5)
6

> (inc "five")
. . +: contract violation
  expected: number?
  given: "five"
  argument position: 2nd
  other arguments...:
```

**Be careful!** `define` change the meaning of built-in [Racket] forms. For
example, you can define away the `define`:

```lisp
> (define x 5)
> x
5

>> (define define 'make)  ;; strange but possible!
>> define
'make

>> (define y 3)
. . y: undefined;
 cannot reference an identifier before its definition
```

Now `define` no longer works! You must re-run the interpreter to fix it.


### Side-effects and Pure Functions

Here's an function that does not return a useful value:

```lisp
(define (greet name)
  (printf "Welcome to Racket ~a!" name)
  (newline)
  (printf "I hope you learn a lot.")
)
```

It is called like this:

```lisp
> (greet "Alan")
Welcome to Racket Alan!
I hope you learn a lot.
```

he only reason to call `greet` is for its **side-effects**, i.e. for what it
prints to the screen. When you call a function, anything that changes *outside*
of a function --- such as printing to the screen, reading from a file, setting a
global variable, etc. --- is a side-effect of the function.

If a function has no side effects, and always returns the same output for the
same input, then it is called a **pure function**. Regular mathematical
functions are pure functions, and it's often a good idea to make functions pure
if you can in your own programs.

## Source Code Comments in Racket

There are a couple of ways of writing [Racket] source code comments:

- `;` is a single-line comment: characters after `;` and to the end of the line
  are ignore, e.g.:

  ```lisp
  ; single-line comments start with ";" in Racket
  
  ;;;
  ;;; more semi-colons can be used for emphasis
  ;;;
  ```

- `#|` and `|#` can mark multi-line comments: `#|` is the start of the comment
  and `|#` is the end of the comment, e.g.:

  ```lisp
  #|

    This is an example of a 
    multi-line comment.

  |#
  ```

- `#;` comments out an entire expression, e.g.:

   ```lisp
    #;(define (nlist? n lst)
      (and (list? lst) 
           (= n (length lst))))
   ```

`#;` is quite handy in practice, and not found in most other languages.


## Conditionals: if, and, or, cond

**Conditionals** make *decisions*. The `if` special form is like an if-then-else
statement in other languages, and it always has this format:

```lisp
(if <test> <true-result> <false-result>)
```

`<test>` is an expression that evaluates to `#t` (true) or `#f` (false). If
`<test>` is `#t`, then `<true-result>` is evaluated; otherwise,
`<false-result>` is evaluated.

Importantly, `if` *returns* its result. It's like the `?:` operator in C++ and
[Java], e.g.:

```lisp
(define x 2)
(define y 3)

> (* 2 (if (< x y) y x))
6

> (- (if (< x y) y x) 
     (if (> x y) y x))
1
```

The last expression calculates the max of `x` and `y` minus the min of `x` and
`y`. So we could have written these function definitions:

```lisp
(define (mymax x y)   ;; max and min are already defined in
    (if (> x y) x y)) ;; Racket, so we call these mymax/mymin

(define (mymin x y)
    (if (< x y) x y))

> (- (mymax 5 2) (mymin 5 2))
3
```

This function returns the absolute difference between `x` and `y`:

```lisp
(define (abs-diff x y)
  (if (< x y)
      (- y x)
      (- x y)))

> (abs-diff 5 2)
3
```

The `and` form calculates the logical "and" of 0 or more boolean expressions:
`(and <test1> <test2> ...)` returns `#t` just when *all* of the tests evaluate
to true, and `#f` otherwise. For example:

```lisp
> (and)
#t
> (and (= 2 3))
#f
> (and (= 2 2) (< 4 5))
#t
> (and (= 2 2) (< 4 5) (> 4 10))
#f
```

Importantly, `and` uses **short-circuiting**: its inputs are evaluated in the
order they're given (left to right), and after the first one evaluates to `#f`,
the expression immediately returns `#f` without evaluating any more of the
expressions. In contrast, in math and logic the order of evaluation doesn't
matter, i.e. $p \land q$ and $q \land p$ are logically equivalent.

For example, this function relies on the fact that `and` is short-circuited:

```lisp
(define (good-password x)
  (and (string? x)                   ;; must be a string
       (<= 8 (length x))             ;; at least 8 chars
       (not (string-contains? x " ") ;; has no spaces
)))
```

`(good-password s)` returns `#t` if `s` is a "good" password, and `#f`
otherwise. If `s` is not a string, then, thanks to short-circuiting, the
following calls to `length` and `string-contains?` are *not* evaluated (they
would fail with an error).

The `or` form is similar to `and`, and it evaluates logical "or": `(or <test1>
<test2> ...)` returns `#t` if 1, or more, of the tests evaluate to true, and
`#f` otherwise. For example:

```lisp
> (or)
#f
> (or (= 2 3))
#f
> (or (= 2 3) (< 4 5))
#t
> (or (= 2 3) (> 4 5) (> 6 10))
#f
```

`or` uses short-circuit evaluation: the tests are evaluated in order (from left
to right), and as soon as one evaluates to `#t` no further tests are evaluated
and the entire expression evaluates to `#t`. For instance, this expression
returns `#t` thanks to short-circuiting:

```lisp
> (or (= 2 2) (error "oops"))
#t
```

Changing the order of evaluation changes the results:

```lisp
> (or (error "oops") (= 2 2))
. . oops
```

Finally, the `cond` form is similar to if-else-if structures in other languages.
For example:

```lisp
(define (sign n)
  (cond [(not (number? n)) 
            (error "not a number")]
        [(< n 0) 
            'negative]
        [(> n 0) 
            'positive]
        [else 
            'zero]
))

> (sign -5)
'negative
> (sign 3)
'positive
> (sign 0)
'zero
> (sign 'three)
. . not a number
```

In general, a `cond` form looks like this:

```lisp
(cond [test1 result1]
      [test2 result2]
      ...
      [else result_else]
)
```

When `cond` is evaluated, first `test1` is evaluated. If it's `#t`, then
`result1` is evaluated and the entire `cond` expression returns `result1` (and
no more tests are evaluated). If instead `test1` is `#f`, then `test2` is
evaluated. If `test2` is `#t`, then the entire `cond` returns `result2`.
Otherwise, if `test2` is `#f`, the rest of the `cond` is evaluated in a similar
fashion.

The final test is `else`, which is a synonym for `#t`. Since `else` is always
true, if the program ever gets to it then `result_else` will be returned as the
value of the `cond`.

A `cond` *doesn't* need to have an `else`: it's optional.

The use of `[]`-brackets in `cond` expressions is just a convention to improve
readability, and you can use regular round brackets if you prefer.


## Conditionals are Not Functions

Suppose `x` is a variable that has already been defined, but we don't know it's
value. The expression `(and (number? x) (= x 0))` is `#t` if `x` equals 0, and
`#f` otherwise. If, say, `x` happens to be a list, then `(= x 0)` is not
evaluated.

You might wonder if it's possible to write your own version of `and` as a
function. Maybe something like this:

```lisp
(define (bad-and e1 e2)   
    (if e1 
        (if e2 #t #f)
        #f
    )
)
```

This returns `#t` if both `e1` and `e2` are true, and `#f` otherwise. Also, if
`e1` is false, then it immediately returns `#f` without evaluating `e2` (i.e. it
does short-circuit evaluation).

But this doesn't work. The problem is that [Racket] evaluates function arguments
*before* passing them to the function. If `x` is a list, then `(number? x)` is
`#f` and `(= x 0)` is an error. `(bad-and (number? x) (= x 0))` evaluates to
`(bad-and #f error!)`: error! indicates that the expression had an error, and to
the entire call to `bad-and` fails with an error.

Conditionals forms like `if`, `and`, `or`, and `cond` *don't immediately
evaluate their arguments*. Since [Racket] functions *do* immediately evaluate
their arguments, you cannot write these forms as functions.

There is no way around this problem using [Racket] *functions*. But they can be
written as **macros**. Macros are function-like definitions that *don't*
evaluate their arguments, and let the body code decide when to evaluate them.
With macros, you implement conditionals and other special forms (such as
`define`).


## Challenge: letter grades

Implement a [Racket] function called `(grade score)` that returns a letter grade
for the given numeric `score`. You can assume `score` is a number. Letter grades
are assigned according to this table:

- 95 <= A+
- 90 <= A < 95
- 85 <= A- < 90
- 80 <= B+ < 85
- 75 <= B < 80
- 70 <= B- < 75
- 65 <= C+ < 70
- 60 <= C < 65
- 55 <= C- < 60
- 50 <= D < 55
- F < 50

Note that `'A+` and `'C-` are valid [Racket] symbols, and so you should return
such symbols.

For example:

```lisp
> (grade 102)
'A+
> (grade 84.6)
'B+
> (grade 59.8)
'C-
> (grade 50)
'D
> (grade -72)
'F
```

## Notes on "Racket Essentials": Lambda Functions

A **lambda function**, also know as an **anonymous function**, is an expression
that evaluates to a function. It's a function without a name.

For example, this lambda function doubles its input:

```lisp
(lambda (n) (* 2 n))   ;; a lambda function
```

This is *not* a function call. It's just an expression that evaluates to a
function.

You can call it like this:

```lisp
> ((lambda (n) (* 2 n)) 31)
62
```

You can use `define` to give a name to the lambda function:

```lisp
(define double (lambda (n) (* 2 n)))

> (double 31)
62
```

The definition is equivalent to this one:

```lisp
(define (double n) (* 2 n))
```

In general, a lambda function has the format `(lambda (arg1 arg2 ... argn)
body-expr)`.


## Challenge: making new functions

In this challenge, `f` and `g` are any functions that take a single number as
input, and return a number. Implement the following two functions:

1. `(make-abs f)` returns a lambda function that takes one number `x` as input
   and returns the *absolute value* of `(f x)`.

2. `(make-max f g)` returns a lambda function that takes one number `x` as input
   and returns the *max* of `(f x)` and `(g x)`.

For example:

```lisp
(define (f1 x) (+ (* 2 x) 5))
(define (g1 x) (* x x))

(define abs-f1 (make-abs f1))
(define abs-g1 (make-abs g1))
(define max-fg (make-max f1 g1))

> (abs-f1 -10)
15
> (max-fg -1)
3
> (max-fg -10)
100
```

## Local Bindings with let and let*

A **local variable**, or a **local binding** is a variable that is usable only
within a particular scope. In [Racket], local variables are introduced using the
`let` special form like this:

```lisp
(define (dist1 x1 y1 x2 y2)
  (let ([dx (- x1 x2)]
        [dy (- y1 y2)])
    (sqrt (+ (* dx dx) (* dy dy)))
))
```

`dx` and `dy` are local variables that only exist within the scope of the `let`
form. In general, `let` has this format:

```lisp
(let ([v1 val1]
      [v2 val2]
      ...
      [vn valn]
     )
  body ;; v1, v2, ..., vn can be used here
)
```

The entire `let` form evaluates to whatever `body` evaluates to.

It is conventional (but not required) to use `[]`-brackets for the variable
bindings. You could write `let` like this if you prefer:

```lisp
(let ((v1 val1)  ;; ()-brackets can be used instead of 
      (v2 val2)  ;; []-brackets
      ...
      (vn valn)
     )
  body  
)
```

### How `let` works

Consider this example of `let`:

```lisp
> (let ([a 1] [b 1] [c 2]) (+ a b c))
4
```

It could be re-written without `let` like this:

```lisp
> ((lambda (a b c) (+ a b c)) 1 1 2)
4
```

This shows that we can *simulate* `let` using a function call: calling a
function binds its input arguments to its formal parameters.

While this shows that `let` can be simulated using a function call, `let` is
more readable because it puts the variables right beside their assigned values.
With a function call, the variables and their assigned values are far apart.

Now lets re-indent the expression to make the scope clearer:

```lisp
( 
  (lambda (a b c) 
     (+ a b c)
  ) 
  1 1 2  ;; a, b, c are not in scope here
)
```

The scope of `a`, `b`, and `c` is limited to the lambda function they're defined
in. You can't use `a`, `b`, or `c` outside of it. So if you try to use one of
those variables outside the scope you get an error:

```lisp
( 
  (lambda (a b c) 
     (+ a b c)
  ) 
  1 a 2  ;; error: a is not in scope
)
```

As an equivalent `let` expression, it would be this:

```lisp
(let ([a 1]
      [b a]  ;; error: a is out of scope here!
      [c 2]
     )
     (+ a b c)
)
```

This is an error, presumably because `let` is converted into something like the
lambda version we wrote above.

This limitation is inconvenient in practice. And so [Racket] provides the `let*`
special form which removes this restriction:

```lisp
(let* ([a 1]
       [b a]  ;; ok: this is a let* environment
       [c 2]
      )
  (+ a b c)
)
```

You could imagine that `let*` re-writes the expression using embedded `let`
forms, perhaps like this:

```lisp
(let ([a 1])
    (let ([b a])     ;; ok: a is in scope
        (let ([c 2])
            (+ a b c)
        )
    )
)
```

Or even as plain lambdas:

```lisp
(
  (lambda (a)
      (
        (lambda (b)
            (
              (lambda (c)
                  (+ a b c)
              )
              2 ;; bound to c
            )
        )
        a ;; bound to b
      )
  )
  1 ;; bound to a
)
```

In practice, many programmers use `let*` exclusively instead of `let`.


[Scheme]: https://en.wikipedia.org/wiki/Scheme_(programming_language)
[Racket]: https://racket-lang.org/
[LISP]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java_(programming_language)
[Python]: https://en.wikipedia.org/wiki/Python_(programming_language)
[JavaScript]: https://en.wikipedia.org/wiki/JavaScript
