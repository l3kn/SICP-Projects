(include "basic_gates.scm")

(define (half-adder a b sum c)
  (let ((d (make-wire))
        (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e sum)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((c1 (make-wire))
        (c2 (make-wire))
        (s (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

;; Exercise 3.30

(define (ripple-carry-adder as bs ss c)
    (let ((c-new (make-wire)))
      (full-adder (car as) (car bs) c (car ss) c-new)
      (if (not (null? (cdr as)))
        (ripple-carry-adder (cdr as) (cdr bs)
                      (cdr ss) c-new))
      'ok))

