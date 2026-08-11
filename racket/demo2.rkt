#lang racket

;; returns the length of list L
(define (len L)
  (if (empty? L)
      0
      (+ 1 (len (rest L)))))

#;(define (contains x lst)
    (cond [test1 value1]
          [test2 value2]
          [else value3]
          )
    )

;; returns #t if one or more top-level items in lst satisfy
;; pred?, and #f otherwise; pred? is assumed to be a predicate,
;; i.e. a function that takes one input and returns either #t
;; or #f
(define (satisfies? pred? lst)
  (cond [(empty? lst)
         #f]
        [(pred? (first lst))
         #t]
        [else
         (satisfies? pred? (rest lst))]))

#;(define (contains? x lst)
    (cond [(empty? lst)
           #f]
          [(equal? x (first lst))
           #t]
          [else
           (contains? x (rest lst))]))

;; returns #t if x is lst (at the top-level),
;; and #f otherwise
(define (contains? x lst)
  (satisfies? (lambda (a) (equal? x a))
              lst))

#;(define (count-sym lst)
    (cond [(empty? lst)
           0]
          [(symbol? (first lst))
           (+ 1 (count-sym (rest lst)))]
          [else
           (count-sym (rest lst))]))

;; returns the number of top-level symbols in lst
(define (count-sym lst)
  (if (empty? lst)
      0
      (+ (if (symbol? (first lst)) 1 0)
         (count-sym (rest lst)))))

;; returns the number of top-level items on lst that satisfy pred?
(define (count-fn pred? lst)
  (cond [(empty? lst)
         0]
        [(pred? (first lst))
         (+ 1 (count-fn pred? (rest lst)))]
        [else
         (count-fn pred? (rest lst))]))

;; reverses list lst
(define (rev lst)
  (if (empty? lst)
      '()
      (append (rev (rest lst))
              (list (first lst)))))

;; appends list A and B
(define (my-append A B)
  (cond [(empty? A)
         B]
        [else
         (cons (first A)
               (my-append (rest A) B))
         ]))

;; returns the number of numbers that occur in the top-level
;; of lst
(define (deep-count-num lst)       
  (cond [(empty? lst) 
         0]
        [(list? (first lst))
         (+ (deep-count-num (first lst)) 
            (deep-count-num (rest lst)))]
        [(number? (first lst))
         (+ 1 (deep-count-num (rest lst)))]
        [else
         (deep-count-num (rest lst))]
        ))

;; returns a list of the non-list items in x, e.g.
;; (flatten '((a) (b (c) (d e)) f)) returns '(a b c d e f)
(define (my-flatten x)
  (cond [(empty? x) 
         x]
        [(not (list? x)) 
         x]
        [(list? (first x))
         (append (my-flatten (first x))
                 (my-flatten (rest x)))]
        [else ;; first element is not a list
         (cons (first x) 
               (my-flatten (rest x)))]
        ))

;; applies f to every member of lst
(define (my-map f lst)
  (cond [(empty? lst)
         '()]
        [else
         (cons (f (first lst))
               (my-map f (rest lst)))]))

;; returns a list of all the elements on lst that satisfy pred?
(define (my-filter pred? lst)
  (cond [(empty? lst)
         '()]
        [(pred? (first lst))
         (cons (first lst)
               (my-filter pred? (rest lst)))]
        [else
         (my-filter pred? (rest lst))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (sum lst)
  (if (empty? lst) 
      0
      (+ (first lst) (sum (rest lst)))))

(define (prod lst)
  (if (empty? lst) 
      1
      (* (first lst) (prod (rest lst)))))

(define (my-length lst)
  (if (empty? lst) 
      0
      (+ 1 (my-length (rest lst)))))


;; (fold-right op init '(a b c)
;; => (op a (op b (op c init)))
(define (fold-right op init lst)
  (if (empty? lst)
      init
      (op (first lst)
          (fold-right op init (rest lst)))))

                    
(define (my-map2 f lst)
  (fold-right (lambda (next acc)
                (cons (f next) acc))
              '()
              lst))

(define (f x) (append x (list 'f)))
(define (g x) (append x (list 'g)))
(define (h x) (append x (list 'h)))

(define (comp f g)
  (lambda (x)
    (f (g x))))

(define fg (comp f g))
(define s (comp rest rest))
(define t (comp first rest))


(define (twice f)
  (comp f f))

(define garnish (twice (lambda (x) (cons 'cheese x))))


(define (compose-n f n)
    (if (= n 1)
        f
        (comp f (compose-n f (- n 1)))))

(define triple-cherry 
   (compose-n (lambda (lst) (cons 'cherry lst)) 3))

(define (I x) x)

(define (compose-all . fns)
  (foldr comp
         I   ;; identity function
         fns))

(define fgh (compose-all f g h))

(define (pipeline . fns)
  (apply compose-all (reverse fns)))

(define d (pipeline
           f
           g
           h
           ))

(define add_a
  (lambda (x y)
    (+ x y)))

(define add_b
  (lambda (x)
    (lambda (y)
      (+ x y))))

(define (curry2 f)
  (lambda (x)
    (lambda (y)
      (f x y))
    ))

(define keep-odds ((curry2 filter) odd?))

(define cons_c (curry2 cons))

;; f is a curried 2-arg function
(define (uncurry2 f)
  (lambda (x y)
    ((f x) y)))

#;(define (I x) x)

;; M combinator
(define (M x) (x x))

;; K combinator
(define (K x) (lambda (y) x))

;; S combinator
(define (S3 x y z)
  ((x z) (y z)))

(define S (curry S3)) ;; curry is a built-in function

;; S, K, I form a basis for pure functions

(define (I a) ((S K K) a))

