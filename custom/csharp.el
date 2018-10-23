;;; csharp.el --- Csharp related                     -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Jerry Hsieh

;; Author: Jerry Hsieh <jerryhsieh@Jerryde-MacBook-Pro.local>
;; Keywords: languages, c

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

(use-package csharp-mode
  :ensure t)


(use-package omnisharp
  :ensure t
  :hook ((csharp-mode . omnisharp-mode)
         (before-save . omnisharp-code-format-entire-file))
  :config
  (add-hook 'omnisharp-mode-hook (lambda()
                                   (add-to-list (make-local-variable 'company-backends)
                                                '(company-omnisharp))))
  )

(provide 'csharp)
;;; csharp.el ends here
