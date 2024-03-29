(cl:in-package #:ecliptic)

;;;; I apologize for the choice of variable names.  I wrote this code
;;;; as a direct translation of a formula I found on the Internet, and
;;;; that formula had these names in it, without any further
;;;; explanation.  I may try to improve on these choices if I find a
;;;; formula with better variable names.


(defun sind (angle)
  (sin (/ (* angle pi) 180)))

(defun cosd (angle)
  (cos (/ (* angle pi) 180)))

(defun day-of-year (day month year)
  (let ((N1 (floor (/ (* 275 month) 9)))
        (N2 (floor (/ (+ month 9) 12)))
        (N3 (1+ (floor (/ (+ (- year (* 4 (floor (/ year 4)))) 2) 3)))))
    (- (+ (- N1 (* N2 N3)) day) 30)))

(defparameter *house-latitude* 44.81472612323331)
(defparameter *house-longitude* -0.6425042274500825)

(defun ecliptic-aux (day-of-year latitude longitude zenith localoffset)
  (let* ((longitude-in-hours  (/ (* longitude 24) 360))
         (Tr (+ day-of-year (/ (- 6 longitude-in-hours) 24)))
         (Ts (+ day-of-year (/ (- 18 longitude-in-hours) 24)))
         (Mr (- (* 0.9856 Tr) 3.289))
         (Ms (- (* 0.9856 Ts) 3.289))
         (Lr (+ Mr
                (* 1.916 (sind Mr))
                (* 0.020 (sind (* 2 Mr)))
                282.634))
         (Lr (cond ((< Lr 0) (+ Lr 360))
                   ((> Lr 360) (- Lr 360))
                   (t Lr)))
         (Ls (+ Ms
                (* 1.916 (sind Ms))
                (* 0.020 (sind (* 2 Ms)))
                282.634))
         (Ls (cond ((< Ls 0) (+ Ls 360))
                   ((> Ls 360) (- Ls 360))
                   (t Ls)))
         (RAr (/ (* (atan (* 0.91764 (tan (/ (* Lr pi) 180)))) 180) pi))
         (RAr  (cond ((< RAr 0) (+ RAr 360))
                     ((> RAr 360 (- RAr 360)))
                     (t RAr)))
         (RAs (/ (* (atan (* 0.91764 (tan (/ (* Ls pi) 180)))) 180) pi))
         (RAs  (cond ((< RAs 0) (+ RAs 360))
                     ((> RAs 360 (- RAs 360)))
                     (t RAs)))
         (Lrq (* (floor (/ Lr 90)) 90))
         (Lsq (* (floor (/ Ls 90)) 90))
         (RArq (* (floor (/ RAr 90)) 90))
         (RAsq (* (floor (/ RAs 90)) 90))
         (RAr (+ RAr (- Lrq RArq)))
         (RAs (+ RAs (- Lsq RAsq)))
         (RAr (/ RAr 15))
         (RAs (/ RAs 15))
         (sinDecr (* 0.39782 (sind Lr)))
         (sinDecs (* 0.39782 (sind Ls)))
         (cosDecr (cos (asin sinDecr)))
         (cosDecs (cos (asin sinDecs)))
         (cosHr (/ (- (cosd zenith) (* sinDecr (sind latitude)))
                   (* cosDecR (cosd latitude))))
         (cosHs (/ (- (cosd zenith) (* sinDecs (sind latitude)))
                   (* cosDecs (cosd latitude))))
         
         (Hr (/ (- 360 (/ (* (acos coshr) 180) pi)) 15))
         (Hs (/ (/ (* (acos coshs) 180) pi) 15))
         (Tr (+ Hr (- RAr (* 0.06571 Tr) 6.622)))
         (Ts (+ Hs (- RAs (* 0.06571 Ts) 6.622)))
         (UTr (- Tr longitude-in-hours))
         (UTr (cond ((< UTr 0) (+ UTr 24))
                    ((> UTr 24) (- UTr 24))
                    (t UTr)))
         (UTs (- Ts longitude-in-hours))
         (UTs (cond ((< UTs 0) (+ UTs 24))
                    ((> UTs 24) (- UTs 24))
                    (t UTs)))
         (localTr (+ UTr localoffset))
         (localTs (+ UTs localoffset)))
    (values (multiple-value-bind (hours fraction)
                (floor localTr)
              (list hours (round (* fraction 60))))
            (multiple-value-bind (hours fraction)
                (floor localTs)
              (list hours (round (* fraction 60)))))))


(defun ecliptic (day month year &key (latitude *house-latitude*) (longitude *house-longitude*) (zenith :official) (localoffset 1))
  (let ((z (ecase zenith
             (:official (+ 90 (/ 50 60)))
             (:civil 96)
             (:nautical 102)
             (:astronomical 108))))
    (ecliptic-aux (day-of-year day month year) latitude longitude z localoffset)))
         
