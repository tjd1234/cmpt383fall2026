#lang racket

(define (clamp-fn f lo hi)
  (lambda (x)
    (let ([fx (f x)])
      (cond [(< fx lo) lo]
            [(< hi fx) hi]
            [else      fx]))))

(define g (clamp-fn sqr 10 20))


(define (bigger f g)
  (lambda (x)
    (max (f x) (g x))))