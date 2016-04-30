(defun scrap-demo/step-1 ()
  (global-nlinum-mode -1)
  (delete-other-windows)
  (setq org-hide-emphasis-markers t)
  (demo-it-frame-fullscreen)
  (demo-it-presentation "~/Dropbox/GTD2/projects/kraklisp-scrap.org" 2)
  (org-toggle-inline-images))

(defun scrap-demo/step-presentation ()
  (demo-it-presentation-advance))

(defun scrap-demo/step-final ()
  (demo-it-end)
  (global-nlinum-mode)
  (org-toggle-inline-images)
  (setq org-hide-emphasis-markers nil))

(defun scrap-demo/start ()
  (interactive)
  (demo-it-start (list 'scrap-demo/step-1
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-presentation
                       'scrap-demo/step-final)))

