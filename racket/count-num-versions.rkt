#lang racket

;;
;; Different ways to count numbers in a list.
;;

#;(define (count-num lst)
    (cond [(empty? lst) 0]
          [(number? (first lst))
           (+ 1 (count-num (rest lst)))]
          [else (count-num (rest lst))]))

#;(define (count-num lst)
    (if (empty? lst) 0
        (+ (if (number? (first lst)) 1 0)
           (count-num (rest lst)))))
        
#;(define (count-num lst)
    (apply +
           (map (lambda (x) (if (number? x) 1 0))
                lst)
           ))

#;(define (count-num lst)
    (length (filter number? lst)))
