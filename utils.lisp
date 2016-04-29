(in-package #:scrap-gumtree)

(defun strip-whitespace (str)
  ;;remove initial whitespace
  (setf str (cl-ppcre:regex-replace "^\\s+" str ""))
  ;;remove trailing whitespace
  (setf str (cl-ppcre:regex-replace "\\s+$" str ""))
  
  ;;remove initial/trailing whitespace in multiline mode
  (setf str (cl-ppcre:regex-replace-all "(?m)^[^\\S\\r\\n]+|[^\\S\\r\\n]+$" str ""))
  (setf str (cl-ppcre:regex-replace-all "(?m)[^\\S\\r\\n]+\\r$" str (make-string 1 :initial-element #\Return)))
  
  ;;replace more than two whitespaces with one
  (setf str (cl-ppcre:regex-replace-all "[^\\S\\r\\n]{2,}" str " "))
  
  ;;remove solitary linebreaks
  (setf str (cl-ppcre:regex-replace-all "([^\\r\\n])(\\r\\n|\\n)([^\\r\\n])" str '(0 " " 2)))
  
  ;;replace more than one linebreak with one
  (setf str (cl-ppcre:regex-replace-all "(\\r\\n|\\n){2,}" str '(0)))
  str)

(defun node-text (node &rest args &key test (strip-whitespace t))
  (let (values result)
    (when (or (not test) (funcall test node))
      (dom:do-node-list (node (dom:child-nodes node))
        (let ((val (case (dom:node-type node)
                     (:element (apply #'node-text node args))
                     (:text (dom:node-value node)))))
          (push val values))))
    (setf result (apply #'concatenate 'string (nreverse values)))
    (if strip-whitespace (strip-whitespace result) result)))
