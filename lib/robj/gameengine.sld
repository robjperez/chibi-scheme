(define-library (robj gameengine)
  (cond-expand
   (emscripten
    (import (chibi) (chibi ast))
    (export clear-screen! draw-lines!)
    (include "gameengine.scm")
    (include-shared "gameengine"))))
