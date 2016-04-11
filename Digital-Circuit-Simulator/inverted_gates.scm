(include "basic_gates.scm")

(define (nand-gate i1 i2 output)
  (let ((o (make-wire)))
    (and-gate i1 i2 o)
    (inverter o output)))

(define (nor-gate i1 i2 output)
  (let ((o (make-wire)))
    (or-gate i1 i2 o)
    (inverter o output)))
