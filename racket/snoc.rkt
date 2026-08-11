#lang racket

;; snoc.rkt

;;
;; (snoc x lst) returns a new list that is the same as lst, but x
;; has been added to the end:
;;
;;   > (snoc 'x '(1 2 3))
;;   '(1 2 3 x)
;;

(define (snoc1 x lst)
  (append lst (list x)))

(define (snoc2 x lst)
  (reverse (cons x (reverse lst))))

(define (snoc3 x lst)
  (if (empty? lst)
      (list x)
      (cons (first lst) (snoc3 x (rest lst)))))
