(define (inverter input output)
  (define (invert-input)
    (let ((new-value
            (logical-not (get-signal input))))
      (after-delay
        inverter-delay
        (lambda ()
          (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))

(define (and-gate i1 i2 output)
  (define (and-action-procedure)
    (let ((new-value
            (logical-and (get-signal i1)
                         (get-signal i2))))
      (after-delay
        and-gate-delay
        (lambda ()
          (set-signal! output new-value)))))
  (add-action! i1 and-action-procedure)
  (add-action! i2 and-action-procedure)
  'ok)

(define (logical-and s1 s2)
  (cond ((and (= s1 0) (= s2 0)) 0)
        ((and (= s1 0) (= s2 1)) 0)
        ((and (= s1 1) (= s2 0)) 0)
        ((and (= s1 1) (= s2 1)) 1)
        (else (error "Invalid signal" s))))

;; Exercise 3.28

(define (or-gate i1 i2 output)
  (define (or-action-procedure)
    (let ((new-value
            (logical-or (get-signal i1)
                        (get-signal i2))))
      (after-delay
        or-gate-delay
        (lambda ()
          (set-signal! output new-value)))))
  (add-action! i1 or-action-procedure)
  (add-action! i2 or-action-procedure)
  'ok)

(define (logical-or s1 s2)
  (cond ((and (= s1 0) (= s2 0)) 0)
        ((and (= s1 0) (= s2 1)) 1)
        ((and (= s1 1) (= s2 0)) 1)
        ((and (= s1 1) (= s2 1)) 1)
        (else (error "Invalid signal" s))))

(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)
