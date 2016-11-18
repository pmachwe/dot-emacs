
;; Turn off mouse interface early in startup to avoid momentary display

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; Set up package

(require 'package)
(setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)
;(setq use-package-verbose t)

;; Load the config
(org-babel-load-file (concat user-emacs-directory "config.org"))

;; Load utility functions
(org-babel-load-file (concat user-emacs-directory "functions.org"))

;; Load the work-specific file which cannot be uploaded to Github
(defvar work-el "~/.emacs.d/work.el"
  "Work specific settings.")

(defvar work-org "~/.emacs.d/work.org"
  "Work specific settings in 'org-mode'.")

;; Load org if available or else try el
(if (file-exists-p work-org)
    (org-babel-load-file work-org)
  (if (file-exists-p work-el)
      (load-file work-el)))

;; Load non-MELPA packages
(require 'my/functions)
(my/get-git-repo "https://github.com/pmachwe/quick-search.git" "quick-search")
(my/get-git-repo "https://github.com/syohex/emacs-counsel-gtags.git" "emacs-counsel-gtags")
(my/get-git-repo "https://github.com/pmachwe/emacs-shutil.git" "emacs-shutil")

;; Move in different file later
;; shutil shortcuts
(when (require 'shutil nil 'noerror)
  (global-set-key (kbd "C-. s b") 'shutil-switch-to-buffer)
  (global-set-key (kbd "C-. s n") 'shutil-get-new-shell)
  (global-set-key (kbd "C-. s |") 'shutil-split-vertically))

(provide 'init)
;;; init.el ends here
