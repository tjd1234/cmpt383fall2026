#lang info

(define deps '("base" "racket-lib"))
(define build-deps '())
(define pkg-desc "A minimal Lisp with a whitelisted set of primitives: quote, cond, else, let, let*, define, lambda, and, or, not, error, +, -, *, /, <, >, <=, >=, =, sqrt, sin, cos, equal?, symbol?, number?, boolean?, list?, pair?, even?, odd?, cons, list, first, rest, empty?. Every other identifier -- if, set!, letrec, eq?, length, append, map, filter, etc. -- is unbound.")
(define compile-omit-paths '("examples"))
(define version "0.2")
