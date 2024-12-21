;;;; days/day-05.lisp

(in-package #:days.day-05)

(defparameter *example* "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47")


(defun build-map (paths)
  (reduce (lambda (map new-path)
            (destructuring-bind (source . destination)
                new-path
              (setf (gethash source map)
                    (cons destination (gethash source map)))
              map))
          paths
          :initial-value (make-hash-table)))


(defun input->update-info (input)
  (destructuring-bind (rules updates)
      (split "\\n\\n" input)
    (values (->> (split "\\n" rules)
                 (mapcar (lambda (rule-string)
                           (apply #'cons
                                  (mapcar #'parse-integer
                                          (split #\| rule-string)))))
                 build-map)
            (->> (split "\\n" updates)
                 (mapcar (lambda (update-string)
                           (mapcar #'parse-integer
                                   (split #\, update-string))))))))


(defun can-path-p (path map)
  (or
   (<= (length path) 1)
   (when (find (cadr path) (gethash (car path) map))
     (can-path-p (cdr path) map))))


;;; Part 1
(defun part-one ()
  (with-puzzle (:year 2024 :day 5)
      (:input-binding puzzle-input)
    (multiple-value-bind (rules updates)
        (input->update-info puzzle-input)
      (->> (remove-if-not (rcurry #'can-path-p rules) updates)
           (mapcar (lambda (seq)
                     (elt seq (floor (/ (length seq) 2)))))
           (reduce #'+)
           submit-part-one))))


;;; Part 2
(defun part-two ()
  (with-puzzle (:year 2024 :day 5)
      (:input-binding puzzle-input)
    (multiple-value-bind (rules updates)
        (input->update-info puzzle-input)
      (->> (remove-if (rcurry #'can-path-p rules) updates)
           (mapcar (rcurry #'sort (lambda (left right) (find right (gethash left rules)))))
           (mapcar (lambda (seq)
                     (elt seq (floor (/ (length seq) 2)))))
           (reduce #'+)
           submit-part-two))))
