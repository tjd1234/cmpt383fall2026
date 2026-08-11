#lang racket

;; rational3.rkt

;;
;; Testing code is at the bottom of the file (search for "Testing").
;;

;;
;; Returns a function that takes input arguments and applies
;; f and g to them. If they return the same result, then #t
;; is returned, otherwise #f is returned.
;;
(define (make-same-checker f g)
  (lambda args
    (equal? (apply f args)
            (apply g args))))

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
(define (r< x y)
  (let*-values ([(a b c d) (num/denom x y)]
                [(ad) (* a d)]
                [(bc) (* b c)])
    (< ad bc)))


;;
;; Returns true iff rational x comes before rational y.
;;
(define (r<= x y)
  (or (r= x y) (r< x y)))


;;
;; Returns true iff rational r is an integer, i.e. r has
;; the form n/1 for some integer n.
;;
(define (is-int? r)
  (let ([d (r-denominator (to-lowest-terms r))])
    (and (integer? d)
         (= 1 d))))


;;
;; Returns the sum of two rationals.
;;
(define (r+ x y)
  (let-values ([(a b c d) (num/denom x y)])
    (make-rational (+ (* a d) (* b c))
                   (* b d))))


;;
;; Returns the product of two rationals.
;;
(define (r* x y)
  (let-values ([(a b c d) (num/denom x y)])
    (make-rational (* a c) (* b d))))

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

;;
;; Returns the inversion of rational r, i.e. n/d becomes d/n.
;;
(define (invert r)
  (let-values ([(n d) (num/denom r)])
    (if (= 0 n)
        (raise "invert: numerator can't be 0")
        (make-rational d n))))

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
(define (insert-sorted lst x lte?)
  (cond [(empty? lst)
         (list x)]
        [(lte? x (first lst))
         (cons x lst)]
        [else
         (cons (first lst)
               (insert-sorted (rest lst) x lte?))]))

;;
;; Assumes left is sorted. Ends when right is empty.
;;
(define (insertion-sort-help left right lte?)
  (cond [(empty? right)
         left]
        [else
         (insertion-sort-help
          (insert-sorted left (first right) lte?)
          (rest right)
          lte?)
         ]))

;;
;; > (insertion-sort (shuffle (range 10)))
;; '(0 1 2 3 4 5 6 7 8 9)
;;
(define (insertion-sort lst less-than?)
  (insertion-sort-help '() lst less-than?))

(define test-sort (make-same-checker sort insertion-sort))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Testing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; name is a string that names the test
;; test-date is a list of all the test cases
;; okay? is a test function that works on a single test case
;;
(define (test name test-data okay?)
  (let* ([failures (filter (negate okay?) test-data)]
         [test-name (string-append "test-" name)])
    (if (empty? failures)
        (display (string-append name ": all tests passed!\n"))
        (begin (display (string-append name ": some tests failed\n"))
               failures))))

(define do-make-rational-test
  (test 
   "make-rational"
   '([0  1]
     [2  8]
     [19 3]
     [6  1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            [rn (r-numerator r)]
            [dn (r-denominator r)])
       (and (integer? rn) (integer? dn)
            (= n rn) (= d dn)
            (r= r r))))))

(define do-numerator-denominator-rational-test
  (test 
   "numerator-denominator"
   '([2   8]
     [0  10]
     [19  3]
     [5   5]
     [30 15]
     [1  10]
     [6   1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            )
       (and (= n (r-numerator r))
            (= d (r-denominator r)))))))

(define do-num-denom-rational-test
  (test 
   "num-denom"
   '([2   8]
     [0  10]
     [19  3]
     [5   5]
     [30 15]
     [1  10]
     [6   1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            )
       (and (= n (r-numerator r))
            (= d (r-denominator r)))))))

(define do-to-string-rational-test
  (test 
   "to-string"
   '([2   8]
     [0  10]
     [19  3]
     [5   5]
     [30 15]
     [1  10]
     [6   1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            )
       (equal? (to-string r)
               (string-append (~s n) "/" (~s d)))))))

(define do-to-float-rational-test
  (test 
   "to-float"
   '([2   8]
     [0  10]
     [19  3]
     [5   5]
     [30 15]
     [1  10]
     [6   1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            )
       (= (to-float r) (exact->inexact (/ n d)))))))

(define do-divide-rational-test
  (test 
   "divide"
   (let* ([nd-values '([2   8]
                       [19  3]
                       [30 15]
                       [5   5]
                       [6   1])]
          [all-pairs (cartesian-product nd-values nd-values)])
     all-pairs)
   (lambda (p-pair)
     (let* ([a (first (first p-pair))]
            [b (second (first p-pair))]
            [c (first (second p-pair))]
            [d (second (second p-pair))]
            [r1 (make-rational a b)]
            [r2 (make-rational c d)]
            )
       (= (/ (/ a b) (/ c d))
          (to-racket-rational (r/ r1 r2)))))))

(define do-r+-rational-test
  (test 
   "r+"
   (let* ([nd-values '([0   7]
                       [2   8]
                       [19  3]
                       [30 15]
                       [5   5]
                       [6   1])]
          [all-pairs (cartesian-product nd-values nd-values)])
     all-pairs)
   (lambda (p-pair)
     (let* ([a (first (first p-pair))]
            [b (second (first p-pair))]
            [c (first (second p-pair))]
            [d (second (second p-pair))]
            [r1 (make-rational a b)]
            [r2 (make-rational c d)]
            )
       (= (+ (/ a b) (/ c d))
          (to-racket-rational (r+ r1 r2)))))))

