# Tiny Lisp Introduction

Tiny Lisp is a simple dialect of Lisp designed for education. It has a small
number of features, and is a subset of Racket.

Here are it's main features:

- basic data types: symbols, numbers (integers, float, and rationals), booleans,
  lists, pairs

- arithmetic operators: `+`, `-`, `*`, `/`, `<=`, `>=`, `<`, `>`, `=`

- mathematical functions: `sqrt`, `sin`, `cos`

- logical operators: `and`, `or`, `not`

- error handling: `error` for raising errors

- predicate functions: `equal?`, `symbol?`, `number?`, `boolean?`, `list?`,
  `pair?`, `even?`, `odd?`
  
- list functions: `empty?`, `first`, `rest`, `cons`, `list`

- special forms: `quote`, `cond`, `else`, `let`, `let*`, `define`, `lambda`


## Basic Data Types and Arithmetic

Arithmetic operations in Tiny Lisp all use **prefix** notation: the operator
comes first, followed by the operands. For example:

```lisp
> (+ 1 2)
3
> (- 10 5)
5
> (* 2 3)
6
> (/ 10 2)
5
> (<= 5 10)
#t
> (>= 10 5)
#t
```

You can pass more the two operands to arithmetic operations:

```lisp
> (+ 1 2 3)
6
> (* 2 3 4 )
24
> (/ 100 2 2)
25
> (< 1 2 3 6 10 20)
#t
> (> 10 9 4 5)
#f
> (= 5 5 5)
#t
> (= 5 5 6 5 5 5)
#f
```

Tiny Lisp supports rational numbers, which are represented as fractions. For
example, `1/2` is a rational number, one half:

```lisp
> (+ 1/2 1/3)
5/6
> (* 1/2 1/2)
1/4
```

The result of division can be a rational number:

```lisp
> (/ 1 2)
1/2
> (/ 10 4)
5/2
```

Note that `1/2` is the literal representation of the rational number one half,
while `(/ 1 2)` is an expression that calls the `/` function with the arguments
1 and 2.

Tiny Lisp also has some helpful mathematical functions: `sqrt`, `sin`, `cos`.
For example:

```lisp
> (sqrt 2)
1.4142135623730951
> (sin 45)
0.8509035245341184
> (cos 80)
-0.11038724383904756

> (+ (* (sin 19) (sin 19)) 
     (* (cos 19) (cos 19)))
0.9999999999999999
```

Notice how line-breaks and indentation are used to make the last expression a
little more readable.

## Logical Operators

In Tiny Lisp, `#t` is true and `#f` is false, and the logical operators work in
the usual way.

For example:

```lisp
> (and #t #t)
#t
> (and #t #f)
#f
> (and (= 2 2) (< 4 10))
#t

> (or #t #f)
#t
> (or #f #f)
#f
> (or (= 2 5) (< 4 10))
#t

> (not #t)
#f
> (not (= 2 4))
#t
```

As with arithmetic operations, you can pass more than two operands to `and` and
`or`:

```lisp
> (and #t #t #t)
#t
> (or #f #f #t #f)
#t
```

Importantly, `and` and `or` **short-circuit** operators, which means they work
like this:

- `(and <expr1> <expr2> ...)` evaluates the expressions in order, left to right,
  and stops on the first expression that evaluates to `#f` and returns `#f` for
  the entire expression. It does *not* evaluate the expressions after the first
  false one. If none of the expressions evaluate to `#f`, it returns `#t`.

- `(or <expr1> <expr2> ...)` evaluates the expressions in order, left to right,
  and stops on the first expression that evaluates to `#t` and returns `#t` for
  the entire expression. It does *not* evaluate the expressions after the first
  false one. If none of the expressions evaluate to `#t`, it returns `#f`.

For example, the expression `(error "oops!")` will raise an error, and this
shows how short-circuiting works: 

```lisp
> (and #f (error "oops!"))   ;; error not evaluated
#f
> (or #t (error "oops!"))    ;; error not evaluated
#f

> (and #t (error "oops!"))   ;; error evaluated
. . oops!
> (or #f (error "oops!"))    ;; error evaluated
. . oops!
```

This shows that, in general, the expressions `(and a b)` and `(and b a)` might
not evaluate to the same thing. Similarly, `(or a b)` and `(or b a)` might not
evaluate to the same thing.

## Symbols

**Symbols** are a special type of data in Tiny Lisp. They are used to represent
names, and start with the `'` character (single-quote). For example, `'cat`,
`'hamster`, and `'mouse` are all symbols. Symbols evaluate to themselves:

```lisp
> 'cat
'cat
> 'hamster
'hamster
> 'mouse
'mouse
```

You can test if two symbols are the same using the `equal?` predicate:

```lisp
> (equal? 'cat 'cat)
#t
> (equal? 'cat 'hamster)
#f
> (equal? 'cat 'mouse)
#f
```

Note that:

- symbols are *not* strings; you shouldn't be comparing them, you shouldn't be
  extracting their letters, you shouldn't use the to store text, etc.

- you can test if two symbols are equal, but you *can't* compare them with
  operators like `<` or `>=`, and you can't add (or concatenate) them

- symbols are sometimes called **atoms**

## Predicate Functions

A **predicate function**, or just **predicate**, is a function that takes any
number of argument and returns a boolean value, i.e. `#t` or `#f`. Tiny Lisp has
a number of useful built-in predicates.

`(number? <expr>)` returns `#t` if the argument is a number, and `#f` otherwise:

```lisp
> (number? 4)
#t
> (number? 4.0)
#t
> (number? 4/5)
#t
> (number? +)  ;; + is a function
#f
```

`(even <expr>)` and `(odd <expr>)` return `#t` if the argument is an even or odd
number, and `#f` otherwise:

```lisp
> (even? 4)
#t
> (even? 5)
#f
> (odd? 4)
#f
> (odd? 5)
#t
```

`(boolean? <expr>)` returns `#t` if the argument is a boolean, and `#f` otherwise:

```lisp
> (boolean? #t)
#t
> (boolean? #f)
#t
> (boolean? 4)
#f
> (boolean? 'false)
#f
```

`(symbol? <expr>)` returns `#t` if the argument is a symbol, and `#f` otherwise:

```lisp
> (symbol? 'cat)
#t
> (symbol? 'dog)
#t
> (symbol? 4)
#f
```

The `(equal? <expr1> <expr2> ...)` predicate takes any number of arguments and
returns `#t` if all the arguments are equal, and `#f` otherwise:

```lisp
> (equal? 'cat 'cat)
#t
> (equal? 'cat 'dog)
#f
> (not (equal? 'cat 'dog))
#t
> (equal? 4 4 4 (* 2 2))
#t
```

## Lists

A **list** is a sequence of zero, or more, elements. List literals are written
between parentheses. For example, `'(1 of the cats)` is a list with four
elements. The `'` at the start is what distinguishes a list literal from a
function call.

For example:

```lisp
> (* 2 3 0)
0
> '(* 2 3 0)
'(* 2 3 0)

> '(carol has no hat today)
'(carol has no hat today)
> (carol has no hat today)
. . carol: undefined;
 cannot reference an identifier before its definition
```

The last example shows that if you don't quote a list, then the list is treated
as a function call (or a macro call). `(carol has no hat today)` is treated as a
function call to the `carol` function with the arguments `has`, `no`, and `hat`,
and `today`. But since there is no `carol` function, it raises an error.

You can put almost anything inside a list, including other lists, and other data
types. For example:

```lisp
> '(my lucky numbers are (2 3 and -4))
'(my lucky numbers are (2 3 and -4))

> '((()))
'((()))
```

