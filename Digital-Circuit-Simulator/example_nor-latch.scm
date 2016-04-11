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

(comment "Setting")
(set-signal! s 1)
(propagate)
(set-signal! s 0)
(propagate)

(comment "Resetting")
(set-signal! r 1)
(propagate)
(set-signal! r 0)
(propagate)
