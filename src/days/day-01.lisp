;;;; days/day-01.lisp

(in-package #:days.day-01)

(defparameter *example* "3   4
4   3
2   5
1   3
3   9
3   3")


(defun input->lists (input)
  (->> (split "\\n" input)
       (mapcar (lambda (line)
                 (->> (split "   " line)
                      (mapcar #'parse-integer)
                      (apply #'list))))
       (apply #'mapcar #'list)))


(defun sum-location-diffs (left right)
  (->> (list left right)
       (mapcar (rcurry #'sort #'<))
       (apply #'mapcar (lambda (x y) (- (max x y) (min x y))))
       (reduce #'+)))


(defun rank-locations (locations instances)
  (loop :with location-ranks := (mapcar (rcurry #'cons 0) (sort (remove-duplicates locations) #'<))
        :for inst :in instances
        :if (assoc inst location-ranks)
          :do
             (incf (cdr (assoc inst location-ranks)))
             (identity location-ranks)
        :finally (return location-ranks)))

;;; Part 1
(defun part-one ()
  (with-puzzle
      (:day 1
       :year 2024)
      (:input-binding puzzle-input)
    (->> (input->lists puzzle-input)
         (apply #'sum-list-diffs)
         (format nil "~D")
         submit-part-one)))


;;; Part 2
(defun part-two ()
  (with-puzzle
      (:day 1
       :year 2024)
      (:input-binding puzzle-input)
    (let* ((lists (input->lists puzzle-input))
           (locations (car lists))
           (ranks (rank-locations (car lists) (car (cdr lists)))))
      (submit-part-two
       (reduce (lambda (acc loc)
                 (+ acc
                    (if (assoc loc ranks)
                        (* loc (cdr (assoc loc ranks)))
                        0)))
               locations
               :initial-value 0)))))
