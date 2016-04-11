(include "wires.scm")
(include "agenda.scm")
(include "flip_flops.scm")

(define the-agenda (make-agenda))

(define s (make-wire))
(define r (make-wire))

(define q (make-wire))

(sr-and-or-latch s r q)

(probe 'set s)
(probe 'reset r)
(probe 'q q)

(define sr (list s r))

(comment "Set")
(set-signals! sr '(1 0))
(propagate)

(comment "Reset")
(set-signals! sr '(1 1))
(propagate)

(comment "Set")
(set-signals! sr '(1 0))
(propagate)

(comment "Reset")
(set-signals! sr '(0 1))
(propagate)
