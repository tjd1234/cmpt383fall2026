#lang racket

(define scale 2.5)

(define (inc n)
  (+ 1 n))
;; def inc(n): return n + 1


(define f (lambda (n)
            (* n 2)))

(define (good-password x)
  (and (string? x)                   ;; must be a string
       (<= 8 (length x))             ;; at least 8 chars
       (not (string-contains? x " ") ;; has no spaces
            )))

;;
;; Why is this an incorrect implementation for "and"?
;;
(define (bad-and e1 e2)
  (if e1
      (if e2 #t #f)
      #f
      ))

(define (launch-missiles)
  (println "missiles have been launched") ;; print a message
  #t                                      ;; #t signals missiles fired
  )

(define code 'halt)


(define (dist1 x1 y1 x2 y2)
  (let ([dx (- x1 x2)]
        [dy (- y1 y2)])
    (sqrt (+ (* dx dx) (* dy dy)))
    ))

#;(
   (lambda (a)
     (
      (lambda (b)
        (
         (lambda (c)
           (+ a b c)
           )
         2 ;; bound to c
         )
        )
      a ;; bound to b
      )
     )
   1 ;; bound to a
   )

(define (my-second lst)
  (first (rest lst)))