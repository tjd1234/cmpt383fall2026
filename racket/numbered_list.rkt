;; numbered_list.rkt

#lang racket

(define pets '(cat dog bird hamster))

;;
;; Returns a list of pairs, where the the first element of each pair
;; is a number, and the second element is the corresponding value in lst.
;;
(define (make-numbered-list-help lst start)
  (if (empty? lst)
      '()
      (cons (list start (first lst))
            (make-numbered-list-help (rest lst)
                                     (+ start 1))
            )))

(define (make-numbered-list lst)
  (make-numbered-list-help lst 1))

(make-numbered-list pets)
;; '((1 cat) (2 dog) (3 bird) (4 hamster))
