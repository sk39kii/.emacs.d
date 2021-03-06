;; -*- mode: Emacs-Lisp ; Coding: utf-8 -*-
(set-language-environment "UTF-8")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Setup package.el
;;;
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable". "http://stable.melpa.org/packages/") t)
;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

(when (not (require 'use-package nil t))
  (package-install 'use-package))

(setq use-package-always-pin "melpa-stable")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; auto-install.el
;;;
;; usage
;; M-x install-elisp URL
;; M-x install-elisp-from-emacswiki EmacsWikiのページ名
;; M-x install-elisp-from-gist gist-id
(require 'auto-install)
(auto-install-compatibility-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Emacs basic configurations
;;;

;;; mozc
(use-package mozc
  :if (eq system-type 'gnu/linux)
  :config
  (setq default-input-method "japanese-mozc")
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)
  )

;;; バックアップファイルを~/.ehistに保存する
(setq backup-directory-alist '((".*" . "~/.ehist")))

;;; 行番号、桁番号をモードラインに表示
(line-number-mode t)
(column-number-mode t)
;;; 行番号をフレームの左に表示
(use-package linum)
(global-linum-mode)
(setq linum-format "%5d ")

;;; OS Clipboard
(setq x-select-enable-clipboard t)

;;; ハイライト関連
(show-paren-mode t)
(setq show-paren-style 'mixed)

;;; 現在行のハイライト
;;(global-hl-line-mode t)

(require 'hl-line)
(defun global-hl-line-timer-function()
    (global-hl-line-unhighlight-all)
    (let ((global-hl-line-mode t))
        (global-hl-line-highlight)))
(setq global-hl-line-timer
    (run-with-idle-timer 0.1 t 'global-hl-line-timer-function))
    ;; (cancel-timer global-hl-line-timer)

;(require 'hl-line+)
;(toggle-hl-line-when-idle)
;(setq hl-line-idle-interval 3)
(set-face-background 'hl-line "color-236")

;;; ディレクトリツリー関連
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  (setq neo-show-hidden-files t)
  (setq neo-createfile-auto-open t)
  (setq neo-persist-show t))

;;; 非アクティブバッファの背景色
(use-package hiwin
  :config
  (hiwin-activate)
  (set-face-background 'hiwin-face "color-237"))

;;; whitespace
;; カーソル行の描画がずれるのでコメントアウト
;(use-package whitespace
;  :config
;  (setq whitespace-style '(face
;			   tabs
;			   space-mark
;			   tab-mark
;			   ))
;  (setq whitespace-display-mappings
;	'((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
;  (global-whitespace-mode 1))

;;; 範囲選択してdelete or backspace 
(delete-selection-mode t)

;;; タブ幅
(setq default-tab-width 4)

;;; カーソルそのままで一括インデント
(require 'point-undo)
(define-key global-map [f7] 'point-undo)
(define-key global-map [S-f7] 'point-redo)

(defun all-indent ()
  (interactive)
  (mark-whole-buffer)
  (indent-region (region-beginning)(region-end))
  (point-undo))
(bind-key "C-x C-]" 'all-indent)

;;; Global Keymap
(use-package bind-key
  :config
  (bind-keys :map global-map
	     ;; BackSpace Key
	     ("C-h" . delete-backward-char)
	     ;; 長い行の折り返し表示を切り替え
	     ("C-c l" . toggle-truncate-lines)
	     ;; フレーム間移動(標準でC-x oでも可能)
	     ("C-c <left>" . windmove-left)
	     ("C-c <down>" . windmove-down)
	     ("C-c <up>" . windmove-up)
	     ("C-c <right>" . windmove-right)
	     ;; フレーム間移動をホームポジションで
	     ("C-c h" . windmove-left)
	     ("C-c j" . windmove-down)
	     ("C-c k" . windmove-up)
	     ("C-c l" . windmove-right)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; web-mode
;;;
(require 'web-mode)

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset    2)
  (setq web-mode-css-offset     2)
  (setq web-mode-script-offset  2)
  (setq web-mode-php-offset     2)
  (setq web-mode-java-offset    2)
  (setq web-mode-asp-offset     2))
(add-hook 'web-mode-hook 'web-mode-hook)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Macosx
;;;
(when (eq system-type 'darwin)
  ;; command key -> meta
  (setq mac-command-modifier 'meta)
  ;; ミニバッファにカーソル移動時 ASCIIモード
  ;;(mac-auto-ascii-mode 1)
  ;; Font settings
  ;; フォントをインストール済みでもエラーが出る場合は、
  ;; フォントキャッシュの再作成(fc-cache -vf)
  (add-to-list 'default-frame-alist '(font . "ricty-15")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Windows
;;;
(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :family "MeiryoKe_Gothic" :height 110)
  (set-fontset-font nil	'japanese-jisx0208
		    (font-spec :family "MeiryoKe_Console"))
  (setq face-font-rescale-alist '(("MeiryoKe_Console" . 1.0))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Emacs Colo Theme
;;;

;; built-in Theme
(load-theme 'wombat t)

;; Custom Theme
;; exp https://github.com/emacs-jp/replace-colorthemes/blob/master/screenshots.md
;;(setq custom-theme-directory "~/.emacs.d/themes/")
;;(load-theme 'cobalt t)
;;(enable-theme 'cobalt)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Emacs GUI
;;;
(when window-system
  ;; GUIの時のみatom-one-dark
  (load-theme 'atom-one-dark t)
  ;; フレームサイズ調整
  (setq default-frame-alist
	(append (list
		 '(width . 120)
		 '(height . 40)
		 )
		default-frame-alist)))
(setq initial-frame-alist default-frame-alist)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; python
;;;

;;; indent
(add-hook 'python-mode-hook
		  (lambda ()
			(setq indent-tabs-mode nil)
			(setq indent-level 4)
			(setq python-indent 4)
			(setq tab-width 4)))

;;; helm
;;; helm-etags-plus(tag jamp) $ ctags -o TAGS *.py
;;(require 'helm-etags+)

;;; imenu(function list)
(semantic-mode 1)
(add-hook 'python-mode-hook
		  (lambda ()
			(setq imenu-create-index-funcfion 'python-imenu-create-index)))

;;; quickxxparun(execute script)
;; M-x package-install quickrun
(quickrun-add-command "python"
		      '((:command . "python"))
		      :override t)

;;; autopep8
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=120"))
(setq flycheck-flake8-maximun-line-length 120)
(py-autopep8-enable-on-save)

;;; python-pep8
(defcustom python-pep8-command "/usr/local/bin/pep8"
    "PEP8 command."
    :type '(file)
    :group 'python-pep8)

(when (load "python-pep8")
    (define-key global-map "\C-c\ p" 'python-pep8))

;;; pyflakes
(flycheck-mode t)
(require 'flymake-python-pyflakes)
(flymake-python-pyflakes-load)

;;; jedi
(defvar jedi:goto-stack '())
(defun jedi:jump-to-definition ()
  (interactive)
  (add-to-list 'jedi:goto-stack
				(list (buffer-name) (point)))
  (jedi:goto-definition))
(defun jedi:jump-back ()
  (interactive)
  (let ((p (pop jedi:goto-stack)))
	(if p ((progen )
		   (switch-to-buffer (nth 0 p))
		   (goto-char (nth 1 p))))))
(jedi:setup)
;; ウィンドウの移動
(define-key jedi-mode-map (kbd "<C-tab>") nil)
(setq jedi:complete-on-dot t)
(define-key jedi-mode-map (kbd "C-j") 'jedi:complete)
(define-key jedi-mode-map "." 'jedi:dot-complete)
(setq ac-sources
	  (delete 'ac-source-words-in-same-mode-buffers ac-sources))
(add-to-list 'ac-sources 'ac-source-filename)
(add-to-list 'ac-sources 'ac-source-jedi-direct)


;;;閉じる括弧やクォートの補完
(add-hook 'python-mode-hook
		  (lambda ()
			(define-key python-mode-map "\C-ct" 'jedi:jump-to-definition)
			(define-key python-mode-map "\C-cb" 'jedi:jump-back)
			(define-key python-mode-map "\C-cr" 'helm-jedi-related-names)
			(define-key python-mode-map "\"" 'electric-pair)
			(define-key python-mode-map "\'" 'electric-pair)
			(define-key python-mode-map "("  'electric-pair)
			(define-key python-mode-map "["  'electric-pair)
			(define-key python-mode-map "{"  'electric-pair)))
(defun electric-pair ()
  (interactive)
  (let (parens-require-spaces)
	(insert-pair)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Markdown
;;;
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SSH
;;; C-x C-f /ssh:user@hostname#port:.emacs.d/init.el
(require 'tramp)
(setq tramp-default-method "ssh")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; org-mode
;;;
(setq org-use-speed-commands t)

