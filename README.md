# SICP-Projects

## Digital Circuit Simulator

### Currently Implemented

* inverter
* and-gate
* or-gate
* half-adder
* full-adder
* ripple-carry-adder (n-bit)

### Example

``` lisp
(define the-agenda (make-agenda))
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)

(define c (make-wire))
(define a1 (make-wire))
; ...
(define b1 (make-wire))
; ...
(define s1 (make-wire))
; ...

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
(set-signals! bs '(1 0 0 0 0)) ; binary 1

(propagate)
```

``` bash
$ csi -s main.scm | ruby visualize.rb
sum1: ……………………########…………………………………………………………………………………………………………………………………
sum2: ……………………########################………………………………………………………………………………………
sum3: ……………………########################################……………………………………………
sum4: …………………………………………………………………………………………………………………………………………………………………………#
sum5: ……………………………………………………………………………………………………………………………………………………………………………
```
