;;;; days/day-02.lisp

(in-package #:days.day-02)

(defparameter *example* "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9")


(defun input->safety-reports (input)
  (mapcar (compose
           (curry #'mapcar
                  #'parse-integer)
           (curry #'split " "))
          (split "\\n" input)))


(defun rate-report-values (report)
  (loop :for from :in report
        :for to :in (cdr report)
        :collect (- from to)))


(defun is-report-safe-p (report)
  (every #'identity
         (funcall (juxt (lambda (ratings) (every (compose (lambda (x) (and (> x 0) (<= x 3))) #'abs) ratings))
                        (lambda (ratings) (every (if (plusp (car ratings)) #'plusp #'minusp) ratings)))
                  report)))


(defun get-report-slope (report)
  (signum (- (/ (reduce #'+ report)
                (length report))
             (car report))))


(defun get-ratings-slope (ratings)
  (signum (reduce #'+ (mapcar #'signum ratings))))


(defun rating-safe-p (rating slope)
  (and (= (signum rating) slope)
       (> (abs rating) 0)
       (<= (abs rating) 3)))


(defun add-error (ratings error-pos)
  (loop :for rating :in ratings
        :for index :from 0
        :with skew := nil
        :if (= index error-pos)
          :do (setf skew rating)
        :else
          :collect (if (numberp skew)
                       (prog1
                           (+ skew rating)
                         (setf skew nil))
                       rating)))


(defun dampen-errors (ratings)
  (let* ((safe-p (rcurry #'rating-safe-p (get-ratings-slope ratings)))
         (error-pos (position-if (compose #'not safe-p) ratings)))
    (or (every safe-p (add-error ratings error-pos))
        (every safe-p (add-error (reverse ratings)
                                 (- (length ratings) 1 error-pos))))))


;;; Part 1
(defun part-one ()
  (with-puzzle
      (:day 2
       :year 2024)
      (:input-binding puzzle-input)
    (->> (input->safety-reports puzzle-input)
         (mapcar #'rate-report-values)
         (mapcar #'is-report-safe-p)
         (count t)
         submit-part-one)))


;;; Part 2
(defun part-two ()
  (with-puzzle
      (:day 2
       :year 2024)
      (:input-binding puzzle-input)
    (->> (input->safety-reports puzzle-input)
         (mapcar #'rate-report-values)
         (mapcar (lambda (ratings)
                   (if (is-report-safe-p ratings)
                       t
                       (dampen-errors ratings))))
         (count t)
         submit-part-two)))