Notice that the inner list is *not* quoted.

`'()` is the **empty list**, and it has no elements. You can test if a list is
empty with the `(empty? <expr>)` predicate:

```lisp
> (empty? '())
#t
> (empty? '(1 of the cats))
#f
> (empty? 0)
#f 
```

You can test if an value is a list with the `(list? <expr>)` predicate:

```lisp
> (list? '())
#t
> (list? '(1 of the cats))
#t
> (list? 56)
#f
> (list? (+ 2 3 4))
#f
```

The `(first <expr>)` function returns the first element of the list, and 
`(rest <expr>)` returns the list of all elements except the first element:

```lisp
> (first '(once upon a time))
'once
> (rest '(once upon a time))
'(upon a time)

> (first '(/ 50 2))
'/    ;; the symbol /, not the division function
> (rest '(/ 50 2))
'(50 2)

> (first (/ 50 2))
. . first: contract violation
  expected: (and/c list? (not/c empty?))
  given: 25

> (rest (/ 50 2))
. . rest: contract violation
  expected: (and/c list? (not/c empty?))
  given: 25
```

The last two examples cause an error because `first` and `rest` only work on
lists, and not on numbers --- and `(/ 50 2)` is the number 25.

You can create a new list with the `(cons x lst)` function, where `x` is any
value, and `lst` is a list:

```lisp
> (cons 'the '(big cat))
'(the big cat)
> (cons 4 '(1 2 3 4 5))
'(4 1 2 3 4 5)
> (cons 'the '())
'(the)
> (cons '(1 2) '(three four))
'((1 2) three four)
> (cons (- 10 2) '(a b c))
'(8 a b c)
```

Another way to create a new list is to use the `(list <expr1> <expr2> ...)`
function, where each `<expr>` is an expression:

```lisp
> (list 1 2 3)
'(1 2 3)
> (list 'result 'is (* 6 7))
'(result is 42)
> (list 'a '(b c) (cons 'd '(e)))
'(a (b c) (d e))
```

`(pair? <expr>)` returns `#t` if the argument is a **pair**, and `#f` otherwise:

```lisp
> (pair? '(1 2))
#t
> (pair? '(a b c d))
#t
> (pair? '(a . b))
#t

> (pair? '())
#f
> (pair? 5)
#f
```

A pair is a fundamental date type in Tiny Lisp. As the name suggests, a pair
holds two values and is literal form is written as `(<value1> . <value2>)`. For
example, `(1 . 2)` is a pair, and so is `(1 . (2 . (3 . ())))`:

```lisp
> (pair? '(1 . (2 . (3 . ()))))
#t
> (list? '(1 . (2 . (3 . ()))))
#t
```

In general a list of the form `(a b c ... z)` is short-hand for the pair `(a .
(b . (c . (... . (z . ())))))`. 

## Special Forms

A **special form** is an expression that is similar to a function call, but its
arguments are evaluated differently than for a function call. They let us do
some very useful things that are not possible with functions.

`(define <symbol> <expr>)` defines a new function or variable. For example, this
defines a variable `pi`:

```lisp
> (define pi 3.14159)
> pi
3.14159
> (* pi 2)
6.28318
```

Be careful: `pi` is a variable, *not* a symbol. For instance:

```lisp
> (define pi 3.14159)
> (list pi 'pi)
'(3.14159 pi)
```

`pi` evaluates to the number `3.14159`, while `'pi` is a symbol that evaluates
to itself.

`(define <symbol> <expr>)` can also be used to define a new function. For
example:

```lisp
> (define (square x) (* x x))
> (square 2)
4

> (define (inc n) (+ n 1))
> (inc 2)
3
> (inc (square 4))
17
```

`(cond <test1> <test2> ...)` is a special form that implements an if-else-if
statement. For example, the `(sign n)` function returns `'negative` if `n` is
less than 0, `'positive` if `n` is greater than 0, and `'zero` if `n` is 0. If
`n` is not a number, it raises an error:

```lisp
(define (sign n)
  (cond [(not (number? n)) (error "not a number")]
        [(< n 0)           'negative]
        [(> n 0)           'positive]
        [else              'zero]
        ))

> (sign 4)
'positive
> (sign -4)
'negative
> (sign 0)
'zero
> (sign 'cat)
. . not a number
```

Each `<test>` is an expression of the form `[<cond> <value>]`, where `<cond>` is
a boolean expression (that evaluates to `#t` or `#f`) and `<value>` is the
expression that is evaluated and returned if `<cond>` is `#t`. `cond` does each
`<test>` in the order given, and the for the first condition that is true it
stops and returns its value (and no further tests are evaluated).

The square brackets are purely cosmetic: [Racket] lets you use square brackets
in place of parentheses whenever you like, and they are often used in `cond`
expressions to make the code more readable.

The `else` keyword is the catch-all case: if none of the conditions before it
are true, then the value after `else` is evaluated and returned. Indeed, you
could replace the `else` with `#t`.

`let` and `let*` are special forms that create new local variables. For example:

```lisp
> (let [(x 1) (y 2)] (+ x y))
3
```

The general form of `let` is:


```lisp
(let [(<var1> <expr1>) 
      (<var2> <expr2>) 
      ...
     ] 
     <body>
)
```

`var1`, `var2`, etc. are new local variables that are bound to the values of the
corresponding expressions `<expr1>`, `<expr2>`, etc.  `<body>` is an expression
that is evaluated and returned, and it can refer to the variables `var1`,
`var2`, ...

`let` is often used in functions:

```lisp
(define (dist x1 y1 x2 y2)
  (let [(dx (- x2 x1))
        (dy (- y2 y1))]
    (sqrt (+ (* dx dx) (* dy dy)))))

> (dist 2 2 4 3)
2.23606797749979
```

`let*` is like `let`, but it binds the variables in the order given and so
allows previous variables to be used in the expressions for later variables. For
example:

```lisp
> (let* [(x 1) (y (+ x 1))] (* x y))
2
```

If you use `let` instead of `let*`, you get an error:

```lisp
> (let [(x 1) (y (+ x 1))] (* x y))
. . x: undefined;
 cannot reference an identifier before its definition
```

`(lambda (<arg1> <arg2> ...) <body>)` is a special form that creates a new
function *without a name*. For example:

```lisp
>(define sq (lambda (x) (* x x)))
> (sq 2)
4
> (sq 3)
9
```
Or:

```lisp
> ((lambda (x) (* x x)) 2)
4
> ((lambda (x) (* x x)) 3)
9
```

In practice, `lambda` functions are often a convenient way to create small
functions, especially when a name doesn't matter.

`(quote <expr>)` is a special form that returns the value of the expression
without evaluating it. Usually we use the `'` shorthand for `quote`, but we can
also write code like this:

```lisp
> (quote x)
'x
> (quote (1 2 3))
'(1 2 3)
> (quote (first '(a b c)))
'(first '(a b c))
```

## Functions to Know

The following functions are all useful for working with lists, and are good
practice for writing recursive functions in LISP.

### length of a list

`(length L)` returns the number of elements in the list `L`. The recursive idea
is:

- return 0 if the list is empty
- otherwise, return 1 plus the length of the rest of the list

```lisp
(define (length L)
  (cond [(empty? L) 0]
        [else
         (+ 1
            (length (rest L)))]
        ))

> (length '())
0
> (length '(a b c))
3
> (length '(the (quick brown) fox (jumped over)))
4
```

### sum and product of a list

The sum and product of a list are conceptually similar to the length of a list.
To calculate the sum of list the recursive idea is:

