(org-babel-load-file
 (concat (file-name-directory user-init-file) "discoverable-emacs.org"))

(setq custom-file
      (concat (file-name-directory user-init-file) "emacs-custom.el"))

;; load modus-vivendi by default
;; TODO change to loading https://github.com/Lambda-Emacs/lambda-themes faded light by default
(load-theme 'modus-vivendi t)
