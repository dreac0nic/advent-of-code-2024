;;;; advent-of-code-2024.asd

(asdf:defsystem #:advent-of-code-2024
  :description "We advent of code again boys"
  :author "spenser <spenser.m.bray@gmail.com>"
  :license  "N/A"
  :version "0.0.1"
  :serial t
  :depends-on (#:uiop #:arrows #:cl-ppcre #:cl-advent-of-code)
  :components ((:module "src"
                :serial t
                :components
                ((:file "package")
                 (:file "utility")
                 (:module "days"
                  :serial t
                  :components
                  ((:file "day-01")
                   (:file "day-02")
                 (:file "advent-of-code-2024"))))
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md")))