- return 0 if the list is empty
- otherwise, return the first element plus the sum of the rest of the list

```lisp
(define (sum L)
  (cond [(empty? L) 0]
        [else (+ (first L)
                 (sum (rest L)))]
        ))

> (sum '())
0
> (sum '(5 2))
7
> (sum '(10 4 -2))
12
```

`(product L)` returns the product of the elements in the list `L`. The recursive
idea is similar to `sum`, but with a different base case and operator:

- return 1 if the list is empty
- otherwise, return the first element times the product of the rest of the list

```lisp
(define (product L)
  (cond [(empty? L) 1]
        [else (* (first L)
                 (product (rest L)))]
        ))

> (product '())
1
> (product '(2 6 10))
120
```

### member of a list

`(member? x L)` returns `#t` if `x` is an element of the list `L`, and `#f`
otherwise. The recursive idea is:

- return `#f` if the list is empty
- else, return `#t` if its first element is `x`
- otherwise return the result of `(member? x (rest L))`

```lisp
(define (member? x L)
  (cond [(empty? L)
         #f]
        [(equal? x (first L))
         #t]
        [else (member? x (rest L))]
        ))

> (member? 'cat '())
#f
> (member? 'cat '(cat))
#t
> (member? 'cat '(dog mouse bird))
#f
> (member? 'cat '(my pets (cat dog bird)))
#f
```

`member?` can also be written without `cond` like this:

```lisp
(define (member? x L)
  (and (not (empty? L))
       (or (equal? x (first L))
           (member? x (rest L)))))
```

Intuitively, this says that `x` is a member of `L` if `L` is not empty and
either `x` is the first element of `L`, or `x` is a member of the rest of `L`.

### count occurrences

`(count x L)` returns the number of occurrences of `x` in the list `L`. The
recursive idea is:

- return 0 if the list is empty
- else, if `x` is the first element of `L`, return 1 plus the count of `x` in
  the rest of `L`
- otherwise, return the count of `x` in the rest of `L`

```lisp
(define (count x L)
  (cond [(empty? L)
         0]
        [(equal? x (first L))
         (+ 1 (count x (rest L)))]
        [else
         (count x (rest L))]
        ))

> (count 'cat '())
0
> (count 'cat '(cat))
1
> (count 'cat '(dog mouse bird))
0
> (count 'cat '(my cat (is a cat)))
1
```

### last element

`(last L)` returns the last element of the list `L`. The recursive idea is:

- return an error if the list is empty
- else, if the rest of the list is empty (i.e. the list only has one element),
  return the first element
- otherwise, return the last element of the rest of the list

```lisp
(define (last L)
  (cond [(empty? L)
         (error "last: empty list")]
        [(empty? (rest L))
         (first L)]
        [else
         (last (rest L))]
        ))

> (last '())
. . last: empty list
> (last '(call for bubble gum))
'gum
> (last '(the big brown dog (ate an apple)))
'(ate an apple)
```

### nth element

`(nth n L)` returns the item at index location `n` in the list `L`. Let's make
the indexing zero-based, so the first element is at index 0, the second element
is at index 1, etc. The recursive implementation idea is: 

- return an error if the list is empty, or if `n` is negative
- else, if `n` is 0, return the first element of the list
- otherwise, return the item at index `n-1` in the rest of the list

```lisp
(define (nth n L)
  (cond [(empty? L)
         (error "nth: index out of range")]
        [(< n 0)
         (error "nth: negative index")]
        [(= n 0)
         (first L)]
        [else
         (nth (- n 1) (rest L))]
        ))

> (nth 0 '(a b c))
'a
> (nth 1 '(a b c))
'b
> (nth 2 '(a b c))
'c
> (nth 3 '(a b c))
. . nth: index out of range
```

Be careful: `(nth n L)` runs in `O(n)` time, so it is not efficient to use for
large lists.

### remove all occurrences of an element from a list

`(remove x L)` returns a new list with *all* occurrences of `x` removed from
list `L`. The recursive idea is:

- return an empty list if the list is empty
- else, if the first element is `x`, return the result of `(remove x (rest L))`
- otherwise, return the first element followed by the result of `(remove x (rest L))`

```lisp
(define (remove-all x L)
  (cond [(empty? L)
         '()]
        [(equal? x (first L))
         (remove-all x (rest L))]
        [else
         (cons (first L) (remove-all x (rest L)))]
        ))

> (remove-all 'dust '(dirt dust dust dirt (dirt dust)))
'(dirt dirt (dirt dust))

> (remove-all 'cat '())
'()

> (remove-all 'cat '(cat cat mouse cat))
'(mouse)
```

### append two lists

`(append A B)` returns a new list that is the *concatenation* of the lists `A`
and `B`. The recursive idea is:

- return `B` if `A` is empty
- otherwise, return the first element of `A` followed by the result of 
  `(append (rest A) B)`

```lisp
(define (append A B)
  (cond [(empty? A)
         B]
        [else
         (cons (first A) (append (rest A) B))]
        ))

> (append '(once up) '(a time))
'(once up a time)
> (append '(+ 2 3) '(w x y z))
'(+ 2 3 w x y z)
```

It's is instructive to trace how a call to `append` works:

```
(append '(1 2) '(3 4))
= (cons 1 (append '(2) '(3 4)))
= (cons 1 (cons 2 (append '() '(3 4))))
= (cons 1 (cons 2 '(3 4)))
= (1 2 3 4)
```

This shows that the running time of `append` is proportional to the length of
`A`. So if `A` has `n` elements, `append` takes `O(n)` time.

This is important: `append` is a linear-time operation. If you call `append`
repeatedly, you can end up with a quadratic-time operation. As we will see,
naive implementations of a number of lists functions that use `append` are
quadratic-time because of this.

### append all lists in a list

`(concat list-of-lists)` returns a new list that is the concatenation of all the
lists in `list-of-lists`. For example, `(concat '((1) (two three four) (five) (6
7)))` evaluates to `'(1 two three four five 6 7)`.

The recursive idea is:

- return an empty list if `list-of-lists` is empty
- otherwise, append the first list of `list-of-lists` to the result of 
  `(concat (rest list-of-lists))`

```lisp
(define (concat list-of-lists)
  (cond [(empty? list-of-lists)
         '()]
        [else
         (append (first list-of-lists)
                 (concat (rest list-of-lists)))]
        ))

> (concat '((1 2) (three four five) (six) (7 8)))
'(1 2 three four five six 7 8)
> (concat (list '(a b c) '() '(d e (f) g)))
'(a b c d e (f) g)
```

While `concat` is a common name for this function, it is also known as `append*`
or `append-all`.

### reverse a list

`(reverse L)` returns a new list that is the reverse of the list `L`. The
recursive idea is:

- return an empty list if `L` is empty
- otherwise, return the result of `(append (reverse (rest L)) (list (first L)))`

```lisp
(define (reverse L)
  (cond [(empty? L)
         '()]
        [else
         (append (reverse (rest L))
                 (list (first L)))]
        ))

> (reverse '())
'()
> (reverse '(a b c))
'(c b a)
> (reverse '(1 2 3 4 5))
'(5 4 3 2 1)
> (reverse '(this (is a) (big test)))
'((big test) (is a) this)
```

Unfortunately, this version of `reverse` is a **quadratic-time operation**.
Tracing it helps show why:

```
(reverse '(1 2 3))
= (append (reverse '(2 3)) '(1))
= (append (append (reverse '(3)) '(2)) '(1))
= (append (append (append '() '(3)) '(2)) '(1))
= (append (append '(3) '(2)) '(1))
= (append '(3 2) '(1))
= (3 2 1)
```

