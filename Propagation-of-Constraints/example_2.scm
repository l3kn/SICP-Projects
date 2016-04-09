(include "connector.scm")
(include "probe.scm")
(include "averager.scm")

(define i1 (make-connector))
(define i2 (make-connector))
(define o (make-connector))

(averager i1 i2 o)

(probe "In1" i1)
(probe "In2" i2)
(probe "Out" o)

(set-value! i1 10 'user)
(set-value! i2 30 'user)

(forget-value! i1 'user)
(set-value! o 40 'user)
