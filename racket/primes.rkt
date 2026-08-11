;; primes.rkt

#lang racket

;;
;; Returns a list of all the divisors of n.
;;
;; Works by removing from the list (1 2 ... n) all the
;; numbers that have a non-zero remainder when divided
;; into n.
;;
;; This is not the most efficient way to generate the
;; the divisors of n. Faster would be to check the numbers
;; up to, and including, the square root of n.
;;
(define (divisors n)
  (filter (lambda (d) (= 0 (remainder n d)))
          (range 1 (+ n 1))))
 

;;
;; Returns true when n is prime, and false otherwise.
;;
;; Not as efficient as it could be. You don't need all
;; divisors of n, you just need to know that the smallest
;; one is between 1 and n.
;;
(define (is-prime1? n)
  (cond [(< n 2) #f]
        [(= n 2) #t]
        [(= 0 (remainder n 2)) #f]
        [else (= 2 (length (divisors n)))]))

;;
;; Returns true when n is prime, and false otherwise.
;;
;; Simpler implementation that the previous version, but not as
;; efficient.
;;
(define (is-prime2? n)
  (= 2 (length (divisors n))))

(define (num-primes-less-than n)
  (length (filter is-prime2? (range n))))
;; > (time (num-primes-less-than 10000))
;; cpu time: 1531 real time: 1528 gc time: 607
;; 1229

