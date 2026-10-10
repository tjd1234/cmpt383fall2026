#lang tiny-lisp

;; Fails: `set!` is not bound in tiny-lisp -- there is no mutation.
;; `let` gives you local bindings, but you can't reassign them.

(define (zero-out! lst)
  (let ([dummy (first lst)])
    (set! dummy 0)
    dummy))

(zero-out! '(1 2 3))
