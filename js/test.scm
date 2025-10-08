(import (scheme base)
        (robj gameengine))

(define angle 0)
(define cx 400)
(define cy 300)
(define radius 150)

(define (initialize)
  (write-string "Init") (newline))

(define (update)
  (set! angle (+ 1 angle)))

(define (render)
  (let* ((indices '(0 1 2))
         (points
          (map (lambda (i)
                 (let ((a (+ angle (* i 2.0 (/ pi 3.0)))))
                   (list (round (+ cx (* radius (cos a))))
                         (round (+ cy (* radius (sin a)))))))
               indices)))
    (draw-lines! indices)))        
