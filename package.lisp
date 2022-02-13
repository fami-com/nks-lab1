;;;; package.lisp

(defpackage #:nks-lab1
  (:use #:cl)
  (:local-nicknames (#:a #:alexandria-2))
  (:import-from #:arrow-macros #:-> #:->> #:as->)
  (:export #:run))
