
;; Turn off mouse interface early in startup to avoid momentary display
(defvar time-start
  "Log the starting time."
  nil)

(setq time-start (float-time))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; Set up package

(require 'package)
(setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'bind-key))

(eval-when-compile
  (require 'use-package))
;(require 'diminish)
(require 'bind-key)

;; Taken from comments on this post;
;; http://endlessparentheses.com/init-org-Without-org-mode.html
(defun my/load-el-before-org (org-file el-file)
  "If ORG-FILE is not recently changed, load the EL-FILE."
  (if (file-exists-p org-file)
      (if (and (file-exists-p el-file)
               (time-less-p (nth 5 (file-attributes org-file))
                            (nth 5 (file-attributes el-file))))
          (load-file el-file)
        (if (fboundp 'org-babel-load-file)
            (org-babel-load-file org-file)
          (message "Function not found: org-babel-load-file")
          (load-file el-file)))
    (error "Init org file '%s' missing" org-file)))

(my/load-el-before-org (concat user-emacs-directory "config.org")
                       (concat user-emacs-directory "config.el"))

(my/load-el-before-org (concat user-emacs-directory "functions.org")
                       (concat user-emacs-directory "functions.el"))

;; Load the work-specific file which cannot be uploaded to Github
(defvar work-el (concat user-emacs-directory "work.el")
  "Work specific settings.")

(defvar work-org (concat user-emacs-directory "work.org")
  "Work specific settings in 'org-mode'.")

;; Load org if available or else try el
(if (file-exists-p work-org)
    (my/load-el-before-org work-org work-el)
  (if (file-exists-p work-el)
      (load-file work-el)))

(provide 'init)

(message "Total loading time: %0.03fs"
         (float-time (time-subtract (float-time) time-start)))

;;; init.el ends here
