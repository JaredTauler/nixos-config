;;; Init.el --- Description -*- lexical-binding: t; -*
;;
;; Copyright (C) 2025 Jared Tauler
;;
;; Author: Jared Tauler <jared@z390ud>
;; Maintainer: Jared Tauler <jared@z390ud>
;; Created: July 29, 2025
;; Modified: July 29, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/jared/init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


;; Appearance
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode 1)
(set-fringe-mode 10)   ;; Give some breathing room
(global-display-line-numbers-mode 1)

(load-theme 'ef-maris-dark t)

;; scream if you love direnv
(require 'envrc)
(envrc-global-mode 1)


;; --- Completion style ---
(require 'orderless)
(setq completion-styles '(orderless)
      completion-category-defaults nil)

;; popup completion
(require 'corfu)
(setq corfu-auto t
      corfu-auto-delay 0
      corfu-cycle t)
(global-corfu-mode)

;; enhance completion
(require 'cape)

;; ;; Enable symbol + dabbrev completion in buffers
;; (defun my/lisp-completion-setup ()
;;   (setq-local completion-at-point-functions
;;               (list (cape-super-capf #'cape-symbol #'cape-dabbrev))))

;;(add-hook 'emacs-lisp-mode-hook #'my/lisp-completion-setup)


(recentf-mode 1)

;; keys
(require 'evil)
(evil-mode 1)
(require 'general)

(general-create-definer my/leader
  :states '(normal motion)   ;; only active outside Insert mode
  :keymaps 'override
  :prefix "SPC")

;; Your SPC keybindings
(
 my/leader
 "f s" #'save-buffer
 "f f" #'find-file
 "f r" #'consult-recent-file
 "f p" #'project-find-file
 "RET" #'format-buffer

 "b b" #'switch-to-buffer

 ;; treemacs follow current buffer
 "p o" #'treemacs-add-and-display-current-project-exclusively

 ;;reload config
 "h r r" (lambda () (interactive) (load-file "~/.emacs.d/init.el"))

 )

;; Optional: Make ESC go back to Normal mode
(general-define-key
 :keymaps 'evil-insert-state-map
 "C-c" 'evil-normal-state)


;; FIXME retarded
(defun my/reload-config ()
  (interactive)
  (load-file "~/nixos-config/home-option/emacs/dotfiles/init.el"))


(require 'flycheck)

(require 'vertico)
(vertico-mode 1)

(require 'orderless)
(setq completion-styles '(orderless basic))

(require 'marginalia)
(marginalia-mode 1)

;; better search
(require 'consult)
(global-set-key (kbd "C-s") #'consult-line) ;;


(defun alejandra-format-buffer ()
  "Format the current buffer using Alejandra."
  (interactive)
  (unless (executable-find "alejandra")
    (user-error "Alejandra not found in PATH"))
  (let ((tmpfile (make-temp-file "alejandra" nil ".nix"))
        (outputbuf (get-buffer-create "*Alejandra Errors*"))
        (curpoint (point)))
    (unwind-protect
        (progn
          (write-region nil nil tmpfile nil 'silent)
          (if (zerop (call-process "alejandra" nil outputbuf nil tmpfile))
              (progn
                (erase-buffer)
                (insert-file-contents tmpfile)
                (goto-char curpoint)
                (message "Alejandra formatted buffer"))
            (progn
              (display-buffer outputbuf)
              (error "Alejandra failed; see *Alejandra Errors*"))))
      (delete-file tmpfile))))
;; nix
;; Hook
;; (add-hook 'nix-mode-hook
;; 	  (lambda ()
;; 	    (lsp)
;; 	    (flycheck-mode 1)
;; 	    (when (fboundp 'tree-sitter-mode)
;; 	      (tree-sitter-mode)
;; 	      (tree-sitter-hl-mode))

;; 	    ;; nix-formt-buffer is shitty
;; 	    ;; (setq-local format-buffer-function 'nix-mode-format)
;; 	    (setq-local format-buffer-function #'alejandra-format-buffer)

;; 	    )
;; 	  )

(require 'polymode)

(defun my-nix-hook ()
  (lsp-deferred)
  (flycheck-mode 1)
  (setq-local format-buffer-function #'alejandra-format-buffer))
(add-hook 'poly-nix-mode-hook #'my-nix-hook)

;; must end with hostmode, then innermode:
(define-hostmode poly-nix-hostmode :mode 'nix-mode)
(define-innermode poly-nix-bash-innermode
  :mode 'sh-mode
  :head-matcher "''[ \t]*\n"
  :tail-matcher "^[ \t]*''"
  :head-mode 'host :tail-mode 'host)



(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(require 'lsp-mode)

;; Use nixd as the LSP server
(setq lsp-nix-server 'nixd)

;; format buffer function
(defvar-local format-buffer-function nil
  "Function to format the current buffer. Should be buffer-local.")


(define-polymode poly-nix-mode
  :hostmode 'poly-nix-hostmode
  :innermodes '(poly-nix-bash-innermode))

;; ensure .nix uses poly, not plain nix-mode
(setq auto-mode-alist
      (cons '("\\.nix\\'" . poly-nix-mode)
            (rassq-delete-all 'nix-mode auto-mode-alist)))


;; general format buffer function
(defun format-buffer ()
  "Format the current buffer using `format-buffer-function`, or notify if not set."
  (interactive)
  (if format-buffer-function
      (funcall format-buffer-function)
    (user-error "No formatter configured for this buffer dumbass")))


;; all languages
(require 'dap-mode)
(use-package polymode :ensure t)
(use-package nix-mode  :ensure t)

;; debug dap
(setenv "DEBUG" "*")
(setq dap-print-io t)



(add-hook 'prog-mode-hook
	  (lambda ()
	    (flycheck-mode 1)
	    ;; (when (fboundp 'tree-sitter-mode)
	    ;;   (tree-sitter-mode)
	    ;;   (tree-sitter-hl-mode))
	    ))


;; js + ts
(require 'dap-js)

;; FIXME errors before sending initialize message
;; only on integratedterminal

;; (defun my/dap-internal-terminal-vterm (command title debug-session)
;;   (let ((vterm-shell command)
;;         (vterm-kill-buffer-on-exit nil))
;;     (with-current-buffer (dap--make-terminal-buffer title debug-session)
;;       (require 'vterm)
;;       (vterm-mode)
;;       ;; Optional: show the buffer
;;       (display-buffer (current-buffer)))))


;; (setq dap-internal-terminal #'my/dap-internal-terminal-vterm)



;; js
(add-hook 'js-mode-hook
	  (lambda ()
	    (lsp)
	    )
	  )


;; (defun dap-js--populate-start-file-args (conf)
;;   "Populate CONF with the required arguments."
;;   (let ((port (dap--find-available-port)))
;;     (let* ((program (s-join " " dap-js-debug-program))
;;            (command (concat program " " (number-to-string port))))
;;       ;; (message "[DAP] Launching JS debug server: %s" command)  ;; <-- echo it here

;;       ;; ;; You could even pause here:
;;       ;; (debug command)

;;       (-> conf
;;           (append
;;            (list :debugServer port
;;                  :host "localhost"
;;                  :type "pwa-node"
;;                  :program-to-start command))



;;           (dap--put-if-absent :cwd default-directory)
;;           (dap--put-if-absent :name "Node Debug")))))

;; (setq dap-internal-terminal #'dap-internal-terminal-shell)

(dap-register-debug-template
 "Launch JS (Bare)"
 (list :type "pwa-node"
       :name "Launch JS (Bare)"
       :request "launch"
       :program "${workspaceFolder}/hello.js"
       :cwd "${workspaceFolder}"
       :runtimeExecutable "node"
       :runtimeArgs ["--inspect-brk"]
       :protocol "inspector"
       :console "internalConsole"
       ;; :internalConsoleOptions "neverOpen"
       ;; :sourceMaps nil

       ;; :port 9229
       :skipFiles ["<node_internals>/**"]
       ))



;; ts
(add-hook 'typescript-mode-hook
	  (lambda ()
	    (lsp)
	    )
	  )

(dap-register-debug-template
 "Launch TSX Clean"
 (list :type "pwa-node"
       :name "Launch TSX Clean"
       :request "launch"
       :program "${workspaceFolder}/src/server/server.ts"
       :cwd "${workspaceFolder}"
       :runtimeExecutable "node"
       :runtimeArgs ["--inspect-brk" "--import" "tsx" ]
       :protocol "inspector"
       :console "internalConsole"
       :output "std"
       ;; :internalConsoleOptions "neverOpen"
       ;; :sourceMaps nil
       :skipFiles ["<node_internals>/**"]
       ))


;; (dap-register-debug-template
;;  "Attach: Simple Node"
;;  (list :type "pwa-node"
;;        :request "attach"
;;        :name "Attach: Simple Node"
;;        :port 9229
;;        :cwd "${workspaceFolder}"
;;        :protocol "inspector"
;;        :sourceMaps t
;;        :skipFiles ["<node_internals>/**"]))


;; Lisp
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
            (setq-local format-buffer-function
                        (lambda ()
                          (delete-trailing-whitespace)
			  (indent-region (point-min) (point-max))))
	    )
	  )




;; (require 'dap-mode)
;; (require 'dap-ui)
;; (dap-mode 1)
;; (dap-ui-mode 1)

;; (require 'dap-node)
;; (setq dap-node-debug-program `("node" "--inspect-brk"))
;; (setq dap-node-debug-port 9229)

;; (dap-register-debug-template
;;   "Node :: Run File"
;;   (list :type "node"
;;         :request "launch"
;;         :name "Node :: Run"
;;         :program "${file}"
;;         :cwd "${workspaceFolder}"))


;;breadcrumb mode

;; flycheck
;; treesitter

;; (when (fboundp 'tree-sitter-mode)
;;   (require 'treesit)
;;   (global-tree-sitter-mode)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;   (add-hook 'nix-mode-hook #'tree-sitter-mode)

;;   (unless (treesit-language-available-p 'nix)
;;     (message "â ï¸ Tree-sitter grammar for Nix not installed. Run: M-x treesit-install-language-grammar RET nix")))

;; (require 'flycheck)
;; (global-flycheck-mode)

;; (flycheck-define-checker nix-statix
;;   "Statix static analysis for Nix files."
;;   :command ("statix" "check" source)
;;   :error-patterns
;;   ((error line-start (file-name) ":" line ":" column ": " (message) line-end))
;;   :modes nix-mode)

;; (add-to-list 'flycheck-checkers 'nix-statix)

(add-hook 'envrc-after-update-environment-hook
          (lambda ()
            (setq exec-path (parse-colon-path (getenv "PATH")))))



(defun my/nixos-rebuild ()
  "Open eshell and run 'nixos-rebuild switch'."
  (interactive)
  (let ((eshell-buffer-name "*nixos-rebuild*"))
    (eshell)
    (insert "sudo nixos-rebuild switch --flake ~/nixos-config/#z390ud")
    (eshell-send-input)))



;; (require 'em-alias) ;; optional but common
;; (require 'em-prompt)
;; (require 'em-term)
;; (require 'em-smart)

;; (setq eshell-prompt-function
;;       (lambda () (concat (user-login-name) "@" (system-name) " $ ")))

;; (setq eshell-highlight-prompt t)
;; (setq eshell-prompt-regexp "^[^#$\n]*[#$] ")

;; (add-hook 'eshell-mode-hook #'ansi-color-for-comint-mode-on)
;; (add-hook 'eshell-mode-hook #'eshell-smart-initialize)
;; (setenv "CLICOLOR" "1")
;; (setenv "LS_COLORS" "ExFxCxDxBxegedabagacad") ;; optional

(defun my/make-unique-buffer (prefix)
  "Create a new buffer with a unique name starting with PREFIX."
  (generate-new-buffer (generate-new-buffer-name prefix)))

(defun my/run-command-in-vterm (cmd)
  (let ((buf (generate-new-buffer "*vterm-run*")))
    (with-current-buffer buf
      (require 'vterm)
      (vterm-mode)
      (display-buffer buf)
      (vterm-send-string (concat cmd " & echo $!\n")))))

;; (defvar vterm-shell)
;; (defvar vterm-kill-buffer-on-exit)
;; ;; (defun my/dap-vterm (command title debug-session)
;; ;;   (let ((vterm-shell command)
;; ;;         (vterm-kill-buffer-on-exit nil))
;; ;;     (with-current-buffer (my/make-unique-buffer title)
;; ;;       (require 'vterm)
;; ;;       (vterm)
;; ;;       (display-buffer (current-buffer))

;; ;;       )))


;; (defun my/dap-vterm (command title debug-session)
;;   (let* ((vterm-shell command)
;;          (vterm-kill-buffer-on-exit nil)
;;          (buf (generate-new-buffer (format "*dap-vterm-%s*" (gensym)))))
;;     (with-current-buffer buf
;;       (require 'vterm)
;;       (vterm)
;;       (let ((proc (get-buffer-process buf)))
;;         (unless (and proc (process-live-p proc))
;;           (error "No live process in vterm"))
;;         (display-buffer buf)
;;         `(:processId ,(process-id proc))))))

;; (defun my/dap-vterm (command title debug-session)
;;   (let ((vterm-shell command)
;;         (vterm-kill-buffer-on-exit nil)
;;         (buf (my/make-unique-buffer title)))
;;     (with-current-buffer buf
;;       (require 'vterm)
;;       (vterm)
;;       (display-buffer (current-buffer))
;;       `(:processId ,(process-id (get-buffer-process (current-buffer)))))))
;; (defun my/dap-vterm (command title debug-session)
;;   (let ((vterm-shell command)
;;         (vterm-kill-buffer-on-exit nil)
;;         (buf (generate-new-buffer (format "*dap-vterm-%s*" (gensym)))))
;;     (with-current-buffer buf
;;       (require 'vterm)
;;       (vterm)
;;       (display-buffer buf)
;;       (let ((proc (get-buffer-process buf)))
;;         (unless (process-live-p proc)
;;           (error "No process started in vterm"))
;;         `(:processId ,(process-id proc))))))



(setq dap-internal-terminal #'my/dap-vterm)
;; (defun my/dap-vterm (command title debug-session)

;;   (let* ((env      (dap--debug-session-environment debug-session))
;;          (default-directory (or (plist-get debug-session :cwd)
;;                                 default-directory))
;;          ;; make a *separate* buffer; don't reuse the adapterâs
;;          (buf-name (format "*DAP-term: %s*" title))
;;          (process-environment (append env process-environment)))
;;     (vterm buf-name)                      ; forks a brand-new PTY
;;     (with-current-buffer buf-name
;;       (setq-local vterm-kill-buffer-on-exit nil)
;;       (vterm-send-string command)
;;       (vterm-send-return))
;;     (display-buffer buf-name)))

;; (setq dap-internal-terminal #'my/dap-vterm)


(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("6bf350570e023cd6e5b4337a6571c0325cec3f575963ac7de6832803df4d210a"
     default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
