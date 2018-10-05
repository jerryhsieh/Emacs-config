;;; web.el --- Web related setup                     -*- lexical-binding: t; -*-

;; Copyright (C) 2018  vagrant

;; Author: vagrant <vagrant@node1.onionstudio.com.tw>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
(use-package web-mode
  :ensure t
  :mode ("\\.html\\'" "\\.vue\\'" "\\.jsx\\'")
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-css-colorization t)
  (set-face-attribute 'web-mode-html-tag-face nil :foreground "royalblue")
  (set-face-attribute 'web-mode-html-attr-name-face nil :foreground "powderblue")
  (set-face-attribute 'web-mode-doctype-face nil :foreground "lightskyblue")
  (setq web-mode-content-types-alist
        '(("vue" . "\\.vue\\'")
          ("jsx" . "\\.jsx\\'")
          ))
  (use-package company-web
    :ensure t
    :config
    (add-hook 'web-mode-hook (lambda ()
                               (cond ((equal web-mode-content-type "html")
                                      (my/web-html-setup))
                                     ((equal web-mode-content-type "vue")
                                      (my/web-vue-setup))
                                     ((equal web-mode-content-type "jsx")
                                      (my/web-jsx-setup))
                                     )))
    )
  )

;;
;; html
;;
(defun my/web-html-setup()
  "Setup for web-mode html files."
  (flycheck-add-mode 'html-tidy 'web-mode)
  (flycheck-select-checker 'html-tidy)
  (add-to-list (make-local-variable 'company-backends)
               '(company-web-html company-files company-css company-capf company-dabbrev))
  (add-hook 'before-save-hook #'sgml-pretty-print)

  )

;;
;; vue
;;
(defun my/web-vue-setup()
  "Setup for vue related."
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (my/use-eslint-from-node-modules)
  (flycheck-select-checker 'javascript-eslint)
  (flycheck-mode)
  (add-hook 'web-mode-hook #'setup-tide-mode)
  (add-hook 'web-mode-hook #'prettier-js-mode)
  )

;;
;; jsx
;;
(defun my/web-jsx-setup()
  "Setup for jsx related."
  )



;;
;; eslint use local
;;
(defun my/use-eslint-from-node-modules()
  "Use local eslint from node_modules before global."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js" root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 css                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package css-mode
  :ensure t
  :mode "\\.css\\'"
  :config
  (add-to-list (make-local-variable 'company-backends)
               '(company-css company-files company-yasnippet company-capf))
  (setq css-indent-offset 2)
  (setq flycheck-stylelintrc "~/.stylelintrc")
  )


(use-package scss-mode
  :ensure t
  :mode "\\scss\\'"
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                emmet                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emmet-mode
  :ensure t
  :hook (web-mode css-mode scss-mode sgml-mode)
  :config
  (add-hook 'emmet-mode-hook (lambda()
                              (setq emmet-indent-after-insert t)))

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                  js                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.json\\'" . javascript-mode))
  :init
  (setq-default js2-basic-offset 2)
  (setq-default js2-global-externs '("module" "require" "assert" "setInterval" "console" "__dirname__") )
  )


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(add-hook 'js2-mode-hook #'setup-tide-mode)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save))
  )

(use-package prettier-js
  :ensure t
  :hook ((js2-mode . prettier-js-mode))
  :config
  (setq prettier-js-args '(
                           "--trailing-comma" "all"
                           "--bracket-spacing" "false"
                           ))
  )

(provide 'web)
;;; web.el ends here
