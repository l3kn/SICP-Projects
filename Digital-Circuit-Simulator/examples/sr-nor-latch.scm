(include "wires.scm")
(include "agenda.scm")
(include "flip_flops.scm")

(define the-agenda (make-agenda))

(define s (make-wire))
(define r (make-wire))

(define q (make-wire))
(define inv-q (make-wire))

(sr-nor-latch s r q inv-q)

(probe 'set s)
(probe 'reset r)
(probe 'q q)
(probe 'inv-q inv-q)

(define sr (list s r))

(comment "Set")
(set-signals! sr '(1 0))
(propagate)

(set-signals! sr '(0 0))
(propagate)

(comment "Reset")
(set-signals! sr '(0 1))
(propagate)

(set-signals! sr '(0 0))
(propagate)

(comment "Unstable")
(set-signals! sr '(1 1))
(propagate)