Each time the recursive call to `reverse` is made, it calls a `append`, and
because `append` is linear-time, the running time of `reverse` adds up to being
quadratic. 

### reverse a list with an accumulator

`(reverse-acc L acc)` returns a new list that is the reverse of the list `L`. It
does it using an accumulator, which lets it run in linear time. The idea of an
accumulator is to keep track of the result as we go so that we don't have to
call `append` repeatedly.

```lisp
(define (reverse-acc L acc)
  (cond [(empty? L)
         acc]
        [else
         (reverse-acc (rest L)
                      (cons (first L) acc))]
        ))

(define (reverse2 L)
  (reverse-acc L '()))
```

The first thing to notice is that there are two functions: `reverse2` is the one
the user should usually call, and `reverse-acc` is the helper function that does
the actual work. `reverse-acc` takes two arguments: the list to reverse, and an
accumulator. The accumulator is initially empty, and is used to build the
result. There is no call to `append` in `reverse-acc`, and all the other
functions are constant time, and so the running time is linear.

Using an accumulator is a common technique for speeding up recursive functions.
It comes at the cost of adding a second parameter, and thus a helper function
is usually used. 

### length and sum with an accumulator

Recall the `length` function from before:

```lisp
(define (length L)
  (cond [(empty? L) 0]
        [else
         (+ 1
            (length (rest L)))]
        ))
```

We can rewrite it using an accumulator:

```lisp
(define (length-acc L acc)
  (cond [(empty? L)
         acc]
        [else
         (length-acc (rest L)
                     (+ acc 1))]))

(define (length2 L)
  (length-acc L 0))
```

Here, `acc` stores the running count of the number of elements in the list:

```lisp
(length2 '(a b c))
= (length-acc '(a b c) 0)
= (length-acc '(b c)   1)
= (length-acc '(c)     2)
= (length-acc '()      3)
= 3
```

Compare this to a trace of the original `length` function:

```lisp
(length '(a b c))
= (+ 1 (length '(b c)))
= (+ 1 (+ 1 (length '(c))))
= (+ 1 (+ 1 (+ 1 (length '()))))
= (+ 1 (+ 1 (+ 1 0)))
= 3
```

`length` and `length2` both have about the same running time, but `length2` is
more space-efficient because it doesn't need to build up the list 
`(+ 1 (+ 1 (+ 1 ...)))`.

We can also use an accumulator to speed up the `sum` function:

```lisp
(define (sum-acc L acc)
  (cond [(empty? L)
         acc]
        [else
         (sum-acc (rest L)
                  (+ acc (first L)))]))

(define (sum2 L)
  (sum-acc L 0))
```

Here's a trace:

```
(sum2 '(4 5 6))
= (sum-acc '(4 5 6) 0)
= (sum-acc '(5 6)   4)
= (sum-acc '(6)     9)
= (sum-acc '()      15)
= 15
```

Compare this to the `sum` function from before:

```lisp
(define (sum L)
  (cond [(empty? L) 0]
        [else (+ (first L)
                 (sum (rest L)))]
        ))
```

Like `length`, `sum` uses more memory than `sum2` because it builds up the list
`(+ 4 (+ 5 (+ 6 ...)))`:

```
(sum '(4 5 6))
= (+ 4 (sum '(5 6)))
= (+ 4 (+ 5 (sum '(6))))
= (+ 4 (+ 5 (+ 6 (sum '()))))
= (+ 4 (+ 5 (+ 6 0)))
= (+ 4 (+ 5 6))
= (+ 4 11)
= 15
```

### map a list

`(map f L)` returns a new list that is the result of applying the function `f`
to each element of the list `L`. For example, `(map square '(1 2 3))` returns
`(1 4 9)`, and `(map (lambda (x) (+ x 1)) '(1 2 3))` returns `(2 3 4)`.

In the call `(map fn L)`,  `fn` is a function that takes one input, and L is a
list of 0 or more elements that `fn` can be applied to. `fn` is often written as
a lambda expression.

The recursive idea for implementing `map` is:

- return an empty list if `L` is empty
- otherwise, return the result of applying `f` to the first element of `L`
  followed by the result of `(map f (rest L))`

```lisp
(define (map fn L)
  (cond [(empty? L)
         '()]
        [else
         (cons (fn (first L))
               (map fn (rest L)))]))
```

`map` calls `fn` exactly once for each element of `L`, and so the running time
is proportional to the length of `L`. If `fn` is a constant-time operation, then
`map` is a linear-time operation. If `fn` is a linear-time operation, then `map`
is a quadratic-time operation.

`map` is quite useful in practice, and most modern programming languages have it
in some form. For example, in Python list comprehensions provide a form of `map`:

```
Python:
[x * x for x in [1, 2, 3]]
= [1, 4, 9]

Lisp:
(map (lambda (x) (* x x)) '(1 2 3))
= '(1 4 9)
```

Note that `(map fn L)` always returns a list that is the same length as the list
`L`. `map` cannot increase or decrease the length of the list.

### filter a list

The function `(filter pred? L)` returns a new list that is the contains just the
elements of `L` that satisfy the predicate `pred?`. For example, `(filter even?
'(1 2 3 4 5))` returns `(2 4)`, and `(filter (lambda (x) (> x 3)) '(1 2 3 4 5))`
returns `(4 5)`.

`pred?` is a function that takes one input, and returns a boolean value, i.e.
`#t` or `#f`. `L` is a list of 0 or more elements that `pred?` can be applied
to. As with `map`, `pred?` is often written as a lambda expression.

The recursive idea for implementing `filter` is:

- return an empty list if `L` is empty
- otherwise, if the first element of `L` satisfies `pred?`, return a new list
  with the first element of `L` followed by the result of `(filter pred? (rest
  L))`
- otherwise, return the result of `(filter pred? (rest L))`

```lisp
(define (filter pred? L)
  (cond [(empty? L)
         '()]
        [(pred? (first L))
         (cons (first L)
               (filter pred? (rest L)))]
        [else
         (filter pred? (rest L))]))
```

`pred?` is called exactly once for each element of `L`, and so the running time
is proportional to the length of `L`. If `pred?` is a constant-time operation,
then `filter` is a linear-time operation. If `pred?` is a linear-time operation,
then `filter` is a quadratic-time operation.

Recall `(remove-all x L)` from before: it returns a new list that is the same as
`L` but with all occurrences of `x` removed. We can implement it using `filter`:

```lisp
(define (remove-all x L)
  (filter (lambda (y) (not (equal? y x))) 
          L))
```

Intuitively, this says to keep the elements of all that are *not* equal to `x`.

In practice, `filter` is quite useful and goes together well with `map`. For
example, Python's list comprehensions are a form of `filter` and `map`:

```
Python:
[x * x for x in [1, 2, 3, 4, 5] 
       if x % 2 == 0]

Lisp:
(map (lambda (x) (* x x))
     (filter even? '(1 2 3 4 5)))
```

### all

`(all pred? L)` returns `#t` if all the elements of `L` satisfy the predicate
(i.e. make it true). Or, a little more precisely, `(all pred? L)` returns `#t`
just when there is no element in `L` makes `pred?` return `#f`. 

`pred?` is a boolean predicate function that takes one input and returns `#t` or
`#f`, while `L` is a list of 0 or more elements that `pred?` can be applied to.

For example, `(all even? '(2 4 6))` returns `#t`, and `(all symbol? '(two 4
five))` returns `#f`.

The recursive idea for implementing `all` is:

- return `#t` if `L` is empty

- otherwise, if the first element of `L` satisfies `pred?`, return the result of
  `(all pred? (rest L))`

