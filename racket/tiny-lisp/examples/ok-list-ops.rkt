#lang tiny-lisp

;; Everything here uses only: define, cond, else, and, or, not,
;; empty?, first, rest, cons, list, quote -- tiny-lisp's original
;; primitive set, before equal?/+/-/*/let/lambda were added. These
;; functions don't need any of the later additions: they only branch
;; on "is it empty?" and recurse over list structure. (`if` is still
;; genuinely absent from the language -- see examples/bad-uses-if.rkt.)

;; append two lists
(define (my-append lst1 lst2)
  (cond
    [(empty? lst1) lst2]
    [else (cons (first lst1) (my-append (rest lst1) lst2))]))

;; reverse a list
(define (my-reverse lst)
  (cond
    [(empty? lst) (quote ())]
    [else (my-append (my-reverse (rest lst)) (list (first lst)))]))

;; is every element of a list-of-lists itself empty?
(define (all-empty? lol)
  (cond
    [(empty? lol) #t]
    [else (and (empty? (first lol)) (all-empty? (rest lol)))]))

;; is at least one element of a list-of-lists non-empty?
(define (any-nonempty? lol)
  (cond
    [(empty? lol) #f]
    [else (or (not (empty? (first lol))) (any-nonempty? (rest lol)))]))

(my-append '(1 2 3) '(4 5 6))
(my-reverse '(1 2 3 4 5))
(all-empty? (list '() '() '()))
(any-nonempty? (list '() '(x) '()))
