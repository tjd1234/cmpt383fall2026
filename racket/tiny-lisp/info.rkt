#lang info

(define deps '("base" "racket-lib"))
(define build-deps '())
(define pkg-desc "A minimal Lisp with a whitelisted set of primitives: define, cond, else, and, or, not, empty?, first, rest, cons, list, quote, equal?, +, -, *, let, lambda. Every other identifier -- if, /, eq?/eqv?/=, let*/letrec, set!, map, etc. -- is unbound.")
(define compile-omit-paths '("examples"))
(define version "0.1")
