# Racket Notes

## Racket Problem Set

The [Racket problem set](Racket_problemset.md).

## Installing Racket

Please use the [DrRacket IDE](https://racket-lang.org/). We won't use the
command-line version.

## Coding Style

Racket supports many different languages, and we will be using only the core
Racket language. You must put this line at the top of all your Racket source
files:

```lisp
#lang racket

;; ... your Racket code ...
```

While Racket/Scheme has loops, we are *not* going to be using them in our
discussion of Racket. We will also *not* be using any mutating Racket functions.

Instead we will focus on functional programming, a style of programming
pioneered by LISP. This is good preparation for Haskell (the language we'll
study after Racket), which does not allow loops or mutating functions.


## Racket Lectures

### Lecture 1,2 Racket: Basics

- [Introduction to Racket](racket_intro.md)


### Lecture 3 Racket: Lists, Symbols, and Recursion

- [Racket lists and recursion](racket_lists_and_recursion.md)
- Sample programs: [count_up.rkt](count_up.rkt),
  [count_down.rkt](count_down.rkt), [numbered_list.rkt](numbered_list.rkt),
  [primes.rkt](primes.rkt), [stats.rkt](stats.rkt), [bits.rkt](bits.rkt),
  [sort.rkt](sort.rkt)

### Lecture 4 Racket: Functional Programming

- [Maps, filters, and folds](racket_maps_filters_folds.md)

### Lecture 5, 6 Racket: Higher Order Functions

- [Higher order functions](racket_higher_order_functions.md)
- [The Racket match form](racket_match_form.md)

### Lecture 7 Racket: Symbolic Programming Examples
- [Symbolic Programming in Racket](racket_symbolic_programming.md)

### Skipped: Lecture 8 Racket: Macros
- [Racket macros](racket_macros.md)
