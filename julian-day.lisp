(cl:in-package #:ecliptic)

;;; The Julian Day number, or Julian Day is a count of days and
;;; fractions of days from the beginning of the year -4712.

;;; The formula used here is taken from Astronomical Algorithms by
;;; Jean Meeus.  It has been tested against the table given in chapter
;;; 7 of that book.

;;; YEAR is the integer representing the year.  MONTH is the integer
;;; given as 1 for January, etc.  DAY is the day of the month and it
;;; can be have a fractional part.
(defun julian-day (year month day)
  (flet ((aux (year month day)
           (let* (;; The value of B should be 0 when the Julian
                  ;; calendar is used, but we use the Gregorian
                  ;; calendar.  The value A represents the number of
                  ;; years that are multiple of 100.
                  (a (floor year 100))
                  ;; The form (FLOOR A 4) represents the number of
                  ;; years that are leap years because the year is a
                  ;; multiple of 400.  I am not sure where the 2 comes
                  ;; from.
                  (b (+ 2 (- a) (floor a 4))))
             ;; Remaining leap years that are multiples of 4 are taken
             ;; into account by the fraction 0.25 which is valid both
             ;; for the Julian and the Gregorian calendars.
             (+ (floor (* 365.25d0 (+ year 4716)))
                ;; The value 30.6 is roughly the average number of
                ;; days in a month if February is excluded from the
                ;; calculation, so (float (/ (- 365 28) 11)) =>
                ;; 30.636...
                (floor (* 30.6001d0 (1+ month)))
                day
                b
                -1524.5d0))))
    (if (> month 2)
        (aux year month day)
        ;; January and February are considered to be the 13th and 14th
        ;; months of the previous year, respectively.
        (aux (1- year) (+ month 12) day))))