- otherwise, return `#f`

```lisp
(define (all pred? L)
  (cond [(empty? L)
         #t]
        [else
         (and (pred? (first L))
              (all pred? (rest L)))]))
```

`pred?` is called exactly once for each element of `L`, and so the running time
is proportional to the length of `L`. If `pred?` is a constant-time operation,
then `all` is a linear-time operation. If `pred?` is a linear-time operation,
then `all` is a quadratic-time operation.

Another way to implement `all` is to use `filter`. The idea is to remove the
elements that *don't* satisfy `pred?`. If that filtered list is length 0, then
all the elements of `L` satisfy `pred?`. Otherwise, some element of `L` does not
satisfy `pred?`, and so `all` returns `#f`:

```lisp
(define (all pred? L)
  (empty? (filter (lambda (x) (not (pred? x))) 
                  L)))
```

Unfortunately, this implementation is often slower than the recursive version.
The recursive version ends as soon as `pred?` returns `#f`: there is no reason
to keep checking once we know that the result is `#f`. 

But the `filter` version always calls `pred?` on all the elements of `L`, even
if the very first element makes `pred?` return `#f`.

Despite it's slowness, the `filter` version is interesting because it is doesn't
explicitly use recursion, and is instead built-up from simpler operations. For
many programmers, it is easier to understand and reason about than the recursive
version.

### folding a list

**Folding** a list is a powerful technique that we'll introduce through an
example. Consider the list `'(a b c d)`. We can write it as a series of nested
calls to `cons`:

```
'(a b c d)
= (cons 'a (cons 'b (cons 'c (cons 'd '()))))
```

We'll call the expression `(cons 'a (cons 'b (cons 'c (cons 'd '()))))` is
called the **consed-out form** of the list `'(a b c d)`.

Notice a few things:

- `cons` is a **binary function**, i.e. it takes two inputs and returns one
  output 

- the second parameter for the last `cons` is the empty list `'()`

Now imagine generalizing the cons-ed out form to work with a binary function (on
values that make sense for it) other than `cons`. For instance, imagine
replacing `cons` with `+`:

```
(+ 1 (+ 2 (+ 3 (+ 4 0))))
= 10
```

This is the sum of the numbers in the list `'(1 2 3 4)`. Notice that instead of
the empty list, the final value passed to the last `+` is 0, which makes sense
for addition.

If we replaced `cons` with `*`, we would get the product of the numbers:

```
(* 1 (* 2 (* 3 (* 4 1))))
= 24
```

Notice again that last value passed to the last `*`: it is 1, because that makes
sense for multiplication.

Now lets generalize this. Suppose you have a list of elements `'(a b c d)`, a
binary operator `op` that works on those values, and also we have the final
value `init` for the last call to `op`. Then we can calculate the folded form of
the list like this:

```
(op a (op b (op c (op d init))))
```

This is called a **fold**, or more specifically, a **right fold** because the
brackets are nested to the right. In Lisp, it is usually called `foldr`, and
would be called like this:

```lisp
(foldr op init '(a b c d))
= (op a (op b (op c (op d init))))
```

To write `(foldr op init L)`, we can use this recursive idea:

- return `init` if `L` is empty

- otherwise, apply `op` to the first element of `L` and the result of `(foldr op
  init (rest L))`

```lisp
(define (foldr op init L)
  (cond [(empty? L)
         init]
        [else
         (op (first L) 
            (foldr op init (rest L)))]))

> (foldr + 0 '(1 2 3 4))
10

> (foldr * 1 '(1 2 3 4))
24

> (foldr - 0 '(1 2 3 4))
-2
```

## sum as a right fold

We can implement `(sum L)` as a right fold:

```lisp
(define (sum L)
  (foldr + 0 L))

> (sum '(1 2 3 4))
10
```

It is useful to trace a function call. Imagine calling `(sum '(1 2 3 4))`, and
evaluating it step by step:

```
(sum '(1 2 3 4))
= (foldr + 0 '(1 2 3 4))
= (+ 1 (foldr + 0 '(2 3 4)))
= (+ 1 (+ 2 (foldr + 0 '(3 4))))
= (+ 1 (+ 2 (+ 3 (foldr + 0 '(4)))))
= (+ 1 (+ 2 (+ 3 (+ 4 0))))
= (+ 1 (+ 2 (+ 3 4)))
= (+ 1 (+ 2 7))
= (+ 1 9)
= 10
```

The basic pattern is that `foldr` goes through the list left to right to create
a big expression: `(+ 1 (+ 2 (+ 3 (+ 4 0))))`. And then the expression is
evaluated in the usual way according to the brackets.

## length as a right fold

The `(length L)` function can be written like this:

```lisp
(define (length L)
  (foldr (lambda (next acc) (+ acc 1)) 
         0 
         L))

> (length '())
0

> (length '(a))
1

> (length '(a b c d))
4
```

The key idea is the folding function is `(lambda (next acc) (+ acc 1))`. This is
a binary function that takes two inputs: the `next` element of the list, and the
`acc`umulated value of the previous calls to the folding function.

Calling `(foldr op 0 '(a b c))` gives this:

```
(foldr op 0 '(a b c))
= (op a (op b (op c 0)))
```

`op` is `(lambda (next acc) (+ acc 1))`, so doing one step of evaluation gives:

```
(foldr op 0 '(a b c))
= (op a (op b (op c 0)))
= (op a (op b (+ 0 1)))
```

The `c` disappears because the body of `op` ignores it. Continuing this process,
the calls to `op` are evaluated in the usual way:

```
(foldr op 0 '(a b c))
= (op a (op b (op c 0)))
= (op a (op b (+ 0 1)))
= (op a (op b 1))
= (op a (+ 1 1))
= (op a 2)
= (+ 2 1)
= 3
```

### member? as a right fold

The `(member? x L)` function can be written like this:

```lisp
(define (member? x L)
  (foldr (lambda (next acc) (or (eq? next x) acc))
         #f
         L))
```

For example, `(member? 3 '(1 2 3 4))` evaluates to:

```lisp
(member? 3 '(1 2 3 4))
= (foldr op  ;; op is (lambda (next acc) (or (equal? next x) acc))
         #f
         '(1 2 3 4))
= (op 1 (op 2 (op 3 (op 4 #f))))
= (op 1 (op 2 (op 3 #f)))
= (op 1 (op 2 #t))
= (op 1 #t)
= #t
```

## map and filter as a right folds

The `(map f L)` function can be written as a right fold:

```lisp
(define (map f L)
  (foldr (lambda (next acc) (cons (f next) acc))
         '()
         L))

> (map list '(a b c d))
'((a) (b) (c) (d))
```

To understand this, look at the folding function `(lambda (next acc) (cons (f
next) acc))`. Intuitively, it applies `f` to each `next` element of the list,
and then pushes the result onto the front of the accumulated values.

`(filter pred? L)` can be written as a right fold:

```lisp
(define (filter pred? L)
  (foldr (lambda (next acc)
           (cond [(pred? next)
                  (cons next acc)]
                 [else
                  acc]))
         '()
         L))

> (filter even? '(1 2 3 4))
'(2 4)
```

The folding function for `filter` is a little more complex. It checks if the
`next` element satisfies `pred?`. If it does, it pushes it onto the front of the
accumulated values. If it does not, it skips the element and keeps the
accumulated values as is.

### append as a right fold

The `(append A B)` function can be written as this simple right fold:

```lisp
(define (append A B)
  (foldr cons B A))

> (append '(1 2 3) '(a b))
'(1 2 3 a b)
```

Tracing this:

