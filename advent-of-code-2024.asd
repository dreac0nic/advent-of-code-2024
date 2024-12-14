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
                   (:file "day-03")
                   (:file "day-04")
                   (:file "day-05")
                   (:file "day-06")
                   (:file "day-07")
                   (:file "day-08")
                   (:file "day-09")
                   (:file "day-10")
                   (:file "day-11")
                   (:file "day-12")
                   (:file "day-13")
                   (:file "day-14")
                   (:file "day-15")
                   (:file "day-16")
                   (:file "day-17")
                   (:file "day-18")
                   (:file "day-19")
                   (:file "day-20")
                   (:file "day-21")
                   (:file "day-22")
                   (:file "day-23")
                   (:file "day-24")
                   (:file "day-25")))
                 (:file "advent-of-code-2024"))))
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md")))
