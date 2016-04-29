(in-package #:scrap-gumtree)

(defparameter *url-base* "http://www.gumtree.pl/s-nieruchomosci/krakow/")
(defparameter *url-suffix* "/v1c2l3200208q0p1")

(defun make-search-url (search-terms)
  (let ((terms (substitute #\+ #\Space search-terms)))
    (format nil "~A~A~A" *url-base* terms *url-suffix*)))

(defun fetch-site (url)
  (drakma:http-request url))

(defun parse-site-contents (url)
  (chtml:parse (fetch-site url)
               (cxml-dom:make-dom-builder)))

(defun get-ad-elements (dom)
  (css:query "li.result div.container" dom))

(defun process-ad (ad)
  (let ((title (node-text (css:query1 "div.title a" ad)))
        (description (node-text (css:query1 "div.description" ad)))
        (price (node-text (css:query1 "div.price" ad))))
    (list title description price)))

(defun get-results (search)
  (mapcar #'process-ad
          (get-ad-elements (parse-site-contents (make-search-url search)))))