```
(append '(1 2 3) '(a b))
= (foldr cons '(a b) '(1 2 3))
= (cons 1 (cons 2 (cons 3 '(a b))))
= (cons 1 (cons 2 '(3 a b)))
= (const 1 '(2 3 a b))
= '(1 2 3 a b)
```

## insertion sort

Recall that **insertion sort** is a sorting algorithm that builds a sorted list
of numbers by taking numbers from the input list and inserting them in the
correct sorted position in a new list. 

Insertion sort can be implemented using a right fold. Each new number in the
list is inserted into the correction position of the accumulated list (which is
in sorted order) using a helper function `insert-sorted`:

```lisp
(define (insertion-sort L)
  (foldr insert-sorted '() L))

> (insertion-sort '(3 1 4 2 5))
'(1 2 3 4 5)
```

For this to work we need to write `(insert-sorted x L)`, where `L` is in sorted
order. It returns a new list with `x` inserted into the correct position in `L`,
e.g.:

```
> (insert-sorted 3 '(1 2 4 5))
'(1 2 3 4 5)
```

A recursive idea for implementing `insert-sorted` is:

- if `L` is empty, return a list with just `x` in it
- if `x` is less than or equal to the first element of `L`, insert `x` at the
  front of `L` using `cons`
- otherwise, insert `x` at the front of the rest of `L` and `cons` the first
  element of `L` back onto the front of the result

Here is an implementation of `insert-sorted`:

```lisp
(define (insert-sorted x L)
  (cond [(empty? L)
         (list x)]
        [(<= x (first L))
         (cons x L)]
        [else
         (cons (first L)
               (insert-sorted x (rest L)))]))
```

Now `(foldr insert-sorted '() L))` returns a copy of `L` in sorted order.

## quicksort with filter

**Quicksort** is another sorting algorithm that works by selecting a *pivot*
element, partitioning the list into two sub-lists around that pivot, and
recursively sorting the two sub-lists.

Here is an implementation of quicksort that chooses the first element of the
list as the pivot:

```lisp
(define (quicksort L)
  (cond [(<= (length L) 1)
         L]
        [else
         (let* [(pivot (first L))
                (smalls (filter (lambda (n) (< n pivot))
                                (rest L)))
                (bigs (filter (lambda (n) (>= n pivot))
                              (rest L)))
                ]
           (concat (list (quicksort smalls)
                         (list pivot)
                         (quicksort bigs))))]))

> (quicksort '(9 3 2 0 8 7 3))
'(0 2 3 3 7 8 9)
```

Recall that `concat` appends a list of lists into a single list, e.g.
`(concat '((1 2 5) (7) (8 10)))` evaluates to `'(1 2 5 7 8 10)`.

## flattening a list

`(flatten L)` returns a new list with all internal sub-lists removed, but the
non-list elements kept as they are in the order they appear in the original
list.

For example:

- `(flatten '((a) ((c d (e f)) g) h))` evaluates to `'(a c d e f g h)`
- `(flatten '(define (x y) (+ x y)))` evaluates to `(define x y + x y)`

A recursive idea for implementing `flatten` is:

- return an empty list if `L` is empty

- if the first element of `L` is a list, return the result of flatten that first
  element, and append to the flattened rest of the list

- otherwise, make a new list with the first element of `L` followed by the
  flattened rest of the list

```lisp
(define (flatten L)
  (cond [(empty? L)
         '()]
        [(list? (first L))
         (append (flatten (first L))
                 (flatten (rest L)))]
        [else
         (cons (first L)
               (flatten (rest L)))]))

> (flatten '((1 2) (3 4) 5))
'(1 2 3 4 5)

> (flatten '(define (x y) (+ x y)))
'(define x y + x y)
```

Note that this implementation repeats `(first L)` and `(rest L)` a couple of
times. This does not slow the function down (because the repeats are different
`cond` clauses), but it does, arguably, make the code less readable.

So here is an alternative implementation that uses `let*` to avoid the
repetition:

```lisp
(define (flatten L)
  (cond [(empty? L)
         '()]
        [else
         (let* [(head (first L))
                (tail (rest L))
                (flat-tail (flatten tail))]
           (cond [(list? head)
                  (append (flatten head) flat-tail)]
                 [else
                  (cons head flat-tail)]))]))
```

It might be easier for some programmers to see the structure of the code in this
version.

Another idea for implementing `flatten` is to use a right fold. The basic
structure would be:

```lisp
(define (flatten L)
  (foldr (lambda (next acc)
           ???
         )
         '() ;; the initial accumulated value
         L))
```

What should the folding function be? It should examine `next`. If it *is* a
list, it should recursively flatten it, and then append it to the accumulated
value. If `next` is *not* a list, it should just put it unchanged onto the
accumulated value:

```lisp
(define (flatten L)
  (foldr (lambda (next acc)
           (cond [(list? next)
                  (append (flatten next) acc)]
                 [else
                  (cons next acc)]))
         '()
         L))
```

## deep functions

A **deep function** is a function that operates on a list, and goes into nested
sub-lists.

For example, `(deep-sum L)` returns the sum of all the numbers in the list,
including the numbers in the nested lists. For example, `(deep-sum '((1 ((2)) 3)
(4 5) 6))` evaluates to 21.

An idea for implementing `deep-sum` is to flatten the list and then use a the
regular shallow `sum` function we've already defined:

```lisp
(define (deep-sum L)
  (sum (flatten L)))
```

This works because `(flatten L)` returns a list of all the numbers in the list,
including the numbers in the nested lists. Then `(foldr + 0 (flatten L))`
returns the sum of all the numbers in the list.

Another example is `(deep-member? x L)`, which returns `#t` if `x` is found in
the list, including in any nested sub-lists. For example, `(deep-member? 2 '((1
((2)) 3) (4 5) 6))` evaluates to `#t`.

Again, it can be implemented using `flatten` and the regular shallow `member?`
function:

```lisp
(define (deep-member? x L)
  (member? x (flatten L)))
```

Not all deep functions can implemented using `flatten`. For example, `(deep-map
f L)` returns a new list with `f` applied to each element of the list, including
the elements in the nested lists. Importantly, `deep-map` preserves the nested
structure of the list.

For example, `(deep-map square '((1 2) (3 4) 5))` evaluates to `'((1 4) (9 16)
25)`.

An idea for implementing `deep-map` is to use a right fold. The idea is that
each next new item in the list is either a list of a non-list. If it is a list,
it should be deep-mapped and put onto the front of the accumulated value. If it
is a non-list, it should be `f` applied to it and put onto the front of the
accumulated value.

```lisp
(define (deep-map f L)
  (foldr (lambda (next acc)
           (cons (cond [(list? next)
                        (deep-map f next)]
                       [else
                        (f next)])
                 acc))
         '()
         L))

> (deep-map (lambda (n) (* n n))
            '(1 ((2 3) 4) ((5))))
'(1 ((4 9) 16) ((25)))
```

## Closures

A **closure** combines two things: a function, and an environment of variables
and their values. The function can use variables from this environment.

For example, this function, but *not* a closure:

```lisp
(define (f n)     ;; f is a function, but not a closure
        (+ n 1))

> (f 5)
6
```

Now consider this one:

```lisp
(define (make-adder n)
    (lambda (x) (+ n x))   ;; n is outside the lambda function
)

(define g (make-adder 1))  ;; g is a closure

> (g 5)
6
```

`g` is a closure because it has both a function and a binding for the variable
`n`. By itself, the function `(lambda (x) (+ n x))` can't be evaluated because
variable `n` is *free*. But, in `g`, `n` is bound to the value 1. The function
plus this binding of `n` is a closure.

