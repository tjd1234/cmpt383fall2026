#lang tiny-lisp

(define pi 3.14155926)

#;(define inc
    (lambda (n) (+ 1 n)))

(define (inc n)
  (+ 1 n))

(define (square x)
  (* x x))

(define (sign n)
  (cond [(not (number? n)) (error "not a number")]
        [(< n 0)           'negative             ]
        [(> n 0)           'positive             ]
        [else              'zero                 ]
        ))

#;(define (dist x1 y1 x2 y2)
    (let [(dx (- x2 x1))
          (dy (- y2 y1))]
      (let [(dxx (* dx dx))
            (dyy (* dy dy))]
        (sqrt (+ dxx dyy)))))

(define (dist x1 y1 x2 y2)
  (let* [(dx (- x2 x1))
         (dy (- y2 y1))
         (dxx (* dx dx))
         (dyy (* dy dy))]
    (sqrt (+ dxx dyy))))

;; > (length '(a b c))
;; 3
;; > (length '())
;; 0

;; Recursion:
;; - Base case: 0 if list is empty
;; - Recursive case: 1 + the length of the rest of the list
#;(define (length L)
    (cond [(empty? L)
           0]
          [else
           (+ 1 (length (rest L)))]))

;; > (sum '())
;; 0
;; > (sum '(3 2 4))
;; 9

;; Base case: empty list is 0
;; Recursive case: add the first number of the list to the sum of
;;                 the rest

(define (sum L)
  (cond [(empty? L)
         0]
        [else
         (+ (first L)
            (sum (rest L)))]))

(define (product L)
  (cond [(empty? L)
         1]
        [else
         (* (first L)
            (product (rest L)))]))

;; > (range 5)
;; '(0 1 2 3 4)

#;(define (map fn L)
    (cond [(empty? L)
           '()]
          [else
           (cons (fn (first L))
                 (map fn (rest L)))]))

#;(define (filter pred? L)
  (cond [(empty? L)
         '()]
        [(pred? (first L))
         (cons (first L)
               (filter pred? (rest L)))]
        [else
         (filter pred? (rest L))]))

#;(define (all pred? L)
    (cond [(empty? L)
           #t]
          [else
           (and (pred? (first L))
                (all pred? (rest L)))]))

(define (all pred? L)
  (empty? (filter (lambda (x) (not (pred? x))) 
                  L)))

(define (foldr op init L)
  (cond [(empty? L)
         init]
        [else
         (op (first L)
             (foldr op init (rest L)))]))

(define (length L)
  (foldr (lambda (x acc) (+ acc 1)) 
         0 
         L))

(define (member? x L)
  (foldr (lambda (next acc)
           (or (equal? next x) acc))
         #f
         L))

(define (append A B)
  (foldr cons B A))

(define (map f L)
  (foldr (lambda (next acc) (cons (f next) acc))
         '()
         L))

(define (filter pred? L)
  (foldr (lambda (next acc)
           (cond [(pred? next) (cons next acc)]
                 [else acc]))
         '()
         L))
