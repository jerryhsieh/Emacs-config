;;; ruby.el --- ruby related                         -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Jerry Hsieh

;; Author: Jerry Hsieh <jerryhsieh@Jerryde-MacBook-Pro.local>
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

;; (defvar my-ruby-close-brace-goto-close t)

;; (defun my-ruby-close-brace ( )
;;   "replacement for ruby-electric-brace for the close brace"
;;   (interactive)
;;   (let ((p (point)))
;;     (if my-ruby-close-brace-goto-close
;;         (unless (search-forward "}" nil t)
;;           (message "No close brace found")
;;           (insert "}"))
;;       (insert "}")
;;       (save-excursion (if (search-forward "}" nil t)
;;                           (delete-char -1))))))

(use-package ruby-mode
  :ensure t
  :mode ("\\.rb\\'" "Rakefile\\'" "Gemfile\\'" "Berksfile\\'" "Vagrantfile\\'")
  :interpreter "ruby"
  :bind (:map ruby-mode-map
              ("}" . my-ruby-close-brace)
              ("\C-c r a" . rvm-activate-corresponding-ruby)
              ("\C-c r r" . inf-ruby))
  :config
  (use-package rvm
    :ensure t
    :config
    (rvm-use-default))
  (add-hook 'ruby-mode-hook (lambda ()
                              (add-to-list (make-local-variable 'company-backends)
                                           '(company-robe))))
  )

(use-package inf-ruby
  :ensure t
  :hook (ruby-mode . inf-ruby-minor-mode)
  :config
  )

;;
;; ruby electric mode
;;
(use-package ruby-electric
  :ensure t
  :hook (ruby-mode . ruby-electric-mode)
  )

;;
;; robe
;;
(use-package robe
  :ensure t
  :hook (ruby-mode . robe-mode)
  :bind ("C-M-." . robe-jump)
  :config
  (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
    (rvm-activate-corresponding-ruby))
  )




;;
;; flycheck with rubocop
;;
(use-package rubocop
  :ensure t
  :hook (ruby-mode . rubocop-mode)
  ;;:diminish rubocop-mode
  )

;;
;; projectile
;;
(use-package projectile-rails
  :ensure t
  :hook (projectile-mode . projectile-rails-on)
  )

;;
;; auto formatter
;;
(use-package rufo
  :ensure t
  :hook (ruby-mode . rufo-minor-mode)
  )


(provide 'ruby)
;;; ruby.el ends here
