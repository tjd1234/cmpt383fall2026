#lang racket

;; rational2.rkt

;; TODO: remove all check- functions (use test functions at end of file)
;; TODO: call test functions

;;
;; Assertion macro for testing.
;;
(define-syntax-rule (assert expr)
  (when (not expr)
    (error 'assert "assertion failed: ~s" (quote expr))))

;;
;; Returns a new rational value. (make-rational n d) returns n/d,
;; and (make-rational n) returns n/1.
;;
(define (make-rational . args)
  (match args
    [(list n d) (cond [(= d 0)
                       (raise "make-rational: denominator can't be 0")]
                      [(< d 0) (list (- n) (- d))]
                      [else (list n d)])]
    [(list n) (cond [(integer? n) (list n 1)]
                    [(rational? n) (list (numerator n) (denominator n))]
                    [else
                     (raise "make-rational: arg must be 1 or 2 integers")])]
    [_ (raise "make-rational: arg must be 1 or 2 integers")]))

         
;;
;; Returns true if x is a rational value, and false otherwise.
;;
(define (is-rat? x)
  (match x
    [(list n d) (and (integer? n)
                     (integer? d)
                     (not (zero? d)))]
    [_ #f]))

(define r-numerator first)
(define r-denominator second)

;; Returns the numerator and denominator of r as multiple values.
;; Use with the let-values environment.
#;(define (num/denom r)
    (values (r-numerator r) (r-denominator r)))

;;
;; Takes any number of rationals as input and returns the
;; numerators and denominators as multiple values that can
;; be extracted inside a let-values environment.
;;
(define (num/denom . args)
  (apply values (flatten (map (lambda (r)
                                (list (r-numerator r)
                                      (r-denominator r)))
                              args))))

;;
;; Returns the numerator and denominator as a list.
;;
(define (num-denom r) r)

;;
;; Given a rational n/d, returns the string "n/d".
;;
(define (to-string r)
  (string-append (~s (r-numerator r))
                 "/"
                 (~s (r-denominator r))))

;;
;; Converts rational r to an inexact floating point number.
;;
(define (to-float r)
  (exact->inexact (/ (r-numerator r) (r-denominator r))))

;;
;; Convert a rational to a Racket rational. Useful for testing.
;;
(define (to-racket-rational r)
  (/ (r-numerator r) (r-denominator r)))

(define r= equal?)

;;
;; Returns true iff rational x comes before rational y.
;;
#;(define (r< x y)
    (let ([ad (* (r-numerator x) (r-denominator y))]
          [bc (* (r-numerator y) (r-denominator x))])
      (< ad bc)))

(define (r< x y)
  (let*-values ([(a b c d) (num/denom x y)]
                [(ad) (* a d)]
                [(bc) (* b c)])
    (< ad bc)))

(define (check-r< x y)
  (and (rational? x) (rational? y)
       (let* ([expected (< x y)]
              [given (r< (make-rational x)
                         (make-rational y))])
         (equal? expected given))))

;;
;; Returns true iff rational r is an integer, i.e. r has
;; the form n/1 for some integer n.
;;
(define (is-int? r)
  (let ([d (r-denominator (to-lowest-terms r))])
    (and (integer? d)
         (= 1 d))))

#;(define (add x y)
    (let ([a (r-numerator x)]
          [b (r-denominator x)]
          [c (r-numerator y)]
          [d (r-denominator y)])
      (make-rational (+ (* a d) (* b c))
                     (* b d))))

;;
;; Returns the sum of two rationals.
;;
(define (r+ x y)
  (let-values ([(a b c d) (num/denom x y)])
    (make-rational (+ (* a d) (* b c))
                   (* b d))))

(define (check-r+ x y)
  (and (rational? x) (rational? y)
       (let* ([expected (+ x y)]
              [given (r+ (make-rational x)
                         (make-rational y))])
         (= expected (to-racket-rational given)))))

#;(define (multiply x y)
    (let ([a (r-numerator x)]
          [b (r-denominator x)]
          [c (r-numerator y)]
          [d (r-denominator y)])
      (make-rational (* a b) (* b d))))

;;
;; Returns the product of two rationals.
;;
(define (r* x y)
  (let-values ([(a b c d) (num/denom x y)])
    (make-rational (* a c) (* b d))))

(define (check-r* x y)
  (and (rational? x) (rational? y)
       (let* ([expected (* x y)]
              [given (r* (make-rational x)
                         (make-rational y))])
         (= expected (to-racket-rational given)))))

;;
;; Returns the quotient of two rationals.
;;
(define (r/ x y)
  (let-values ([(a b c d) (num/denom x y)])
    (cond [(or (= b 0) (= d 0))
           (raise "divide: denominators can't be 0")]
          [(= c 0)
           (raise "divide: numerator of divisor is 0")]
          [else 
           (make-rational (* a d) (* b c))])))

(define (check-r/ x y)
  (and (rational? x) (rational? y)
       (let* ([expected (/ x y)]
              [given (r/ (make-rational x)
                         (make-rational y))])
         (= expected (to-racket-rational given)))))

#;(define (invert x)
    (let ([n (r-numerator x)]
          [d (r-denominator x)])
      (if (= 0 n)
          (raise "invert: numerator can't be 0")
          (make-rational d n))))

;;
;; Returns the inversion of rational r, i.e. n/d becomes d/n.
;;
(define (invert r)
  (let-values ([(n d) (num/denom r)])
    (if (= 0 n)
        (raise "invert: numerator can't be 0")
        (make-rational d n))))

(define (check-invert x)
  (and (rational? x)
       (not (zero? x))
       (let* ([expected (/ 1 x)]
              [given (invert (make-rational x))])
         (= expected (to-racket-rational given)))))

#;(define (to-lowest-terms x)
    (let* ([n (r-numerator x)]
           [d (r-denominator x)]
           [g (gcd n d)])
      (make-rational (/ n g) (/ d g))))

