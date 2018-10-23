;;; go.el --- Go rleated setup                       -*- lexical-binding: t; -*-

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
(use-package go-mode
  :ensure t
  :mode (("\\.go\\'" . go-mode))
  :hook ((before-save . gofmt-before-save))
  :config
  (setq gofmt-command "goimports")
  (use-package company-go
    :ensure t
    :config
    (add-hook 'go-mode-hook (lambda()
                              (add-to-list (make-local-variable 'company-backends)
                                           '(company-go company-files company-yasnippet company-capf))))
    )
  (use-package go-eldoc
    :ensure t
    :hook (go-mode . go-eldoc-setup)
    )
  (use-package go-guru
    :ensure t
    :hook (go-mode . go-guru-hl-identifier-mode)
    )
  (use-package go-rename
    :ensure t)
  )

;;
;; for guru setup scope
;;
(defun my/go-guru-set-current-package-as-main ()
    "GoGuru requires the scope to be set to a go package which
     contains a main, this function will make the current package the
     active go guru scope, assuming it contains a main"
    (interactive)
    (let* ((filename (buffer-file-name))
           (gopath-src-path (concat (file-name-as-directory (go-guess-gopath)) "src"))
           (relative-package-path (directory-file-name (file-name-directory (file-relative-name filename gopath-src-path)))))
      (setq go-guru-scope relative-package-path)))




(provide 'go)
;;; go.el ends here
