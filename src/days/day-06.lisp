;;;; days/day-06.lisp

(in-package #:days.day-06)

(defparameter *example* "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...")


(defun input->game (input)
  (loop :with lines := (mapcar (rcurry #'coerce 'list) (split "\\n" input))
        :with lookup := (make-array (list (length lines) (length (car lines))) :initial-element nil)
        :with guard := nil
        :for line in lines
        :for y :from 0
        :do (loop :for c :in line
                  :for x :from 0
                  :do (setf (aref lookup y x)
                            (cond
                              ((or (char= c #\^)
                                   (char= c #\>)
                                   (char= c #\<)
                                   (char= c #\v))
                               (prog1 nil
                                 (setf guard
                                       (list (cons :position (cons x y))
                                             (cons :direction
                                                   (case c
                                                     (#\^ :up)
                                                     (#\v :down)
                                                     (#\< :left)
                                                     (#\> :right)))))))
                              ((char= c #\#) :wall)
                              (t nil))))
        :finally (return (values lookup
                                 guard))))


(defun move (position direction)
  (destructuring-bind (x . y)
      position
    (case direction
      (:up (setf y (- y 1)))
      (:down (setf y (+ y 1)))
      (:left (setf x (- x 1)))
      (:right (setf x (+ x 1))))
    (cons x y)))


(defun can-move-p (guard map)
  (destructuring-bind (x . y)
      (move (cdr (assoc :position guard))
            (cdr (assoc :direction guard)))
    (or (not (within-bounds-p (make-guard x y) map))
        (not (equal (aref map y x)
                    :wall)))))

(defun rotate-90 (direction)
  (case direction
    (:up :right)
    (:right :down)
    (:down :left)
    (:left :up)))


(defun make-guard (x y &optional (direction :up))
  (list (cons :position (cons x y))
        (cons :direction direction)))


(defun simple-guard-tick (guard map &key (step 1))
  (loop :with pos := (cdr (assoc :position guard))
        :with dir := (cdr (assoc :direction guard))
        :repeat step
        :if (can-move-p (make-guard (car pos) (cdr pos) dir) map)
          :do (setf pos (move pos dir))
        :else
          :do (setf dir (rotate-90 dir))
        :finally (return (make-guard (car pos) (cdr pos) dir))))


(defun within-bounds-p (guard map)
  (destructuring-bind (x . y)
      (cdr (assoc :position guard))
    (destructuring-bind (height width)
        (array-dimensions map)
      (and (>= x 0)
           (< x width)
           (>= y 0)
           (< y height)))))


(defun print-guard (guard)
  (format t "~&Guard @ ~a ~a~%"
          (cdr (assoc :position guard))
          (cdr (assoc :direction guard))))


(defun build-visited-map (map guard)
  (loop :with visited-tiles := (make-array (array-dimensions map) :initial-element nil)
        :with active-guard := guard
        :for pos := (cdr (assoc :position active-guard))
        :for dir := (cdr (assoc :direction active-guard))
        :while (within-bounds-p active-guard map)
        :do (setf (aref visited-tiles (cdr pos) (car pos))
                  (cons dir (aref visited-tiles (cdr pos) (car pos)))
                  active-guard
                  (simple-guard-tick active-guard map))
        :finally (return visited-tiles)))


;; Part 1
(defun part-one ()
  (with-puzzle (:year 2024 :day 6)
      (:input-binding puzzle-input)
    (multiple-value-bind (map guard)
        (input->game puzzle-input)
      (-> (loop :with active-guard := guard
                :for pos := (cdr (assoc :position active-guard))
                :while (within-bounds-p active-guard map)
                :collect pos
                :do (setf active-guard
                          (simple-guard-tick active-guard map)))
          (remove-duplicates :test #'equal)
          length
          submit-part-one))))


;; Part 2

(defun looping-guard-p (map guard)
  (loop :with visited := (make-array (array-dimensions map) :initial-element nil)
        :with loop-guard := guard
        :for (x . y) := (cdr (assoc :position loop-guard))
        :for dir := (cdr (assoc :direction loop-guard))
        :while (within-bounds-p loop-guard map)
        :do (format t "~&@ ~a, ~a -> ~a~%" x y dir)
        :if (find dir (aref visited y x))
          :return t
        :do (setf (aref visited y x)
                  (cons dir (aref visited y x))
                  loop-guard
                  (simple-guard-tick loop-guard map))))


(defmacro place-temp-obstacle ((map x y) &body body)
  (let ((temp-sym (gensym)))
    `(let ((,temp-sym (aref map ,y ,x)))
       (setf (aref map ,y ,x) #\#)
       (unwind-protect
            (progn
              ,@body)
         (setf (aref map ,y ,x) ,temp-sym)))))


;; (multiple-value-bind (map guard)
;;     (input->game "#.###
;; #...#
;; #^..#
;; #...#
;; #####")
;;   (place-temp-obstacle (map 1 0)
;;     (looping-guard-p map guard)))


(defun part-two ()
  (with-puzzle (:year 2024 :day 6)
      (:input-binding puzzle-input)
    (submit-part-two
     (multiple-value-bind (map guard)
         (input->game puzzle-input)
       (loop :with visited := (make-array (array-dimensions map) :initial-element nil)
             :with active-guard := guard
             :for pos := (cdr (assoc :position active-guard))
             :for dir := (cdr (assoc :direction active-guard))
             :for alt-dir := (rotate-90 dir)
             :count (->> (loop :for alt-pos := pos :then (move alt-pos alt-dir)
                               :for (x . y) := alt-pos
                               :while (and (within-bounds-p (make-guard x y) map)
                                           (can-move-p (make-guard x y alt-dir) map))
                               :append (aref visited y x))
                         remove-duplicates
                         (find alt-dir))
             :while (within-bounds-p active-guard map)
             :do (setf (aref visited (cdr pos) (car pos))
                       (cons dir (aref visited (cdr pos) (car pos)))
                       active-guard
                       (simple-guard-tick active-guard map)))))))

;; TODO: I think we need to write a crawler that determines if it is
;; stuck in a loop or not. For each step of the normal path, with spin
;; off a crawler starting in this position that tests for a looping
;; path. If it finds one, it yeilds successfully.
