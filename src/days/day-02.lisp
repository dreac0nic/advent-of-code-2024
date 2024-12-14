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
                  (rate-report-values report))))

(defun get-report-slope (report)
  (signum (- (/ (reduce #'+ report)
                (length report))
             (car report))))


(defun simulate-report-p (report)
  (loop :with oopsie := nil
        :with slope := (get-report-slope report)
        :with from := (- (car report) slope)
        :for to :in report
        :for rank := (- to from)
        :if (or (not (= (signum rank) slope))
                (<= (abs rank) 0)
                (> (abs rank) 3))
          :do (if (not oopsie)
                  (setf oopsie t)
                  (return))
        :else
          :do
             (setf from to)
        :finally (return t)))

;; FIXME: Doesn't work
;; probably need to iterate by retaining the "previous" number and iterating by 1; this way we can handle the case when we need to "skip" a bad result, but still keep the previous number for testing
;; by iterating using a second value, we skip the left side value when correcting for the error

;; XXX: bad fixme attempt ^^^^^^
;; need to be able to look ahead as wel as behind
;; also something is super screwed

;; TODO: Solve problem for first item

;; (let ((reports (input->safety-reports *example*)))
;;   (mapcar #'simulate-report-p reports))





;;; Part 1
(defun part-one ()
  (with-puzzle
      (:day 2
       :year 2024)
      (:input-binding puzzle-input)
    (->> (input->safety-reports puzzle-input)
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
         (mapcar #'simulate-report-p)
         (count t)
         submit-part-two)))
