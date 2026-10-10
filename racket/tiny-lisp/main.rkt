#lang racket/base

;; tiny-lisp
;;
;; This module *is* the language for `#lang tiny-lisp`. It is a whitelist:
;; the ONLY bound identifiers a `#lang tiny-lisp` program gets are the ones
;; explicitly `provide`d below. Any other Racket identifier (if, set!, map,
;; length, append, strings, ...) is unbound in tiny-lisp.
;;
;; If you change the list of primitives, also update README.md and the
;; pkg-desc in info.rkt so they stay consistent.
;;

(require (only-in racket/base
                  ;; module plumbing (needed for any #lang to work)
                  #%module-begin #%app #%datum #%top #%top-interaction

                  ;; special forms
                  quote cond else let let* define lambda and or

                  ;; arithmetic, comparison, and math
                  + - * / < > <= >= = sqrt sin cos

                  ;; logic and errors
                  not error

                  ;; predicates
                  equal? symbol? number? boolean? list? pair? even? odd?

                  ;; list construction
                  cons list)

         ;; list access
         (only-in racket/list first rest empty?))

(provide #%module-begin #%app #%datum #%top #%top-interaction
         quote cond else let let* define lambda and or
         + - * / < > <= >= = sqrt sin cos
         not error
         equal? symbol? number? boolean? list? pair? even? odd?
         cons list
         first rest empty?)
