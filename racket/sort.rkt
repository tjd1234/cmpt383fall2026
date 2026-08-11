;; sort.rkt

#lang racket

;;
;; The standard Racket sort function takes two arguments:
;;
;;    (sort some-list less-than-fn)
;;
;; It returns a new list containing the elements of some-list in order
;; according to less-than-fn.
;;
;; For example:
;;
;;   > (sort '(10 -4.5 12 8 5 3 12) <)
;;   '(-4.5 3 5 8 10 12 12)
;;
;;   > (sort '("once" "upon" "a" "time") string<?)
;;   '("a" "once" "time" "upon")
;;


;;
;; A list of (name age) pairs.
;;
(define people
  '(("Bob" 10) ("Maya" 55) ("Scooby" 7) ("Anais" 40)))

(define (by-name x y)
  (string<? (first x) (first y)))

(define (by-age x y)
  (< (second x) (second y)))

;;
;; Sort by names.
;;
(sort people by-name)

;;
;; Sort by age.
;;
(sort people by-age)

