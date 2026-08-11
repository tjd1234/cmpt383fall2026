#lang racket

(define all-bin-ops '(+ - * /))
(define all-unary-ops '(- +))

;; checks if x is basic expression at the top-level;
;; (member x lst) returns either #f is x not in lst,
;; and if x is in lst it returns the sub-list starting
;; with x
(define (is-basic-expr3? x)
  (or (number? x)
      (match x       
        [`(,op ,a)    (member op all-unary-ops)]
        [`(,a ,op ,b) (member op all-bin-ops)]
        [_            #f]
        )))
















;; check top-level expressions
(define (is-basic-expr4? x)
  (or (number? x)
      (match x       
        [`(- ,a)    #t] ;; ` quasiquote
        [`(+ ,a)    #t]
        [`(,a + ,b) #t]
        [`(,a - ,b) #t]
        [`(,a * ,b) #t]
        [`(,a / ,b) #t]
        [_          #f]
        )))












;; check if x is valid expression, recurrsively checking sub-expressions
(define (is-basic-expr? x)
  (or (number? x)
      (match x       
        [`(- ,a)    (is-basic-expr? a)]
        [`(+ ,a)    (is-basic-expr? a)]
        [`(,a + ,b) (and (is-basic-expr? a) (is-basic-expr? b))]
        [`(,a - ,b) (and (is-basic-expr? a) (is-basic-expr? b))]
        [`(,a * ,b) (and (is-basic-expr? a) (is-basic-expr? b))]
        [`(,a / ,b) (and (is-basic-expr? a) (is-basic-expr? b))]
        [_          #f]
        )))















;; evaluate expression x
(define (arith-eval x)
  (if (number? x)
      x
      (match x
        [`(- ,a)    (- (arith-eval a))]
        [`(+ ,a)    (+ (arith-eval a))]
        [`(,a + ,b) (+ (arith-eval a) (arith-eval b))]
        [`(,a - ,b) (- (arith-eval a) (arith-eval b))]
        [`(,a * ,b) (* (arith-eval a) (arith-eval b))]
        [`(,a / ,b) (/ (arith-eval a) (arith-eval b))]
        [_ (error "arith-eval: bad expression")])))

