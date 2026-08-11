#lang racket

;;
;; Returns a function that takes input arguments and applies
;; f and g to them. If they return the same result, then #t
;; is returned, otherwise #f is returned.
;;
(define (make-same-checker f g)
  (lambda args
    (equal? (apply f args)
            (apply g args))))

#;(define (twice f x)  ;; call f twice on input x
    (f (f x)))

#;(define (twice f)  ;; call f twice on input x
    (lambda (x)
      (f (f x))))

(define (twice x)  ;; call f twice on input x
  (lambda (f)
    (f (f x))))

;;
;; Zip can be re-written using a map that takes multiple lists, e.g:
;;
;;    > (map list '(a b c) '(1 2 3))
;;    '((a 1) (b 2) (c 3))
;;
;; But what about plain old single-list map?
;;
(define (zip lst1 lst2)
  (cond [(empty? lst1)
         '()]
        [else
         (cons (list (first lst1) (first lst2))
               (zip (rest lst1) (rest lst2)))]))

;;
;; 2d points
;;
;; These points are immutable, i.e. after a point is created it can never change.
;;

;;
;; Creates a new point value.
;;
(define (make-point x y)
  (list 'point x y))

;;
;; Checks if a value is a point.
;;
;; Useful for development and debugging.
;;
(define (is-point? p)
  (and (list? p)
       (= 3 length p)
       (equal? 'point (first p))
       (number? (second p))
       (number? (third p))))

;;
;; The origin is an important point, so we give it a name.
;;
(define origin (make-point 0 0))

;;
;; Sample points for testing.
;;
(define pa (make-point 2 3))
(define pb (make-point 4 4))
(define pc (make-point -8 10))

;;
;; Point getters (setters are discussed further down).
;;
(define get-x second)
(define get-y third)

;;
;; Convert a point to a string.
;;
;; (~s n) converts the number n to a string.
;;
(define (to-string p)
  (string-append "(" (~s (get-x p)) ", " (~s (get-y p)) ")"))

;;
;; Returns #t if points p and q are the same, and #f if they're not.
;;
(define (same? p q)
  (and (= (get-x p) (get-x q))
       (= (get-y p) (get-y q))))

;;
;; Returns a scaled poiunt, i.e. a new point (sx, sy),
;; where s is a number (the scaling factor).
;;
(define (scale p s)
  (make-point (* s (get-x p))
              (* s (get-y p))))

;;
;; Returns the sum of two points as a new point.
;;
(define (add p q)
  (let* ([px (get-x p)]
         [py (get-y p)]
         [qx (get-x q)]
         [qy (get-y q)])
    (make-point (+ px qx) (+ py qy))))

;;
;; Returns the difference of two points as a new point.
;;
(define  (sub p q)
  (add p (scale q -1)))

;;
;; Return the distance between two points.
;;
(define (dist p q)
  (let* ([px (get-x p)]
         [py (get-y p)]
         [qx (get-x q)]
         [qy (get-y q)]
         [dx (- px qx)]
         [dy (- py qy)])
    (sqrt (+ (sqr dx) (sqr dy)))))

;;
;; Return the distance between a point and the origin, (0, 0)
;;
(define (dist-to-origin p)
  (dist p origin))

;;
;; Point setters.
;;
;; Points can't be modified (they're immutable), so a setter returns a new
;; point.
;;
;; This isn't as efficient as actually modifying the passed-in point, but it's
;; all we can do given our restriction that points are immutable.
;;
(define (set-x p new-x)
  (make-point new-x (get-y p)))

(define (set-y p new-y)
  (make-point (get-x p) new-y))

(define (my-sum lst)
  (apply + lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Review of some ways to write a summation function.
;;
(define (sum1 lst)
  (if (empty? lst)
      0
      (+ (first lst) (sum1 (rest lst)))))

;;
;; (fold-right f init '(a b c)) calculates this:
;;
;;    (f a (f b (f c init)))
;;
(define (fold-right f init lst)
  (if (empty? lst)
      init
      (f (first lst) (fold-right f init (rest lst)))))

(define (sum2 lst)
  (fold-right + 0 lst))

;;
;; To call a Racket function, we write the function name followed by its arguments:
;;
;; >  (cons 'a '(1 2))
;; '(a 1 2)
;;
;; Racket's apply function is another way to call a function. (apply f args) calles
;; function f on the list of arguments arg:
;;
;; > (apply cons '(a (1 2)))
;; '(a 1 2)
;; > (first '(one two three))
;; 'one
;; > (apply first '((one two three)))   ;; not just '(one two three)
;; 'one
;; > (apply + '(2 8 7))
;; 17
;; > (apply * '(2 8 7))
;; 112
;;
;; These last two functions show us yet another way to write sum:
;;
(define (sum3 lst)
  (apply + lst))

(define (product lst)
  (apply * lst))

#;(define (factorial n)
    (product (range 1 (+ n 1))))


;;
;; apply also gives us another way to implement the flatten function:

;;
;; A typical recursive implementation of flatten.
;;
;; > (my-flatten '(a (b (c) (d ((e) f)))))
;; '(a b c d e f)
;;
(define (my-flatten x)
  (cond [(empty? x) x]
        [(not (list? x)) x]
        [(list? (first x))
         (append (my-flatten (first x))
                 (my-flatten (rest x)))]
        [else (cons (first x) 
                    (my-flatten (rest x)))]
        ))


;;
;; This version combines apply, append, and map to do the same thing.
;;
;; The general strategy is to map through the passed-in list one item at a time.
;; If the item is a list, then we recursively call the function on that list. If
;; the item isn't a list, then we return it in a list.
;;
;; The result of this mapping is a list of lists, and append can be used to combine
;; them into a single list.
;;
;; append takes 0 or more lists as input, and combines them in to a single list
;;
;; > (append '(1 two) '(3 4 5) '() '(six))
;; '(1 two 3 4 5 six)
;;
(define (my-flatten2 lst)
  (apply append (map (lambda (x) (if (list? x)
                                     (my-flatten2 x)
                                     (list x)))  ;; (list x) needed for append to work
                     lst)))

;;
;; Another interesting and useful higher-order function is compose. (compose f g) takes two
;; (or more) single-input functions and returns a new function that, when passed an argument x,
;; calls (f (g x)). In other words, compose is the regular mathematical notion of composing
;; functions.
;;
;; For example:
(define (f x) (* x x))
(define (g x) (+ (* 2 x) 1))
(define (h x) (f (g x)))
;;
;; > (f 2)
;; 4
;; > (g 2)
;; 5
;; > (f (g 2))
;; 25
;; > (h 2)
;; 25

;;
;; Using compose we can define h2 like this:
(define h2 (compose f g))
;;
;; > (h2 2)
;; 25

;;
;; We can define second like this:
(define my-second (compose first rest))
;;
;; > (my-second '(a b c))
;; 'b
;;
;; Notice that the definitions of h2 and my-second don't explicitly
;; mention the input parameter the way the definition of h does. This style
;; of definition is sometimes called **point-free programming**.
;;

;;
;; (flip f) takes a two-input function f as input, and returns a new function that
;; is the same as f except the order of the arguments is reversed.
;;
(define (flip f)
  (lambda (x y) (f y x)))

;; > ((flip -) 10 2)
;; -8

(define fcons (flip cons))
;;
;; > (fcons '(1 2 3) 'a)
;; '(a 1 2 3)
;;

;;
;; chain is like compose, but the functions are evaluated in the order given.
;; Some programmers prefer this ordering when composing functions.
;;
(define chain (flip compose))

;;
;; > (define my-second2 (chain rest first))
;; > (my-second2 '(a b c d e))
;;

;;
;; Finally, lets look at a couple of simple functions called **combinators**.
;; They are good examples of **pure functions**, i.e. functions that have no
;; side-effects (like printing to the screen, writing to a database, modifying a
;; global variable, etc.) and whose output depends only the input given to the
;; function.
;;

;;
;; I is the identity function, and returns whatever you pass it.
;;
(define (I x) x)

;;
;; (M x) calls x on x
;;
(define (M x) (x x))
;;
;; > (M I)
;; #<procedure:I>
;; > (I M)
;; #<procedure:M>
;; > (M list)
;; '(#<procedure:list>)
;; > (M M)
;; infinite loop!
;;
;; The expression (M M) is runs forever. Since (M x) is the same as (lambda (x) (x x)),
;; we can rewrite it as:
;;
;; ((lambda (x) (x x)) (lambda (x) (x x)))  ;; infinite loop!
;;
;; Here have an expression that causes an infinite loop, yet has no loops or recursion.
;;

;;
;; (K x) returns a function of one argument that returns x no matter what you give it.
;; In other words, K makes constant functions.
;;
(define (K x) (lambda (y) x))

(define always-cow (K 'cow))
;; > (always-cow 'horse)
;; 'cow
;; > (always-cow always-cow)
;; 'cow

;; > ((K I) M) 
;; #<procedure:I>
;; > ((I K) M)
;; #<procedure:...>
;; > (((I K) M) 10)
;; #<procedure:M>

;; (define (M x) (x x))

;;
;; Y combinator, from https://en.wikipedia.org/wiki/Fixed-point_combinator
;;
#;(define (Y f)
    ((lambda (x) (f (x x)))
     (lambda (x) (f (x x)))
     )
    )
;;
;; By calculation, you can see that:
;;
;;   (Y f) = (f (Y  f)) = (f (f (Y f))) = (f (... (f (Y f)) ...))
;;
;; In other words, (Y f) gives an expression where f is called infinitely many times.
;;
;;

;; https://mvanier.livejournal.com/2897.html
(define Y 
  (lambda (f)
    ((lambda (x) (x x))
     (lambda (x) (f (lambda (y) ((x x) y)))))))

(define factorial-helper
  (lambda (f)
    (lambda (n)
      (if (= n 0)
          1
          (* n (f (- n 1)))))))

(define factorial (Y factorial-helper))

(define fibonacci-helper
  (lambda (f)
    (lambda (n)
      (cond ((= n 0) 0)
            ((= n 1) 1)
            (else (+ (f (- n 1)) (f (- n 2))))))))

(define fibonacci (Y fibonacci-helper))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; insertion sort without recursion
;;

(define (insert-sorted x lst)
  (append
   (takef lst (lambda (a) (< a x)))
   (list x)
   (dropf lst (lambda (a) (< a x)))))
           

(define (insertion-sort lst)
  (foldr insert-sorted '() lst))

(define (rand-list n)
  (map (lambda (x) (random 1 1000)) (range n)))

(define (test-sort n)
  (time (begin (insertion-sort (rand-list n))
               'done)))
