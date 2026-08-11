;; count_down.rkt

#lang racket

;;
;; Returns a new list (n n-1 ... 0).
;;
(define (count-down-help n)
  (if (<= n 0)
      '()
      (cons n (count-down-help (- n 1)))))

;;
;; Returns a new list (n n-1 ... 0 blast-off!).
;;
(define (count-down n)
  (append (count-down-help n) '(blast-off!)))

(count-down 10)
