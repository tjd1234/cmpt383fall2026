;; count_up.rkt

#lang racket

;;
;; Returns a new list (start start+1 ... stop-1).
;;
(define (count-up-help start stop)
  (if (< start stop)
      (cons start (count-up-help (+ start 1) stop))
      '()  ;; empty list returned if start >= stop
      ))

;;
;; Returns a new list (0 1 ... n-1).
;;
(define (count-up n) (count-up-help 0 n))

(count-up 10)