(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)


;;
;; set autosave and backup directory
;;
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

;;
;; custome variable path
;;
(setq custom-file "~/.emacs.d/custom-variables.el")
(load custom-file)


;;
;; use use-package
;;
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(use-package diminish :ensure t)
(use-package bind-key :ensure t)

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;;
;; basic setup
;;
(menu-bar-mode -1)

(show-paren-mode t)
(electric-pair-mode t)

(setq electric-pair-pairs '(
			    (?\' . ?\')
			    ))

(setq-default indent-tabs-mode nil)

(winner-mode t)

;;
;; hideshow
;;
(add-hook 'prog-mode-hook #'hs-minor-mode)


;;
;; multiple cursors
;;
(use-package multiple-cursors
  :ensure t
  :bind (
         ("M-3" . mc/mark-next-like-this)
         ("M-4" . mc/mark-previous-like-this)
         :map ctl-x-map
         ("\C-m" . mc/mark-all-dwim)
         ("<return>" . mule-keymap)
         )
  )
