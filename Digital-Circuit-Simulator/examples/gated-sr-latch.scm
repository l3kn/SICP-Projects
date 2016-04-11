(include "wires.scm")
(include "agenda.scm")
(include "flip_flops.scm")

(define the-agenda (make-agenda))

(define s (make-wire))
(define r (make-wire))
(define e (make-wire))

(define q (make-wire))
(define inv-q (make-wire))

(gated-sr-latch s r e q inv-q)

(probe 'set s)
(probe 'reset r)
(probe 'enable e)
(probe 'q q)
(probe 'inv-q inv-q)

(define sr (list s r))

(comment "Set")
(set-signal! e 1)
(set-signals! sr '(1 0))
(propagate)

(comment "Reset")
(set-signals! sr '(0 1))
(propagate)

(comment "Set, Disabled")
(set-signal! e 0)
(set-signals! sr '(1 0))
(propagate)

; (set-signals! sr '(0 0))
; (propagate)

; (comment "Reset")
; (set-signals! sr '(0 1))
; (propagate)

; (set-signals! sr '(0 0))
; (propagate)

; (comment "Disable")
; (set-signal! e 1)
; (propagate)

; (comment "Set")
; (set-signals! sr '(1 0))
; (propagate)

; (set-signals! sr '(0 0))
; (propagate)

; (comment "Reset")
; (set-signals! sr '(0 1))
; (propagate)

; (set-signals! sr '(0 0))
; (propagate)
