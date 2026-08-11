#lang racket

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
(define (sub p q)
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
