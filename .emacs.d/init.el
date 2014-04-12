;; おまじない
(require 'cl)

;; スタートアップメッセージの非表
(setq inhibit-startup-screen t)

;; user-emacs-directory 変数定義(バージョン23以前)
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; add-to-load-path 関数の定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; add-to-load-path 関数にディレクトリを追加
(add-to-load-path "elisp" "conf" "public_repos")

;; "C-m" に newline-and-indent を設定
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; "C-c l" に toggle-truncate-lines を設定
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t" に other-window を設定
(define-key global-map (kbd "C-t") 'other-window)

;; "M-k" でカレントバッファを閉じる
(define-key global-map (kbd "M-k") 'kill-this-buffer)

;; exec-path にパスを追加
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")

;; 言語設定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; ファイル名の設定(OS X)
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; menu-bar を非表示
(menu-bar-mode 0)

;; カラム番号の表示
(setq column-number-mode t)

;; ファイルサイズの表示
(setq size-indication-mode t)

;; カーソル前の文字を1文字消す
(global-set-key "\C-h" 'delete-backward-char)

;; リージョン内の行数と文字数をモードラインに表示
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines, %d chars "
	      (count-lines (region-beginning) (region-end))
	      (- (region-end) (region-beginning)))
    ""))
(add-to-list 'default-mode-line-format
	     '(:eval (count-lines-and-chars)))

;; hl-line-mode の設定
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
     (((class color) (background light))
      (:background "LightGoldenrodYellow" t))
     (t (:bold t)))
    "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; paren-mode の設定
(setq show-paren-delay 0)
(show-paren-mode t)
;(setq show-paren-style 'expression)
;(set-face-background 'show-paren-match-face nil)
;(set-face-underline-p 'show-paren-match-face "yellow")

;; ファイルが #! から始まるとき、+x を付け保存する
(add-hook 'after-save-hook
	  'executable-make-buffer-file-executable-if-script-p)

;; elisp-mode-hooks 関数定義
(defun elisp-mode-hooks ()
  "elisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-elay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;; elisp-mode-hooks 関数にセット
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)
;(add-hook 'lisp-interaction-mode-hook 'elisp-mode-hooks)

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-'") 'redo))

;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-input-idle-delay 0.2
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet)

  ;; anything-config
  (when (require 'anything-config nil t)
    (setq anything-su-or-sudo "sudo"))

  ;; anything-match-plugin
  (require 'anything-match-plugin nil t)
  (and (equal current-language-environment "Japanese")
       (executable-find "cmigemo")

       ;; anything-migemo
       (require 'anything-migemo nil t))

  ;; anything-complete
  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150))

  ;; anything-show-completion
  (require 'anything-show-completion nil t)

  ;; auto-install
  (when (require 'auto-install nil t)

    ;; anything-auto-install
    (require 'anything-auto-install nil t))

  ;; descbinds-anything
  (when (require 'descbinds-anything nil t)
    (descbinds-anything-install))

  ;; anything-grep
  (require 'anything-grep nil t)
  (define-key global-map (kbd "s-f") 'anything)
  (define-key global-map (kbd "s-y") 'anything-show-kill-ring)

    ;; anything-for-document
    (setq anything-for-document-sources
	  (list anything-c-source-man-pages
		anything-c-source-info-cl
		anything-c-source-info-pages
		anything-c-source-info-elisp
		anything-c-source-apropos-emacs-commands
		anything-c-source-apropos-emacs-functions
		anything-c-source-apropos-emacs-variables))
    (defun anything-for-document ()
      "Preconfigured `anything' for anything-for-document."
      (interactive)
      (anything anything-for-document-sources (thing-at-point 'symbol) nil nil nil "*anything for document*"))
    (define-key global-map (kbd "s-d") 'anything-for-document)

    ;; (install-elisp "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
    (when (require 'anything-c-moccur nil t)
      (setq
       anything-c-moccur-anything-idle-delay 0.1
       anything-c-moccur-higligt-info-line-flag t
       anything-c-moccur-enable-auto-look-flag t
       anything-c-moccur-enable-initial-pattern t)
      (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))
    )

;; auto-complete-config
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
	       "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; (install-elisp "http://www.emacswiki.org/emacs/download/color-moccur.el")
(when (require 'color-moccur nil t)
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (when (and (executable-find "cmigemo")
	     (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; (install-elisp "http://www.emacswiki.org/emacs/download/moccur-edit.el")
(require 'moccur-edit nil t)

;; (install-elisp "http://www.emacswiki.org/emacs/wgrep.el")
(require 'wgrep nil t)

;; (install-elisp "http://www.emacswiki.org/emacs/download/grep-edit.el")
(require 'grep-edit)

;; (install-elisp "http://cx4.org/pub/undohist.el")
(when (require 'undohist nil t)
  (undohist-initialize))

;; (install-elisp "http://dr-qubit.org/undo-tree/undo-tree.el")
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/point-undo.el")
(when (require 'point-undo nil t)
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo))

;; cua-mode の設定
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; HTMLの編集を html-mode -> nxml-mode に変更
(add-to-list 'auto-mode-alist '("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . nxml-mode))
(setq nxml-slash-auto-complete-flag t)
(setq nxml-bind-meta-tab-to-complete-flag t)
(add-to-list 'ac-modes 'nxml-mode)
(setq nxml-child-indent 4)
(setq nxml-attribute-indent 4)

;; git clone git://github.com/hober/html5-el.git
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-location-files "~/.emacs.d/public_repos/html5-el/schemas.xml"))
(require 'whattf-dt)

;; (install-elisp "http://www.garshol.priv.no/download/software/css-mode/css-mode.el")
(defun css-mode-hooks ()
  "css-mode hooks"
  (setq cssm-indent-function #'cssm-c-style-indenter)
  (setq cssm-ident-level 4)
  (setq-default indent-tabs-mode nil)
  (setq cssm-newline-before-closing-bracket ))
(add-hook 'css-mode-hook 'css-mode-hooks)

;; (package-install "js2-mode")
(defun js-indent-hook ()
  (setq js-indent-level 2
	js-expr-indent-offset 2
	indent-tabs-mode nil)
  (defun my-js-indent-line ()
    (interactive)
    (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
	   (offset (- (current-colum) (current-indentation)))
	   (indentation (js--proper-identation parse-status)))
      (back-to-indentation)
      (if (looking-at "case\\s-")
	  (indent-line-to (+ indentation 2))
	(js-indent-line))
      (when (> offset 0) (forward-char offset))))
  (set (make-local-variable 'indent-line-function) 'my-js-indent-line))
(add-hook 'js-mode-hook 'js-indent-hook)

;; git clone git://github.com/ejmr/php-mode.git
(when (require 'php-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode))
  (setq php-search-url "http://jp.php.net/ja/")
  (setq php-manual-url "http://jp.php.net/manual/ja/"))
(defun php-indent-hook ()
  (setq c-basic-offset 4)
  (setq c-tab-width 4)
  (setq c-indent-level 4)
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (c-set-offset 'argList-intro '+)
  (c-set-offset 'arglist-close 0))
(add-hook 'php-mode-hook 'php-indent-hook)

;; git clone git://github.com/imakado/php-completion.git
(defun php-completion-hook ()
  (when (require 'php-completion nil t)
	(php-completion-mode t)
	(define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
	(when (require 'auto-complete nil t)
	  (make-variable-buffer-local 'ac-sources)
	  (add-to-list 'ac-sources 'ac-source-php-completion)
	  (auto-complete-mode t))))
(add-hook 'php-mode-hook 'php-completion-hook)

;; gtags-mode のキーバインド有効化
(setq gtags-suggested-key-mapping t)
(require 'gtags nil t)

;; hg clone ssh://hg@bitbucket.org/semente/ctags.el
(require 'ctags nil t)
(setq tags-revert-without-query t)
(setq ctags-command "ctags -R  --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

;; (auto-install-from-emacswiki "anything-gtags.el")
;; (auto-install-from-emacswiki "anything-exuberant-ctags.el")
(when (and (require 'anything-exuberant-ctags nil t)
	   (require 'anything-gtags nil t))
  (setq anything-for-tags
	(list anything-c-source-imenu
	      anything-c-source-gtags-select
	      anything-c-source-exuberant-ctags-select
	      ))
  (defun anything-for-tags ()
    "Preconfigured `anuthing' for anything-for-tags."
    (interactive)
    (anything anything-for-tags
	      (thing-at-point 'symbol)
	      nil nil nil "*anything for tags*"))
  (define-key global-map (kbd "M-t") 'anything-for-tags))

;; (auto-install "http://raw.github.com/byplayer/egg/master/egg.el")
;; (auto-install "http://raw.github.com/byplayer/egg/master/egg-grep.el")
(when (executable-find "git")
  (require 'egg nil t))

;; カーソル位置のファイルを開く
(ffap-bindings)

;; ELPA の設定
(when (require 'package nil t)
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.milkbox.net/packages/"))
  (add-to-list 'package-archives
	       '("ELPA" . "http://tromey.com/elpa/"))
  (package-initialize))

;; (package-install "web-mode")
(when (require 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
)