(define do-r*-rational-test
  (test 
   "r*"
   (let* ([nd-values '([0   7]
                       [2   8]
                       [19  3]
                       [30 15]
                       [5   5]
                       [6   1])]
          [all-pairs (cartesian-product nd-values nd-values)])
     all-pairs)
   (lambda (p-pair)
     (let* ([a (first (first p-pair))]
            [b (second (first p-pair))]
            [c (first (second p-pair))]
            [d (second (second p-pair))]
            [r1 (make-rational a b)]
            [r2 (make-rational c d)]
            )
       (= (* (/ a b) (/ c d))
          (to-racket-rational (r* r1 r2)))))))

(define do-r<-rational-test
  (test 
   "r<"
   (let* ([nd-values '([0   7]
                       [2   8]
                       [19  3]
                       [30 15]
                       [5   5]
                       [6   1])]
          [all-pairs (cartesian-product nd-values nd-values)])
     all-pairs)
   (lambda (p-pair)
     (let* ([a (first (first p-pair))]
            [b (second (first p-pair))]
            [c (first (second p-pair))]
            [d (second (second p-pair))]
            [r1 (make-rational a b)]
            [r2 (make-rational c d)]
            )
       (equal? (< (/ a b) (/ c d))
               (r< r1 r2))))))

(define do-r<=-rational-test
  (test 
   "r<="
   (let* ([nd-values '([0   7]
                       [2   8]
                       [19  3]
                       [30 15]
                       [5   5]
                       [6   1])]
          [all-pairs (cartesian-product nd-values nd-values)])
     all-pairs)
   (lambda (p-pair)
     (let* ([a (first (first p-pair))]
            [b (second (first p-pair))]
            [c (first (second p-pair))]
            [d (second (second p-pair))]
            [r1 (make-rational a b)]
            [r2 (make-rational c d)]
            )
       (equal? (<= (/ a b) (/ c d))
               (r<= r1 r2))))))

(define do-r=-rational-test
  (test 
   "r="
   (let* ([nd-values '([0   7]
                       [2   8]
                       [19  3]
                       [30 15]
                       [5   5]
                       [6   1])]
          [all-pairs (cartesian-product nd-values nd-values)])
     all-pairs)
   (lambda (p-pair)
     (let* ([a (first (first p-pair))]
            [b (second (first p-pair))]
            [c (first (second p-pair))]
            [d (second (second p-pair))]
            [r1 (make-rational a b)]
            [r2 (make-rational c d)]
            )
       (equal? (= (/ a b) (/ c d))
               (r= r1 r2))))))

(define do-invert-rational-test
  (test 
   "invert"
   '([2   8]
     [19  3]
     [5   5]
     [30 15]
     [1  10])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            )
       (= (/ 1 (/ n d))
          (to-racket-rational (invert r)))))))

(define do-is-int?-rational-test
  (test 
   "is-int?"
   '([2   8]
     [0  10]
     [19  3]
     [5   5]
     [30 15]
     [1  10]
     [6   1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (make-rational n d)]
            )
       (equal? (integer? (/ n d))
               (is-int? r))))))

(define do-to-lowest-terms-rational-test
  (test 
   "to-lowest-terms"
   '([2   8]
     [0  10]
     [19  3]
     [5   5]
     [30 15]
     [1  10]
     [6   1])
   (lambda (pair)
     (let* ([n (first pair)]
            [d (second pair)]
            [r (to-lowest-terms (make-rational n d))]
            )
       (and (= (numerator (/ n d)) (r-numerator r))
            (= (denominator (/ n d)) (r-denominator r)))))))

(define do-harmonic-rational-test
  (test 
   "harmonic"
   (rest (range 26))
   (lambda (n)
     (let* ([rh (to-lowest-terms (harmonic-sum n))]
            [correct-h (racket-harmonic-sum n)]
            )
       (and (= (numerator correct-h) (r-numerator rh))
            (= (denominator correct-h) (r-denominator rh)))))))

(define do-insertion-sort-rational-test
  (test 
   "insertion-sort-rational"
   (list '()
         (list (make-rational 2 3))
         (list (make-rational 2 3) (make-rational 6 3))
         (list (make-rational 2 3) (make-rational 6 3) (make-rational -10 8))
         (list (make-rational 2 3) (make-rational 6 3) (make-rational -10 8) (make-rational 0 81))
         (list (make-rational 2 3) (make-rational 6 3) (make-rational -10 8) (make-rational 0 81)
               (make-rational 4 7)))
   (lambda (lst)
     (test-sort lst r<=))))

(define do-insertion-sort-int-test
  (test 
   "insertion-sort-int"
   (list '()
         '(2)
         '(1 2)
         '(2 1)
         '(2 2)
         '(1 2 3)
         '(3 2 1)
         '(2 1 3)
         '(4 4 4 4)
         '(893 98292 982 82 72 467 26 78 16 93))
   (lambda (lst)
     (test-sort lst <=))))

(define do-insertion-sort-string-test
  (test 
   "insertion-sort-string"
   (list '()
         '("up")
         '("up" "down")
         '("down" "up")
         '("one" "two" "three" "four"))
   (lambda (lst)
     (test-sort lst string<=?))))