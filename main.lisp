(in-package #:scrap-gumtree)

(defparameter *url-base* "http://www.gumtree.pl/s-nieruchomosci/krakow/")
(defparameter *url-suffix* "/v1c2l3200208q0p1")

(defvar *acceptor* nil)

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



(hunchentoot:define-easy-handler (say-yo :uri "/rss") (search)
  (setf (hunchentoot:content-type*) "text/xml")
  (make-rss (get-results search) search))


(defun start-rss-service (port)
  (setf *acceptor* (hunchentoot:start
                    (make-instance 'hunchentoot:easy-acceptor
                                   :port port))))

(defun stop-rss-service ()
  (hunchentoot:stop *acceptor*))


(defun make-rss (data search)
  (with-output-to-string (stream)
    (xml-emitter:with-rss2 (stream)
      (xml-emitter:rss-channel-header "Gumtree scraping" "http://example.com/"
                                      :description (concatenate 'string
                                                                "Results for "
                                                                search))
      (mapcar (lambda (item)
                (xml-emitter:rss-item (first item)
                                      :description (second item)
                                      :author (third item))) data))))
