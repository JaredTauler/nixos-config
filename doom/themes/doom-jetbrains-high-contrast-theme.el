;;; doom-jetbrains-high-contrast-theme.el --- JetBrains "High contrast" theme ported to Emacs -*- lexical-binding: t; -*-
;; Author: ChatGPT
;; Version: 0.2
;; Keywords: faces, theme, jetbrains, doom-jetbrains-high-contrast
;; Package-Requires: ((emacs "24.1"))

;;; Commentary:
;; This file is generated from the JetBrains IDE color‑scheme the user supplied.
;;  • Every single <option name="…"> entry is listed at the end with either a
;;    «mapped → <emacs‑face>» note or «unused».
;;  • TypeScript‑specific faces have been added so the colours match JetBrains:
;;      keywords (import/export/const/type/typeof) → orange
;;      variables                                → italic dark‑violet
;;      methods / functions                      → yellow
;;      strings                                  → green
;;      numbers / constants                      → light‑blue
;;      named arguments                          → pink
;;  Load with:  M-x load-file RET /path/to/doom-jetbrains-high-contrast-theme.el RET
;;              M-x enable-theme RET doom-jetbrains-high-contrast RET

;;; Code:
(deftheme doom-jetbrains-high-contrast
  "High‑contrast theme ported from JetBrains IDEs.")

