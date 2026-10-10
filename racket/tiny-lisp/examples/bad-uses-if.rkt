#lang tiny-lisp

;; Fails: `if` is not bound in tiny-lisp -- only `cond` is available.

(define (choose flag lst1 lst2)
  (if flag lst1 lst2))

(choose #t '(1 2) '(3 4))
