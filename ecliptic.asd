(cl:in-package #:asdf-user)

(defsystem #:ecliptic
  :serial t
  :components
  ((:file "packages")
   (:file "ecliptic")))
