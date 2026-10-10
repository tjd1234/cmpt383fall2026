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
> (last '(the big brown dog (at an apple)))
'(at an apple)
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

> (remove-all 'cat '())
'()
> (remove-all 'cat '(cat))
'()
> (remove-all 'dust '(dirt dust dust dirt (dirt dust)))
'(dirt dirt (dirt dust))
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
lists in `list-of-lists`. The recursive idea is:

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
> 
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

`(reverse-acc L)` returns a new list that is the reverse of the list `L`. It
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

`length` and `length2` both have about the same running time, but `length2` is more space-efficient because it doesn't need to build up the list `(+ 1 (+ 1 (+ 1 ...)))`.

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

`map` is quite useful in practice, and most modern programming languages have a
`map` function in some form. For example, in Python list comprehensions are a
form of `map`:

```
Python:
[x * x for x in [1, 2, 3]]

Lisp:
(map (lambda (x) (* x x)) '(1 2 3))
```

Note that  `(map fn L)` always returns a list that is the same length as the
list `L`. `map` cannot increase or decrease the length of the list.

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

In practice, `filter` is quite useful and goes together well with `map`. For example, Python's list comprehensions are a form of `filter` and `map`:
```
Python:
[x * x for x in [1, 2, 3, 4, 5] 
       if x % 2 == 0]

Lisp:
(map (lambda (x) (* x x))
     (filter even? '(1 2 3 4 5)))
```

### all

`(all pred? L)` returns `#t` if all the elements of `L` satisfy the predicate.
Or, a little more precisely, `(all pred? L)` returns `#t` just when there is no
element in `L` that makes `pred?` return `#f`. 

`pred?` is a boolean predication function that takes one input and returns `#t`
or `#f`, while `L` is a list of 0 or more elements that `pred?` can be applied
to.

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

There is another way to implement `all` using `filter`. The idea is to filter on
the elements that *don't* satisfy `pred?`. If that filtered list is length 0,
then all the elements of `L` satisfy `pred?`. Otherwise, some element of `L`
does not satisfy `pred?`, and so `all` returns `#f`:

```lisp
(define (all pred? L)
  (empty? (filter (lambda (x) (not (pred? x))) 
                  L)))
```

Unfortunately, this implementation is often slower than the recursive version.
The recursive version ends as soon as `pred?` returns `#f`: there is no reason
to keep checking once we know that the result is `#f`. 

However, the `filter` version always calls `pred?` on all the elements of `L`,
even if the very first element makes `pred?` return `#f`.

Yet, despite it's slowness, the `filter` version is interesting because it is
doesn't explicitly use recursion, and is instead built-up from simpler
operations. For many programmers, it is easier to understand and reason about
than the recursive version.

### folding a list

**Folding** a list is a powerful technique that we'll introduce through an
example. Consider the list `'(a b c d)`. We can write i ast a series of nested
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

Now imagine generalization the cons-ed out form to work with *any* binary
function (on values that make sense for it). For instance, imagine replacing
`cons` with `+`:

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
binary operator `op` that works those list values, and also we have the final
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

It is useful to trace a function call. Imagine calling `(sum '(1 2 3 4))`, and evaluating it step by step:

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

`op` is `(lambda (next acc) (+ acc 1))`, so we we do one step of evaluation we
get:

```
(foldr op 0 '(a b c))
= (op a (op b (op c 0)))
= (op a (op b (+ 0 1)))
```

The `c` disappears because the body of `op` adds 1 to the accumulated value.
Continuing this process, the calls to `op` are evaluated in the usual way:

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

### member has a right fold

The `(member x L)` function can be written like this:

```lisp
(define (member x L)
  (foldr (lambda (next acc) (or (eq? next x) acc))
         #f
         L))
```

For example, `(member? 3 '(1 2 3 4))` evaluates to:

```lisp
(or (equal? 1 3)
    (or (equal? 2 3)
        (or (equal? 3 3)  ;; a match!
            (or (equal? 4 3) #f))))
```

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

### deep-count of a list

Coming soon!

### flatten a list

Coming soon!

### insertion sort

Coming soon!

### quicksort with filter

Coming soon!
