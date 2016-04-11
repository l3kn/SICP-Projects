(include "basic_gates.scm")
(include "inverted_gates.scm")

(define (sr-nor-latch s r q inv-q)
  (nor-gate s q inv-q)
  (nor-gate r inv-q q))
