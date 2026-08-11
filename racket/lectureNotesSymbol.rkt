#lang racket

(define (count-sym3 lst)
  (length (filter symbol? lst)))

;;
;; Returns a list contain all the elements of lst that satisfy pred?.
;;
(define (myfilter pred? lst)
  (cond [(empty? lst)
         '()]
        [(pred? (first lst))
         (cons (first lst)
               (myfilter pred? (rest lst)))]
        [else
         (myfilter pred? (rest lst))]))

(define (deep-count-sym lst)
  (count-sym3 (flatten lst)))


(define (my-flatten lst)
  (cond [(empty? lst) '()]
        [(list? (first lst))
         (append (my-flatten (first lst))
                 (my-flatten (rest lst)))]
        [else
         (cons (first lst)
               (my-flatten (rest lst)))]))

