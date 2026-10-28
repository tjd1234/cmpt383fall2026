#lang tiny-lisp

;; Uses `-`, `let`, and `lambda`.

;; a user-defined higher-order function: apply f to every element
(define (my-map f lst)
  (cond
    [(empty? lst) (quote ())]
    [else (cons (f (first lst)) (my-map f (rest lst)))]))

;; subtract 1 from every element, using an anonymous function
(define (decrement-all lst)
  (my-map (lambda (x) (- x 1)) lst))

;; `let` to name an intermediate result
(define (double-first lst)
  (let ([x (first lst)])
    (cons (+ x x) (rest lst))))

(decrement-all '(3 4 5))
(double-first '(10 20 30))
