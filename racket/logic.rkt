#lang racket


;;
;; EBNF specification of a propositional logic language with
;; expressions like ((t and f) or (not (f or t)))
;;
;;
;;         expr =  bool-literal | not-expr 
;;               | and-expr     | or-expr .
;; 
;; 
;; bool-literal = "t" | "f" .
;; 
;;     not-expr = "(" "not" expr ")" .
;; 
;;     and-expr = "(" expr "and" expr ")" .
;; 
;;      or-expr = "(" expr "or" expr ")" .
;;

(define (is-expr? e)
  (match e
    ['t           #t]
    ['f           #t]
    [`(not ,a)    (is-expr? a)]
    [`(,a or ,b)  (and (is-expr? a) (is-expr? b))]
    [`(,a and ,b) (and (is-expr? a) (is-expr? b))]
    [_            #f]
    ))


(define (eval-prop-bool expr)
  (match expr
    ['t           #t]
    ['f           #f]
    [`(not ,a)    (not (eval-prop-bool a))]
    [`(,a or ,b)  (or (eval-prop-bool a)
                      (eval-prop-bool b))]
    [`(,a and ,b) (and (eval-prop-bool a)
                       (eval-prop-bool b))]
    [_            (error "eval-prop-bool3: syntax error")]
    ))

;;
;; EBNF for nand-only expression
;;
;; expr =   "t"
;;        | "f"
;;        | "(" expr "nand" expr ")" .
;;

(define (is-nand? expr)
  (match expr
    ['t            #t]
    ['f            #t]
    [`(,a nand ,b) (and (is-nand? a) (is-nand? b))]
    [_             #f]
    ))

(define (eval-nand expr)
  (match expr
    ['t            #t]
    ['f            #f]
    [`(,a nand ,b) (not (and (eval-nand a)
                             (eval-nand b)))]
    [_ (error "eval-nand: syntax error")]
    ))

;;
;; Converting propositional expressions to logically equivalent nand-only
;; expressions.
;;
;; - (not p) is logically equivalent to (p nand p)
;; 
;; - (p and q) is logically equivalent to ((p nand q) nand (p nand q))
;; 
;; - (p or q) is logically equivalent to ((p nand p) nand (q nand q))

(define (make-nand a b) (list a 'nand b))

(define (to-nand expr)
  (if (symbol? expr) 
      expr  ;; if expr is a symbol, return it unchanged
      (match expr
        [`(not ,a)    (let ([na (to-nand a)])
                        (make-nand na na))]
        [`(,a or ,b)  (let* ([na (to-nand a)]
                             [nb (to-nand b)]
                             [nana (make-nand na na)]
                             [nbnb (make-nand nb nb)])
                        (make-nand nana nbnb))]     
        [`(,a and ,b) (let* ([na (to-nand a)]
                             [nb (to-nand b)]
                             [nanb (make-nand na nb)])
                        (make-nand nanb nanb))]
        [_ (error "nand-rewrite syntax error")]
        )))

;; (to-nand '((p and (not (q or p))) or (p and q)))


;;
;; Simplifying an expression by removing double-negation.
;; (not (not e)) ==> e
;;
;; double negation elimination

;; (not (not expr)) <==> expr

(define (simplify expr)
  (match expr
    ['t              't]
    ['f              'f]
    [`(not (not ,a)) (simplify a)]
    [`(not ,a)       (list 'not (simplify a))]
    [`(,a or ,b)     (list (simplify a) 'or (simplify b))]
    [`(,a and ,b)    (list (simplify a) 'and (simplify b))]
    [_ (error "simplify: syntax error")]
    ))

;; (simplify '(not (not (t or (f and (not (not t)))))))
