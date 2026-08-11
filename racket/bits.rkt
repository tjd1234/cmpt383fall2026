;; bits.rkt

#lang racket

;def nbits(n)
;    # non-recursive base cases
;    return [] if n < 0
;    return ['0','1'] if n == 1
;
;    # recursive case
;    n1bits = nbits(n-1)
;    zero = n1bits.map {|s| '0' + s}
;    one = n1bits.map {|s| '1' + s}
;    return zero + one
;end

;;
;; Returns a list of all bit list of length n.
;;
;; > (nbits 2)
;; '((0 0) (0 1) (1 0) (1 1))
;;
;; Note the use of let* instead of let. let* allows you to use
;; bindings that have been declarted in the same let* environment.
;;
(define (nbits n)
  (cond [(< n 0) '()]
        [(= n 1) '((0) (1))]
        [else (let* ([n1bits (nbits (- n 1))]
                     [zero (map (lambda (bits) (cons 0 bits)) n1bits)]
                     [one (map (lambda (bits) (cons 1 bits)) n1bits)])
                (append zero one))]))

                