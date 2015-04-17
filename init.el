(require 'cask "~/.cask/cask.el")
(cask-initialize)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-selection ((t (:background "brightblack"))))
 '(minibuffer-prompt ((t (:foreground "cyan")))))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
(set-language-environment "Japanese")
(iswitchb-mode 1)
(add-hook 'iswitchb-define-mode-map-hook
          (lambda ()
            (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
            (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)))
(global-auto-revert-mode 1)
(display-time-mode 1)
(column-number-mode 1)
(display-battery-mode 1)

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(eval-after-load 'flycheck
  '(custom-set-variables
    '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

;; Helm
(add-to-list 'load-path (expand-file-name "~/.emacs.d/helm/"))
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-q") 'helm-mini)

;; emacs directory
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;; package management
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

(defun package-install-with-refresh (package)
  (unless (assq package package-alist)
    (package-refresh-contents))
  (unless (package-installed-p package)
    (package-install package)))

;; install evil
(package-install-with-refresh 'evil)
(package-install-with-refresh 'color-theme)

;; enable evil
(require 'evil)
(evil-mode 1)
(setq evil-shift-width 2)

(setq require-final-newline t)

(require 'color-theme)

(global-set-key "\C-h" 'backward-delete-char)
(define-key key-translation-map [?\C-h] [?\C-?])

(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-insert-state-map (kbd "C-k") 'previous-line)
(define-key evil-insert-state-map (kbd "C-j") 'next-line)
(define-key evil-insert-state-map (kbd "C-h") 'previous-char)
(define-key evil-insert-state-map (kbd "C-l") 'next-char)
(define-key evil-normal-state-map (kbd "C-k") 'previous-line)
(define-key evil-normal-state-map (kbd "C-j") 'next-line)
(define-key evil-normal-state-map (kbd "C-h") 'previous-char)
(define-key evil-normal-state-map (kbd "C-l") 'next-char)

(define-key evil-normal-state-map ")" 'sp-up-sexp)
(define-key evil-normal-state-map "(" 'sp-down-sexp)

(defun set-pretty-patterns (patterns)
  (loop for (glyph . pairs) in patterns do
        (loop for (regexp . major-modes) in pairs do
              (loop for major-mode in major-modes do
                    (let ((major-mode (intern (concat (symbol-name major-mode) "-mode")))
                          (n (if (string-match "\\\\([^?]" regexp) 1 0)))
                      (font-lock-add-keywords major-mode
                                              `((,regexp (0 (prog1 ()
                                                              (compose-region (match-beginning ,n)
                                                                              (match-end ,n)
                                                                              ,glyph)))))))))))

;;(set-pretty-patterns
;; '((?λ ("\\<lambda\\>" lisp lisp-interaction emacs-lisp scheme))
;;   (?λ ("\\<function\\>" js2))))

;;(add-hook 'slime-mode-hook
;;          (lambda ()
;;            (load-library "cl-indent")
;;            (setq lisp-indent-function 'common-lisp-indent-function)))

;; clone slime in .emacs.d/
;; `git clone https://github.com/slime/slime`
(add-to-list 'load-path (expand-file-name "~/.emacs.d/slime/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/slime-repl-ansi-color/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/cl-annot/misc/"))
(require 'slime)
(require 'slime-repl-ansi-color)
(require 'slime-annot)
(setq inferior-lisp-program "ros run -Q -l ~/.rosrc -s")
;; (setq inferior-lisp-program "ccl")
;; (setq inferior-lisp-program "clisp")
(slime-setup '(slime-repl slime-fancy slime-banner slime-repl-ansi-color slime-indentation))
(setq common-lisp-hyperspec-root
      (concat "file://" (expand-file-name "~/dev//HyperSpec/"))
      common-lisp-hyperspec-symbol-table
      (expand-file-name "~/dev/HyperSpec/Data/Map_Sym.txt"))
(add-hook 'lisp-mode-hook
          (lambda ()
            (slime-mode t)
            (show-paren-mode t)))
(add-hook 'lisp-mode-hook
          (lambda ()
            (global-set-key "\C-a" 'slime-switch-to-output-buffer)
            (global-set-key "\C-ch" 'slime-hyperspec-lookup)))

(setq mac-pass-command-to-system nil)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/popwin/"))
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;; Apropos
(push '("*slime-apropos*") popwin:special-display-config)
;; Macroexpand
(push '("*slime-macroexpansion*") popwin:special-display-config)
;; Help
(push '("*slime-description*") popwin:special-display-config)
;; Compilation
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
;; Cross-reference
(push '("*slime-xref*") popwin:special-display-config)
;; Debugger
(push '(sldb-mode :stick t) popwin:special-display-config)
;; REPL
(push '(slime-repl-mode) popwin:special-display-config)
;; Connections
(push '(slime-connection-list-mode) popwin:special-display-config)

(require 'smartparens)
(require 'smartparens-config)
(defun enable-smartparens-mode ()
  (unless smartparens-mode
    (smartparens-mode)))
(add-hook 'slime-mode-hook #'enable-smartparens-mode)
(add-hook 'lisp-mode-hook #'enable-smartparens-mode)
(add-hook 'emacs-lisp-mode-hook #'enable-smartparens-mode)

;; (require 'magit)

(add-to-list 'auto-mode-alist
             '("\\.tmpl\\'" . html-mode))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/js2-mode"))
(require 'js2-mode)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/espresso-mode/"))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook
          #'(lambda ()
              (require 'espresso)
              (setq espresso-indent-level 2
                    espresso-expr-indent-offset 2
                    indent-tabs-mode nil)
              (defun my-js-indent-line ()
                (interactive)
                (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
                       (offset (- (current-column) (current-indentation)))
                       (indentation (espresso--proper-indentation parse-status)))
                  (back-to-indentation)
                  (if (looking-at "case\\s-")
                      (indent-line-to (+ indentation 2))
                    (espresso-indent-line))
                  (when (> offset 0) (forward-char offset))))
              (set (make-local-variable 'indent-line-function) 'my-js-indent-line)))

;; emmet-mode
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップ言語全部で使う
(add-hook 'css-mode-hook  'emmet-mode) ;; CSSにも使う
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent はスペース2個
(eval-after-load "emmet-mode" '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(define-key emmet-mode-keymap (kbd "C-i") 'emmet-expand-line) ;; C-i で展開

;; scss-mode
(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(defun scss-custom ()
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)))
(add-hook 'scss-mode-hook
          '(lambda () (scss-custom)))

;; Erlang
;; (add-to-list 'load-path (expand-file-name "/usr/local/lib/erlang/lib/tools-2.7.1/emacs/"))
;; (setq erlang-root-dir "/usr/local/lib/erlang")
;; (add-to-list 'exec-path (expand-file-name "/usr/local/lib/erlang/bin"))
;; (setq erlang-electric-commands '(erlang-electric-newline erlang-electric-gt erlang-electric-semecolon))
;; (require 'erlang-start)
;; (push '("*erlang*") popwin:special-display-config)

;; jsx
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))
(setq web-mode-markup-indent-offset 2)

(flycheck-def-executable-var 'jsxhint-checker "jsxhint")
(flycheck-define-command-checker 'jsxhint-checker
  "A JSX syntax and style checker based on JSXHint.
   You must insatll jsxhint with `npm insatll -g jsxhint` first"

  :command `("jsxhint" "--config" ,(expand-file-name "~/.emacs.d/.jshintrc") source)
  :error-patterns '((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
  :modes '(web-mode))

(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              ;; enable flycheck
              (flycheck-select-checker 'jsxhint-checker)
              (flycheck-mode))))

;; Yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Dired
(setq dired-dwim-target t)
(setq dired-recursive-copies 'always)
(setq dired-isearch-filenames t)

;; Gauche
(setq process-coding-system-alist
      (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))
(push '("gosh") popwin:special-display-config)
(setq scheme-program-name "/usr/local/bin/gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)
(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))
(define-key global-map
  "\C-cZ" 'scheme-other-window)

;; js-comint
(require 'js-comint)
(setq inferior-js-program-command "node --interactive")
;;(push '("*js*") popwin:special-display-config)
(add-hook 'js2-mode-hook '(lambda () 
                            (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix)
                            (local-set-key "\C-x\C-e" 'js-send-last-sexp)
                            (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
                            (local-set-key "\C-cb" 'js-send-buffer)
                            (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
                            (local-set-key "\C-cl" 'js-load-file-and-go)
                            (local-set-key "\C-c\C-r" 'js-send-region)))

;; quickrun
(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)
(global-set-key (kbd "C-c C-r") 'quickrun)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("726dd9a188747664fbbff1cd9ab3c29a3f690a7b861f6e6a1c64462b64b306de" default)))
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages)))

(require 'evil-dvorak)
(global-evil-dvorak-mode 1)
