;;$DOOMDIR/config.el -*- lexical-binding: t; -*-
;;https://rogerdudler.github.io/git-guide

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;===================== COMPANY  ================================
(use-package company
  :demand t
  :bind (;; Replace `completion-at-point' and `complete-symbol' with
         ;; `company-manual-begin'. You might think this could be put
         ;; in the `:bind*' declaration below, but it seems that
         ;; `bind-key*' does not work with remappings.
         ([remap completion-at-point] . company-manual-begin)
         ([remap complete-symbol] . company-manual-begin)

         ;; The following are keybindings that take effect whenever
         ;; the completions menu is visible, even if the user has not
         ;; explicitly interacted with Company.

         :map company-active-map

         ;; Make TAB always complete the current selection. Note that
         ;; <tab> is for windowed Emacs and TAB is for terminal Emacs.
         ("<tab>" . company-complete-selection)
         ("TAB" . company-complete-selection)

         ;; Prevent SPC from ever triggering a completion.
         ("SPC" . nil)

         ;; The following are keybindings that only take effect if the
         ;; user has explicitly interacted with Company.

         :map company-active-map
         :filter (company-explicit-action-p)

         ;; ;; Make RET trigger a completion if and only if the user has
         ;; ;; explicitly interacted with Company. Note that <return> is
         ;; ;; for windowed Emacs and RET is for terminal Emacs.
         ;; ("<return>" . company-complete-selection)
         ;; ("RET" . company-complete-selection)

         ;; We then do the same for the up and down arrows. Note that
         ;; we use `company-select-previous' instead of
         ;; `company-select-previous-or-abort'. I think the former
         ;; makes more sense since the general idea of this `company'
         ;; configuration is to decide whether or not to steal
         ;; keypresses based on whether the user has explicitly
         ;; interacted with `company', not based on the number of
         ;; candidates.

         ("<C-k>" . company-select-previous)
         ("<C-j>" . company-select-next))

  :bind* (;; The default keybinding for `completion-at-point' and
          ;; `complete-symbol' is M-TAB or equivalently C-M-i. Here we
          ;; make sure that no minor modes override this keybinding.
          ("M-TAB" . company-manual-begin))

  :diminish company-mode
  :config

  ;; Turn on Company everywhere.
  (global-company-mode 1)

  ;; Show completions instantly, rather than after half a second.
  (setq company-idle-delay 0.1)

  ;; Show completions after typing a single character, rather than
  ;; after typing three characters.
  (setq company-minimum-prefix-length 2)

  ;; Show a maximum of 10 suggestions. This is the default but I think
  ;; it's best to be explicit.
  (setq company-tooltip-limit 6)

  ;; Always display the entire suggestion list onscreen, placing it
  ;; above the cursor if necessary.
  (setq company-tooltip-minimum company-tooltip-limit)

  ;; Always display suggestions in the tooltip, even if there is only
  ;; one. Also, don't display metadata in the echo area. (This
  ;; conflicts with ElDoc.)
  (setq company-frontends '(company-pseudo-tooltip-frontend))

  ;; Show quick-reference numbers in the tooltip. (Select a completion
  ;; with M-1 through M-0.)
  (setq company-show-numbers t)

  ;; Prevent non-matching input (which will dismiss the completions
  ;; menu), but only if the user interacts explicitly with Company.
  (setq company-require-match #'company-explicit-action-p)

  ;; Company appears to override our settings in `company-active-map'
  ;; based on `company-auto-complete-chars'. Turning it off ensures we
  ;; have full control.
  (setq company-auto-commit-chars nil)

(setq company-dabbrev-downcase 0)
  ;; Prevent Company completions from being lowercased in the
  ;; completion menu. This has only been observed to happen for
  ;; comments and strings in Clojure.
  (setq company-dabbrev-downcase nil)

  ;; Only search the current buffer to get suggestions for
  ;; company-dabbrev (a backend that creates suggestions from text
  ;; found in your buffers). This prevents Company from causing lag
  ;; once you have a lot of buffers open.
  (setq company-dabbrev-other-buffers nil)

  ;; Make company-dabbrev case-sensitive. Case insensitivity seems
  ;; like a great idea, but it turns out to look really bad when you
  ;; have domain-specific words that have particular casing.
  (setq company-dabbrev-ignore-case nil)

  ;; Make it so that Company's keymap overrides Yasnippet's keymap
  ;; when a snippet is active. This way, you can TAB to complete a
  ;; suggestion for the current field in a snippet, and then TAB to
  ;; move to the next field. Plus, C-g will dismiss the Company
  ;; completions menu rather than cancelling the snippet and moving
  ;; the cursor while leaving the completions menu on-screen in the
  ;; same location.

  (with-eval-after-load 'yasnippet
    ;; TODO: this is all a horrible hack, can it be done with
    ;; `bind-key' instead?

    ;; This function translates the "event types" I get from
    ;; `map-keymap' into things that I can pass to `lookup-key'
    ;; and `define-key'. It's a hack, and I'd like to find a
    ;; built-in function that accomplishes the same thing while
    ;; taking care of any edge cases I might have missed in this
    ;; ad-hoc solution.
    (defun radian--normalize-event (event)
      (if (vectorp event)
          event
        (vector event)))

    ;; Here we define a hybrid keymap that delegates first to
    ;; `company-active-map' and then to `yas-keymap'.
    (setq radian--yas-company-keymap
          ;; It starts out as a copy of `yas-keymap', and then we
          ;; merge in all of the bindings from
          ;; `company-active-map'.
          (let ((keymap (copy-keymap yas-keymap)))
            (map-keymap
             (lambda (event company-cmd)
               (let* ((event (radian--normalize-event event))
                      (yas-cmd (lookup-key yas-keymap event)))
                 ;; Here we use an extended menu item with the
                 ;; `:filter' option, which allows us to
                 ;; dynamically decide which command we want to
                 ;; run when a key is pressed.
                 (define-key keymap event
                   `(menu-item
                     nil ,company-cmd :filter
                     (lambda (cmd)
                       ;; There doesn't seem to be any obvious
                       ;; function from Company to tell whether or
                       ;; not a completion is in progress (à la
                       ;; `company-explicit-action-p'), so I just
                       ;; check whether or not `company-my-keymap'
                       ;; is defined, which seems to be good
                       ;; enough.
                       (if company-my-keymap
                           ',company-cmd
                         ',yas-cmd))))))
             company-active-map)
            keymap))
    (setq python-shell-interpreter "/home/tocha/develop/Python-sandbox/sandbox/bin")
    ;; The function `yas--make-control-overlay' uses the current
    ;; value of `yas-keymap' to build the Yasnippet overlay, so to
    ;; override the Yasnippet keymap we only need to dynamically
    ;; rebind `yas-keymap' for the duration of that function.
    (defun radian--advice-company-overrides-yasnippet
        (yas--make-control-overlay &rest args)
      "Allow `company' to override `yasnippet'.
This is an `:around' advice for `yas--make-control-overlay'."
      (let ((yas-keymap radian--yas-company-keymap))
        (apply yas--make-control-overlay args)))

    (advice-add #'yas--make-control-overlay :around
                #'radian--advice-company-overrides-yasnippet)))
;;; Prevent suggestions from being triggered automatically. In particular,
  ;;; this makes it so that:
  ;;; - TAB will always complete the current selection.
  ;;; - RET will only complete the current selection if the user has explicitly
  ;;;   interacted with Company.
  ;;; - SPC will never complete the current selection.
  ;;;
  ;;; Based on:
  ;;; - https://github.com/company-mode/company-mode/issues/530#issuecomment-226566961
  ;;; - https://emacs.stackexchange.com/a/13290/12534
  ;;; - http://stackoverflow.com/a/22863701/3538165
  ;;;
  ;;; See also:
  ;;; - https://emacs.stackexchange.com/a/24800/12534
  ;;; - https://emacs.stackexchange.com/q/27459/12534

(setq doom-modeline-vcs-max-length 132);
;; <return> is for windowed Emacs; RET is for terminal Emacs
(dolist (key '("<return>" "RET"))
  ;; Here we are using an advanced feature of define-key that lets
  ;; us pass an "extended menu item" instead of an interactive
  ;; function. Doing this allows RET to regain its usual
  ;; functionality when the user has not explicitly interacted with
  ;; Company.
  (define-key company-active-map (kbd key)
    `(menu-item nil company-complete
                :filter ,(lambda (cmd)
                           (when (company-explicit-action-p)
                             cmd)))))
(define-key company-active-map (kbd "TAB") #'company-complete-selection)
(define-key company-active-map (kbd "SPC") nil)


;; Company appears to override the above keymap based on company-auto-complete-chars.
;; Turning it off ensures we have full control.
(setq company-auto-commit-chars nil)
;;Ignore file projectile sin .gitignore

(use-package flycheck-projectile
  :load-path "~/.emacs.d/packages/")
;;======================REACT==================================
;;
(use-package rjsx-mode
  :mode ("\\.jsx?$" . rjsx-mode)
  :hook (rjsx-mode . tide-setup)
  )

(with-eval-after-load 'rjsx-mode
  (define-key rjsx-mode-map "<" nil)
  (define-key rjsx-mode-map (kbd "C-d") nil)
  (define-key rjsx-mode-map ">" nil))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode))

;;;;
;;;;
;;;;
;; =========================VUE================================
(setq vue-mode-packages
      '(vue-mode))
(defun vue-mode/init-vue-mode ()
  "Initialize my package"
  (use-package vue-mode))
;; ;;=====================TYPESCRIPT=============================
;; (require 'import-js)
;; (require 'json-mode)
(require 'eslint-fix)
(require 'prettier)
(setq flycheck-javascript-eslint-executable "eslint_d")
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (company-mode +1)
  (tide-hl-identifier-mode +1))

(setq tide-format-options '(:insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets nil))
;; ;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(add-hook 'typescript-mode-hook #'setup-tide-mode)


(global-set-key (kbd "C-c z") 'hydra-typescript/body)

(setq tide-server-max-response-length 2147483647)
(defhydra hydra-typescript (:color red :hint nil )


  "
  ^Buffer^                 ^Errors^                   ^Refactor^                   ^Format^                 ^Tide^
------------------------------------------------------------------------------------------------------------------------------------
[_d_]   Documentation      [_e_] Errors              [_rs_]  Rename symbol         [_t_]  Tide format       [_*_]  Restart server
[_fd_]  Find definition    [_a_] Apply error fix     [_rf_]  Refactor              [_c_]  JSDoc comment     [_v_]  Verify setup
[_fr_]  Find references    [_l_] Apply eslint fix                                                           [_i_]  Organize imports
                           [_m_]  Fix imports                                                                                         "

  ("a" tide-fix :exit t)
  ("d" tide-documentation-at-point :exit t)
  ("fd" tide-jump-to-definition :exit t)
  ("fr" tide-references :exit t)
  ("c" tide-jsdoc-template :exit t)
  ("e" tide-project-errors :exit t)
  ("rs" tide-rename-symbol :exit t)
  ("l" eslint-fix :exit t)
  ("rf" tide-refactor :exit t)
  ("t" tide-format :exit t)
  ("m" import-js-import :exit t)
  ("*" tide-restart-server :exit t)
  ("v" tide-verify-setup :exit t)
  ("i" tide-organize-imports :exit t)
  )
;; ------------------------------------------  DAP - MODE - NODE ------------------------------------
(setq dap-auto-configure-features '(sessions locals controls tooltip))
(require 'dap-mode)
(require 'dap-ui)
(require 'dap-mouse)
(global-set-key (kbd "C-c d") 'dap-hydra/body)
(dap-mode 1)

;; The modes below are optional

(dap-ui-mode 1)
;; enables mouse hover support
(dap-tooltip-mode 1)
;; use tooltips for mouse hover
;; if it is not enabled `dap-mode' will use the minibuffer.
(tooltip-mode 1)
;; displays floating panel with debug buttons
;; requies emacs 26+
(dap-ui-controls-mode 1)

(require 'dap-node)
(dap-register-debug-template "Search TME"
(list :name "Search TME"
:type "node"
:request "launch"
:args ["/home/tocha/develop/TME/search/src/bin/index.ts"]
:runtimeArgs ["--nolazy" "-r" "ts-node/register"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/TME/search"
:protocol "inspector"))


(dap-register-debug-template "Aidmed"
(list :name "Aidmed"
:type "node"
:request "launch"
:args ["/home/tocha/develop/aidmed-website-my/src/app.ts"]
:runtimeArgs ["--nolazy" "-r" "ts-node/register"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/aidmed-website-my/"
:protocol "inspector"))


(dap-register-debug-template "Dos-DB"
(list :name "Search TME"
:type "node"
:request "launch"
:args ["./src/console.ts" "generate-ddl" "views"]
:runtimeArgs ["--nolazy" "-r" "ts-node/register"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/TME/dos-db"
:protocol "inspector"))


(dap-register-debug-template "test debug"
(list :name "TS Index"
:type "node"
:request "launch"
:args ["/home/tocha/develop/debug_typescript_node/index.ts"]
:runtimeArgs ["--nolazy" "-r" "ts-node/register"]
:sourceMaps t
:cwd "/home/tocha/develop/debug_typescript_node"
:protocol "inspector"))

(dap-register-debug-template "Search TME test-e2e"
(list :name "Search TME test-e2e"
:type "node"
:request "launch"
:program "/home/tocha/develop/TME/search/node_modules/jest/bin/jest.js"
:args ["--config" "jest.config.e2e.ts" "--no-cache" "-i"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/TME/search"
:protocol "inspector"))


(dap-register-debug-template "Search TME test-unit"
(list :name "Search TME test-unit"
:type "node"
:request "launch"
:program "/home/tocha/develop/TME/search/node_modules/jest/bin/jest.js"
:args ["--config" "jest.config.unit.ts" "--no-cache" "-i"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/TME/search"
:protocol "inspector"))


(dap-register-debug-template "Search TME test-functional"
(list :name "Search TME test-functional"
:type "node"
:request "launch"
:program "/home/tocha/develop/TME/search/node_modules/jest/bin/jest.js"
:args ["--config" "jest.config.functional.ts" "--no-cache" "-i"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/TME/search"
:protocol "inspector"))

(dap-register-debug-template "Pol-sun"
(list :name "Pol-sun debug"
:type "node"
:request "launch"
:args ["/home/tocha/develop/sekvoia/polsun-api/src/main.ts"]
:runtimeArgs ["--nolazy" "-r" "ts-node/register"]
:trace t
:sourceMaps t
:cwd "/home/tocha/develop/sekvoia/polsun-api"
:protocol "inspector"))

(require 'dap-chrome)

(add-hook 'dap-stopped-hook
          (lambda (args) (call-interactively #'dap-hydra/body) (call-interactively #'dap-ui-show-many-windows) ))


(add-hook 'dap-terminated-hook
          (lambda (args) (call-interactively #'dap-ui-hide-many-windows) ))


(defhydra dap-hydra (:color red :hint nil)
  "
^Stepping^          ^Switch^                 ^Breakpoints^         ^Debug^                     ^Eval
^^^^^^^^----------------------------------------------------------------------------------------------------------------
_n_: Next           _ss_: Session            _bb_: Toggle          _dd_: Debug                 _ee_: Eval
_i_: Step in        _st_: Thread             _bd_: Delete          _dr_: Debug recent          _er_: Eval region
_o_: Step out       _sf_: Stack frame        _ba_: Add             _dl_: Debug last            _es_: Eval thing at point
_c_: Continue       _sl_: List locals        _bc_: Set condition   _de_: Edit debug template   _ea_: Add expression.
_r_: Restart frame  _sb_: List breakpoints   _bh_: Set hit count
_Q_: Disconnect     _sS_: List sessions      _bl_: Set log message
"
  ("n" dap-next :exit t)
  ("i" dap-step-in :exit t)
  ("o" dap-step-out :exit t)
  ("c" dap-continue :exit t)
  ("r" dap-debug-restart :exit t)
  ("ss" dap-switch-session :exit t)
  ("st" dap-switch-thread :exit t)
  ("sf" dap-switch-stack-frame :exit t)
  ("sl" dap-ui-locals :exit t)
  ("sb" dap-ui-breakpoints :exit t)
  ("sS" dap-ui-sessions :exit t)
  ("bb" dap-breakpoint-toggle :exit t)
  ("ba" dap-breakpoint-add :exit t)
  ("bd" dap-breakpoint-delete :exit t)
  ("bc" dap-breakpoint-condition :exit t)
  ("bh" dap-breakpoint-hit-condition :exit t)
  ("bl" dap-breakpoint-log-message :exit t)
  ("dd" dap-debug :exit t)
  ("dr" dap-debug-recent :exit t)
  ("dl" dap-debug-last :exit t)
  ("de" dap-debug-edit-template :exit t)
  ("ee" dap-eval :exit t)
  ("ea" dap-ui-expressions-add :exit t)
  ("er" dap-eval-region :exit t)
  ("es" dap-eval-thing-at-point :exit t)
  ("q" nil "quit" :exit t)
  ("Q" dap-disconnect :exit t))

(setq-default line-spacing 3)
(require 'restclient)

(add-to-list 'auto-mode-alist '("\\.http$" . restclient-mode))
(setq restclient-same-buffer-response-name "*RESTClient*")

(add-hook 'restclient-response-loaded-hook
      (lambda ()
        (let ((json-special-chars (remq (assoc ?/ json-special-chars) json-special-chars)))
              (ignore-errors (json-pretty-print-buffer)))
        (restclient-prettify-json-unicode)))
(provide 'init-restclient)
(require 'ranger)
(global-set-key (kbd "C-c r") 'ranger)

;; ;;============================LSP===============================
;; ;;

;; (use-package! lsp-mode
;;   :after (:any typescript-mode
;;                javascript-mode
;;                )
;;   :config
;;   (setq lsp-enable-completion-enable t)
;;   (setq lsp-enable-snippet nil)
;;   (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.node_modules\\'")
;;   (setq gc-cons-threshold 100000000)
;;   (setq read-process-output-max (* 1024 1024)) ;; 1mb
;;   (setq lsp-log-io nil) ; if set to true can cause a performance hit
;;   (setq lsp-idle-delay 0.020) ; delay
;;   )
