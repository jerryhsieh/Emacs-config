;;; package --- Summary
;;
;;; Commentary:
;;;
;;; Code:

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))


(package-initialize)

(load-theme 'manoj-dark t)
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
(when (file-exists-p custom-file)
    (load custom-file))


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
         ))

;;
;; ivy mode
;;
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 10)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order)))
  )

;;
;; counsel
;;
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

;;
;; swiper
;;
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper))
  )

;;
;; yasnippet
;;
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t)
  )

;;
;; company
;;
(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-backends
        '((company-files
           company-keywords
           company-capf
           company-yasnippet
           )
          (company-abbrev company-dabbrev))))

(add-hook 'emacs-lisp-mode-hook (lambda () (set (make-local-variable 'company-backends) '(company-elisp))))


;;
;; change C-n C-p
;;
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil))


;;
;; change company complete common
;;
(advice-add 'company-complete-common :before (lambda () (setq my-company-point (point))))
(advice-add 'company-complete-common :after (lambda () (when (equal my-company-point (point))
                                                         (yas-expand))))


;;
;; flycheck
;;

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  )

;;
;; magit
;;
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))
  )


;;
;; projectile
;;
(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t)
  )


(use-package ag
  :ensure t)


;;
;; auto insert
;;
(defun my/autoinsert-yas-expand()
  "auto insert yasnippet"
  (yas-expand-snippet (buffer-string) (point-min) (point-max))
  )

(use-package autoinsert
  :ensure t
  :config
  (setq auto-insert-query nil)
  (setq auto-insert-directory (locate-user-emacs-file "templates"))
  (add-hook 'find-file-hook 'auto-insert)
  (auto-insert-mode t)
  (define-auto-insert "\\.org\\'" ["default-org.org" my/autoinsert-yas-expand])
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                c/c++                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "~/.emacs.d/custom/c.el")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                python               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/python.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 web                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/web.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                  go                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/go.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 org                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/org.el")

(provide 'init)
;;; init.el ends here

