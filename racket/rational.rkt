#lang racket

;; rational.rkt

(define (make-rational n d)
  (if (= d 0)
      (raise "make-rational: denominator can't be 0")
      (list n d)))

(define (int-to-r n)
  (if (integer? n)
      (list n 1)
      (raise "int-to-r: n is not an integer")))

(define numerator first)
(define denominator second)
(define to-pair identity)

(define (to-string r)
  (string-append (~s (numerator r))
                 "/"
                 (~s (denominator r))))

(define (to-float r)
  (exact->inexact (/ (numerator r) (denominator r))))

(define r= equal?)

(define (r< x y)
  (let ([ad (* (numerator x) (denominator y))]
        [cb (* (numerator y) (denominator x))])
    (< ad cb)))
        
(define (is-int? r)
  (let ([d (denominator r)])
    (and (integer? d)
         (= 1 d))))

(define (add x y)
  (let ([a (numerator x)]
        [b (denominator x)]
        [c (numerator y)]
        [d (denominator y)])
    (make-rational (+ (* a d) (* b c))
                   (* b d))))

(define (multiply x y)
  (let ([a (numerator x)]
        [b (denominator x)]
        [c (numerator y)]
        [d (denominator y)])
    (make-rational (* a b) (* b d))))

(define (divide x y)
  (let ([a (numerator x)]
        [b (denominator x)]
        [c (numerator y)]
        [d (denominator y)])
    (cond [(or (= b 0) (= d 0))
           (raise "divide: denominators can't be 0")]
          [(= c 0)
           (raise "divide: numerator of divisor is 0")]
          [else 
           (make-rational (* a d) (* b c))])))

(define (invert x)
  (let ([n (numerator x)]
        [d (denominator x)])
    (if (= 0 n)
        (raise "invert: numerator can't be 0")
        (make-rational d n))))

(define (to-lowest-terms x)
  (let* ([n (numerator x)]
         [d (denominator x)]
         [g (gcd n d)])
    (make-rational (/ n g) (/ d g))))

;;
;; > (to-lowest-terms (harmonic-sum 25))
;; '(34052522467 8923714800)
;;
(define (harmonic-sum n)
  (if (= n 1)
      (make-rational 1 1)
      (add (make-rational 1 n)
           (harmonic-sum (- n 1)))))
