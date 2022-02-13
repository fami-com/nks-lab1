;;;; nks-lab1.lisp

(in-package #:nks-lab1)

(defun time-average (hours)
  (a:mean hours))

(defun time* (gamma hours)
  (let* ((interval-length (/ (- (a:lastcar hours) (car hours)) 10))
         (ten-intervals (mapcar
                         (lambda (i)
                           (remove-if-not
                            (lambda (a)
                              (<= (* i interval-length)
                                  a
                                  (* (1+ i) interval-length)))
                            hours))
                         (a:iota 10)))
         (stat-densities (mapcar (lambda (i)
                                   (/ (length i)
                                      (* (length hours) interval-length)))
                                 ten-intervals))
         (ps (let ((area-sum 1))
               (mapcar (lambda (i)
                         (prog1 area-sum
                           (decf area-sum (* i interval-length))))
                       stat-densities)))
         (p-lt (apply #'max
                      (remove-if-not (lambda (p)
                                       (< p gamma))
                                     ps)))
         (p-gt (apply #'min
                      (remove-if-not (lambda (p)
                                       (> p gamma))
                                     ps))))
    (list
     (+ (position p-gt ps)
        (* interval-length
           (/ (- p-gt gamma)
              (- p-gt p-lt))))
     interval-length
     stat-densities)))

(defun p-unfail (time interval-length stat-densities)
  (let ((sum 1)
        (whole-intervals (floor time interval-length)))
    (mapc (lambda (i)
            (decf sum (* i interval-length)))
          stat-densities)
    (decf sum (* (elt stat-densities whole-intervals)
                 (mod time interval-length)))
    (- sum)))

(defun fail-frequency (time interval-length stat-densities)
  (let ((f (elt stat-densities (floor time interval-length)))
        (p (p-unfail time interval-length stat-densities)))
    (+ (/ f p))))

(defun run ()
  (let* ((hours (list 189 833 733 219 137 1542 164 261 380 82 1668 1282 472 279 1128 1715 206 826 255
                      1528 353 296 1267 215 58 346 618 562 341 1742 70 154 224 1038 41 1438 405 415
                      89 368 283 338 444 566 206 2111 398 878 1766 128 859 2853 23 1427 1025 551 552
                      69 482 269 377 100 419 817 609 1581 1468 22 587 58 2313 104 122 154 493 91 1591
                      447 15 101 1661 189 524 265 370 221 1149 448 1175 7 318 2084 156 558 91 432 773
                      406 2088 83))
         (sorted-hours (sort (copy-list hours) #'<))
         (gamma 98/100)
         (faultless-time 414)
         (intense-time 2077)
         (time-report (time* gamma sorted-hours))
         (time-value (first time-report)))
    (format t "Середній наробіток до відмови (Tср): ~a ~:*(~f)~%~
             γ-відсотковий наробіток на відмову (Tγ) при γ = ~a ~:*(~f): ~a ~:*(~f)~%~
             Ймовірність безвідмовної роботи на час ~a годин: ~a ~:*(~f)~%~
             Інтенсивність відмов на час ~a годин: ~a ~:*(~f)~%"
            (time-average hours)
            gamma time-value
            faultless-time (apply #'p-unfail time-report)
            intense-time (apply #'fail-frequency time-report))))
