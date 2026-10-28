#lang tiny-lisp

;; Uses `/`. Division of integers gives an exact rational number when the
;; result isn't a whole number.

(define (count lst)
  (cond
    [(empty? lst) 0]
    [else (+ 1 (count (rest lst)))]))

(define (sum lst)
  (cond
    [(empty? lst) 0]
    [else (+ (first lst) (sum (rest lst)))]))

;; average of a non-empty list of numbers
(define (average lst)
  (/ (sum lst) (count lst)))

(average '(2 4 6))   ;; 4
(average '(1 2))     ;; 3/2
