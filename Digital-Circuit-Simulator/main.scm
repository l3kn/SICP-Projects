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

;; Representing wires

(define (make-wire)
  (let ((signal-value 0)
        (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
        (begin (set! signal-value new-value)
               (call-each action-procedures))
        'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures
            (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal)
             signal-value)
            ((eq? m 'set-signal!)
             set-my-signal!)
            ((eq? m 'add-action!)
             accept-action-procedure!)
            (else (error "Unknown operation:
                          WIRE" m))))
    dispatch))

(define (call-each procedures)
  (if (null? procedures)
    'done
    (begin ((car procedures))
           (call-each (cdr procedures)))))

(define (get-signal wire)
  (wire 'get-signal))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))

(define (set-signals! wires new-values)
  (if (not (null? wires))
    (begin
      (set-signal! (car wires) (car new-values))
      (set-signals! (cdr wires) (cdr new-values)))
    'done))

;; The agenda

(define (make-queue) (cons '() '()))

(define (front-ptr q) (car q))
(define (rear-ptr q) (cdr q))
(define (set-front-ptr! q ptr) (set-car! q ptr))
(define (set-rear-ptr! q ptr) (set-cdr! q ptr))

(define (empty-queue? q) (null? (front-ptr q)))
(define (front-queue q)
  (if (empty-queue? q)
    (error "FRONT-QUEUE called with an empty queue" q)
    (car (front-ptr q))))
(define (insert-queue! q x)
  (let ((new-pair (cons x '())))
    (if (empty-queue? q)
      (begin (set-front-ptr! q new-pair)
             (set-rear-ptr! q new-pair)
             q)
      (begin (set-cdr! (rear-ptr q) new-pair)
             (set-rear-ptr! q new-pair)
             q))))
(define (delete-queue! q)
  (if (empty-queue? q)
    (error "DELETE-QUEUE! called with an empty queue" q)
    (begin (set-front-ptr! q (cdr (front-ptr q)))
           q)))

(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))

(define (make-agenda) (list 0))
(define (current-time agenda) (car agenda))
(define (set-current-time! agenda time)
  (set-car! agenda time))
(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))
(define (first-segment agenda)
  (car (segments agenda)))
(define (rest-segments agenda)
  (cdr (segments agenda)))

(define (empty-agenda? agenda)
  (null? (segments agenda)))

(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
        (< time 
           (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
      (insert-queue!
        (segment-queue (car segments))
        action)
      (let ((rest (cdr segments)))
        (if (belongs-before? rest)
          (set-cdr!
            segments
            (cons (make-new-time-segment time action)
                  (cdr segments)))
          (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
      (set-segments!
        agenda
        (cons (make-new-time-segment time action)
              segments))
      (add-to-segments! segments))))

(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
      (set-segments!
        agenda
        (rest-segments agenda)))))

(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
    (error "Agenda is empty:
            FIRST-AGENDA-ITEM")
    (let ((first-seg (first-segment agenda)))
      (set-current-time!
        agenda
        (segment-time first-seg))
      (front-queue
        (segment-queue first-seg)))))

(define (after-delay n action)
  (add-to-agenda!
    (+ n (current-time the-agenda))
    action
    the-agenda))

(define (propagate)
  (if (empty-agenda? the-agenda)
    'done
    (let ((first-item (first-agenda-item the-agenda)))
      (first-item)
      (remove-first-agenda-item! the-agenda)
      (propagate))))

;; A sample simulation

(define (probe name wire)
  (add-action!
    wire
    (lambda ()
      (print (current-time the-agenda) "\t" name "\t" (get-signal wire)))))

(define the-agenda (make-agenda))
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)

;; Example, 5-bit ripple-carry-adder

(define c (make-wire))

(define a1 (make-wire))
(define a2 (make-wire))
(define a3 (make-wire))
(define a4 (make-wire))
(define a5 (make-wire))

(define b1 (make-wire))
(define b2 (make-wire))
(define b3 (make-wire))
(define b4 (make-wire))
(define b5 (make-wire))

(define s1 (make-wire))
(define s2 (make-wire))
(define s3 (make-wire))
(define s4 (make-wire))
(define s5 (make-wire))

(define as (list a1 a2 a3 a4 a5))
(define bs (list b1 b2 b3 b4 b5))
(define ss (list s1 s2 s3 s4 s5))

(ripple-carry-adder as bs ss c)

(probe 'sum1 s1)
(probe 'sum2 s2)
(probe 'sum3 s3)
(probe 'sum4 s4)
(probe 'sum5 s5)

(set-signals! as '(1 1 1 0 0)) ; LSB first, binary 7
(set-signals! bs '(1 0 0 0 0))

(propagate)
