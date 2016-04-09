(include "connector.scm")
(include "probe.scm")
(include "squarer.scm")

(define i (make-connector))
(define o (make-connector))

(squarer i o)

(probe "In" i)
(probe "Out" o)

(set-value! i 10 'user)
(forget-value! i 'user)
(set-value! o 64 'user)
(forget-value! o 'user)
(set-value! o -10 'user)
