#lang tiny-lisp

;; Uses `*`.

;; product of a list of numbers
(define (product lst)
  (cond
    [(empty? lst) 1]
    [else (* (first lst) (product (rest lst)))]))

;; factorial -- now expressible since we have both `-` and `*`
(define (factorial n)
  (cond
    [(equal? n 0) 1]
    [else (* n (factorial (- n 1)))]))

;; square every element, via the higher-order `my-map` pattern
(define (my-map f lst)
  (cond
    [(empty? lst) (quote ())]
    [else (cons (f (first lst)) (my-map f (rest lst)))]))

(define (square-all lst)
  (my-map (lambda (x) (* x x)) lst))

(product '(1 2 3 4))
(factorial 5)
(square-all '(1 2 3 4))
