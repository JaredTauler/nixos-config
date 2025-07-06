;;; doom-jetbrains-high-contrast-theme.el --- JetBrains High Contrast port for Doom -*- lexical-binding: t; no-byte-compile: t; -*-
(require 'doom-themes)

(defgroup doom-jetbrains-high-contrast nil
  "Options for the `doom-jetbrains-high-contrast' theme."
  :group 'doom-themes)

(def-doom-theme doom-jetbrains-high-contrast
  "A port of JetBrains’ High Contrast WebStorm theme."

  ;; ---------------------------------------------------------------------------
  ;; Base palette
  ;; ---------------------------------------------------------------------------
  ((bg           '("#000000" nil       nil            ))
   (bg-alt       '("#131314" nil       nil            ))
   (base0        '("#000000" "black"   "black"        ))
   (base1        '("#131314" "#1c1c1c" "brightblack"  ))
   (base2        '("#222326" "#262626" "brightblack"  ))
   (base3        '("#333337" "#3a3a3a" "brightblack"  ))
   (base4        '("#44444a" "#4e4e4e" "brightblack"  ))
   (base5        '("#55555b" "#585858" "brightblack"  ))
   (base6        '("#888891" "#626262" "brightblack"  ))
   (base7        '("#CCCCCC" "#8a8a8a" "brightblack"  ))
   (base8        '("#FFFFFF" "white"   "white"        ))

   (fg           '("#EBEBEB" "#eeeeee" "brightwhite"  ))
   (fg-alt       '("#FFFFFF" "#ffffff" "white"        ))

   (grey         base5)
   (red          '("#FA3232" "#ff6655" "red"          ))
   (orange       '("#ED864A" "#dd8844" "brightred"    ))
   (green        '("#54B33E" "#55aa55" "green"        ))
   (teal         '("#37CCCC" "#33cccc" "brightgreen"  ))
   (yellow       '("#FFCF40" "#ffcf40" "yellow"       ))
   (blue         '("#33CCFF" "#33ccff" "brightblue"   ))
   (dark-blue    '("#005380" "#005f87" "blue"         ))
   (magenta      '("#ED94FF" "#d785ff" "magenta"      ))
   (violet       '("#FF79C6" "#ff79c6" "brightmagenta"))
   (cyan         '("#8BE9FD" "#87d7ff" "brightcyan"   ))
   (dark-cyan    '("#006280" "#005f87" "cyan"         ))

   ;; required internal names
   (highlight    '("#000066" "#00005f" "brightblack"  ))
 (success green)
   (error        red)
   (warning      yellow)
   (info         cyan)

   ;; helpers
   (line-highlight '("#000066" "#00005f" "brightblack"))
   (cursor       '("#FFFFFF" "#ffffff" "white"        ))
   (selection    '("#006280" "#005f87" "brightblue"   )))

  ;; ---------------------------------------------------------------------------
  ;; Face categories
  ;; ---------------------------------------------------------------------------
  ((default :background bg :foreground fg)
   (cursor  :background cursor)
   (fringe  :background bg-alt :foreground fg)
   (region  :background selection)
   (highlight :background line-highlight)
   (vertical-border :foreground base3)
   (secondary-selection :background dark-cyan)

   ;; syntax
   (font-lock-builtin-face        :foreground orange)
   (font-lock-comment-face        :foreground grey :slant italic)
   (font-lock-constant-face       :foreground magenta)
   (font-lock-function-name-face  :foreground yellow :weight bold)
   (font-lock-keyword-face        :foreground orange :weight bold)
   (font-lock-string-face         :foreground green)
   (font-lock-type-face           :foreground violet :weight bold)
   (font-lock-variable-name-face  :foreground fg)
   (font-lock-warning-face        :foreground yellow :weight bold)
   (error                         :foreground red   :weight bold)
   (warning                       :foreground yellow)

   ;; line numbers
   ((line-number &override) :foreground grey :background bg-alt)
   ((line-number-current-line &override) :foreground fg-alt :background bg-alt :weight bold)

   ;; mode-line
   (mode-line :background base2 :foreground fg)
   (mode-line-inactive :background base1 :foreground grey)
   (mode-line-emphasis :foreground yellow :weight bold)
   (doom-modeline-bar :background orange)

   ;; org blocks
   (org-block :background bg-alt)
   (org-block-begin-line :foreground grey :background bg-alt)
   (org-block-end-line   :foreground grey :background bg-alt))

  ;; ---------------------------------------------------------------------------
  ;; variables (use Doom defaults)
  ;; ---------------------------------------------------------------------------
  ())

;;; doom-jetbrains-high-contrast-theme.el ends here