There's a nice way to think of closures in Racket: conceptually,  a closure is a
**let over lambda**:

```lisp
(define g1
    (let ([n 1])      ;; let over lambda
        (lambda (x)   ;;
            (+ n x))  ;;
    )                 ;;
)

> (g1 5)
6
```

`g1` is not *just* a function, but a function along with variable bindings that
it can use.

**Free variables** are variables that appear in a function but aren't declared
in the function. For example, `n` is free in `(lambda (x) (+ n x))`. Any
programming language that lets you define functions inside functions must decide
how to handle free variables. Closures are a common solution to this problem.
Another way is to simply disallow returning functions with free variables, but
this greatly reduces the flexibility of returning functions.

## Composing Functions

Recall  **function composition** from math. Given the two functions:

```math
\begin{array}{rcl}
f(x) & = & x^2 \\
g(x) & = & 2x + 1
\end{array}
```

Their **composition** is:

```math
\begin{array}{rcl}
f(g(x)) & = & g(x)^2 \\
        & = & (2x + 1)^2 \\
        & = & 4x^2 + 4x + 1
\end{array}
```

$\circ$ is the **function composition operator**:

```math
\begin{array}{rcl}
(f \circ g)(x) & = & (2x + 1)^2 \\
               & = & 4x^2 + 4x +1
\end{array}
```

In code, we can compose functions directly by calling them:

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

We can also write a function that returns the composition of two given
functions. The `compose` function takes two single-input functions as input and
returns their a function that is their composition:

```lisp
(define (compose f g)
    (lambda (x) (f (g x))))
```

`(compose f g)` returns a function that first applies `g` to its input, and then
applies `f` to the result of that, i.e. it does `g` and then `f`.

This lets us define `h` from above without explicitly using `x`:

```lisp
(define h (compose f g))

> (h 2)
25
```

For example, here's a function that returns the second element of a list:

```lisp
(define second (compose first rest))

> (second '(big red apple))
'red
```

We call `(second lst)`, but the `lst` parameter does *not* appear in the
definition of `second`: it is *implicit*.

The `twice` function takes a function, `f`, as input and returns `f` composed
with itself, i.e. $f \circ f$:

```lisp
(define (twice f) (compose f f))
```

For instance:

```lisp
(define garnish 
    (twice (lambda (x) (cons 'cheese x)))
)

> (garnish '(sauce crust))
(cheese cheese sauce crust)
```

## Composing Multiple Functions

The built-in [Racket] `compose` function lets you compose 2 or more functions,
but it is not part of Tiny Lisp. So lets implement our own version called
`(compose-all f1 f2 ... fn)` that returns the composition of `f1` to `fn`, i.e.
`(f1 (f2 ... (fn x)))`.

Lets start with a concrete example with three functions: `h`, `g`, and `f`, each
of which takes 1 input and returns 1 output. Using the $\circ$ operator, we can
write the composition of all three as $h \circ g \circ f$, which is the same as
$h \circ (g \circ f)$. This has the structure of a right fold. 

Recall that right fold is `(foldr op init lst)`. What would be `init` for
composition? In others, what should `init` be in 
`(compose f (compose g (compose h init)))`?

The answer is the **identity function**, i.e. the function that returns whatever
you pass it. We could write it as $I(x) = x$, and so for example, $f \circ I =
f$, e.g. $(f \circ I)(x) = f(I(x)) = f(x)$.

Now we can write `compose-all` as a right fold:

```lisp
(define (compose-all fns)
  (foldr compose
         (lambda (x) x)   ;; identity function
         fns))
```

Here's an example of how this works:

```lisp
(define (f x) (append x (list 'f)))
(define (g x) (append x (list 'g)))
(define (h x) (append x (list 'h)))

(define fgh (compose-all (list f g h)))

> (seq1 '(test))
`(test h g f)
```

This shows that the functions are applied in *reverse* order, which most humans
find counter-intuitive. So lets write a variation of `compose-all` that applies
the functions in the order they are given:

```lisp
(define (pipeline fns)
  (compose-all (reverse fns)))
```

This lets us write the functions in the order they're applied:

```lisp
(define seq2 (pipeline f g h))

