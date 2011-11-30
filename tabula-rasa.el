;;; tr-mode.el - Distraction free editing mode

(defcustom tr-width 80
  "Width of writing space."
  :type 'integer
  :group 'tabula-rasa
  :set (lambda (symbol value)
         (progn (setq tr-width value)
                (tr-update-window)))
  :initialize 'custom-initialize-default)


(defface tabula-rasa
  '((t (
     :family "IM FELL English Pro"
     :foreground "black"
     :background "ivory"
     :height 120
    )))
  "Face for tabula-rasa mode."
  :group 'tabula-rasa)

(defun tr-update-window()
  (cond 
   ((or (one-window-p t nil) (window-full-width-p))
    (set-window-margins tr-window
                        (/ (- (frame-width) tr-width) 2)              
                        (/ (- (frame-width) tr-width) 2)))
   (t
    (set-window-margins tr-window 0 0)
    (set-window-margins (next-window) 0 0))))

(setq tr-mode-enabledp nil)

(defun tr-mode ()
  (interactive)
  (cond 
   (tr-mode-enabledp (tr-mode-disable))
   (t (tr-mode-enable))))

(defun tr-mode-enable()
  (interactive)
  (setq tr-frame (make-frame `(
                              (fullscreen . fullboth)
                              (unsplittable . t)
                              (vertical-scroll-bars . nil)
                              (left-fringe . 0)
                              (right-fringe . 0)
                              (tool-bar-lines . 0)
                              (menu-bar-lines . 0)
                              (line-spacing . 5)
                              (font . ,(face-font "tabula-rasa"))
                              (foreground-color . ,(face-attribute 'tabula-rasa :foreground))
                              (background-color . ,(face-attribute 'tabula-rasa :background))
                              )))

  (setq tr-window (frame-selected-window tr-frame))

  (set-window-dedicated-p tr-window t)
  (add-hook 'window-configuration-change-hook 'tr-update-window t nil)

  (tr-update-window)

  (setq tr-mode-enabledp t)
  (message (format "tr mode enabled on %s" (selected-frame)))
)

(defun tr-mode-disable()
  (interactive)
  (delete-frame tr-frame)
  (remove-hook 'window-configuration-change-hook 'tr-update-window)
  (setq tr-mode-enabledp nil)
  (message (format "tr mode disabled on %s" (selected-frame)))
)

;;;;;;;;;;;;;;;;; end ;;;;;;;;;;;;;;;;;

(provide 'tr-mode)

;; todo: why doesn't tr.el load?
