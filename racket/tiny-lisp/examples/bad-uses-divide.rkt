#lang tiny-lisp

;; Fails: `/` is not bound in tiny-lisp. `+`, `-`, and `*` are
;; allowed, but division is deliberately excluded -- it drags in exact
;; rationals and division-by-zero, which this language avoids by
;; staying within the integers.

(define (count lst)
  (cond
    [(empty? lst) 0]
    [else (+ 1 (count (rest lst)))]))

(/ (count '(a b c)) 2)
