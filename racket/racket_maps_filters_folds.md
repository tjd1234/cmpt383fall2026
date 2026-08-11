---
tags: ["#racket"]
---

**Functional programming** is a style of programming that focuses on
**higher-order functions**, which are functions that take functions as
arguments, or return functions as values.

Lets look at three of the most useful higher-order functions are `map`,
`filter`, and `fold`.

## Mapping

The `(map f lst)` function applies a given function to every element of a list:

```lisp
> (map sqr '(1 2 3 4))
'(1 4 9 16)

> (map list '(this is a test))
'((this) (is) (a) (test))
```

In general, `(map f '(x1 x2 ... xn))` returns the value of `((f x1) (f x2) ...
(f xn))`.

Here's an implementation of `map`:

```lisp
(define (my-map f lst)
  (if (empty? lst) 
      '()
      (cons (f (first lst))
            (my-map f (rest lst)))))
```

## Challenge: list sums

Suppose `lst` is a list of number lists, where a number list is a list of
numbers. `lst` has zero or more number lists, and each number list has 0 or more
numbers.

Implement a function called `(insert-sum lst)` that returns a new list that is
the same as `lst` but the sum of each list of `lst` has its sum inserted as the
first element.

For example:

```lisp
> (insert-sum '(() (1) (2 3)))
'((0) (1 1) (5 2 3))
> (insert-sum '((1 2 3) (4) (5 6) (7 0 0 1)))
'((6 1 2 3) (4 4) (11 5 6) (8 7 0 0 1))
```

## Challenge: normalizing a list of numbers

Suppose `lst` is a list of 0 or more numbers.

Implement a function called `(normalize lst)` that returns a *normalized*
version of `lst`. To normalize `lst`, divide each of its numbers by the sum of
all numbers in `lst`.

All the numbers on the returned list should be between 0 and 1, and their sum
should be 1.

For example:

```lisp
> (normalize '(1 2 3))
'(1/6 1/3 1/2)
> (normalize '(10 5 2 2.1 3))
'(0.4524886877828054
  0.2262443438914027
  0.09049773755656108
  0.09502262443438914
  0.13574660633484162)
```

## Mapping Example: deep-count re-visited

The function `deep-count` was written in previous notes:

```lisp
;;
;; Returns the number of numbers on lst, even numbers
;; inside of lists:
;;
(define (deep-count-num lst)       
  (cond [(empty? lst) 0]
        [(list? (first lst))
         (+ (deep-count-num (first lst)) 
            (deep-count-num (rest lst)))]
        [(number? (first lst))
         (+ 1 (deep-count-num (rest lst)))]
        [else
         (deep-count-num (rest lst))]))

> (deep-count-num '(a 9 (b 8 9) ((up (or 16 you)))))
4
```

This implementation is straightforward. Its body is a `cond` that handles all
the possible cases of items on a list (plus the special case of the empty list).

A more functional way to implement this is with `foldr` and `map`. The idea is
to replace each item on the list with how many numbers it contains. There are
three kinds of items:

- A number is replaced by a 1.

- A list is replaced by the number of numbers it contains. This is calculated
  using a recursive call.

- Everything else is replaced by a 0.

This gives us a list of numbers whose sum is the number of numbers in the
list. For example:

```lisp
'(a 9 (b 8 9) ((up (or 16 you))))

becomes

'(0 1 2 1)
```

The sum of `'(0 1 2 1)'` is 4, which is the correct answer.

Here's the code:

```lisp
(define (sum lst) (foldr + 0 lst))

(define (deep-count-num lst)       
  (sum
   (map (lambda (x)
          (cond [(list? x) 
                 (deep-count-num x)]
                [(number? x) 
                 1]
                [else 
                 0]
                ))
        lst)))
```

Here's a similar implementation using a helper function that shows the essential
idea more clearly:

```lisp
(define (bool->int b) (if b 1 0))

(define (deep-count-num lst)       
  (sum
   (map (lambda (x)
          (if (list? x) 
              (deep-count-num x)
              (bool->int (number? x))))
        lst)))
```


Compared to the earlier `deep-count`:

- We don't need to explicitly check for the empty list. `map` handles that for
  us.

- There's only one recursive call to `deep-count`.

- There's no calls to `first` or `rest`. `map` takes care of the accounting
  details of picking the items out of the list.

- To understand it, you need to know what `foldr`, `map`, and `lambda` do.

Which implementation do you prefer?


## Challenge: deep sum

Implement a function `(deep-sum lst)` that works like `deep-count`, except
instead of returning the number of numbers in `lst` it returns their sum. For
example:

```lisp
> (deep-sum '(9 (b 8 9) ((up (or 16 you)))))
42
```

## Variations of map

Two useful variations of `map` are `andmap` and `ormap`. Both take a **predicate
function** (or **predicate** for short) and a list as input. A predicate takes
one input, and returns either `#f` or `#t`.

`andmap` returns `#t` if *all* the elements on the list satisfy the predicate,
and `#f` otherwise. For example:

```lisp
> (andmap even? '(1 2 3 4))
#f
> (andmap even? '(12 2 30 4))
#t
```

