;; stats.rkt

#lang racket

(define numbers '(3
                  0
                  -2
                  2.5
                  4.5
                  5))

;;
;; Returns the sum of the numbers in lst.
;;
(define (sum1 lst)
  (if (empty? lst)
      0
      (+ (first lst) (sum1 (rest lst)))))

(define (mean lst)
  (/ (sum1 lst) (length lst)))

;;
;; Returns the smallest item on lst.
;;
;; Assumes lst is non-empty.
;;
(define (minlist1 lst)
  (if (= 1 (length lst))
      (first lst)
      (min (first lst)
           (minlist1 (rest lst)))))
      

;;
;; Returns the largest item on lst.
;;
;; Assumes lst is non-empty.
;;
(define (maxlist1 lst)
  (if (= 1 (length lst))
      (first lst)
      (max (first lst)
           (maxlist1 (rest lst)))))

;;
;; Using the apply function.
;;
;; The _, min, and max functions all work with multiple
;; arguments, so applying them to the passed-in lst does
;; what we want.
;;
(define (sum2 lst)     (apply +   lst))
(define (minlist2 lst) (apply min lst))
(define (maxlist2 lst) (apply max lst))


;;
;; Returns the median of the numbers on lst.
;;
(define (median lst)
  (let ([sorted (sort lst <)]
        [n (length lst)])
    (if (= 1 (remainder n 2))
        (list-ref sorted (/ (- n 1) 2))
        (/ (+ (list-ref sorted (- (/ n 2) 1))
              (list-ref sorted (/ n 2)))
           2))))
    
;;
;; Returns the standard deviation of the numbers on lst.
;;
(define (std-dev lst)
  (let ([n (length lst)]
        [avg (mean lst)])
    (sqrt (/ (sum1 (map (lambda (x) (sqr (- x avg)))
                        lst))
             n))))

