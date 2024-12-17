;;;; days/day-04.lisp

(in-package #:days.day-04)

(defparameter *example* "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX")


(defun input->lookup-array (input)
  (loop :with lines := (mapcar (rcurry #'coerce 'list) (split "\\n" input))
        :with lookup := (make-array (list (length lines) (length (car lines))) :initial-element #\.)
        :for line :in lines
        :for y :from 0
        :do (loop :for c :in line
                  :for x :from 0
                  :do (setf (aref lookup y x) c))
        :finally (return lookup)))


(defun build-slope-string (lookup-map row col row-slope col-slope &key (length 4))
  (coerce (loop :for y := row :then (+ y row-slope)
                :for x := col :then (+ x col-slope)
                :repeat length
                :while (and (>= x 0)
                            (>= y 0)
                            (< x (array-dimension lookup-map 1))
                            (< y (array-dimension lookup-map 0)))
                :collect (aref lookup-map y x))
          'string))


(defun collect-8ways (lookup-map row col)
  (loop :for y :from -1 :to 1
        :append (loop :for x :from -1 :to 1
                      :if (not (and (= x 0)
                                    (= y 0)))
                        :collect (build-slope-string lookup-map row col y x))))


(defun xmas-p (string)
  (string= "XMAS" string))


(defun collect-x-strings (lookup-map row col)
  (let ((left (build-slope-string lookup-map (- row 1) (- col 1) 1 1 :length 3))
        (right (build-slope-string lookup-map (- row 1) (+ col 1) 1 -1 :length 3)))
    (remove-if (curry #'string= "")
               (list left (reverse left) right (reverse right)))))


;;; Part 1
(defun part-one ()
  (with-puzzle (:year 2024 :day 4)
      (:input-binding puzzle-input)
    (submit-part-one
     (let ((word-search (input->lookup-array puzzle-input)))
       (destructuring-bind (rows cols)
           (array-dimensions word-search)
         (loop :for row :from 0 :below rows
               :sum (loop :for col :from 0 :below cols
                          :sum (count-if #'xmas-p (collect-8ways word-search row col)))))))))


;;; Part 2
(defun part-two ()
  (with-puzzle (:year 2024 :day 4)
      (:input-binding puzzle-input)
    (submit-part-two
     (loop :with word-search := (input->lookup-array puzzle-input)
           :with (rows cols) := (array-dimensions word-search)
           :for row :from 1 :below (- rows 1)
           :sum (loop :for col :from 1 :below (- cols 1)
                      :for found-mas := (count-if (curry #'string= "MAS")
                                                  (collect-x-strings word-search row col))
                      :if (>= found-mas 2)
                        :sum 1)))))
