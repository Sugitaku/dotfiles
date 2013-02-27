;; 日本語設定
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8) ; emacs 23 対応

;; php-mode
(load-library "php-mode")
(require 'php-mode)
(add-hook 'php-mode-hook '(lambda ()
    (setq c-basic-offset 4)
    (setq c-tab-width 4)
    (setq c-indent-level 4)
    (setq tab-width 4)
    (setq indent-tabs-mode t)
    (setq-default tab-width 4)
))

;; smarty-mode
(autoload 'smarty-mode "smarty-mode")
(setq auto-mode-alist
    (cons '("\\.tpl\\'" . smarty-mode) auto-mode-alist))

;; js2-mode
(autoload 'js2-mode "js2")
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; css-mode
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
    (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)

;; mmm-mode
;;(require 'mmm-auto)
;;(setq mmm-global-mode 'maybe)
;;(mmm-add-classes
;; '((embedded-css
;;    :submode css-mode
;;    :front "<style[^>]*>"
;;    :back "</style>")))
;;(mmm-add-mode-ext-class nil "\\.html\\'" 'embedded-css)

;; org-mode
(autoload 'org-mode "org")
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; flymake-mode
;;(require 'flymake)

;; csharp-mode
;;(autoload 'csharp-mode "csharp-mode")
;;(setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))
