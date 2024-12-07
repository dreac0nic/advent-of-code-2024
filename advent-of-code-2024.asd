;;;; advent-of-code-2024.asd

(asdf:defsystem #:advent-of-code-2024
  :description "Describe advent-of-code-2024 here"
  :author "spenser <spenser.m.bray@gmail.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:arrows #:cl-ppcre)
  :components ((:file "package")
               (:file "advent-of-code-2024")))
