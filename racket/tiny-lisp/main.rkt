#lang racket/base

;; tiny-lisp
;;
;; This module *is* the language for `#lang tiny-lisp`. Unlike
;; `racket_restrict` (which is "racket minus one thing"), this is a
;; whitelist: the ONLY bound identifiers a `#lang tiny-lisp` program
;; gets are the ones explicitly `provide`d below. Every other Racket
;; binding -- `if`, `/`, `eq?`/`eqv?`/`=`, `let*`/`letrec`, `set!`,
;; `map`, `require`, structs, strings, etc. -- simply does not exist
;; in this language. Using any of them is an unbound-identifier error,
;; exactly like using any other unknown/undefined name.
;;
;; What IS available:
;;   define   -- (define x expr) and (define (f arg ...) body ...),
;;                including recursive functions
;;   cond, else
;;   and, or, not
;;   quote    -- and the '... reader shorthand, so literal data like
;;                '(1 2 3) or '(a b c) can be written
;;   cons, list -- to build new lists at runtime
;;   empty?, first, rest -- to take lists apart
;;   equal?   -- structural equality test
;;   +, -, *  -- addition, subtraction, multiplication (arity like Racket's)
;;   let      -- local bindings, including named let for iteration
;;   lambda   -- anonymous functions, for higher-order functions
;;                (e.g. passing a function to a user-defined my-map)
;;
;; Notably ABSENT: / and other arithmetic; eq?/eqv?/=; if; let*/letrec;
;; set! (no mutation); map/filter/foldl (write your own with lambda +
;; define); strings; structs; and the ability to require any other
;; library.
;;
;; `/` in particular is left out ON PURPOSE, not as an oversight: it
;; immediately raises exact rationals (and division by zero) as an
;; issue, which is more of the numeric tower than this language wants
;; to get into. +, -, and * stay safely within the integers.

(require (only-in racket/base
                   #%module-begin #%app #%datum #%top #%top-interaction
                   define cond else and or not quote cons list equal? + - *
                   let lambda)
         (only-in racket/list first rest empty?))

(provide #%module-begin #%app #%datum #%top #%top-interaction
         define cond else and or not quote cons list equal? + - *
         let lambda
         first rest empty?)