;;
;; Returns a rational equal to r that is in lowest terms.
;;
(define (to-lowest-terms r)
  (let*-values ([(n d) (num/denom r)]
                [(g) (gcd n d)])
    (make-rational (/ n g) (/ d g))))

(define (check-to-lowest-terms x)
  (and (rational? x)
       (let* ([expected x]
              [given (to-lowest-terms (make-rational x))])
         (= expected (to-racket-rational given)))))

;;
;; Ruby:
;; n = 25: 34052522467/8923714800
;;
;; > (to-lowest-terms (harmonic-sum 25))
;; '(34052522467 8923714800)
;;
(define (harmonic-sum n)
  (if (= n 1)
      (make-rational 1 1)
      (r+ (make-rational 1 n)
          (harmonic-sum (- n 1)))))

(define (racket-harmonic-sum n)
  (if (= n 1)
      (/ 1 1)
      (+ (/ 1 n)
         (racket-harmonic-sum (- n 1)))))

;;
;; Sorting
;;


;;
;; Returns a new list that is the same as lst, except
;; x has been inserted at location i,
;;
;; > (insert '(0 1 2 3 4) 'x 3)
;; '(0 1 2 x 3 4)
;;
(define (insert lst x i)
  (append (take lst i)
          (list x)
          (drop lst i)))

;;
;; Returns #t iff lst is in ascending sorted order.
;;
(define (sorted? lst)
  (or (empty? lst)
      (empty? (rest lst))
      (and (<= (first lst) (second lst))
           (sorted? (rest lst)))))

;;
;; Returns a new copy of lst with x inserted into the correct
;; sorted position.
;;
;; Assumes lst is in sorted order
;;
(define (insert-sorted lst x)
  (cond [(empty? lst)
         (list x)]
        [(<= x (first lst))
         (cons x lst)]
        [else
         (cons (first lst)
               (insert-sorted (rest lst) x))]))

;;
;; Assumes left is sorted. Ends when right is empty.
;;
(define (insertion-sort-help left right)
  (cond [(empty? right)
         left]
        [else
         (insertion-sort-help
          (insert-sorted left (first right))
          (rest right))]))

;;
;; > (insertion-sort (shuffle (range 10)))
;; '(0 1 2 3 4 5 6 7 8 9)
;;
(define (insertion-sort lst)
  (insertion-sort-help '() lst))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Testing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (test-make-rational)
  (let* ([nd-values '([0  1]
                      [2  8]
                      [19 3]
                      [6  1])]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        [rn (r-numerator r)]
                        [dn (r-denominator r)])
                   (and (integer? rn) (integer? dn)
                        (= n rn) (= d dn)
                        (r= r r))))]
         [failures (filter (lambda (p) (not (okay p))) nd-values)])
    (if (empty? failures)
        (display "test-make-rational: all tests passed!")
        (begin (display "test-make-rational: some tests failed")
               failures))))
    

