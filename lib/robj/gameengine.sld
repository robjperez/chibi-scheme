(define-library (robj gameengine)
  (cond-expand
   (emscripten
    (import (chibi) (chibi ast))
    (export hello-world say-hello)
    (include "gameengine.scm")
    (include-shared "gameengine"))))
