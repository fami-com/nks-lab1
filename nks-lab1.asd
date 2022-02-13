;;;; nks-lab1.asd

(asdf:defsystem #:nks-lab1
  :description "NSK Lab 1"
  :author "Volodymyr Ivanov <me@funcall.me>"
  :licence "CC0-1.0"
  :version "0.0.1"
  :depends-on (#:alexandria #:arrow-macros)
  :serial t
  :components ((:file "package")
               (:file "nks-lab1")))