(define (all-vals n d)
  (list (/ n d) (/ (- n) d) (/ n (- d)) (/ (- n) (- d))))

(define test-values
  (append (all-vals 1 2)
          (all-vals 7 1)
          (all-vals 20 20)
          (all-vals 21 21)
          (all-vals 200 20)
          (all-vals 20 200)
          (all-vals 101 9001)
          (all-vals 9001 101)
          ))

(define zero-test-values
  (append (all-vals 0 1)
          (all-vals 0 2)
          (all-vals 0 10)
          ))

(define all-test-values (append test-values zero-test-values))

(define (test-divide-rational)
  (let* ([nd-values '([2   8]
                      [19  3]
                      [30 15]
                      [5   5]
                      [6   1])]
         [all-pairs (cartesian-product nd-values nd-values)]
         ;; ([a b] [c d])
         [okay (lambda (p-pair)
                 (let* ([a (first (first p-pair))]
                        [b (second (first p-pair))]
                        [c (first (second p-pair))]
                        [d (second (second p-pair))]
                        [r1 (make-rational a b)]
                        [r2 (make-rational c d)]
                        )
                   (= (/ (/ a b) (/ c d))
                      (to-racket-rational (r/ r1 r2)))))]
         [failures (filter (negate okay) all-pairs)])
    (if (empty? failures)
        (display "test-divide-rational: all tests passed!")
        (begin (display "test-divide-rational: some tests failed")
               failures))))
  
(define (okay1? r)
  (and
   (check-r/ (first r) (second r))
   ))

(display "/ failures: ")
(length (filter (negate okay1?)
                (cartesian-product test-values test-values)))

(define (okay2? r)
  (and
   (check-r+ (first r) (second r))
   (check-r* (first r) (second r))
   (check-r< (first r) (second r))
   ))

(define (test-r+-rational)
  (let* ([nd-values '([0   7]
                      [2   8]
                      [19  3]
                      [30 15]
                      [5   5]
                      [6   1])]
         [all-pairs (cartesian-product nd-values nd-values)]
         ;; ([a b] [c d])
         [okay (lambda (p-pair)
                 (let* ([a (first (first p-pair))]
                        [b (second (first p-pair))]
                        [c (first (second p-pair))]
                        [d (second (second p-pair))]
                        [r1 (make-rational a b)]
                        [r2 (make-rational c d)]
                        )
                   (= (+ (/ a b) (/ c d))
                      (to-racket-rational (r+ r1 r2)))))]                       
         [failures (filter (negate okay) all-pairs)])
    (if (empty? failures)
        (display "test-r+-rational: all tests passed!")
        (begin (display "test-r+-rational: some tests failed")
               failures))))

(define (test-r*-rational)
  (let* ([nd-values '([0   7]
                      [2   8]
                      [19  3]
                      [30 15]
                      [5   5]
                      [6   1])]
         [all-pairs (cartesian-product nd-values nd-values)]
         ;; ([a b] [c d])
         [okay (lambda (p-pair)
                 (let* ([a (first (first p-pair))]
                        [b (second (first p-pair))]
                        [c (first (second p-pair))]
                        [d (second (second p-pair))]
                        [r1 (make-rational a b)]
                        [r2 (make-rational c d)]
                        )
                   (= (* (/ a b) (/ c d))
                      (to-racket-rational (r* r1 r2)))))]                       
         [failures (filter (negate okay) all-pairs)])
    (if (empty? failures)
        (display "test-r*-rational: all tests passed!")
        (begin (display "test-r*-rational: some tests failed")
               failures))))

(define (test-r<-rational)
  (let* ([nd-values '([0   7]
                      [2   8]
                      [19  3]
                      [30 15]
                      [5   5]
                      [6   1])]
         [all-pairs (cartesian-product nd-values nd-values)]
         ;; ([a b] [c d])
         [okay (lambda (p-pair)
                 (let* ([a (first (first p-pair))]
                        [b (second (first p-pair))]
                        [c (first (second p-pair))]
                        [d (second (second p-pair))]
                        [r1 (make-rational a b)]
                        [r2 (make-rational c d)]
                        )
                   (equal? (< (/ a b) (/ c d))
                           (r< r1 r2))))]                
         [failures (filter (negate okay) all-pairs)])
    (if (empty? failures)
        (display "test-r<-rational: all tests passed!")
        (begin (display "test-r<-rational: some tests failed")
               failures))))

