;;;; package.lisp

(defpackage #:utility
  (:use #:cl #:arrows)
  (:export :single? :append1 :map-int :filter :most :compose :disjoin :conjoin :curry :rcurry :always :clamp :juxt))

(defpackage #:days.day-01
  (:use #:cl #:arrows #:cl-ppcre #:utility #:cl-advent-of-code))

(defpackage #:advent-of-code-2024
  (:use #:cl #:arrows))