> (seq2 '(test))
'(test f g h)
```

## Curried Functions

The idea of **currying** is to treat a function that takes more than 1 input as
a series of functions that take 1 input each.

Here are two different ways to write the addition function:

```lisp
(define add_a     ;; uncurried
    (lambda (x y)
        (+ x y)))

> (add_a 3 4)
7

(define add_b     ;; curried
    (lambda (x)
        (lambda (y)
            (+ x y))))

> ((add_b 3) 4)
7
```

`add_a` takes two inputs, and immediately returns an answer. `add_b` takes only
one input and returns a function. This returned function takes the second input
and returns the sum of the two inputs.

The nice thing about `add_b` is that if we give it only a single input `n`, we
get a useful function:

```lisp
(define add5 (add_b 5))
```

In Tiny Lisp, most functions are *not* written in a curried style. Here's a
function that converts a non-curried function into a curried one:

```lisp
;; assumes f is a 2-parameter uncurried function;
;; returns a curried version of f
(define (curry2 f)
  (lambda (x)
    (lambda (y)
      (f x y))))
```

For example:

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

Finally, the `uncurry2` function takes a 2-argument *curried* function as input
and returns a non-curried version of it:

```lisp
;; converts a 2-argument curried function to a non-curried
;; function
(define (uncurry2 f)
  (lambda (x y)
    ((f x) y)))
```

Since functions are non-curried by default, uncurrying isn't common in Tiny Lisp.

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

While `I` doesn't do useful computation, as we saw above for `compose-all`, it
acts like the identity element for function composition, i.e. `f \circ I = f`
and `I \circ f = f`.

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
and the same thing happens again and again forever:

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
(define S       ;; curried version of S3
  (lambda (x)   ;; can be passed 0, 1, 2, or 3 arguments
    (lambda (y)
      (lambda (z)
        ((x z) (y z))))))
```

This lets us pass 0, 1, 2, or 3 arguments to `S`, which is useful when working
with combinators.

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
`(S K K)` evaluates to a function that takes one argument, which in this example
is `'a`. Thus `((S K K) 'a)` evaluates to the same thing as `(S3 K K 'a)`.

Following the definition of `S3`, `(S3 K K 'a)` evaluates to `((K 'a) (K 'a))`.
`(K 'a)` returns a function that always returns `'a` so `((K 'a) (K 'a))`
evaluates to `'a`. Thus `((S K K) 'a)` evaluates to `'a`, which means `(S K K)`
is the identity function.

### Completeness of S and K

Why bother with little functions like `S` and `K`? They don't seem very useful.

Surprisingly, functions `S` and `K` can be combined to define *any* other pure
function. You could think of `S` and `K`  like a low-level assembly language for
pure functions: the atoms of computation. 

We won't cover the proof here, but check out [the Wikipedia page on
combinatory
logic](https://en.wikipedia.org/wiki/Combinatory_logic#Completeness_of_the_S-K_basis)
if you're curious.

## Case Study: Symbolic Programming

One of the original uses of Lisp was **symbolic programming**, e.g. doing
algebra with variables instead of numbers. Even today, Lisp can still be a
useful tool for such problems.

### Symbolic Propositional Logic

Lets write some functions that process a language of **literal boolean
propositional expressions** like `(t and (not f))` and `((f or f) and ((not t)
and f))`. 

The symbols `t` and `f` stand for *true* and *false*. Importantly, they are
*not*  the built-in Tiny Lisp boolean values (`#t` and `#f`) since this is our
own little language different from Tiny Lisp.

### Checking Valid Expressions

The first thing we will write is a function that checks if an expression is a
valid propositional logic for our expression. We'll call this a **recognizer
function**, since it recognizes valid expressions.

We consider the following to be valid expressions:

- `t`
- `f`
- `(not e)` where `e` is a valid expression
- `(e1 and e2)` where `e1` and `e2` are valid expressions
- `(e1 or e2)` where `e1` and `e2` are valid expressions
- `(e1 implies e2)` where `e1` and `e2` are valid expressions
- `(e1 iff e2)` where `e1` and `e2` are valid expressions

### Recognizing Propositional Expressions

To write the recognizer function, we first write a few helper functions:

```lisp
;;
;; recognizing literals t and f
;;
(define (is-true? e) (equal? e 't))
(define (is-false? e) (equal? e 'f))

(define (is-literal? e)
  (or (is-false? e)
      (is-true? e)))

;;
;; general helper functions
;;
(define (length lst)
  (cond [(empty? lst) 0]
        [else (+ 1 (length (rest lst)))]))

(define (second lst)
  (first (rest lst)))

;; returns true iff lst is a list of length n
(define (nlist? n lst)
  (and (list? lst) 
       (= n (length lst))))

;;
;; recognizing a not expression
;;

;; (not expr)
(define (is-not? e)
  (and (nlist? 2 e)
       (equal? 'not (first e))))

;;
;; recognizing binary expressions of the form (p op q)
;;

;; (p op q)
(define (is-bin-op? e op)
  (and (nlist? 3 e)
       (equal? op (second e))))

(define (is-and? e) (is-bin-op? e 'and))        ;; (p and q)
(define (is-or? e) (is-bin-op? e 'or))          ;; (p or q)
(define (is-nand? e) (is-bin-op? e 'nand))      ;; (p nand q)
(define (is-implies e) (is-bin-op? e 'implies)) ;; (p implies q)
(define (is-iff? e) (is-bin-op? e 'iff))        ;; (p iff q)
```

Notice that none of the above recognizers are recursive. They only check the
top-level form of an expression.

Now we can write a recursive function that tests for valid propositional logic
expressions:

```lisp
(define (is-expr? e)
  (cond
    [(is-literal? e) 
     #t]
    [(is-not? e) 
     (is-expr? (second e))]
    [(or (is-and? e)
         (is-or? e)
         (is-nand? e)
         (is-implies? e)
         (is-iff? e))
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

### Evaluating Propositional Expressions

Every literal propositional evaluates to either `t` or `f`. We can evaluate them
like this:

```lisp
(define (eval-prop-bool e)
  (cond
    [(is-false? e) 
     #f]
    [(is-true? e) 
     #t]
    [(is-not? e) ;; (not p)
     (not (eval-prop-bool (second e)))]
    [(is-and? e) ;; (p and q)
     (and (eval-prop-bool (first e)) 
          (eval-prop-bool (third e)))]
    [(is-or? e) ;; (p or q)
     (or (eval-prop-bool (first e)) 
         (eval-prop-bool (third e)))]
    [(is-nand? e) ;; (p nand q)
     (not (and (eval-prop-bool (first e))
               (eval-prop-bool (third e))))]
    [(is-implies? e) ;; (p implies q)
     (or (not (eval-prop-bool (first e)))
         (eval-prop-bool (third e)))]
    [(is-iff? e) ;; (p iff q)
     (equal? (eval-prop-bool (first e))
             (eval-prop-bool (third e)))]
    [else 
     #f]))

(define (eval-prop e)
  (cond [(eval-prop-bool e) 't]
        [else 'f]))

> (eval-prop '((not t) and (t or (not f))))
f
```

`eval-prop-bool` returns [Racket] boolean values, i.e. `#t` and `#f`. We do this
for convenience so that we can use the built-in [Racket] forms `and`, `or`, and
`not`. Otherwise, we'd have to write special-purpose versions of `and`, `or`,
and `not` that work with `'t` and `'f`.

### Rewriting an Expression Using Just nand

An interesting fact about propositional logic is that *any* expression can be
re-written as a logically equivalent one using only the `nand` operator. This
can be useful in electronic circuit design, where `nand` gates are the basic
building blocks.

We need some rules to convert a propositional logic expression into an
equivalent `nand`-only expression:

- `(not p)` is logically equivalent to `(p nand p)`

- `(p and q)` is logically equivalent to `((p nand q) nand (p nand q))`

- `(p or q)` is logically equivalent to `((p nand p) nand (q nand q))`

`(p implies q)` and `(p iff q)` are intentionally left out for now and left as
an exercise for the reader. Note that `(p implies q)` is logically equivalent to
`((not p) or q)`, and `(p iff q)` is logically equivalent to `(p and q) or ((not
p) and (not q))`.

In addition to literals `'t` and `'f'`, our `to-nand` function will handle other
variables, like `p` or `q`. So, for example, `(p and q)` will be rewritten as
`((p nand q) nand (p nand q))`.

```lisp
;;
;; Converts propositional logic expression e to a nand-only expression.
;; Assumes e is a valid propositional logic expression, and does not
;; contain implies or iff operators. Variable names can be any symbol.
;;
(define (to-nand e)
  (cond [(symbol? e)
          e]         ;; return symbols unchanged
        [(is-not? e) ;; (not p) = (p nand p)
         (let ([second-nand (to-nand (second e))])
           (make-nand second-nand
                      second-nand))]
        [(is-and? e) ;; (p and q) = ((p nand q) nand (p nand q))
         (let ([p (to-nand (first e))]
               (q (to-nand (third e))))
           (make-nand (make-nand p q)
                      (make-nand p q)))]
        [(is-or? e)  ;; (p or q) = ((p nand p) nand (q nand q))
         (let ([p (to-nand (first e))]
               (q (to-nand (third e))))
           (make-nand (make-nand p p)
                      (make-nand q q)))]
        [else
         (error "to-nand: unknown expression")]))

> (to-nand '(p and q))
'((p nand q) nand (p nand q))

> (to-nand '((p and q) or ((not p) or q)))
'((((p nand q) nand (p nand q)) nand ((p nand q) nand (p nand q)))
  nand
  ((((p nand p) nand (p nand p)) nand (q nand q)) nand (((p nand p) nand (p nand p)) nand (q nand q))))
```

We say that `to-nand` **compiles** an expression into a `nand`-only expression,
and so `to-nand` is an example of a compiler.

### Removing Double Negations

Another interesting application is to simplify an expression. For example, the
**double negation elimination rule** says that any expression of the form `(not
(not p))` is logically equivalent to `p`.

Lets write a function that removes double negations (`map` is the standard map
function defined earlier):

```lisp
;; double negation elimination
;; (not (not expr)) ==> expr
(define (simplify e)
  (cond [(symbol? e)
         e]
        [(and (is-not? e)    ;; e = (not (not p))
              (is-not? (second e)))
         (simplify (second (second e)))]
        [(or (is-not? e)     ;; e = (not p)
             (is-and? e)     ;; e = (p and q)
             (is-or? e)      ;; e = (p or q)
             (is-nand? e)    ;; e = (p nand q)
             (is-implies? e) ;; e = (p implies q)
             (is-iff? e))    ;; e = (p iff q)
         (map simplify e)]
        [else
         (error "simplify: unknown expression")]))

> (simplify '((not (not t)) and (not (not t))))
(t and t)

> (simplify '(t or ((not (not f)) and t)))
'(t or (f and t))
```

There are many other simplifications we can apply, e.g. `(f and e)` is logically
equivalent to `e`.