(define (test-r=-rational)
  (let* ([nd-values '([0   7]
                      [2   8]
                      [19  3]
                      [30 15]
                      [5   5]
                      [6   1])]
         [all-pairs (cartesian-product nd-values nd-values)]
         ;; ([a b] [c d])
         [okay (lambda (p-pair)
                 (let* ([a (first (first p-pair))]
                        [b (second (first p-pair))]
                        [c (first (second p-pair))]
                        [d (second (second p-pair))]
                        [r1 (make-rational a b)]
                        [r2 (make-rational c d)]
                        )
                   (equal? (= (/ a b) (/ c d))
                           (r= r1 r2))))]                
         [failures (filter (negate okay) all-pairs)])
    (if (empty? failures)
        (display "test-r=-rational: all tests passed!")
        (begin (display "test-r=-rational: some tests failed")
               failures))))

(display "+-< failures: ")
(length (filter (negate okay2?)
                (cartesian-product all-test-values all-test-values)))

(define (okay3? r)
  (and
   (check-invert r)))

(display "invert failures: ")
(length (filter (negate okay3?)
                test-values))

(define (test-invert-rational)
  (let* ([nd-values '([2   8]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        )
                   (= (/ 1 (/ n d))
                      (to-racket-rational (invert r)))))]                   
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-invert-rational: all tests passed!")
        (begin (display "test-invert-rational: some tests failed")
               failures))))

(define (test-is-int?-rational)
  (let* ([nd-values '([2   8]
                      [0  10]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        )
                   (equal? (integer? (/ n d))
                           (is-int? r))))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-is-int?-rational: all tests passed!")
        (begin (display "test-is-int?-rational: some tests failed")
               failures))))

(define (okay4? r)
  (and
   (check-to-lowest-terms r)))

(display "to-lowest-terms failures: ")
(length (filter (negate okay4?)
                all-test-values))


(define (test-to-lowest-terms-rational)
  (let* ([nd-values '([2   8]
                      [0  10]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (to-lowest-terms (make-rational n d))]
                        )
                   (and (= (numerator (/ n d)) (r-numerator r))
                        (= (denominator (/ n d)) (r-denominator r)))))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-to-lowest-terms-rational: all tests passed!")
        (begin (display "test-to-lowest-terms-rational: some tests failed")
               failures))))

(define (test-to-string-rational)
  (let* ([nd-values '([2   8]
                      [0  10]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        )
                   (equal? (to-string r)
                           (string-append (~s n) "/" (~s d)))))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-to-string-terms-rational: all tests passed!")
        (begin (display "test-to-string-terms-rational: some tests failed")
               failures))))

(define (test-to-float-rational)
  (let* ([nd-values '([2   8]
                      [0  10]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        )
                   (= (to-float r) (exact->inexact (/ n d)))))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-to-float-rational: all tests passed!")
        (begin (display "test-to-float-rational: some tests failed")
               failures))))

(define (test-harmonic-rational)
  (let* ([nd-values (rest (range 26))]
         ;; n
         [okay (lambda (n)
                 (let* ([rh (to-lowest-terms (harmonic-sum n))]
                        [correct-h (racket-harmonic-sum n)]
                        )
                   (and (= (numerator correct-h) (r-numerator rh))
                        (= (denominator correct-h) (r-denominator rh)))))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-harmonic-rational: all tests passed!")
        (begin (display "test-harmonic-rational: some tests failed")
               failures))))

(define (test-numerator-denominator-rational)
  (let* ([nd-values '([2   8]
                      [0  10]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        )
                   (and (= n (r-numerator r))
                        (= d (r-denominator r)))))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-numerator-denominator-rational: all tests passed!")
        (begin (display "test-numerator-denominator-rational: some tests failed")
               failures))))

(define (test-num-denom-rational)
  (let* ([nd-values '([2   8]
                      [0  10]
                      [19  3]
                      [5   5]
                      [30 15]
                      [1  10]
                      [6   1])]
         ;; [n d]
         [okay (lambda (pair)
                 (let* ([n (first pair)]
                        [d (second pair)]
                        [r (make-rational n d)]
                        )
                   (equal? (num-denom r) pair)))]
         [failures (filter (negate okay) nd-values)])
    (if (empty? failures)
        (display "test-num-denom-rational: all tests passed!")
        (begin (display "test-num-denom-rational: some tests failed")
               failures))))
