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

;;
;; org youtube embeded
;;
(defvar yt-iframe-format
;;You may want to change your width and height.
(concat "<iframe width=\"440\""
      " height=\"335\""
      " src=\"https://www.youtube.com/embed/%s\""
      " frameborder=\"0\""
      " allowfullscreen>%s</iframe>"))
(org-add-link-type
"yt"
(lambda (handle)
  (browse-url
    (concat "https://www.youtube.com/embed/" handle)))
(lambda (path desc backend)
  (cl-case backend
    (html (format yt-iframe-format path (or desc "")))
    (latex (format "\href{%s}{%s}" path (or desc "video"))))))

(use-package org2blog
:ensure t
:requires org
:init
(setq org2blog/wp-blog-alist
       '(("wordpress"
       :url "https://jerryhsieh01.wordpress.com/xmlrpc.php"
       :username "jerryhsieh01"
       )
      ("my-blog"
       :url "https://blog.onionstudio.com.tw/xmlrpc.php"
       :username "Jerry"
       )))
 :config
 (setq org2blog/wp-use-sourcecode-shortcode t)
 (setq org2blog/wp-sourcecode-langs 
      '("sh" "cpp" "css" "js" "javascript" "perl" "php" "python" "ruby" "emacs-lisp" "lisp" "go" "lua"))
 )

(cond ((eq system-type 'gnu/linux) 
       (setq org-file-apps '((auto-mode . emacs)
                      ("\\.pdf\\'" . "evince %s")
                      ("\\.html\\'" . "chrome %s")
                      )))
       ((eq system-type 'darwin)
       (setq org-file-apps '((auto-mode .emacs)
                      ("\\.pdf\\'" . "open %s")
                      ("\\.html\\'" . "open %s")))))

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

(use-package auth-source
  :ensure t
  )
  (use-package org-gcal
  :ensure t
  :config
  (let (credentials)
    (add-to-list 'auth-sources "~/.netrc")
    (setq credentials (auth-source-user-and-password "org-gcal"))
    (setq org-gcal-client-id (car credentials)
        org-gcal-client-secret (cadr credentials)
        org-gcal-file-alist '(("jerryhsieh01@gmail.com" . "~/org/gcal.org"))
  ))
  (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
;;  (add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync) ))
  )

(use-package ox-reveal
:ensure t
)

(use-package ox-gfm
:ensure t
)
