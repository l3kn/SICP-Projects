(include "constant.scm")
(include "adder.scm")
(include "multiplier.scm")

;; Exercise 3.33

(define (averager v1 v2 average)
  (let ((sum (make-connector))
        (half (make-connector)))
    (adder v1 v2 sum)
    (constant 0.5 half)
    (multiplier sum half average)
    'ok))
