# Tiny Lisp Group Practice

Work in groups of 3 to write the recursive functions below. Please implement in
them in the same recursive style as the functions in the [tiny-lisp
introduction](tiny_lisp_intro.md). Don't use any filter/fold functions (we'll
cover later!), just recursion.

**Important**: *This is a non-AI activity!* Turn off all AI support. The point
is for your group to figure it out together.

## Setup

1. Form a group of 3 people. You only need one laptop, with DrRacket and
   [tiny-lisp](tiny-lisp/README.md) installed.

2. Download [tiny_lisp_practice.rkt](tiny_lisp_practice.rkt), open it in
   DrRacket, put your names at the top, and click **Run**. Every test should
   print `FAIL` for now.

3. Each person takes one of these roles. **Change roles after each problem.**

   - **Driver**: types the code. The driver doesn't decide what to write.
   - **Navigator**: decides what code to write and tells the driver.
   - **Tester**: predicts what each test should print, tries extra examples in
     the interactions window, and looks for missing cases.

## How to Solve Each Problem

Before writing any code, write down the **recursive idea** in 2 or 3 bullet
points, like the notes do. For example, here's the idea for `length`:

- return 0 if the list is empty
- otherwise, return 1 plus the length of the rest of the list

*Then* write the code. When all the tests for a problem print `'(ok ...)`, go on
to the next problem.

Remember that tiny-lisp has no `if`; use `cond`.

## Problem 1: count-evens

`(count-evens L)` returns how many even numbers are in the list of integers `L`.

```lisp
> (count-evens '())
0
> (count-evens '(1 3 5))
0
> (count-evens '(1 2 3 4 6))
3
```

*Hint*: This is very similar to `count` in the notes, but don't call `count` in
your code.

## Problem 2: max-of

`(max-of L)` returns the largest number in the list `L`. If `L` is empty, call
`error`.

```lisp
> (max-of '(5))
5
> (max-of '(3 9 2 7))
9
> (max-of '(-4 -1 -8))
-1
> (max-of '())
. . max-of: empty list
```

## Problem 3: zip

`(zip A B)` returns a list of 2-element lists that pair up the corresponding
elements of `A` and `B`. If one list is longer than the other, the extra
elements are ignored.

```lisp
> (zip '(a b c) '(1 2 3))
'((a 1) (b 2) (c 3))
> (zip '(a b c) '(1))
'((a 1))
> (zip '() '(1 2))
'()
```

## Problem 4: sorted?

`(sorted? L)` returns `#t` if the numbers in `L` are in ascending order, and
`#f` otherwise. Duplicates are allowed, so `'(1 2 2 5)` is sorted. The empty
list and lists with one element are sorted.

```lisp
> (sorted? '())
#t
> (sorted? '(1 2 2 5))
#t
> (sorted? '(1 2 3 0))
#f
```

## Problem 5: range

`(range n)` returns the list of integers from 0 up to, but not including, `n`.
You can assume `n` is a non-negative integer.

```lisp
> (range 0)
'()
> (range 1)
'(0)
> (range 5)
'(0 1 2 3 4)
```

## When You're Done

Submit your finished file to your Canvas TA group so that others can see your
solutions.
