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

#;(define (sum L)
    (cond [(empty? L)
           0]
          [else
           (+ (first L)
              (sum (rest L)))]))

#;(define (product L)
    (cond [(empty? L)
           1]
          [else
           (* (first L)
              (product (rest L)))]))

;; > (range 5)
;; '(0 1 2 3 4)


;;
;; (member? x L)
;; returns #t if x is equal to an element on L (top-level),
;; and #f otherwise
;;
;; > (member? 5 '(4 1 cat 5 7))
;; #t
;;
;; > (member? 'bird '(a (bird nest) in the tree))
;; #f
;;

(define (member? x L)
  (cond [(empty? L)  ;; rule 1: empty is false
         #f]
        [(equal? x (first L))
         #t]
        [else
         (member? x (rest L))]))
        
#;(define (member? x L)
    (and (not (empty? L))
         (or (equal? x (first L))
             (member? x (rest L)))))

;;
;; (last L)
;; returns the final (top-level) element of L
;; causes an error if L is the empty list
;;
;; > (last '(the big red dog))
;; 'dog
;;
;; > (last '(once upon (a time)))
;; '(a time)
;;
;; > (last '())
;; .. error
;;

(define (last L)
  (cond [(empty? L)
         (error "last: empty list")]
        [(empty? (rest L))
         (first L)]
        [else
         (last (rest L))]
        ))

;;
;; (remove-all x L)
;; returns a new list that is the same as L but all
;; top-level occurrences of x have been removed
;;
;; > (remove-all 'cat '())
;; '()
;;
;; > (remove-all 'cat '(cat))
;; '()
;;
;; > (remove-all 'dust '(dirt dust dust dirt (dirt dust)))
;; '(dirt dirt (dirt dust))
;;
(define (remove-all x L)
  (cond [(empty? L)
         '()]
        [(equal? x (first L))
         (remove-all x (rest L))]
        [else ;; non-empty, first element not x
         (cons (first L)
               (remove-all x (rest L)))]))

;;
;; (append A B)
;; returns a new list consisting of all the elements of A
;; followed by all the elements of B
;;
;; > (append '(once up) '(a time))
;; '(once up a time)
;;
;; > (append '(+ 2 3) '(w x y z))
;; '(+ 2 3 w x y z)
;;

#;(define (append A B)
    (cond [(empty? A)
           B]
          [else
           (cons (first A)
                 (append (rest A)
                         B))]
          ))

;;
;; (concat list-of-lists)
;; returns a new list that consist of all the elements of the
;; lists on list-of-lists
;;
;; > (concat '((1 2) (three four five) (six) (7 8)))
;; '(1 2 three four five six 7 8)
;;
;; > (concat (list '(a b c) '() '(d e (f) g)))
;; '(a b c d e (f) g)
;;

(define (concat list-of-lists)
  (cond [(empty? list-of-lists)
         '()]
        [else
         (append (first list-of-lists)
                 (concat (rest list-of-lists)))]
        ))

;;
;; (reverse L)
;; returns a new list with the elements of L in reverse order
;;
;; > (reverse '())
;; '()
;;
;; > (reverse '(a b c))
;; '(c b a)
;;
;; > (reverse '(1 2 3 4 5))
;; '(5 4 3 2 1)
;;
;; > (reverse '(this (is a) (big test)))
;; '((big test) (is a) this)
;;

(define (reverse L)
  (cond [(empty? L)
         '()]
        [else
         (append (reverse (rest L))
                 (list (first L)))]))


(define (reverse-acc L acc)
  (cond [(empty? L)
         acc]
        [else
         (reverse-acc (rest L)
                      (cons (first L) acc))]
        ))

(define (reverse2 L)
  (reverse-acc L '()))

#;(define (length L)
    (cond [(empty? L)
           0]
          [else
           (+ 1 (length (rest L)))]))

(define (length-acc L acc)
  (cond [(empty? L)
         acc]
        [else
         (length-acc (rest L)
                     (+ acc 1))]))

(define (length2 L)
  (length-acc L 0))

;;
;; (map f L) returns a new list with f applied to every
;; element of L; f is a 1-argument function
;;
;; E.g. (map f '(a b c d)) returns '((f a) (f b) (f c) (f d))
;;
(define (map f L)
  (cond [(empty? L)
         '()]
        [else
         (cons (f (first L))
               (map f (rest L)))]))

;;
;; (filter pred? L) returns a new list with just the elements
;; of L that satisfy pred?; pred? is a 1-argument function that
;; returns #t or #f (a boolean function)
;;
;; > (filter? odd '(1 2 3 4 5))
;; '(1 3 5)
;;
(define (filter pred? L)
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

#;(define (all pred? L)
    (equal? L
            (filter pred? L)))

;;
;; Given a 1-argument boolean function (i.e. it returns
;; #t or #f), returns a new 1-argument boolean function that
;; always returns the opposite value of pred?
;;
(define (negate pred?)
  (lambda (x) (not (pred? x))))

;; returns true iff every element of L satsifies pred?
#;(define (all pred? L)
    (empty? (filter (negate pred?) L)))

;; returns true iff no element of L satisfies pred?
#;(define (none pred? L)
    (all (negate pred?) L))

;; (op a (op b (op c (op d init))))
(define (foldr op init L)
  (cond [(empty? L)
         init]
        [else
         (op (first L) 
             (foldr op init (rest L)))]))

(define (sum L)
  (foldr + 0 L))

(define (product2 L)
  (foldr * 1 L))

(define (length L)
  (foldr (lambda (next acc) (+ acc 1)) 
         0 
         L))

;;
;; (member? x L) retursn #t if x is a (top-level)
;; member of list L, and #f otherwise
;;
;; Implement using foldr.
;;

#;(define (member? x L)
    (cond [(empty? L)  ;; rule 1: empty is false
           #f]
          [(equal? x (first L))
           #t]
          [else
           (member? x (rest L))]))

;;
;; (foldr op init '(a b c d)) evaluates to
;; (op a (op b (op c (op d init))))
;;
#;(define (member? x L)
    (foldr op
           init
           L))

;;
;; Implement map using foldr.
;;
#;(define (map f L)
    (cond [(empty? L)
           '()]
          [else
           (cons (f (first L))
                 (map f (rest L)))]))

;;
;; (foldr op init '(a b c d)) evaluates to
;; (op a (op b (op c (op d init))))
;;
#;(define (map f L)
    (foldr op
           init
           L))

;;
;; Implement filter using foldr.
;;
;; filter returns a new list contain just the elements of L
;; that satisfy pred?
;;
#;(define (filter pred? L)
    (cond [(empty? L)
           '()]
          [(pred? (first L))
           (cons (first L)
                 (filter pred? (rest L)))]
          [else
           (filter pred? (rest L))]))

;;
;; (foldr op init '(a b c d)) evaluates to
;; (op a (op b (op c (op d init))))
;;
#;(define (filter pred? L)
    (foldr op
           init
           L))

;;
;; Implement (append A B) using foldr.
;;
(define (append A B)
  (cond [(empty? A)
         B]
        [else
         (cons (first A)
               (append (rest A)
                       B))]
        ))

;;
;; (foldr op init '(a b c d)) evaluates to
;; (op a (op b (op c (op d init))))
;;
#;(define (append A B)
    (foldr op
           init
           L))
;;
;; insertion sort
;;
(define (insert-sorted x L)
  (cond [(empty? L)
         (list x)]
        [(<= x (first L))
         (cons x L)]
        [else
         (cons (first L)
               (insert-sorted x (rest L)))]))

(define (insertion-sort L)
  (foldr insert-sorted '() L))


;;
;; quicksort
;;
(define (quicksort L)
  (cond [(<= (length L) 1)
         L]
        [else
         (let* [(pivot (first L))
                (smalls (filter (lambda (n) (< n pivot))
                                (rest L)))
                (bigs (filter (lambda (n) (>= n pivot))
                              (rest L)))]
           (concat (list (quicksort smalls)
                         (list pivot)
                         (quicksort bigs))))]))

;;
;; The (flatten L) functions returns a new list that is the same as
;; L but all sub-lists have been removed, e.g.:
;;
;; (flatten '((a) ((c d (e f)) g) h)) evaluates to '(a c d e f g h)
;; (flatten '(define (x y) (+ x y))) evaluates to (define x y + x y)
;;
(define (flatten L)
  (cond [(empty? L)
         '()]
        [(list? (first L))
         (append (flatten (first L))
                 (flatten (rest L)))]
        [else
         (cons (first L)
               (flatten (rest L)))]))

;; (op a (op b (op c (op d init))))
#;(define (flatten L)
    (foldr (lambda (next acc)
             (cond [(list? next)
                    (append (flatten next) acc)]
                   [else
                    (cons next acc)]))
           '()
           L))

(define (deep-sum L)
  (sum (flatten L)))

(define (deep-member? x L)
  (member? x (flatten L)))

(define (deep-map f L)
  (foldr (lambda (next acc)
           (cons (cond [(list? next)
                        (deep-map f next)]
                       [else
                        (f next)])
                 acc))
         '()
         L))

;;
;; closures
;;
#;(define (f n)
    (+ n 1))


(define (make-adder n)
  (lambda (x) (+ n x)))
;; (lambda (x) (+ 1 x))
#;(define g (make-adder 1))

;; closure: let over lambda
(define g1
  (let ([n 1])
    (lambda (x) (+ n x))
    ))


;;
;; composing functions
;;
(define (f x) (* x x))
(define (g x) (+ (* 2 x) 1))

#;(define (h x) (f (g x)))

(define (compose f g)
  (lambda (x) (f (g x))))

(define h (compose f g))

(define second (compose first rest))

#;(define (twice f) (compose f f))
(define twice
  (lambda (f)
    (compose f f)))

(define garnish
  (twice (lambda (x) (cons 'cheese x)))) 

;; (op a (op b (op c (op d init))))
;; > (compose-all (list a b c d))
;; (lambda (x) (a (b (c (d x)))))

#;(define (compose f g)
    (lambda (x) (f (g x))))
;; (compose a (compose b (compose c (compose d init))))
;; (compose d init) == d
;; (compose d I)
;; (lambda (x) (d (I x)))
;; (lambda (x) (d x))

;; identity function
#;(define (I x) x)

(define (compose-all fns)
  (foldr compose   ;; binary op
         I         ;; init value: identity function
         fns
         ))

(define (pipeline fns)
  (compose-all (reverse fns)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 2 + 3 = 5
;; 2 + x  = ??

;; non-curried addition
(define (add_a x y)
  (+ x y))

;; curried addition
(define add_b
  (lambda (x)
    (lambda (y)
      (+ x y))))

;; f must take exactly 2 inputs; f is non-curried
;; e.g. (f x y)
(define (curry2 f)
  (lambda (x)
    (lambda (y)
      (f x y))))

;; non-curried
(define (add x y)
  (+ x y))

(define c_add (curry2 add))

(define add1 ((curry2 +) 1))

(define keep-odds
  ((curry2 filter) odd?))

(define c_cons (curry2 cons))

(define add-cherry (c_cons 'cherry))


;; Moses Schonfinkel
;; Haskell Curry

(define (uncurry2 f)
  (lambda (x y)
    ((f x) y)))

;;
;; little
;;
#;(define (I x) x)

(define (M x) (x x))
;; (M M)
;; = (M M)
;; = (M M

(define (K x)
  (lambda (y) x))

(define (S3 x y z)
  ((x z) (y z)))

(define S       ;; curried version of S3
  (lambda (x)   ;; can be passed 0, 1, 2, or 3 arguments
    (lambda (y)
      (lambda (z)
        ((x z) (y z))))))

;; I can be written in terms of S and K (!)
(define (I z) (S3 K K z))
  
#;(define (I a) (((S K) K) a))


;; Question: what is (S3 I I z) ?

;; Example: the flip function
(define (flip f)
  (lambda (x y) (f y x)))



