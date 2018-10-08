;;; c.el --- c/c++ mode                              -*- lexical-binding: t; -*-

;; Copyright (C) 2018  vagrant

;; Author: vagrant <vagrant@node1.onionstudio.com.tw>
;; Keywords: c

;;; Code:


;;
;; irony is for auto-complete, syntax checking and documentation
;;
;; You will need to install irony-server first time use
;; to install irony-server, your system need to install clang, cmake and clang-devel in advance
;;
(use-package irony
  :ensure t
  :hook ((c++-mode . irony-mode)
         (c-mode . irony-mode))
  :config
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (use-package company-irony-c-headers
    :ensure t)
  (use-package company-irony
    :ensure t
    :config
    (add-to-list (make-local-variable 'company-backends)
                 '(company-irony company-irony-c-headers)))
  (use-package flycheck-irony
    :ensure t
    :config
    (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
    )
  (use-package irony-eldoc
    :ensure t
    :config
    (add-hook 'irony-mode-hook #'irony-eldoc)
    )
  )


;;
;; rtags enable jump-to-function definition
;; system need to install rtags first
;;
;; for centos, you need llvm-devel, cppunit-devl
;; install gcc-4.9, cmake 3.1 and download rtags from github and make it
;;

(use-package rtags
  :ensure t
  :config
  (rtags-enable-standard-keybindings)
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (define-key c-mode-base-map (kbd "M-.")
    (function rtags-find-symbol-at-point))
  (define-key c-mode-base-map (kbd "M-,")
    (function rtags-find-references-at-point))
  )

;;
;; cmake-ide enable rdm(rtags) auto start and rc(rtags) to watch directory
;;
(use-package cmake-ide
  :ensure t
  :config
  (cmake-ide-setup)
  )


;;
;; for c formatting
;;
(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style-option "llvm")
  (add-hook 'c-mode-hook (lambda() (add-hook 'before-save-hook 'clang-format-buffer)))
  (add-hook 'c++-mode-hook (lambda() (add-hook 'before-save-hook 'clang-format-buffer)))
  )

(provide 'c)
;;; c.el ends here
