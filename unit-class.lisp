;;     unit-formulas - library for unit checked formula definitions
;;     Copyright (C) 2008 Jakub Higersberger

;;     This program is free software; you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation; either version 2 of the License, or
;;     (at your option) any later version.

;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.

;;     You should have received a copy of the GNU General Public License
;;     along with this program; if not, write to the Free Software
;;     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


(in-package :unit-formulas)

(defparameter *units* (make-hash-table))

(defclass unit ()
  ((factor :accessor factor-of :initform 1 :initarg :factor)
   (units :accessor units-of :initarg :units
	  :initform (make-array (length *base-units*) :initial-element 0))))

(defmethod initialize-instance :after ((unit unit) &rest initargs)
  (declare (ignore initargs))
  (when (typep (factor-of unit) 'single-float)
   (setf (factor-of unit) (float (rationalize (factor-of unit)) 0d0))))

(defmethod print-object ((unit unit) stream)
  (print-unreadable-object (unit stream :type t :identity nil)
    (let ((unit-description
	   (with-output-to-string (str)
	     (format str "~a " (factor-of unit))
	     (print-unit-vector (units-of unit) str))))
      (format stream "~a" unit-description))))

(defmethod make-load-form ((unit unit) &optional environment)
  (declare (ignore environment))
  `(make-instance 'unit :factor ,(factor-of unit)
		        :units ,(units-of unit)))
