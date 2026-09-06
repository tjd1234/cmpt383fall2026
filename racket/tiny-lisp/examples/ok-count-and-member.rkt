#lang tiny-lisp

;; Uses `+` and `equal?`.

;; count the elements of a list
(define (my-length lst)
  (cond
    [(empty? lst) 0]
    [else (+ 1 (my-length (rest lst)))]))

;; is x an element of lst?
(define (member? x lst)
  (cond
    [(empty? lst) #f]
    [(equal? (first lst) x) #t]
    [else (member? x (rest lst))]))

(my-length '(a b c d))
(member? 3 '(1 2 3 4))
(member? 9 '(1 2 3 4))