Here's an implementation:

```lisp
(define (my-andmap pred? lst)
  (if (empty? lst) 
      #t
      (and (pred? (first lst))
           (my-andmap pred? (rest lst)))))
```

`and` is short-circuited, so if `(pred? (first lst))` evaluates to `#f`, the
recursive call to `my-andmap` is *not* made.

`ormap` returns `#t` if 1, or more, elements on the list evaluate to `#t`, and
`#f` otherwise:

```lisp
> (ormap even? '(1 2 3 4))
#t
> (ormap even? '(1 25 3 41))
#f
```

Here's an implementation:

```lisp
(define (my-ormap pred? lst)
  (if (empty? lst) 
      #f   ;; base case different than my-andmap!
      (or (pred? (first lst))
          (my-ormap pred? (rest lst)))))
```

The built-in implementations of `map`, `andmap`, and `ormap` are a little more
general than what we've done, as they allow for multiple lists. For example:

```lisp
> (map + '(1 2 3) '(4 5 6))
'(5 7 9)

> (andmap (lambda (a b) (> a b)) '(11 6 6) '(4 5 6))
#f

> (andmap (lambda (a b) (> a b)) '(11 6 7) '(4 5 6))
#t
```

## Challenge: same sign

Implement a function called `(same-sign? lst)` the returns `#t` when *all* the
numbers on `lst` have the same *sign* and `#f` otherwise. Assume `lst` is a list
of zero or more numbers. Two numbers `x` and `y` have the same sign if `(equal?
(sgn x) (sgn y))` is true.
 
 For example:
 
```lisp
> (same-sign? '(1 4 2))
#t
> (same-sign? '(-1 -4 -2))
#t
> (same-sign? '(0 0 0 0.0))
#t
> (same-sign? '(1 0 4 2))
#f
> (same-sign? '(-1 -4 2))
#f
> (same-sign? '())
#t
```

## Challenge: checking sum lists

Implement a function called `(is-sum-list? lst)` that returns `#t` if `lst` is a
**sum-list**, and `#f` otherwise.

We define [Racket] expression `e` to be a **sum-list** if:

- `e` is a list

- `e` contains zero, or more, non-empty lists of numbers

- the first element of each list on `e` is the sum of the rest of the elements
  on the list

```lisp
> (is-sum-list? '((3 1 2) (13 4 4 5)))
#t
> (is-sum-list? '())
#t
> (is-sum-list? '((0)))
#t
> (is-sum-list? '((3)))
#f
> (is-sum-list? '((1 2) (3 4 5)))
#f
> (is-sum-list? '(cow bird duck))
#f
> (is-sum-list? 'cheese)
#f
```

## Filtering

`(filter pred? lst)` returns a new list that contains just the elements of `lst`
that satisfy `pred?`.

`pred?` is a **predicate function**, which is a function that takes one input,
and returns `#t` or `#f`.

For example:

```lisp
> (filter odd? '(1 2 3 4 5 6))
'(1 3 5)

> (filter even? '(1 2 3 4 5 6))
'(2 4 6)

> (filter (lambda (lst) (>= (length lst) 2))
          '((a b) (5) () (one two three)))
'((a b) (one two three))
```

Here's an implementation:

```lisp
(define (my-filter pred? lst)
  (cond [(empty? lst) 
           '()]
        [(pred? (first lst))
           (cons (first lst) (my-filter pred? (rest lst)))]
        [else
           (my-filter pred? (rest lst))]))
```

A common use of `filter` to count how many elements of a list satisfy a
predicate. For example, to count the number of symbols in a list, you can do
this:

```lisp
> (length (filter symbol? '(we have 4 kinds of 2 wheelers)))
5
```

### Challenge: a filter function

Using the `length` trick just shown, implement a function called `(count-pred
pred? lst)` that returns the number of top-level elements in `lst` that satisfy
`pred?`. For example:

```lisp
> (count-pred even? '(1 2 3 4 5 6))
3
> (count-pred symbol? '(we have 4 kinds of 2 wheelers))
5
> (count-pred (lambda (x) (or (equal? x 'a) (equal? x 'b))) '(a c b b a d c a))
5
```

## Folding

*Folding* applies a 2-argument function to a list in a way that combines all the
elements into a final value. It's like a generalization of `+`, e.g. `(+ 2 5 3
1)` sums all the elements of the list. 

To understand how folding works, first look at these concrete folding functions:

```lisp
(define (sum lst)
  (if (empty? lst) 
      0
      (+ (first lst) (sum (rest lst)))))

(define (prod lst)
  (if (empty? lst) 
      1
      (* (first lst) (prod (rest lst)))))

(define (my-length lst)
  (if (empty? lst) 
      0
      (+ 1 (my-length (rest lst)))))
```

Their implementations all follow the same pattern that we will call
`fold-right`. For example, `(+ 2 5 3 1)` can be written in infix notation as $2
+ (5 + (3 + (1 + 0)))$. Or if we convert that to prefix notation, it becomes `(+
2 (+ 5 (+ 3 (+ 1 0))))`. This is exactly what `fold-right` does, except that `+`
is replaced by some given binary function `op`, and the initial 0 is replaced by
some given initial value `init` that makes sense for `op`:

```lisp
;; (op a (op b (op c init)))
(define (fold-right op init lst)
  (if (empty? lst) 
      init
      (op (first lst) 
         (fold-right op init (rest lst)))))
