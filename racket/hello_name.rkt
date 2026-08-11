;; hello_name.rkt

#lang racket

;; Reads the users name and says hello to them.
;;
;; A begin form is used to execute operations in sequence.
;;
(begin
  (print "What's your name? ")
  (let ((name (read-line)))
    (string-append "Hello " name "!")))