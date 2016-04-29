(asdf:defsystem #:scrap-gumtree
  :serial t
  :long-name "Scrapper for gumtree."
  :author "Imię Nazwisko <email>"
  :description "Scrapper for random web stuff."

  :license "MIT"

  :encoding :utf-8

  :depends-on (#:alexandria
               #:drakma
               #:cl-ppcre
               #:chtml-matcher
               #:cxml
               #:css-selectors)

  :components ((:file "package")
               (:file "utils")
               (:file "main")))
