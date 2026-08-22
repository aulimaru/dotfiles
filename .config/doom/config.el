;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 16))
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

;; Inheriting Environment Variables
;; (use-package! exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-initialize))


;; This is an Emacs package that creates graphviz directed graphs from
;; the headings of an org file

;; prevent client from creating new workspace
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; set default indentation for C/C++ modes to 4 spaces
(setq-default c-basic-offset 4)    ;; For C/C++ modes
(setq-default tab-width 4)          ;; Set tab width to 4
(setq-default indent-tabs-mode nil) ;; Use spaces instead of tabs

(setq yas-snippet-dirs '("~/.config/doom/snippets"))

;; org modern
(with-eval-after-load 'org (global-org-modern-mode))

;; valign
(add-hook! org-mode
  (valign-mode)
  (setq valign-fancy-bar 1)
  (setq org-modern-table nil))

;; start latex preview when start up in proper size
;; (setq org-format-latex-options
;;       (plist-put org-format-latex-options :scale 0.75))
;; (after! org
;;   (setq org-startup-with-latex-preview t))

                                        ;(use-package! org-mind-map
                                        ;  :init
                                        ;  (require 'ox-org)
                                        ;  :ensure t
                                        ;  ;; Uncomment the below if 'ensure-system-packages` is installed
                                        ;  ;;:ensure-system-package (gvgen . graphviz)
                                        ;  :config
                                        ;  (setq org-mind-map-engine "dot"))       ; Default. Directed Graph
;;; (setq org-mind-map-engine "neato")  ; Undirected Spring Graph
;;; (setq org-mind-map-engine "twopi")  ; Radial Layout
;;; (setq org-mind-map-engine "fdp")    ; Undirected Spring Force-Directed
;;; (setq org-mind-map-engine "sfdp")   ; Multiscale version of fdp for the layout of large graphs
;;; (setq org-mind-map-engine "twopi")  ; Radial layouts
;;; (setq org-mind-map-engine "circo")  ; Circular Layout


;; anki-editor
(use-package! anki-editor)

;; Remove file creation date from the capture template
(after! org-roam
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?" :target
           (file+head "${slug}.org" "#+title: ${title}\n")
           :unnarrowed t))))

;; Github Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  ;; :hook (prog-mode . copilot-mode)  ; auto-enable disabled
  :bind (:map copilot-completion-map
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("TAB" . 'copilot-accept-completion)
              ("<tab>" . 'copilot-accept-completion)
              ("C-n" . 'copilot-next-completion)
              ("C-p" . 'copilot-previous-completion)))
;; mlog-mode sb yiheng
;; (use-package! mlog-mode)

;; xclip
;; (use-package! xclip
;;   :config
;;   (setq xclip-program "wl-copy")
;;   (setq xclip-select-enable-clipboard t)
;;   (setq xclip-mode t)
;;   (setq xclip-method (quote wl-copy)))

;; org habit
(add-to-list `org-modules 'org-habit)

;; clipboard fix
;; credit: yorickvP on Github
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe
                                      :noquery t))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)
(setq-hook! '(c-ts-mode-hook c++-ts-mode-hook c-or-c++-ts-mode-hook)
  c-ts-mode-indent-offset 4)

(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools
