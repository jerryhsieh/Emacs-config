(use-package org
:ensure t
:mode (("\\.org\\'" . org-mode)
       ("\\.txt\\'" . org-mode))
:config
(global-set-key (kbd "\C-c l")  'org-store-link)
(global-set-key (kbd "\C-c a")  'org-agenda)
(global-set-key (kbd "\C-c c")  'org-capture)
(setq org-hide-leading-stars t)
(setq org-src-fontify-natively t)
(setq org-log-done 'time)
(use-package org-download
:ensure t
)
(use-package org-bullets
:ensure t
:hook (org-mode . org-bullets-mode)
)
(org-babel-do-load-languages 'org-babel-load-languages 
'((shell . t)
  (python . t)
  (ruby . t)
  (sqlite . t)
  (C . t)
  (js . t)
  (emacs-lisp . t)
  (lisp . t)
  (latex . t)
  (java . t)
))
)

(setq default-notes-file (concat org-directory "/notes.org"))
(setq org-agenda-files (list "~/org/gtd.org"
                             "~/org/blog.org"
                             "~/org/gcal.org"
                             "~/org/journal.org"))
(setq org-capture-templates 
'(("t" "Todo" entry (file+headline "~/org/gtd.org" "Task") "* TODO %?\n %i \n %a")
("j" "Journal" entry (file+olp+datetree "~/org/journal.org") "* %?\nEntered on %U\n %i\n %a")
("b" "Blog" entry (file+headline "~/org/blog.org" "Blog") "* %?\n%T")
("a" "Appointment" entry (file "~/org/gcal.org") "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
))

(use-package htmlize
:ensure t
)

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))

(use-package ox-reveal
:ensure t
)

(setq org-file-apps '((auto-mode . emacs)
                      ("\\.pdf\\'" . "evince %s")
))

(defvar use-font (cond 
 ((eq system-type 'gnu/linux) "{Noto Sans TC Regular}")
  ((eq system-type 'darwin) "{PingFang TC}")))

(setq org-latex-classes (list (list "article" (format "
     \\documentclass[12pt,a4paper]{article}
     \\usepackage{xeCJK}
     \\setCJKmainfont%s
     \\setCJKsansfont%s
     \\setCJKmonofont%s
     " use-font use-font use-font))))