```

`fold-right` can implement each of the above functions in one line:

```lisp
> (fold-right + 0 '(1 2 3 4))
10

> (fold-right * 1 '(1 2 3 4))
24

> (fold-right (lambda (next accum) (+ accum 1)) 0 '(1 2 3 4))
4
```

The function `op` passed to `fold-right` must take two inputs, and it is helpful
to call the first input `next` and the second input `accum`. The idea is that
`next` gets assigned each value of the list, one at a time, and `accum`
*accumulates* the results. Exactly how the values are accumulated depends on
`op`.

`fold-right` is quite general. For instance, it can implement `map`:

```lisp
(define (my-map2 f lst)
  (fold-right (lambda (next accum) (cons (f next) accum))
              '()
              lst))

> (my-map2 list '(one two (three)))
'((one) (two) ((three)))

> (my-map2 sqr '(2 3 5))
'(4 9 25)
```

## Challenge: filtering with fold

Using just one call to `fold-right`, implement the function `(my-filter pred? lst)`.

## Folding consed-out lists

Folds can be tricky to think about. For example, what does `(fold-right cons '()
'(a b c d))` evaluate to?

Here is a perspective that can help with right folds. Any list can be written in
consed-out form, e.g. `'(a b c d)` is:

```lisp
> (cons 'a (cons 'b (cons 'c (cons 'd '()))))
'(a b c d)
```

You can think of `(fold-right op init '(a b c d))` as *replacing* `cons` with `op`
and `'()` with `init` in the consed-out list:

```lisp
(fold-right op init '(a b c d))

;; is the same as

(op 'a (op 'b (op 'c (op 'd init))))
```

For example, `(fold-right + 0 '(1 2 3))` evaluates this expression:

```lisp
(+ 1 (+ 2 (+ 3 0)))
```

With this in mind, we can see that `(fold-right cons '() '(a b c d))` evaluates
to `'(a b c d)`.

`fold-right` is called a *right* fold because it processes the items in the list
in *reverse* order, from the right end to the left end. For example,
`(fold-right + 0 '(1 2 3))` is this: `(+ 1 (+ 2 (+ 3 0))`. First `(+ 3 0)` is
calculated, and then `(+ 2 3)` is calculated, and finally `(+ 1 5)`.

For some expressions, that might not be the order you want, and so there is the
`fold-left` function applies `op` from left to right. It is usually defined like
this:

```lisp
;; (op (op (op init a) b) c)
(define (fold-left op init lst)
  (if (empty? lst) 
      init
      (fold-left op (op init (first lst)) (rest lst))))
```

A nice feature of `fold-left` is that it is **tail-recursive**, i.e. the last
thing it does is call itself. [Racket] can automatically optimize away the
recursion in a tail-recursive functions and replace it with a loop. This saves
both time and memory. For this reason, in practice, left folds are often
preferable to right folds.

Both left and right folds are built-in functions in [Racket]. `foldr` is the
same as our `foldr`, but `foldl` is not defined quite the same as
`fold-left` (the `show` function is defined below):

```lisp
> (foldl show 'init '(a b c d))
'(op d (op c (op b (op a init))))
> (fold-left show 'init '(a b c d))
'(op (op (op (op init a) b) c) d)
```

## Folding Example: The Structure of Folds

To better understand how folds work, lets write a function that calculates the
structure of a fold. First, we define this function:

```lisp
(define (show next acc)
  (cons 'op (cons next (list acc))))
  
> (show 'a '(c d))
'(op a (c d))
```

By passing `show` to the various fold functions, we get a list showing the
order of evaluation. For example:

```lisp
> (foldr show '() '(a b c))
'(op a (op b (op c ())))
> (foldr show '() '(a b c))
'(op a (op b (op c ())))
```

This shows that both our `foldr`, and the built-in [Racket] `foldr`
evaluate to the same thing. However, `fold-left` and `foldl` are different:

```lisp
> (fold-left show '() '(a b c))
'(op (op (op () a) b) c)
> (foldl show '() '(a b c))
'(op c (op b (op a ())))
```

This last expression suggests that `foldl` could be implemented like this:

```lisp
(define (my-foldl f init lst)
  (foldr f init (reverse lst)))
```

However, this is *not* how [Racket] implements `foldl`. According to [the
documentation for foldl and foldr]
(https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Fprivate%2Flist..rkt%29._foldl%29%29),
`foldl` uses a *constant* amount of space to process the list, while `foldr`
uses an amount of space proportional to the size of the list. But this
implementation of `my-foldl` calls `foldr`, meaning it uses space
proportional to the size of the list.

[Scheme]: https://en.wikipedia.org/wiki/Scheme_(programming_language)
[Racket]: https://racket-lang.org/
[LISP]: https://en.wikipedia.org/wiki/Lisp_(programming_language)
[Java]: https://en.wikipedia.org/wiki/Java