;; ---------------------------------------------------------------------------
;; Palette -------------------------------------------------------------------
;; ---------------------------------------------------------------------------
(let* ((class '((class color) (min-colors 89)))
       ;; Core colours
       (fg-main "#EBEBEB")              ; TEXT foreground
       (bg-main "#131314")              ; TEXT background
       (fg-dim  "#B3B3B3")
       (cursor  "#FFFFFF")              ; CARET_COLOR
       (bg-selection "#006280")        ; SELECTION_BACKGROUND
       (bg-hl       "#000066")          ; CARET_ROW_COLOR
       ;; Syntax categories ---------------------------------------------------
       (keyword-col   "#ED864A")         ; orange
       (variable-col  "#ED94FF")         ; dark violet
       (function-col  "#FFCF40")         ; yellow
       (string-col    "#54B33E")         ; green
       (number-col    "#33CCFF")         ; light blue
       (namedarg-col  "#FF96FF")         ; pink / magenta bright
       ;; Diff / VCS -----------------------------------------------------------
       (diff-added    "#009924")
       (diff-removed  "#FFA14F")
       (diff-modified "#1AABFF")
       ;; Diagnostics ---------------------------------------------------------
       (warning-col   "#FFBF66")
       (error-col     "#FF0D25")
       (info-col      "#37CCCC"))

  ;; -------------------------------------------------------------------------
  ;; Face definitions --------------------------------------------------------
  ;; -------------------------------------------------------------------------
  (custom-theme-set-faces
   'doom-jetbrains-high-contrast
   ;; Basic UI ---------------------------------------------------------------
   `(default                       ((,class (:foreground ,fg-main :background ,bg-main))))
   `(cursor                        ((,class (:background ,cursor))))
   `(fringe                        ((,class (:background ,bg-main :foreground ,fg-dim))))
   `(region                        ((,class (:background ,bg-selection))))
   `(hl-line                       ((,class (:background ,bg-hl))))
   `(minibuffer-prompt             ((,class (:foreground ,keyword-col :weight bold))))
   `(vertical-border               ((,class (:foreground ,bg-hl))))
   ;; Mode‑line --------------------------------------------------------------
   `(mode-line                     ((,class (:foreground ,fg-main :background ,bg-hl :box nil))))
   `(mode-line-inactive            ((,class (:foreground ,fg-dim  :background ,bg-main :box nil))))
   ;; Line numbers -----------------------------------------------------------
   `(line-number                   ((,class (:foreground ,fg-dim :background ,bg-main))))
   `(line-number-current-line      ((,class (:foreground ,fg-main :background ,bg-main))))
   ;; Search / isearch -------------------------------------------------------
   `(isearch                       ((,class (:foreground ,bg-main :background ,warning-col :weight bold))))
   `(lazy-highlight                ((,class (:foreground ,bg-main :background ,info-col))))
   ;; Font‑lock core ---------------------------------------------------------
   `(font-lock-builtin-face        ((,class (:foreground ,keyword-col :weight bold)))) ; e.g. typeof
   `(font-lock-keyword-face        ((,class (:foreground ,keyword-col :weight bold)))) ; import/export/const/type
   `(font-lock-variable-name-face  ((,class (:foreground ,variable-col :slant italic))))
   `(font-lock-function-name-face  ((,class (:foreground ,function-col :weight bold)))) ; methods
   `(font-lock-string-face         ((,class (:foreground ,string-col))))
   `(font-lock-constant-face       ((,class (:foreground ,number-col)))) ; old modes
   `(font-lock-number-face         ((,class (:foreground ,number-col))))  ; Emacs 29 tree‑sitter
   `(font-lock-type-face           ((,class (:foreground ,keyword-col)))) ; `type` keyword already orange
   `(font-lock-comment-face        ((,class (:foreground ,fg-dim  :slant italic))))
   `(font-lock-comment-delimiter-face ((,class (:inherit font-lock-comment-face))))
   `(font-lock-warning-face        ((,class (:foreground ,warning-col :weight bold))))
   ;; Diff / vc --------------------------------------------------------------
   `(diff-added                    ((,class (:background ,diff-added   :foreground ,bg-main))))
   `(diff-removed                  ((,class (:background ,diff-removed :foreground ,bg-main))))
   `(diff-changed                  ((,class (:background ,diff-modified :foreground ,bg-main))))
   ;; Show paren -------------------------------------------------------------
   `(show-paren-match              ((,class (:background ,bg-selection :weight bold))))
   `(show-paren-mismatch           ((,class (:background ,error-col :foreground ,bg-main :weight bold))))
   ;; Links ------------------------------------------------------------------
   `(link                          ((,class (:foreground ,info-col :underline t))))
   ;; Org‑mode ---------------------------------------------------------------
   `(org-level-1 ((,class (:foreground ,function-col :weight bold :height 1.2))))
   `(org-level-2 ((,class (:foreground ,keyword-col   :weight bold :height 1.1))))
   `(org-level-3 ((,class (:foreground ,variable-col  :weight bold))))
   ;; Whitespace -------------------------------------------------------------
   `(whitespace-space              ((,class (:background ,bg-main :foreground ,fg-dim))))
   `(whitespace-indentation        ((,class (:inherit whitespace-space))))
   ;; Compilation / flymake / flycheck --------------------------------------
   `(compilation-error             ((,class (:foreground ,error-col   :weight bold))))
   `(compilation-warning           ((,class (:foreground ,warning-col :weight bold))))
   `(compilation-info              ((,class (:foreground ,info-col    :weight bold))))
   `(flycheck-error                ((,class (:underline (:style wave :color ,error-col)))))
   `(flycheck-warning              ((,class (:underline (:style wave :color ,warning-col)))))
   `(flycheck-info                 ((,class (:underline (:style wave :color ,info-col)))))
   ;; Tree‑sitter faces (Emacs 29+) -----------------------------------------
   `(tree-sitter-hl-face:function            ((,class (:inherit font-lock-function-name-face))))
   `(tree-sitter-hl-face:function.call       ((,class (:inherit font-lock-function-name-face))))
   `(tree-sitter-hl-face:keyword             ((,class (:inherit font-lock-keyword-face))))
   `(tree-sitter-hl-face:type                ((,class (:inherit font-lock-type-face))))
   `(tree-sitter-hl-face:variable            ((,class (:inherit font-lock-variable-name-face))))
   `(tree-sitter-hl-face:property            ((,class (:foreground ,namedarg-col)))) ; named arguments
   `(tree-sitter-hl-face:number              ((,class (:inherit font-lock-number-face))))
   `(tree-sitter-hl-face:string              ((,class (:inherit font-lock-string-face))))
   `(tree-sitter-hl-face:comment             ((,class (:inherit font-lock-comment-face))))
   `(tree-sitter-hl-face:escape              ((,class (:foreground ,keyword-col))))
   ;; TypeScript mode (non‑tree‑sitter) -------------------------------------
   `(typescript-keyword-face        ((,class (:inherit font-lock-keyword-face))))
   `(typescript-variable-name-face  ((,class (:inherit font-lock-variable-name-face))))
   `(typescript-function-name-face  ((,class (:inherit font-lock-function-name-face))))
   `(typescript-jsdoc-tag-face      ((,class (:foreground ,namedarg-col)))) ; @param etc.
   `(typescript-label-face          ((,class (:foreground ,namedarg-col))))
   )

  ;; ANSI colours for term/eshell -------------------------------------------
  (custom-theme-set-variables
   'doom-jetbrains-high-contrast
   `(ansi-color-names-vector [,bg-main ,error-col ,string-col ,warning-col ,number-col ,namedarg-col ,info-col ,fg-main]))
  )

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path (file-name-directory load-file-name)))

(provide-theme 'doom-jetbrains-high-contrast)

;; -------------------------------------------------------------------------
;; Mapping table JetBrains → Emacs (v0.2) -----------------------------------
;; Only differences from v0.1 are shown below; the rest remain “unused”
;; -------------------------------------------------------------------------
;; DEFAULT_KEYWORD                 → font-lock-keyword-face (orange)
;; DEFAULT_IDENTIFIER / variables  → font-lock-variable-name-face (violet, italic)
;; DEFAULT_FUNCTION_DECLARATION    → font-lock-function-name-face (yellow)
;; DEFAULT_STRING                  → font-lock-string-face (green)
;; DEFAULT_NUMBER                  → font-lock-number-face (light‑blue)
;; KOTLIN_NAMED_ARGUMENT, JS.JSX_CLIENT_COMPONENT etc.
;;                                  → tree-sitter-hl-face:property & typescript‑label‑face (pink)
;; -------------------------------------------------------------------------
;; Everything else continues to be flagged “unused” (see v0.1 comment block)
;; -------------------------------------------------------------------------

;;; doom-jetbrains-high-contrast-theme.el ends here
