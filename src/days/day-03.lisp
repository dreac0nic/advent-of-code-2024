;;;; days/day-03.lisp

(in-package #:days.day-03)

(defparameter *example* "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")

(defparameter *example-two* "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")



(defparameter *mul-rx*
  (-> '(:SEQUENCE "mul("
        (:REGISTER (:GREEDY-REPETITION 1 3 :DIGIT-CLASS))
        ","
        (:REGISTER (:GREEDY-REPETITION 1 3 :DIGIT-CLASS))
        ")")
      create-scanner))


(defparameter *muldo-rx*
  (-> '(:SEQUENCE
        (:REGISTER (:ALTERNATION "mul" "do" "don't"))
        "("
        (:GREEDY-REPETITION 0 1
         (:SEQUENCE
          (:REGISTER (:GREEDY-REPETITION 1 3 :DIGIT-CLASS))
          ","
          (:REGISTER (:GREEDY-REPETITION 1 3 :DIGIT-CLASS))))
        ")")
      create-scanner))


(defun tokenize-fn (input)
  (intern (string-upcase (remove #\' input)) "KEYWORD"))


;;; Part 1
(defun part-one ()
  (with-puzzle (:year 2024 :day 3)
      (:input-binding puzzle-input)
    (->> (let (instructions)
           (do-register-groups ((#'parse-integer left-param right-param))
               (*mul-rx* puzzle-input instructions)
             (setf instructions
                   (cons (* left-param right-param)
                         instructions))))
         (reduce #'+)
         submit-part-one)))


;;; Part 2
(defun part-two ()
  (with-puzzle (:year 2024 :day 3)
      (:input-binding puzzle-input)
    (->> (let (instructions
               (mul-p t))
           (do-register-groups ((#'tokenize-fn command) (#'parse-integer left-param right-param))
               (*muldo-rx* puzzle-input instructions)
             (case command
               (:do (setf mul-p t))
               (:dont (setf mul-p nil))
               (:mul (when mul-p
                       (setf instructions
                             (cons (* left-param right-param)
                                   instructions)))))))
         (reduce #'+)
         submit-part-two)))
