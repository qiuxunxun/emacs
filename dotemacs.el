(require 'package)
(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; 配置 use-package 集成 straight。
(setq straight-use-package-by-default t)
(setq straight-vc-git-default-clone-depth 1)
(setq straight-recipes-gnu-elpa-use-mirror t)
(setq straight-check-for-modifications '(check-on-save find-when-checking watch-files))
(setq straight-host-usernames '((github . "opsnull")))

;; 安装 straight.el。
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; 安装 use-package。
(straight-use-package 'use-package)
(setq use-package-verbose t)
(setq use-package-compute-statistics t)

;; 为 use-package 添加 :ensure-system-package 指令。
(use-package use-package-ensure-system-package)

(use-package exec-path-from-shell
  :demand
  :custom
  ;; 去掉 -i 参数, 加快启动速度。
  (exec-path-from-shell-arguments '("-l")) 
  (exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-variables '("PATH" "MANPATH" "GOPATH" "GOPROXY" "GOPRIVATE" "GOFLAGS" "GO111MODULE"))
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; 提升 IO 性能。
(setq process-adaptive-read-buffering nil)
;; 增加单次读取进程输出的数据量（缺省 4KB) 。
(setq read-process-output-max (* 4 1024 1024))

;; 提升长行处理性能。
(setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering 'left-to-right)
(setq-default bidi-paragraph-direction 'left-to-right)

;; 缩短 fontify 时间。
(setq jit-lock-defer-time nil)
(setq jit-lock-context-time 0.1)
;; 更积极的 fontify 。
(setq fast-but-imprecise-scrolling nil)
(setq redisplay-skip-fontification-on-input nil)

;; 缩短更新 screen 的时间。
(setq idle-update-delay 0.1)

;; 加快快捷键提示的速度。
(setq echo-keystrokes 0.1)

;; 显示消息超时的时间。
(setq minibuffer-message-timeout 1)     

;; 使用字体缓存，避免卡顿。
(setq inhibit-compacting-font-caches t)

;; Garbage Collector Magic Hack
(use-package gcmh
  :demand
  :init
  ;; 在 minibuffer 显示 GC 信息。
  ;;(setq garbage-collection-messages t)
  ;;(setq gcmh-verbose t)
  (setq gcmh-idle-delay 5)
  (setq gcmh-high-cons-threshold (* 64 1024 1024))
  (gcmh-mode 1)
  (gcmh-set-high-threshold))

(when (memq window-system '(mac ns x))
  ;; 关闭各种图形元素。
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  ;; 关闭对话框。
  (setq use-file-dialog nil)
  (setq use-dialog-box nil)
  ;; 使用更瘦字体。
  (setq ns-use-thin-smoothing t)
  ;; 不在新 frame 打开文件（如 Finder 的 "Open with Emacs") 。
  (setq ns-pop-up-frames nil)
  ;; 一次滚动一行，避免窗口跳动。
  (setq mouse-wheel-scroll-amount '(1 ((shift) . hscroll)))
  (setq mouse-wheel-scroll-amount-horizontal 1)
  (setq mouse-wheel-follow-mouse t)
  (setq mouse-wheel-progressive-speed nil)
  (xterm-mouse-mode t))

;; 关闭启动消息。
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)

;; 指针不闪动。
(blink-cursor-mode -1)

;; 调大 fringe, 避免行号列跳动。
(set-fringe-mode 10)

;; 出错提示。
(setq visible-bell t)

;; 窗口间显示分割线。
(setq window-divider-default-places t)
(add-hook 'window-setup-hook #'window-divider-mode)

;; 左右分屏, nil: 上下分屏。
(setq split-width-threshold 30)

;; 复用当前 frame。
(setq display-buffer-reuse-frames t)

;; 滚动一屏后显示 3 行上下文。
(setq next-screen-context-lines 3)

;; 平滑地进行半屏滚动，避免滚动后 recenter 操作。
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq scroll-margin 2)

;; 滚动时保持光标位置。
(setq scroll-preserve-screen-position 1)

;; 像素平滑滚动（Emacs 29 开始支持）。
(if (boundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode t))

;; 大文件不显示行号。
(setq large-file-warning-threshold nil)
(setq line-number-display-limit large-file-warning-threshold)
(setq line-number-display-limit-width 1000)
(dolist (mode '(text-mode-hook prog-mode-hook conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; 根据窗口自适应调整图片大小。
(setq image-transform-resize t)
(auto-image-file-mode t)

;; 预览主题: https://emacsthemes.com/
(use-package doom-themes
  :demand
  :after (treemacs)
  ;; 添加 "extensions/*" 后才支持 visual-bell/treemacs/org 配置。
  :straight (:files ("*.el" "themes/*" "extensions/*"))
  :custom-face
  (doom-modeline-buffer-file ((t (:inherit (mode-line bold)))))
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  (doom-themes-treemacs-theme "doom-colors")
  :config
  (doom-themes-visual-bell-config)
  (load-theme 'doom-palenight t)
  ;; 为 treemacs 关闭 variable-pitch 模式，否则显示的较丑！
  ;; 必须在执行 doom-themes-treemacs-config 前设置该变量为 nil, 否则不生效。
  (setq doom-themes-treemacs-enable-variable-pitch nil)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package awesome-tray
  :demand
  :straight (:repo "manateelazycat/awesome-tray" :host github)
  :hook
  ;; emacs 启动完毕后再启动，这样可以替换掉 doom-theme 的 modeline, 避免显示两个。
  (after-init .  (lambda () (awesome-tray-mode)))
  :config
  ;; modeline 中添加 input-method 显示。
  (setq awesome-tray-active-modules '("location" "file-path" "mode-name" "battery" "input-method" "date")))

(use-package sort-tab
  :demand
  :straight (:repo "manateelazycat/sort-tab" :host github)
  :config
  (sort-tab-mode 1)
  (global-set-key (kbd "s-1") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-2") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-3") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-4") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-5") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-6") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-7") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-8") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-9") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-0") 'sort-tab-select-visible-tab)
  (global-set-key (kbd "s-Q") 'sort-tab-close-all-tabs)
  (global-set-key (kbd "s-q") 'sort-tab-close-mode-tabs)
  (global-set-key (kbd "s-;") 'sort-tab-close-current-tab)
  ;; 设置 tab 颜色，M-x list-colors-display.
  (set-face-foreground 'sort-tab-current-tab-face "bisque4")
  ;; 不显示背景颜色。
  (set-face-background 'sort-tab-current-tab-face nil))

(use-package dashboard
  :demand
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Happy Hacking & Writing 🎯")
  (setq dashboard-projects-backend #'project-el)
  (setq dashboard-center-content t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents . 10) (projects . 8) (agenda . 3))))

;; 参考: https://github.com/DogLooksGood/dogEmacs/blob/master/elisp/init-font.el
;; 缺省字体（英文，如显示代码）。
(setq +font-family "Fira Code Retina")
(setq +modeline-font-family "Fira Code Retina")
;; 其它均使用 Sarasa Mono SC 字体。
(setq +fixed-pitch-family "Sarasa Mono SC")
(setq +variable-pitch-family "Sarasa Mono SC")
(setq +font-unicode-family "Sarasa Mono SC")
(setq +font-size 14)

;; 设置缺省字体。
(defun +load-base-font ()
  ;; 只为缺省字体设置 size, 其它字体都通过 :height 动态伸缩。
  (let* ((font-spec (format "%s-%d" +font-family +font-size)))
	(set-frame-parameter nil 'font font-spec)
	(add-to-list 'default-frame-alist `(font . ,font-spec))))

;; 设置各特定 face 的字体。
(defun +load-face-font (&optional frame)
  (let ((font-spec (format "%s" +font-family))
	    (modeline-font-spec (format "%s" +modeline-font-family))
	    (variable-pitch-font-spec (format "%s" +variable-pitch-family))
	    (fixed-pitch-font-spec (format "%s" +fixed-pitch-family)))
	(set-face-attribute 'variable-pitch frame :font variable-pitch-font-spec :height 1.2)
	(set-face-attribute 'fixed-pitch frame :font fixed-pitch-font-spec :height 1.0)
	(set-face-attribute 'fixed-pitch-serif frame :font fixed-pitch-font-spec :height 1.0)
	(set-face-attribute 'tab-bar frame :font font-spec :height 1.0)
	(set-face-attribute 'mode-line frame :font modeline-font-spec :height 1.0)
	(set-face-attribute 'mode-line-inactive frame :font modeline-font-spec :height 1.0)))

;; 设置中文字体。
(defun +load-ext-font ()
  (when window-system
	(let ((font (frame-parameter nil 'font))
		  (font-spec (font-spec :family +font-unicode-family)))
	  (dolist (charset '(kana han hangul cjk-misc bopomofo symbol))
	    (set-fontset-font font charset font-spec)))))

;; 设置 Emoji 字体。
(defun +load-emoji-font ()
  (when window-system
	(setq use-default-font-for-symbols nil)
	(set-fontset-font t '(#x1f000 . #x1faff) (font-spec :family "Apple Color Emoji"))
	(set-fontset-font t 'symbol (font-spec :family "Symbola"))))

(add-hook 'after-make-frame-functions 
		  ( lambda (f) 
		    (+load-face-font f)
		    (+load-ext-font)
		    (+load-emoji-font)))

(defun +load-font ()
  (+load-base-font)
  (+load-face-font)
  (+load-ext-font)
  (+load-emoji-font))

(+load-font)

;; all-the-icons 和 fire-code-mode 只能在 GUI 模式下使用。
(when (display-graphic-p)
  (use-package all-the-icons :demand)
  (use-package fira-code-mode
	:custom
	(fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x"))
	:hook prog-mode))

(use-package vertico
  :demand
  :straight (:repo "minad/vertico" :files ("*" "extensions/*.el" (:exclude ".git")))
  :bind
  (:map vertico-map
        ;; 在多个 source 中切换(如 consult-buffer, consult-grep) 。
        ("C-M-n" . vertico-next-group)
        ("C-M-p" . vertico-previous-group)
        ;; 快速选择，特别适用于候选者比较多的情况。
        ("M-i" . vertico-quick-insert)
        ("M-e" . vertico-quick-exit)
        ;; 文件路径操作。
        ("<backspace>" . vertico-directory-delete-char)
        ("C-w" . vertico-directory-delete-word)
        ("C-<backspace>" . vertico-directory-delete-word)
        ("RET" . vertico-directory-enter))
  :hook
  (
   ;; 在输入时清理文件路径。
   (rfn-eshadow-update-overlay . vertico-directory-tidy)
   ;; 确保 vertico 状态被保存（用于支持 vertico-repeat)。
   (minibuffer-setup . vertico-repeat-save))
  :config
  ;; 显示的侯选者数量。
  (setq vertico-count 20)
  (setq vertico-cycle nil)
  (vertico-mode 1)

  ;; 重复上一次 vertico session;
  (global-set-key "\M-r" #'vertico-repeat-last)
  (global-set-key "\M-R" #'vertico-repeat-select)

  ;; 开启 vertico-multiform, 为 commands 或 categories 设置不同的显示风格。
  (vertico-multiform-mode)

  ;; 按照 completion category 设置显示风格, 优先级比 vertico-multiform-commands 低。
  ;; 为 file 设置 grid 模式, grep buffer 模式与 awesome-tray 不兼容。
  (setq vertico-multiform-categories '((file grid))))

(use-package emacs
  :init
  ;; 在 minibuffer 中不显示光标。
  (setq minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  ;; M-x 是不显示当前 mode 不支持的命令以及 vertico 相关命令。
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  ;; 开启 minibuffer 递归编辑。
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :demand
  :config
  (defvar +orderless-dispatch-alist
    '((?% . char-fold-to-regexp)
      (?! . orderless-without-literal)
      (?`. orderless-initialism)
      (?= . orderless-literal)
      (?~ . orderless-flex)))

  (defun +orderless-dispatch (pattern index _total)
    (cond
     ((string-suffix-p "$" pattern)
      `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
     ;; 文件扩展。
     ((and
       ;; 补全文件名或 eshell.
       (or minibuffer-completing-file-name
           (derived-mode-p 'eshell-mode))
       ;; 文件名扩展
       (string-match-p "\\`\\.." pattern))
      `(orderless-regexp . ,(concat "\\." (substring pattern 1) "[\x100000-\x10FFFD]*$")))
     ;; 忽略单个 !
     ((string= "!" pattern) `(orderless-literal . ""))
     ;; 前缀和后缀。
     ((if-let (x (assq (aref pattern 0) +orderless-dispatch-alist))
          (cons (cdr x) (substring pattern 1))
        (when-let (x (assq (aref pattern (1- (length pattern))) +orderless-dispatch-alist))
          (cons (cdr x) (substring pattern 0 -1)))))))
  (setq orderless-style-dispatchers '(+orderless-dispatch))

  ;; 自定义 orderless 风格。
  (orderless-define-completion-style +orderless-with-initialism
    (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))
  ;; 使用 orderless 过滤候选者。
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  ;; 各 category 使用的补全风格。
  (setq completion-category-overrides '((buffer (styles +orderless-with-initialism))
                                        (file (styles basic partial-completion))
                                        (command (styles +orderless-with-initialism))
                                        (variable (styles +orderless-with-initialism))
                                        (symbol (styles +orderless-with-initialism))))
  ;; 使用 SPACE 来分割过滤字符串, SPACE 可以用 \ 转义。
  (setq orderless-component-separator #'orderless-escapable-split-on-space))

(use-package consult
  :ensure-system-package (rg . ripgrep)
  :demand
  :bind
  (;; C-c 绑定 (mode-specific-map)
   ("C-c h" . consult-history)
   ("C-c m" . consult-mode-command)
   ;; C-x 绑定 (ctl-x-map)
   ("C-M-:" . consult-complex-command)
   ("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x r b" . consult-bookmark)
   ("C-x p b" . consult-project-buffer)
   ;; 寄存器绑定。
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)
   ("C-M-#" . consult-register)
   ;; 其它自定义绑定。
   ("M-y" . consult-yank-pop)
   ("<help> a" . consult-apropos)
   ;; M-g 绑定 (goto-map)
   ("M-g e" . consult-compile-error)
   ;;("M-g f" . consult-flycheck)
   ("M-g g" . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-g o" . consult-outline)
   ;; consult-buffer 默认已包含 recent file.
   ;;("M-g r" . consult-recent-file)
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)
   ;; M-s 绑定 (search-map)
   ("M-s d" . consult-find)
   ("M-s D" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s m" . consult-multi-occur)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)
   ;; Isearch 集成。
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)
   ("M-s e" . consult-isearch-history)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ;; Minibuffer 历史。
   :map minibuffer-local-map
   ("M-s" . consult-history)
   ("M-r" . consult-history))
  :hook
  (completion-list-mode . consult-preview-at-point-mode)
  :init
  ;; 如果搜索字符少于 3，可以添加后缀#开始搜索，如 #gr#。
  (setq consult-async-min-input 3)
  (setq consult-async-input-debounce 0.4)
  (setq consult-async-input-throttle 0.5)
  ;; 预览寄存器。
  (setq register-preview-delay 0.1)
  (setq register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref)
  :config
  ;; 按 C-l 激活预览，否则 buffer 列表中有大文件或远程文件时会卡住。
  (setq consult-preview-key (kbd "C-l"))
  (setq consult-narrow-key "<")
  (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)
  (setq completion-in-region-function #'consult-completion-in-region)
  ;; 不对 consult-line 结果进行排序（按行号排序）。
  (consult-customize consult-line :prompt "Search: " :sort nil)
  ;; Buffer 列表中不显示的 buffer 名称。
  (mapcar 
   (lambda (pattern) (add-to-list 'consult-buffer-filter pattern))
   '("\\*scratch\\*" 
     "\\*Warnings\\*"
     "\\*helpful.*"
     "\\*Help\\*" 
     "\\*Org Src.*"
     "Pfuture-Callback.*"
     "\\*epc con"
     "\\*dashboard"
     "\\*lsp-bridge"
     "\\*Ibuffer"
     "\\*sort-tab"
     "[0-9]+.gpg")))

(use-package embark
  :init
  ;; 使用 C-h 来显示 key preifx 绑定。
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (setq embark-prompter 'embark-keymap-prompter)
  (setq embark-collect-live-update-delay 0.5)
  (setq embark-collect-live-initial-delay 0.8)
  ;; 隐藏 Embark live/completions buffers 的 modeline.
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  :bind
  (("C-;" . embark-act)
   ([remap describe-bindings] . embark-bindings)))

(use-package embark-consult
  ;; 加 :demand 才生效。
  :demand
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package marginalia
  :init
  ;; 显示绝对时间。
  (setq marginalia-max-relative-age 0)
  (marginalia-mode)
  :config
  (setq marginalia-annotator-registry
        (assq-delete-all 'file marginalia-annotator-registry))
  (setq marginalia-annotator-registry
        (assq-delete-all 'project-file marginalia-annotator-registry)))

(use-package corfu
  :demand
  :straight (corfu :host github :repo "minad/corfu" :files ("*.el" "extensions/*.el"))
  :init
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)) 
  :custom
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  ;; 后续使用 corfu-doc 来显示文档，故关闭。
  (corfu-echo-documentation nil)
  ;; 使用候选者的历史位置来排序。
  :config
  (savehist-mode 1)
  (corfu-history-mode t)
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (global-corfu-mode))

;; 总是在弹出菜单中显示候选者。
(setq completion-cycle-threshold nil)

;; 使用 TAB 来 indentation+completion(completion-at-point 默认是 M-TAB) 。
(setq tab-always-indent 'complete)

;; 在候选者右方显示文档。
(use-package corfu-doc
  :straight (corfu-doc :host github :repo "galeo/corfu-doc")
  :after (corfu)
  :hook (corfu-mode . corfu-doc-mode)
  :bind
  (:map corfu-map
        ("M-n" . corfu-doc-sroll-up)
        ("M-p" . corfu-doc-scroll-down))
  :custom
  (corfu-doc-delay 0.2)
  (corfu-doc-max-width 80)
  (corfu-doc-max-height 30))

(use-package cape
  :demand
  :straight (cape :host github :repo "minad/cape")
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  :config
  (setq cape-dabbrev-min-length 3)
  ;; 前缀长度达到 3 时才调用 CAPF，避免频繁调用自动补全。
  (cape-wrap-prefix-length #'cape-dabbrev 3))

(use-package yasnippet
  :demand
  :init
  (defvar snippet-directory "~/.emacs.d/snippets")
  (if (not (file-exists-p snippet-directory))
      (make-directory snippet-directory t))
  :hook
  ((prog-mode org-mode  vterm-mode) . yas-minor-mode)
  :config
  (add-to-list 'yas-snippet-dirs snippet-directory)
  ;; 保留 snippet 的缩进。
  (setq yas-indent-line 'fixed)
  (yas-global-mode 1))

(use-package yasnippet-snippets :demand)

(use-package yasnippet-classic-snippets :demand)

(use-package consult-yasnippet
  :demand
  :after(consult yasnippet)
  :bind
  (:map yas-minor-mode-map
        ("C-c y" . 'consult-yasnippet)))

(use-package ace-window
  :init
  ;; 使用字母而非数字标记窗口，便于跳转。
  (setq aw-keys '(?a ?w ?e ?g ?i ?j ?k ?l ?p))
  ;; 根据自己的使用习惯来调整快捷键，这里使用大写字母避免与 aw-keys 冲突。
  (setq aw-dispatch-alist
        '((?0 aw-delete-window "Delete Window")
          (?1 delete-other-windows "Delete Other Windows")
          (?2 aw-split-window-vert "Split Vert Window")
          (?3 aw-split-window-horz "Split Horz Window")
          (?F aw-split-window-fair "Split Fair Window")
          (?S aw-swap-window "Swap Windows")
          (?M aw-move-window "Move Window")
          (?C aw-copy-window "Copy Window")
          ;; 为指定 window 选择新的 Buffer 并切换过去。
          (?B aw-switch-buffer-in-window "Select Buffer")
          ;; 为指定 window 选择新的 Buffer，切换到其它 buffer；
          (?O aw-switch-buffer-other-window "Switch Buffer Other Window")
          (?N aw-flip-window)
          (?T aw-transpose-frame "Transpose Frame")
          (?? aw-show-dispatch-help)))
  :config
  ;; 设置为 frame 后会忽略 treemacs frame，否则即使两个窗口时也会提示选择。
  (setq aw-scope 'frame)
  ;; 总是提示窗口选择，进而执行 ace 命令。
  (setq aw-dispatch-always t)
  (global-set-key (kbd "M-o") 'ace-window))

(use-package winner
  :straight (:type built-in)
  :commands (winner-undo winner-redo)
  :hook (after-init . winner-mode)
  :init
  (setq winner-boring-buffers
        '("*Completions*"
          "*Compile-Log*"
          "*inferior-lisp*"
          "*helpful"
          "*lsp-help*"
          "*Fuzzy Completions*"
          "*Apropos*"
          "*Help*"
          "*cvs*"
          "*Buffer List*"
          "*Ibuffer*"
          "*esh command on file*")))

;; https://github.com/manateelazycat/toggle-one-window/blob/main/toggle-one-window.el
(defvar toggle-one-window-window-configuration nil
  "The window configuration use for `toggle-one-window'.")

(defun toggle-one-window ()
  "Toggle between window layout and one window."
  (interactive)
  (if (equal (length (cl-remove-if #'window-dedicated-p (window-list))) 1)
      (if toggle-one-window-window-configuration
          (progn
            (set-window-configuration toggle-one-window-window-configuration)
            (setq toggle-one-window-window-configuration nil))
        (message "No other windows exist."))
    (setq toggle-one-window-window-configuration (current-window-configuration))
    (delete-other-windows)))
(global-set-key (kbd "s-<f11>") 'toggle-one-window)

;; 切换透明背景。
(defun my/toggle-transparency ()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
  (add-to-list 'default-frame-alist '(alpha . (90 . 90))))

;; 在 frame 底部显示窗口。
(setq display-buffer-alist
      `((,(rx bos (or
                   "*Apropos*"
                   "*Help*"
                   "*helpful"
                   "*info*"
                   "*Summary*"
                   "*lsp-help*"
                   "*vterm"
                   "Shell Command Output") (0+ not-newline))
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         (window-height . 0.43)
         (mode apropos-mode help-mode helpful-mode Info-mode Man-mode))))

  (use-package ibuffer
    :straight (:type built-in)
    :bind
    ("C-x C-b" . ibuffer)
    :config
    (setq ibuffer-expert t)
    (setq ibuffer-display-summary nil)
    (setq ibuffer-use-other-window t)
    ;; 隐藏空组。
    (setq ibuffer-show-empty-filter-groups nil)
    (setq ibuffer-movement-cycle nil)
    ;;(setq ibuffer-default-sorting-mode 'filename/process)
    (setq ibuffer-default-sorting-mode 'recency)
    (setq ibuffer-use-header-line t)
    (setq ibuffer-default-shrink-to-minimum-size nil)
    (setq ibuffer-saved-filter-groups nil)
    (setq ibuffer-old-time 48)
    (add-hook 'ibuffer-mode-hook #'hl-line-mode))

  (use-package ibuffer-project
    :hook
    ((ibuffer . (lambda ()
		  (setq ibuffer-filter-groups (ibuffer-project-generate-filter-groups))
		  (unless (eq ibuffer-sorting-mode 'project-file-relative)
		    (ibuffer-do-sort-by-project-file-relative)))))
    :config
    ;; 显示的文件名是相对于 project root 的相对路径。
    (setq ibuffer-formats
	  '((mark modified read-only " "
		  (name 18 18 :left :elide)
		  " "
		  (size 9 -1 :right)
		  " "
		  (mode 16 16 :left :elide)
		  " "
		  project-file-relative))))

  (use-package hydra)

  ;; Ref: https://github.com/abo-abo/hydra/wiki/Ibuffer
  (defhydra hydra-ibuffer-main (:color pink :hint nil)
    "
  ^Mark^         ^Actions^         ^View^          ^Select^              ^Navigation^
  _m_: mark      _D_: delete       _g_: refresh    _q_: quit             _k_:   ↑    _h_
  _u_: unmark    _s_: save marked  _S_: sort       _TAB_: toggle         _RET_: visit
  _*_: specific  _a_: all actions  _/_: filter     _o_: other window     _j_:   ↓    _l_
  _t_: toggle    _._: toggle hydra _H_: help       C-o other win no-select
  "
    ("m" ibuffer-mark-forward)
    ("u" ibuffer-unmark-forward)
    ("*" hydra-ibuffer-mark/body :color blue)
    ("t" ibuffer-toggle-marks)

    ("D" ibuffer-do-delete)
    ("s" ibuffer-do-save)
    ("a" hydra-ibuffer-action/body :color blue)

    ("g" ibuffer-update)
    ("S" hydra-ibuffer-sort/body :color blue)
    ("/" hydra-ibuffer-filter/body :color blue)
    ("H" describe-mode :color blue)

    ("h" ibuffer-backward-filter-group)
    ("k" ibuffer-backward-line)
    ("l" ibuffer-forward-filter-group)
    ("j" ibuffer-forward-line)
    ("RET" ibuffer-visit-buffer :color blue)

    ("TAB" ibuffer-toggle-filter-group)

    ("o" ibuffer-visit-buffer-other-window :color blue)
    ("q" quit-window :color blue)
    ("." nil :color blue))

  (defhydra hydra-ibuffer-mark (:color teal :columns 5
				:after-exit (hydra-ibuffer-main/body))
    "Mark"
    ("*" ibuffer-unmark-all "unmark all")
    ("M" ibuffer-mark-by-mode "mode")
    ("m" ibuffer-mark-modified-buffers "modified")
    ("u" ibuffer-mark-unsaved-buffers "unsaved")
    ("s" ibuffer-mark-special-buffers "special")
    ("r" ibuffer-mark-read-only-buffers "read-only")
    ("/" ibuffer-mark-dired-buffers "dired")
    ("e" ibuffer-mark-dissociated-buffers "dissociated")
    ("h" ibuffer-mark-help-buffers "help")
    ("z" ibuffer-mark-compressed-file-buffers "compressed")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-action (:color teal :columns 4
				  :after-exit
				  (if (eq major-mode 'ibuffer-mode)
				      (hydra-ibuffer-main/body)))
    "Action"
    ("A" ibuffer-do-view "view")
    ("E" ibuffer-do-eval "eval")
    ("F" ibuffer-do-shell-command-file "shell-command-file")
    ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
    ("H" ibuffer-do-view-other-frame "view-other-frame")
    ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
    ("M" ibuffer-do-toggle-modified "toggle-modified")
    ("O" ibuffer-do-occur "occur")
    ("P" ibuffer-do-print "print")
    ("Q" ibuffer-do-query-replace "query-replace")
    ("R" ibuffer-do-rename-uniquely "rename-uniquely")
    ("T" ibuffer-do-toggle-read-only "toggle-read-only")
    ("U" ibuffer-do-replace-regexp "replace-regexp")
    ("V" ibuffer-do-revert "revert")
    ("W" ibuffer-do-view-and-eval "view-and-eval")
    ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
    ("b" nil "back"))

  (defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
    "Sort"
    ("i" ibuffer-invert-sorting "invert")
    ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
    ("v" ibuffer-do-sort-by-recency "recently used")
    ("s" ibuffer-do-sort-by-size "size")
    ("f" ibuffer-do-sort-by-filename/process "filename")
    ("m" ibuffer-do-sort-by-major-mode "mode")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
    "Filter"
    ("m" ibuffer-filter-by-used-mode "mode")
    ("M" ibuffer-filter-by-derived-mode "derived mode")
    ("n" ibuffer-filter-by-name "name")
    ("c" ibuffer-filter-by-content "content")
    ("e" ibuffer-filter-by-predicate "predicate")
    ("f" ibuffer-filter-by-filename "filename")
    (">" ibuffer-filter-by-size-gt "size")
    ("<" ibuffer-filter-by-size-lt "size")
    ("/" ibuffer-filter-disable "disable")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body)

(use-package dired
  :straight (:type built-in)
  :config
  ;; re-use dired buffer, available in Emacs 28
  ;; @see https://debbugs.gnu.org/cgi/bugreport.cgi?bug=20598
  (setq dired-kill-when-opening-new-dired-buffer t)
  ;; "always" means no asking
  (setq dired-recursive-copies 'always)
  ;; "top" means ask once for top level directory
  (setq dired-recursive-deletes 'top)
  ;; search file name only when focus is over file
  (setq dired-isearch-filenames 'dwim)
  ;; if another Dired buffer is visible in another window, use that directory as target for Rename/Copy
  (setq dired-dwim-target t)
  ;; @see https://emacs.stackexchange.com/questions/5649/sort-file-names-numbered-in-dired/5650#5650
  (setq dired-listing-switches "-laGh1v --group-directories-first")
  (put 'dired-find-alternate-file 'disabled nil))

;; dired 显示高亮增强。
(use-package diredfl
  :config
  (diredfl-global-mode))

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(define-key dired-mode-map "." 'hydra-dired/body)

(use-package pyim
  :straight (pyim :repo "tumashu/pyim")
  :demand
  :hook
  ;; 设置缺省输入法为 pyim.
  (emacs-startup . (lambda () (setq default-input-method "pyim")))
  :config
  (global-set-key (kbd "C-\\") 'toggle-input-method)
  ;; 全半角切换。
  (global-set-key (kbd "C-,") 'pyim-punctuation-toggle)
  ;; 中英文切换。
  (global-set-key (kbd "C-.") 'pyim-toggle-input-ascii)
  ;; 金手指设置，可以将光标处的编码，比如：拼音字符串，转换为中文。
  (global-set-key (kbd "M-j") 'pyim-convert-string-at-point)
  ;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp
  (define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)
  ;; 使用全拼。
  (pyim-default-scheme 'quanpin)
  ;; 使用百度云拼音。
  (setq pyim-cloudim 'baidu)
  ;; 开启代码搜索中文功能（比如拼音，五笔码等）。
  (pyim-isearch-mode 1)
  ;; 中文使用全角标点，英文使用半角标点。
  (setq-default pyim-punctuation-translate-p '(auto yes no))   
  ;; 设置模糊音。
  (add-to-list 'pyim-pinyin-fuzzy-alist '("z" "zh"))
  (add-to-list 'pyim-pinyin-fuzzy-alist '("c" "ch"))
  ;; 设置中英文自动切换。
  (setq-default pyim-english-input-switch-functions
		        '(pyim-probe-program-mode
		          pyim-probe-auto-english
		          ;;pyim-probe-dynamic-english
		          ;; pyim-probe-org-structure-template
		          ))
  ;; 显示候选词数量。
  (setq pyim-page-length 8))

;; 清华大学开放中文词库。
(use-package pyim-tsinghua-dict
  :straight (pyim-tsinghua-dict :host github :repo "redguardtoo/pyim-tsinghua-dict")
  :after pyim
  :config
  (pyim-tsinghua-dict-enable))

(use-package org
  :straight (org :repo "https://git.savannah.gnu.org/git/emacs/org-mode.git")
  :ensure auctex
  :demand
  :ensure-system-package
  ((watchexec . watchexec)
   (pygmentize . pygments)
   (magick . imagemagick))
  :config
  ;; 关闭与 pyim 冲突的 C-, 快捷键。
  (define-key org-mode-map (kbd "C-,") nil)
  (setq org-ellipsis ".."
        org-highlight-latex-and-related '(latex)
        ;; 隐藏标记。
        org-hide-emphasis-markers t
        ;; 去掉 * 和 /, 使它们不再具有强调含义。
        org-emphasis-alist
        '(("_" underline)
          ("=" org-verbatim verbatim)
          ("~" org-code verbatim)
          ("+" (:strike-through t)))
        ;; 隐藏 block
        org-hide-block-startup t
        org-hidden-keywords '(title)
        org-cycle-separator-lines 2
        org-cycle-level-faces t
        org-n-level-faces 4
        org-tags-column -80
        org-log-into-drawer t
        org-log-done 'note
        ;; 先从 #+ATTR.* 获取宽度，如果没有设置则默认为 300 。
        org-image-actual-width '(300)
        org-export-with-broken-links t
        org-startup-folded 'content
        ;; 使用 R_{s} 形式的下标（默认是 R_s, 容易与正常内容混淆) 。
        org-use-sub-superscripts nil
        ;; export 时不处理 super/subscripting, 等效于 #+OPTIONS: ^:nil 。
        org-export-with-sub-superscripts nil
        org-startup-indented t
        ;; 支持鼠标点击链接。
        org-return-follows-link t
        org-mouse-1-follows-link t
        ;; 文件链接使用相对路径, 解决 hugo 等 image 引用的问题。
        org-link-file-path-type 'relative)
  (setq org-catch-invisible-edits 'show)
  (setq org-todo-keywords
        '((sequence "☞ TODO(t)" "PROJ(p)" "⚔ INPROCESS(s)" "⚑ WAITING(w)"
                    "|" "☟ NEXT(n)" "✰ Important(i)" "✔ DONE(d)" "✘ CANCELED(c@)")
          (sequence "✍ NOTE(N)" "FIXME(f)" "☕ BREAK(b)" "❤ Love(l)" "REVIEW(r)" )))

  ;; 支持无空格的中文强调。
  ;; (setq org-emphasis-regexp-components
  ;;       '("-[:multibyte:][:space:]('\"{"
  ;;         "-[:multibyte:][:space:].,:!?;'\")}\\["
  ;;         "[:space:]"
  ;;         "[^=~*_]"  ;; 不允许强调字符嵌套。
  ;;         1))
  ;; (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
  ;; (org-element-update-syntax)

  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c b") 'org-switchb)
  (add-hook 'org-mode-hook 'turn-on-auto-fill)
  (add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0))))

;; 自动创建和更新目录。
(use-package org-make-toc
  :config
  (add-hook 'org-mode-hook #'org-make-toc-mode))

(use-package htmlize)

(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)
(setq org-html-self-link-headlines t)
(setq org-html-preamble "<a name=\"top\" id=\"top\"></a>")

(use-package org-html-themify
  :straight (org-html-themify :repo "DogLooksGood/org-html-themify" :files ("*.el" "*.js" "*.css"))
  :hook
  (org-mode . org-html-themify-mode)
  :custom
  (org-html-themify-themes '((dark . doom-palenight) (light . doom-one-light))))

;; Ref: https://github.com/abo-abo/hydra/wiki/Org-clock-and-timers
 (bind-key "C-c w" 'hydra-org-clock/body)
 (defhydra hydra-org-clock (:color blue :hint nil)
   "
^Clock:^ ^In/out^     ^Edit^   ^Summary^    | ^Timers:^ ^Run^           ^Insert
-^-^-----^-^----------^-^------^-^----------|--^-^------^-^-------------^------
(_?_)    _i_n         _e_dit   _g_oto entry | (_z_)     _r_elative      ti_m_e
 ^ ^     _c_ontinue   _q_uit   _d_isplay    |  ^ ^      cou_n_tdown     i_t_em
 ^ ^     _o_ut        ^ ^      _r_eport     |  ^ ^      _p_ause toggle
 ^ ^     ^ ^          ^ ^      ^ ^          |  ^ ^      _s_top
"
   ("i" org-clock-in)
   ("c" org-clock-in-last)
   ("o" org-clock-out)
   
   ("e" org-clock-modify-effort-estimate)
   ("q" org-clock-cancel)

   ("g" org-clock-goto)
   ("d" org-clock-display)
   ("r" org-clock-report)
   ("?" (org-info "Clocking commands"))

  ("r" org-timer-start)
  ("n" org-timer-set-timer)
  ("p" org-timer-pause-or-continue)
  ("s" org-timer-stop)

  ("m" org-timer)
  ("t" org-timer-item)
  ("z" (org-info "Timers")))

(defun my/org-faces ()
  (setq-default line-spacing 2)
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :height (cdr face)))
  ;; 美化 BEGIN_SRC 整行。
  (setq org-fontify-whole-block-delimiter-line t)
  ;; 如果配置参数 :inherit 'fixed-pitch, 则需要明确设置 fixed-pitch 字体，
  ;; 否则选择的缺省字体可能导致显示问题。
  (custom-theme-set-faces
   'user
   '(org-block ((t (:height 0.9))))
   '(org-code ((t (:height 0.9))))
   ;; 调小高度 , 并设置下划线。
   '(org-block-begin-line ((t (:height 0.8 :underline "#A7A6AA"))))
   '(org-block-end-line ((t (:height 0.8 :underline "#A7A6AA"))))
   '(org-meta-line ((t (:height 0.7))))
   '(org-document-info-keyword ((t (:height 0.6))))
   '(org-document-info ((t (:height 0.8))))
   '(org-document-title ((t (:foreground "#ffb86c" :weight bold :height 1.5))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-property-value ((t (:height 0.8))) t)
   '(org-drawer ((t (:height 0.8))) t)
   '(org-special-keyword ((t (:height 0.8))))
   ;; table 使用中英文严格等宽的 Sarasa Mono SC 字体, 避免中英文不对齐。
   '(org-table ((t (:font "Sarasa Mono SC" :height 0.9))))
   '(org-verbatim ((t (:height 0.9))))
   '(org-tag ((t (:weight bold :height 0.8)))))
  (setq-default prettify-symbols-alist '(("#+BEGIN_SRC" . "»")
                                         ("#+END_SRC" . "«")
                                         ("#+begin_src" . "»")
                                         ("#+end_src" . "«")))
  (setq prettify-symbols-unprettify-at-point 'right-edge))
(add-hook 'org-mode-hook 'my/org-faces)
(add-hook 'org-mode-hook 'prettify-symbols-mode)

(use-package org-superstar
  :after (org)
  :hook
  (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉"  "🞛" "✿" "○" "▷")))

(use-package org-fancy-priorities
  :after (org)
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("[A]" "[B]" "[C]")))

;; 编辑时显示隐藏的标记。
(use-package org-appear
  :config
  (add-hook 'org-mode-hook 'org-appear-mode))

(defun my/org-mode-visual-fill (fill width)
  (setq-default
   ;; 自动换行的字符数。
   fill-column fill
   ;; window 可视化行宽度，值应该比 fill-column 大，否则超出的字符被隐藏。
   visual-fill-column-width width
   visual-fill-column-fringes-outside-margins nil
   ;; 使用 setq-default 来设置居中, 否则可能不生效。
   visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :demand
  :after (org)
  :hook
  (org-mode . (lambda () (my/org-mode-visual-fill 110 130)))
  :config
  ;; 文字缩放时自动调整 visual-fill-column-width 。
  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust))

(use-package org-download
  :ensure-system-package pngpaste
  :bind
  ("<f6>" . org-download-screenshot)
  :config
  (setq-default org-download-image-dir "./images/")
  (setq org-download-method 'directory
        org-download-display-inline-images 'posframe
        org-download-screenshot-method "pngpaste %s"
        org-download-image-attr-list '("#+ATTR_HTML: :width 400 :align center"))
  (add-hook 'dired-mode-hook 'org-download-enable)
  (org-download-enable))

(setq org-confirm-babel-evaluate nil)
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
;; 为 #+begin_quote 和  #+begin_verse 添加特殊 face 。
(setq org-fontify-quote-and-verse-blocks t)
;; 不自动缩进。
(setq org-src-preserve-indentation t)
(setq org-edit-src-content-indentation 0)
;; 在当前窗口编辑 SRC Block.
(setq org-src-window-setup 'current-window)

(require 'org)
(use-package ob-go)
(use-package ox-reveal)
(use-package ox-gfm)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (js . t)
   (go . t)
   (emacs-lisp . t)
   (python . t)
   (dot . t)
   (css . t)))

(use-package org-contrib
  :straight (org-contrib :repo "https://git.sr.ht/~bzg/org-contrib")
  :demand)

(require 'ox-latex)
(with-eval-after-load 'ox-latex
  ;; latex image 的默认宽度, 可以通过 #+ATTR_LATEX :width xx 配置。
  (setq org-latex-image-default-width "0.7\\linewidth")
  ;; 默认使用 booktabs 来格式化表格。
  (setq org-latex-tables-booktabs t)
  ;; 保存 LaTeX 日志文件。
  (setq org-latex-remove-logfiles nil)
  (setq org-latex-pdf-process '("latexmk -xelatex -quiet -shell-escape -f %f"))
  ;; ;; Alist of packages to be inserted in every LaTeX header.
  ;; (setq org-latex-packages-alist
  ;;       (quote (("" "color" t)
  ;;               ("" "xcolor" t)
  ;;               ("" "listings" t)
  ;;               ("" "fontspec" t)
  ;;               ("" "parskip" t) ;; 增加正文段落的间距
  ;;               ("AUTO" "inputenc" t))))
  (add-to-list 'org-latex-classes
               '("ctexart"
                 "\\documentclass[lang=cn,11pt,a4paper,table]{ctexart}
                 [NO-DEFAULT-PACKAGES]
                 [PACKAGES]
                 [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  ;; 自定义 latex 语言环境(基于 tcolorbox), 参考：https://blog.shimanoke.com/ja/posts/output-latex-code-with-tcolorbox/
  (setq org-latex-custom-lang-environments
        '((c "\\begin{programlist}[label={%l}]{c}{: %c}\n%s\\end{programlist}")
          (ditaa "\\begin{programlist}[label={%l}]{text}{: %c}\n%s\\end{programlist}")
          (emacs-lisp "\\begin{programlist}[label={%l}]{lisp}{: %c}\n%s\\end{programlist}")
          (ruby "\\begin{programlist}[label={%l}]{ruby}{: %c}\n%s\\end{programlist}")
          (latex "\\begin{programlist}[label={%l}]{latex}{: %c}\n%s\\end{programlist}")
          (go "\\begin{programlist}[label={%l}]{go}{: %c}\n%s\\end{programlist}")
          (lua "\\begin{programlist}[label={%l}]{lua}{: %c}\n%s\\end{programlist}")
          (java "\\begin{programlist}[label={%l}]{java}{: %c}\n%s\\end{programlist}")
          (javascript "\\begin{programlist}[label={%l}]{javascript}{: %c}\n%s\\end{programlist}")
          (json "\\begin{programlist}[label={%l}]{json}{: %c}\n%s\\end{programlist}")
          (plantuml "\\begin{programlist}[label={%l}]{text}{: %c}\n%s\\end{programlist}")
          (yaml "\\begin{programlist}[label={%l}]{yaml}{: %c}\n%s\\end{programlist}")
          (maxima "\\begin{programlist}[label={%l}]{text}{: %c}\n%s\\end{programlist}")
          (ipython "\\begin{programlist}[label={%l}]{python}{: %c}\n%s\\end{programlist}")
          (python "\\begin{programlist}[label={%l}]{python}{: %c}\n%s\\end{programlist}")
          (perl "\\begin{programlist}[label={%l}]{perl}{: %c}\n%s\\end{programlist}")
          (html "\\begin{programlist}[label={%l}]{html}{: %c}\n%s\\end{programlist}")
          (org "\\begin{programlist}[label={%l}]{text}{: %c}\n%s\\end{programlist}")
          (typescript "\\begin{programlist}[label={%l}]{typescript}{: %c}\n%s\\end{programlist}")
          (scss "\\begin{programlist}[label={%l}]{scss}{: %c}\n%s\\end{programlist}")
          (sh "\\begin{programlist}[label={%l}]{shell}{: %c}\n%s\\end{programlist}")
          (bash "\\begin{programlist}[label={%l}]{shell}{: %c}\n%s\\end{programlist}")
          (shell "\\begin{programlist}[label={%l}]{shell}{: %c}\n%s\\end{programlist}")
          (shellinput "\\begin{shellinput}[%c]\n%s\\end{shellinput}")
          (shelloutput "\\begin{shelloutput}[%c]\n%s\\end{shelloutput}")))
  (setq org-latex-listings 'listings))

(use-package org-tree-slide
  :after (org)
  :commands org-tree-slide-mode
  :bind
  (:map org-mode-map
        ("<f8>" . org-tree-slide-mode)
        :map org-tree-slide-mode-map
        ("<f9>" . org-tree-slide-content)
        ("<left>" . org-tree-slide-move-previous-tree)
        ("<right>" . org-tree-slide-move-next-tree))
  :hook
  ((org-tree-slide-play . (lambda ()
                            (blink-cursor-mode +1)
                            (setq-default x-stretch-cursor -1)
                            ;;(beacon-mode -1)
                            (redraw-display)
                            (org-display-inline-images)
                            (text-scale-increase 1)
                            ;;(centaur-tabs-mode 0)
                            ;;(awesome-tab-mode 0)
                            (read-only-mode 1)))
   (org-tree-slide-stop . (lambda ()
                            (blink-cursor-mode +1)
                            (setq-default x-stretch-cursor t)
                            (text-scale-increase 0)
                            ;;(beacon-mode +1)
                            ;;(centaur-tabs-mode 1)
                            ;;(awesome-tab-mode 1)
                            (read-only-mode -1))))
  :config
  (setq org-tree-slide-header nil)
  (setq org-tree-slide-heading-emphasis nil)
  (setq org-tree-slide-slide-in-effect t)
  (setq org-tree-slide-content-margin-top 0)
  (setq org-tree-slide-activate-message " ")
  (setq org-tree-slide-deactivate-message " ")
  (setq org-tree-slide-modeline-display nil)
  (setq org-tree-slide-breadcrumbs " 👉 ")
  ;; 隐藏 #+KEYWORD 行内容。
  (defun +org-present-hide-blocks-h ()
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^[[:space:]]*\\(#\\+\\)\\(\\(?:BEGIN\\|END\\|begin\\|end\\|ATTR\\|DOWNLOADED\\)[^[:space:]]+\\).*" nil t)
        (org-flag-region (match-beginning 0) (match-end 0) org-tree-slide-mode t))))
  (add-hook 'org-tree-slide-play-hook #'+org-present-hide-blocks-h))

;; 设置缺省 prefix key, 必须在加载 org-journal 前设置。
(setq org-journal-prefix-key "C-c j")

(use-package org-journal
  :demand
  :commands org-journal-new-entry
  :init
  (defun org-journal-save-entry-and-exit()
    (interactive)
    (save-buffer)
    (kill-buffer-and-window))
  :bind
  (:map org-journal-mode-map
        ("C-c C-j" . 'org-journal-new-entry)
        ("C-c C-e" . 'org-journal-save-entry-and-exit))
  :config
  (setq org-journal-file-type 'monthly)
  (setq org-journal-dir "~/journal")
  (setq org-journal-find-file 'find-file)

  ;; 加密 journal 文件。
  (setq org-journal-enable-encryption t)
  (setq org-journal-encrypt-journal t)
  (defun my-old-carryover (old_carryover)
    (save-excursion
      (let ((matcher (cdr (org-make-tags-matcher org-journal-carryover-items))))
        (dolist (entry (reverse old_carryover))
          (save-restriction
            (narrow-to-region (car entry) (cadr entry))
            (goto-char (point-min))
            (org-scan-tags '(lambda ()
                              (org-set-tags ":carried:"))
                           matcher org--matcher-tags-todo-only))))))
  (setq org-journal-handle-old-carryover 'my-old-carryover)

  ;; journal 文件头。
  (defun org-journal-file-header-func (time)
    "Custom function to create journal header."
    (concat
     (pcase org-journal-file-type
       (`daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything")
       (`weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
       (`monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
       (`yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))
  (setq org-journal-file-header 'org-journal-file-header-func)

  ;; org-agenda 集成。
  ;; automatically adds the current and all future journal entries to the agenda
  ;;(setq org-journal-enable-agenda-integration t)
  ;; When org-journal-file-pattern has the default value, this would be the regex.
  (setq org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|[0-9]\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")
  (add-to-list 'org-agenda-files org-journal-dir)

  ;; org-capture 集成。
  (defun org-journal-find-location ()
    (org-journal-new-entry t)
    (unless (eq org-journal-file-type 'daily)
      (org-narrow-to-subtree))
    (goto-char (point-max)))

  ;; (setq org-capture-templates
  ;;       (cons '("j" "Journal" plain (function org-journal-find-location)
  ;;               "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
  ;;               :jump-to-captured t :immediate-finish t) org-capture-templates))
  )

(setq vc-follow-symlinks t)

(use-package magit
  :straight (magit :repo "magit/magit" :files ("lisp/*.el"))
  :custom
  ;; 在当前 window 中显示 magit buffer。
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-commit-ask-to-stage nil)
  ;; 默认不选中 magit buffer。
  (magit-display-buffer-noselect t)
  (magit-log-arguments '("--graph" "--decorate" "--color"))
  :config
  ;; kill 所有 magit buffer。
  (defun my-magit-kill-buffers (&rest _)
    "Restore window configuration and kill all Magit buffers."
    (interactive)
    (magit-restore-window-configuration)
    (let ((buffers (magit-mode-get-buffers)))
      (when (eq major-mode 'magit-status-mode)
        (mapc (lambda (buf)
                (with-current-buffer buf
                  (if (and magit-this-process
                           (eq (process-status magit-this-process) 'run))
                      (bury-buffer buf)
                    (kill-buffer buf))))
              buffers))))
  (setq magit-bury-buffer-function #'my-magit-kill-buffers))

(use-package git-link
  :config
  (global-set-key (kbd "C-c g l") 'git-link)
  (setq git-link-use-commit t))

(use-package diff-mode
  :straight (:type built-in)
  :init
  (setq diff-default-read-only t)
  (setq diff-advance-after-apply-hunk t)
  (setq diff-update-on-the-fly t)
  (setq diff-refine nil)
  ;; better for patches
  (setq diff-font-lock-prettify nil))

(use-package ediff
  :straight (:type built-in)
  :config
  (setq ediff-keep-variants nil)
  ;; 忽略空格。
  (setq ediff-diff-options "-w")
  (setq ediff-split-window-function 'split-window-horizontally)
  ;; 不创建新的 frame 来显示 Control-Panel。
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  ;; 启动 ediff 前关闭 treemacs frame, 否则 Control-Panel 显示异常。
  (add-hook 'ediff-before-setup-hook
            (lambda ()
              (require 'treemacs)
              (if (string-match "visible" (symbol-name (treemacs-current-visibility)))
                  (delete-window (treemacs-get-local-window)) ) ))

  ;; ediff 时自动展开 org-mode, https://dotemacs.readthedocs.io/en/latest/#ediff
  (defun f-ediff-org-showhide (buf command &rest cmdargs)
    "If buffer exists and is orgmode then execute command"
    (when buf
      (when (eq (buffer-local-value 'major-mode (get-buffer buf)) 'org-mode)
        (save-excursion (set-buffer buf) (apply command cmdargs)))))

  (defun f-ediff-org-unfold-tree-element ()
    "Unfold tree at diff location"
    (f-ediff-org-showhide ediff-buffer-A 'org-reveal)
    (f-ediff-org-showhide ediff-buffer-B 'org-reveal)
    (f-ediff-org-showhide ediff-buffer-C 'org-reveal))

  (defun f-ediff-org-fold-tree ()
    "Fold tree back to top level"
    (f-ediff-org-showhide ediff-buffer-A 'hide-sublevels 1)
    (f-ediff-org-showhide ediff-buffer-B 'hide-sublevels 1)
    (f-ediff-org-showhide ediff-buffer-C 'hide-sublevels 1))

  ;; disable ligatures in ediff completely
  (add-hook 'ediff-mode-hook (lambda () (setq auto-composition-mode nil)))
  (add-hook 'ediff-select-hook 'f-ediff-org-unfold-tree-element)
  (add-hook 'ediff-unselect-hook 'f-ediff-org-fold-tree))

(defhydra hydra-ediff (:color blue :hint nil)
  "
^Buffers           Files           VC                     Ediff regions
----------------------------------------------------------------------
_b_uffers           _f_iles (_=_)       _r_evisions              _l_inewise
_B_uffers (3-way)   _F_iles (3-way)                          _w_ordwise
                  _c_urrent file
"
  ("b" ediff-buffers)
  ("B" ediff-buffers3)
  ("=" ediff-files)
  ("f" ediff-files)
  ("F" ediff-files3)
  ("c" ediff-current-file)
  ("r" ediff-revision)
  ("l" ediff-regions-linewise)
  ("w" ediff-regions-wordwise))

(add-hook 'prog-mode-hook (lambda () (hs-minor-mode t)))
(defhydra hydra-hs (:idle 1.0)
   "
Hide^^            ^Show^            ^Toggle^    ^Navigation^
----------------------------------------------------------------
_h_ hide all      _s_ show all      _t_oggle    _n_ext line
_d_ hide block    _a_ show block              _p_revious line
_l_ hide level

_SPC_ cancel
"
   ("s" hs-show-all)
   ("h" hs-hide-all)
   ("a" hs-show-block)
   ("d" hs-hide-block)
   ("t" hs-toggle-hiding)
   ("l" hs-hide-level)
   ("n" forward-line)
   ("p" (forward-line -1))
   ("SPC" nil)
)

(global-set-key (kbd "s-@") 'hydra-hs/body) ;;Example binding

;; 显示缩进。
(use-package highlight-indent-guides
  :demand
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-suppress-auto-error t)
  (highlight-indent-guides-delay 0.1)
  :config
  (add-hook 'python-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'js-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'web-mode-hook 'highlight-indent-guides-mode))

(use-package tree-sitter
  :demand t
  :config
  (global-tree-sitter-mode)
  ;; 对于支持的语言（tree-sitter-major-mode-language-alist）使用
  ;; tree-sitter 提供的高亮来取代内置的、基于 font-lock 正则的低效高亮模式。
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )

(use-package tree-sitter-langs
  :demand)

(use-package posframe)

(use-package  dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  )

;; 融合 `lsp-bridge' `find-function' 以及 `dumb-jump' 的智能跳转
(defun lsp-bridge-jump ()
  (interactive)
  (cond
   ((eq major-mode 'emacs-lisp-mode)
    (let ((symb (function-called-at-point)))
      (when symb
        (find-function symb))))
   (lsp-bridge-mode
    (lsp-bridge-find-def))
   (t
    (require 'dumb-jump)
    (dumb-jump-go))))

(defun lsp-bridge-jump-back ()
  (interactive)
  (cond
   (lsp-bridge-mode
    (lsp-bridge-return-from-def))
   (t
    (require 'dumb-jump)
    (dumb-jump-back))))

(use-package lsp-bridge
  :demand
  :after (markdown-mode)
  :straight (:host github :repo "manateelazycat/lsp-bridge" :files ("*" "acm/*"))
  :bind
  (:map lsp-bridge-mode-map
        ("M-."  . lsp-bridge-jump)
        ("M-," . lsp-bridge-jump-back)
        ("M-?" . lsp-bridge-find-references)
        ("M-i" . lsp-bridge-lookup-documentation)
        ("M-n" . lsp-bridge-popup-documentation-scroll-up)
        ("M-p" . lsp-bridge-popup-documentation-scroll-down)
        ("s-C-n" . lsp-bridge-jump-to-next-diagnostic)
        ("s-C-p" . lsp-bridge-jump-to-prev-diagnostic))
  :config
  (setq lsp-bridge-enable-log t)
  (setq lsp-bridge-enable-signature-help t)
  (require 'lsp-bridge-icon)
  (require 'lsp-bridge-orderless)
  (global-lsp-bridge-mode)
  (add-to-list 'lsp-bridge-org-babel-lang-list "emacs-lisp")
  (add-to-list 'lsp-bridge-org-babel-lang-list "sh")
  (add-to-list 'lsp-bridge-org-babel-lang-list "shell")
  (when (> (frame-pixel-width) 3000) (custom-set-faces '(corfu-default ((t (:height 1.3))))))
  ;; 通过Cape融合不同的补全后端，比如lsp-bridge、 tabnine、 file、 dabbrev.
  (defun lsp-bridge-mix-multi-backends ()
    (setq-local completion-category-defaults nil)
    (setq-local completion-at-point-functions
                (list
                 (cape-capf-buster
                  (cape-super-capf
                   #'lsp-bridge-capf
                   #'cape-file
                   #'cape-dabbrev
                   )
                  'equal)
                 )))

  (dolist (hook lsp-bridge-default-mode-hooks)
    (add-hook hook (lambda ()
                     (lsp-bridge-mix-multi-backends) ; 通过 Cape 融合多个补全后端
                     ))))

(use-package emacs
  :straight (:type built-in)
  :ensure-system-package
  ((pyenv . "brew install --HEAD pyenv")
   (pyenv-virtualenv . "brew install --HEAD pyenv-virtualenv")))

(defun my/python-setup-shell (&rest args)
  (if (executable-find "ipython")
      (progn
        (setq python-shell-interpreter "ipython")
        (setq python-shell-interpreter-args "--simple-prompt -i"))
    (progn
      (setq python-shell-interpreter "python")
      (setq python-shell-interpreter-args "-i"))))

;; (defun my/python-setup-checkers (&rest args)
;;   (when (fboundp 'flycheck-set-checker-executable)
;;     (let ((pylint (executable-find "pylint"))
;;           (flake8 (executable-find "flake8")))
;;       (when pylint
;;         (flycheck-set-checker-executable "python-pylint" pylint))
;;       (when flake8
;;         (flycheck-set-checker-executable "python-flake8" flake8)))))

(use-package python
  :ensure-system-package
  ((pylint . pylint)
   (flake8 . flake8)
   (ipython . "pip install ipython"))
  :init
  (setq python-indent-guess-indent-offset t)  
  (setq python-indent-guess-indent-offset-verbose nil)
  (setq python-indent-offset 4)
  (with-eval-after-load 'exec-path-from-shell (exec-path-from-shell-copy-env "PYTHONPATH"))
  :hook
  (python-mode . (lambda ()
                   (my/python-setup-shell)
                   ;; (my/python-setup-checkers)
                   )))

  ;; 使用 yapf 格式化 python 代码。
(use-package yapfify
  :straight (:host github :repo "JorisE/yapfify"))

(use-package lsp-pyright
  :after (python)
  :ensure-system-package
  ((pyright . "npm update -g pyright")
   (yapf . "pip install yapf"))
  :init
  (defvar pyright-directory "~/.emacs.d/.cache/lsp/npm/pyright/lib")
  (if (not (file-exists-p pyright-directory))
      (make-directory pyright-directory t))
  (when (executable-find "python3")
    (setq lsp-pyright-python-executable-cmd "python3"))
  :hook
  (python-mode . (lambda () (require 'lsp-pyright) (yapf-mode))))

(use-package go-mode
  :ensure-system-package (gopls . "go install golang.org/x/tools/gopls@latest")
  :init
  (setq godoc-reuse-buffer t)
  ;; goimports 在格式化 buffer 的同时自动 import package。
  (setq gofmt-command "goimports")
  ;; 需要安装 gogetdoc 命令。
  ;;(setq godoc-at-point-function #'godoc-gogetdoc)
  (defun lsp-go-save-hooks ()
    (add-hook 'before-save-hook #'gofmt-before-save t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  :hook (go-mode . lsp-go-save-hooks)
  :bind
  (:map go-mode-map
        ("C-c C-a" . go-import-add)
        ("C-c C-c" . go-run-buffer)
        ("C-c C-r" . go-remove-unused-imports)
        ("C-c C-f" . gofmt)
        ("C-c C-d" . godoc-at-point)))

(defvar go--tools '("golang.org/x/tools/gopls"
                    "golang.org/x/tools/cmd/goimports"
                    "honnef.co/go/tools/cmd/staticcheck"
                    "github.com/go-delve/delve/cmd/dlv"
                    "github.com/zmb3/gogetdoc"
                    "github.com/josharian/impl"
                    "github.com/cweill/gotests/..."
                    "github.com/fatih/gomodifytags"
                    "github.com/davidrjenni/reftools/cmd/fillstruct"))

(defun go-update-tools ()
  (interactive)
  (unless (executable-find "go")
    (user-error "Unable to find `go' in `exec-path'!"))
  (message "Installing go tools...")
  (dolist (pkg go--tools)
    (set-process-sentinel
     (start-process "go-tools" "*Go Tools*" "go" "install" "-v" "-x" (concat pkg "@latest"))
     (lambda (proc _)))))

(use-package go-fill-struct)
(use-package go-impl)

(use-package go-tag
  :bind
  (:map go-mode-map
        ("C-c t a" . go-tag-add)
        ("C-c t r" . go-tag-remove))
  :init
  (setq go-tag-args (list "-transform" "camelcase")))

(use-package go-gen-test
  :bind
  (:map go-mode-map
        ("C-c t g" . go-gen-test-dwim)))

(use-package gotest
  :bind
  (:map go-mode-map
        ("C-c t f" . go-test-current-file)
        ("C-c t t" . go-test-current-test)
        ("C-c t j" . go-test-current-project)
        ("C-c t b" . go-test-current-benchmark)
        ("C-c t c" . go-test-current-coverage)
        ("C-c t x" . go-run)))

(use-package go-playground
  :diminish
  :commands (go-playground-mode))

(use-package markdown-mode
  :ensure-system-package multimarkdown
  :commands (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (when (executable-find "multimarkdown")
    (setq markdown-command "multimarkdown"))
  (setq markdown-enable-wiki-links t)
  (setq markdown-italic-underscore t)
  (setq markdown-asymmetric-header t)
  (setq markdown-make-gfm-checkboxes-buttons t)
  (setq markdown-gfm-uppercase-checkbox t)
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-gfm-additional-languages "Mermaid")
  (setq markdown-content-type "application/xhtml+xml")
  (setq markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
                             "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css"))
  (setq markdown-xhtml-header-content "
<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
<style>
body {
  box-sizing: border-box;
  max-width: 740px;
  width: 100%;
  margin: 40px auto;
  padding: 0 10px;
}
</style>
<link rel='stylesheet' href='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/default.min.css'>
<script src='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('markdown-body');
  document.querySelectorAll('pre code').forEach((code) => {
    if (code.className != 'mermaid') {
      hljs.highlightBlock(code);
    }
  });
});
</script>
<script src='https://unpkg.com/mermaid@8.4.8/dist/mermaid.min.js'></script>
<script>
mermaid.initialize({
  theme: 'default',  // default, forest, dark, neutral
  startOnLoad: true
});
</script>
"))

(use-package grip-mode
  :ensure-system-package
  (grip . "pip install grip")
  :bind
  (:map markdown-mode-command-map ("g" . grip-mode))
  :config
  (setq grip-preview-use-webkit nil)
  ;; 支持网络访问（默认 localhost）。
  (setq grip-preview-host "0.0.0.0")
  ;; 保存文件时才更新预览。
  (setq grip-update-after-change nil)
  ;; 从 ~/.authinfo 文件获取认证信息。
  (require 'auth-source)
  (let ((credential (auth-source-user-and-password "api.github.com")))
    (setq grip-github-user (car credential)
          grip-github-password (cadr credential))))

(use-package markdown-toc
  :after(markdown-mode)
  :bind (:map markdown-mode-command-map
              ("r" . markdown-toc-generate-or-refresh-toc)))

;; (defun my/use-eslint-from-node-modules ()
;;   ;; use local eslint from node_modules before global
;;   ;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
;;   (let* ((root (locate-dominating-file (or (buffer-file-name) default-directory) "node_modules"))
;;          (eslint (and root (expand-file-name "node_modules/eslint/bin/eslint.js" root))))
;;     (when (and eslint (file-executable-p eslint))
;;       (setq-local flycheck-javascript-eslint-executable eslint))))

;; (shell-command "which npm &>/dev/null || brew install npm &>/dev/null")
(defun my/setup-tide-mode ()
  "Use hl-identifier-mode only on js or ts buffers."
  (when (and (stringp buffer-file-name)
             (string-match "\\.[tj]sx?\\'" buffer-file-name))
    (tide-setup)
    ;;(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
    (tide-hl-identifier-mode +1)))

;; for .ts and .tsx file
(use-package typescript-mode
  :ensure-system-package
  (eslint . "npm install -g eslint babel-eslint eslint-plugin-react")
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))
  :hook
  ((typescript-mode . my/setup-tide-mode))
  :config
  ;;(flycheck-add-mode 'typescript-tslint 'typescript-mode)
  (setq typescript-indent-level 2))

(use-package tide
  :hook ((before-save . tide-format-before-save))
  :ensure-system-package
  ((typescript-language-server . "npm install -g typescript-language-server")
  (tsc . "npm install -g typescript"))
  :config
  ;; 开启 tsserver 的 debug 日志模式。
  (setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log")))

(use-package js2-mode
  ;;:after (tide flycheck)
  :after (tide)
  :config
  ;; js-mode-map 将 M-. 绑定到 js-find-symbol, 没有使用 tide 和 lsp, 所以需要解
  ;; 绑。这样 M-. 被 tide 绑定到 tide-jump-to-definition.
  (define-key js-mode-map (kbd "M-.") nil)
  ;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-hook 'js-mode-hook 'js2-minor-mode)
  ;; 为 js/jsx 文件启动 tide.
  (add-hook 'js-mode-hook 'my/setup-tide-mode)
  ;; disable jshint since we prefer eslint checking
  ;; (setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers '(javascript-jshint)))
  ;; (flycheck-add-mode 'javascript-eslint 'js-mode)
  ;; (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
  ;; (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode)))

(use-package web-mode
  ;;:after (flycheck)
  :init
  (add-to-list 'auto-mode-alist '("\\.jinja2?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tmpl\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.gotmpl\\'" . web-mode))
  :custom
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-css-colorization t)
  (web-mode-markup-indent-offset 4)
  (web-mode-css-indent-offset 4)
  (web-mode-code-indent-offset 4)
  (web-mode-enable-auto-quoting nil)
  (web-mode-enable-block-face t)
  (web-mode-enable-current-element-highlight t)
  ;;:config
  ;;(flycheck-add-mode 'javascript-eslint 'web-mode)
)

(use-package yaml-mode
  :ensure-system-package
  (yaml-language-server . "npm install -g yaml-language-server")
  :hook
  (yaml-mode . (lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode)))

(use-package envrc
  :ensure-system-package direnv
  :hook (after-init . envrc-global-mode)
  :config
  (define-key envrc-mode-map (kbd "C-c e") 'envrc-command-map))

;; 移动到行或代码的开头、结尾。
(use-package mwim
  :bind (([remap move-beginning-of-line] . mwim-beginning-of-code-or-line)
         ([remap move-end-of-line] . mwim-end-of-code-or-line)))

;; 智能括号。
(use-package smartparens
  :demand
  :config
  (smartparens-global-mode t)
  (show-smartparens-global-mode t))

;; 彩色括号。
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; 高亮匹配的括号。
(use-package paren
  :straight (:type built-in)
  :hook
  (after-init . show-paren-mode)
  :init
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))

;; 开发文档。
(use-package dash-at-point
  :bind
  (("C-c d ." . dash-at-point)
   ("C-c d d" . dash-at-point-with-docset)))

(use-package expand-region
  :init
  (define-advice set-mark-command (:before-while (arg))
    "Repeat C-SPC to expand region."
    (interactive "P")
    (if (eq last-command 'set-mark-command)
        (progn
          (er/expand-region 1)
          nil)
      t))
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package dap-mode
  :disabled
  :demand
  :config
  (dap-auto-configure-mode 1)
  (require 'dap-chrome))

(defun my/project-try-local (dir)
  "Determine if DIR is a non-Git project."
  (catch 'ret
    (let ((pr-flags '((".project")
                      ("go.mod" "pom.xml" "package.json")
                      ("Makefile" "README.org" "README.md"))))
      (dolist (current-level pr-flags)
        (dolist (f current-level)
          (when-let ((root (locate-dominating-file dir f)))
            (throw 'ret (cons 'local root))))))))

(setq project-find-functions '(my/project-try-local project-try-vc))

(cl-defmethod project-root ((project (head local)))
  (cdr project))

(defun my/project-info ()
  (interactive)
  (message "%s" (project-current t)))

(defun my/project-add (dir)
  (interactive "DDirectory: \n")
  ;; 使用 project-remember-project 报错。
  (project-remember-projects-under dir nil))

(defun my/project-new-root ()
  (interactive)
  (let* ((root-dir (read-directory-name "Root: "))
         (f (expand-file-name ".project" root-dir)))
    (message "Create %s..." f)
    (make-directory root-dir t)
    (when (not (file-exists-p f))
      (make-empty-file f))
    (my/project-add root-dir)))

(defun my/project-remember-advice (fn pr &optional no-write)
  (let* ((remote? (file-remote-p (project-root pr)))
         (no-write (if remote? t no-write)))
    (funcall fn pr no-write)))

(advice-add 'project-remember-project :around 'my/project-remember-advice)

(defun my/project-discover ()
  (interactive)
  (dolist (search-path '("~/go/src/github.com/*" "~/go/src/github.com/*" "~/go/src/k8s.io/*" "~/go/src/gitlab.*/*"))
    (dolist (file (file-expand-wildcards search-path))
      (when (file-directory-p file)
          (message "dir %s" file)
          ;; project-remember-projects-under 列出 file 下的目录, 分别加到 project-list-file 中。
          (project-remember-projects-under file nil)
          (message "added project %s" file)))))

(setq project-vc-ignores '("vendor/"))

(use-package treemacs
  :init
  (with-eval-after-load 'winum (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq
     treemacs-collapse-dirs                 3
     treemacs-deferred-git-apply-delay      0.1
     treemacs-display-in-side-window        t
     treemacs-eldoc-display                 t
     treemacs-file-event-delay              300
     treemacs-file-follow-delay             0.01
     treemacs-follow-after-init             t
     treemacs-git-command-pipe              ""
     treemacs-goto-tag-strategy             'refetch-index
     treemacs-indentation                   1
     treemacs-indentation-string            " "
     treemacs-is-never-other-window         t
     treemacs-max-git-entries               500
     treemacs-missing-project-action        'ask
     treemacs-no-png-images                 nil
     treemacs-no-delete-other-windows       t
     treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
     treemacs-position                      'left
     treemacs-recenter-distance             0.01
     treemacs-recenter-after-file-follow    t
     treemacs-recenter-after-tag-follow     t
     treemacs-recenter-after-project-jump   'always
     treemacs-recenter-after-project-expand 'on-distance
     treemacs-shownn-cursor                 t
     treemacs-show-hidden-files             t
     treemacs-silent-filewatch              nil
     treemacs-silent-refresh                nil
     treemacs-sorting                       'alphabetic-asc
     treemacs-select-when-already-in-treemacs 'stay
     treemacs-space-between-root-nodes      nil
     treemacs-tag-follow-cleanup            t
     treemacs-tag-follow-delay              1
     treemacs-width                         35
     treemacs-width-increment               5
     treemacs-width-is-initially-locked     nil
     treemacs-project-follow-cleanup        t
     imenu-auto-rescan                      t)
    (treemacs-resize-icons 11)
    (treemacs-follow-mode t)
    ;;(treemacs-tag-follow-mode t)
    ;;(treemacs-project-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (treemacs-indent-guide-mode t)
    (treemacs-git-mode 'deferred)
    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package deadgrep
  :ensure-system-package (rg . ripgrep)
  :bind ("<f5>" . deadgrep))

;; 为远程 buffer 关闭 treemacs, 避免建立新连接耗时。
(add-hook 'buffer-list-update-hook
          (lambda ()
            (when (file-remote-p default-directory)
              (require 'treemacs)
              (if (string-match "visible" (symbol-name (treemacs-current-visibility)))
                  (delete-window (treemacs-get-local-window))))))

(require 'grep)
(dolist (dir '(".cache" "vendor" "node_modules"))
  (add-to-list 'grep-find-ignored-directories dir))
(dolist (item '("GPATH" "GRTAGS" "GTAGS" "TAGS" ".classpath" ".project" ".DS_Store" ))
  (add-to-list 'grep-find-ignored-files item))
(setq grep-highlight-matches t)

;; 编辑 grep buffers, 可以和 consult-grep 和 embark-export 联合使用。
(use-package wgrep)

(use-package ctrlf
  :config
  (ctrlf-mode +1)
  (add-hook 'pdf-isearch-minor-mode-hook (lambda () (ctrlf-local-mode -1))))

;; browser-url 使用 Mac 默认浏览器。
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

(use-package engine-mode
  :config
  (engine/set-keymap-prefix (kbd "C-c s"))
  (engine-mode t)
  ;;(setq engine/browser-function 'eww-browse-url)
  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "h")

  (defengine google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "g")

  (defengine twitter
    "https://twitter.com/search?q=%s"
    :keybinding "t")

  (defengine wikipedia
    "http://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s"
    :keybinding "w"
    :docstring "Searchin' the wikis."))

;; 添加环境变量 export PATH="/usr/local/opt/curl/bin:$PATH"
(use-package emacs
  :straight (:type built-in)
  :ensure-system-package ("/usr/local/opt/curl/bin/curl" . "brew install curl"))

(setq my/socks-host "127.0.0.1")
(setq my/socks-port 13659)
(setq my/socks-proxy (format "socks5h://%s:%d" my/socks-host my/socks-port))

(use-package mb-url-http
  :demand
  :straight (mb-url :repo "dochang/mb-url")
  :commands (mb-url-http-around-advice)
  :init
  (require 'auth-source)
  (let ((credential (auth-source-user-and-password "api.github.com")))
    (setq github-user (car credential)
          github-password (cadr credential))
    (setq github-auth (concat github-user ":" github-password))
    (setq mb-url-http-backend 'mb-url-http-curl
          mb-url-http-curl-program "/usr/local/opt/curl/bin/curl"
          mb-url-http-curl-switches `("-k" "-x" ,my/socks-proxy
                                      ;;"--max-time" "300"
                                      ;;"-u" ,github-auth
                                      ;;"--user-agent" "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36"
                                      ))))

(defun proxy-socks-show ()
  "Show SOCKS proxy."
  (interactive)
  (when (fboundp 'cadddr)
    (if (bound-and-true-p socks-noproxy)
        (message "Current SOCKS%d proxy is %s:%d" 5 my/socks-host my/socks-port)
      (message "No SOCKS proxy"))))

(defun proxy-socks-enable ()
  "使用 socks 代理 url 访问请求。"
  (interactive)
  (require 'socks)
  (setq url-gateway-method 'socks
        socks-noproxy '("localhost" "10.0.0.0/8" "172.0.0.0/8" "*cn" "*alibaba-inc.com" "*taobao.com" "*antfin-inc.com")
        socks-server `("Default server" ,my/socks-host ,my/socks-port 5))
  (setenv "all_proxy" my/socks-proxy)
  (proxy-socks-show)
  ;;url-retrieve 使用 curl 作为后端实现, 支持全局 socks5 代理。
  (advice-add 'url-http :around 'mb-url-http-around-advice))

(defun proxy-socks-disable ()
  "Disable SOCKS proxy."
  (interactive)
  (require 'socks)
  (setq url-gateway-method 'native
        socks-noproxy nil)
  (setenv "all_proxy" "")
  (proxy-socks-show))

(defun proxy-socks-toggle ()
  "Toggle SOCKS proxy."
  (interactive)
  (require 'socks)
  (if (bound-and-true-p socks-noproxy)
      (proxy-socks-disable)
    (proxy-socks-enable)))

(use-package vterm
  :ensure-system-package
  ((cmake . cmake)
   (glibtool . libtool)
   (exiftran . exiftran))
  :config
  (setq vterm-set-bold-hightbright t)
  (setq vterm-always-compile-module t)
  (setq vterm-max-scrollback 100000)
  ;; vterm buffer 名称，需要配置 shell 来支持（如 bash 的 PROMPT_COMMAND）。
  (setq vterm-buffer-name-string "*vterm: %s")
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setf truncate-lines nil)
              (setq-local show-paren-mode nil)
              (yas-minor-mode -1)
              ;; (flycheck-mode -1)
              ))
  ;; 使用 M-y(consult-yank-pop) 粘贴剪贴板历史中的内容。
  (define-key vterm-mode-map [remap consult-yank-pop] #'vterm-yank-pop)
  :bind
  (:map vterm-mode-map ("C-l" . nil))
  ;; 防止输入法切换冲突。
  (:map vterm-mode-map ("C-\\" . nil)) )

(use-package multi-vterm
  :after (vterm)
  :config
  (define-key vterm-mode-map (kbd "M-RET") 'multi-vterm))

(use-package vterm-toggle
  :after (vterm)
  :custom
  ;; 由于 TRAMP 模式下关闭了 projectile，scope 不能设置为 'project。
  ;;(vterm-toggle-scope 'dedicated)
  (vterm-toggle-scope 'project)
  :config
  (global-set-key (kbd "C-`") 'vterm-toggle)
  (global-set-key (kbd "C-~") 'vterm-toggle-cd)
  (define-key vterm-mode-map (kbd "C-RET") #'vterm-toggle-insert-cd)
  ;; 切换到一个空闲的 vterm buffer 并插入一个 cd 命令， 或者创建一个新的 vterm buffer 。
  (define-key vterm-mode-map (kbd "s-i") 'vterm-toggle-cd-show)
  (define-key vterm-mode-map (kbd "s-n") 'vterm-toggle-forward)
  (define-key vterm-mode-map (kbd "s-p") 'vterm-toggle-backward)
  (define-key vterm-copy-mode-map (kbd "s-i") 'vterm-toggle-cd-show)
  (define-key vterm-copy-mode-map (kbd "s-n") 'vterm-toggle-forward)
  (define-key vterm-copy-mode-map (kbd "s-p") 'vterm-toggle-backward))

(use-package vterm-extra
  :straight (:host github :repo "Sbozzolo/vterm-extra")
  :bind
  (:map vterm-mode-map
        (("C-c C-e" . vterm-extra-edit-command-in-new-buffer)))
  :config
  (advice-add #'vterm-extra-edit-done :after #'winner-undo))

(setq explicit-shell-file-name "/bin/bash")
(setq shell-file-name "/bin/bash")
(setq shell-command-prompt-show-cwd t)
(setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
(setenv "SHELL" shell-file-name)
(setenv "ESHELL" "bash")
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;; 提示符只读
(setq comint-prompt-read-only t)

;; 命令补全
(setq shell-command-completion-mode t)

;; 高亮模式
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

(use-package tramp
  :straight (tramp :files ("lisp/*"))
  :config
  ;; 使用 ~/.ssh/config 中的 ssh 持久化配置。（Emacs 默认复用连接，但不持久化连接）
  (setq  tramp-ssh-controlmaster-options nil)
  ;; TRAMP buffers 关闭 version control, 防止卡住.
  (setq vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)" vc-ignore-dir-regexp tramp-file-name-regexp))
  ;; 关闭自动保存 ad-hoc proxy 代理配置, 防止为相同 IP 的 VM 配置了错误的 Proxy.
  (setq tramp-save-ad-hoc-proxies nil)
  ;; 调大远程文件名过期时间（默认 10s), 提高查找远程文件性能.
  (setq remote-file-name-inhibit-cache 600)
  ;;tramp-verbose 10
  ;; 增加压缩传输的文件起始大小（默认 4KB），否则容易出错： “gzip: (stdin): unexpected end of file”
  (setq tramp-inline-compress-start-size (* 1024 8))
  ;; 当文件大小超过 tramp-copy-size-limit 时，用 external methods(如 scp）来传输，从而大大提高拷贝效率。
  (setq tramp-copy-size-limit (* 1024 1024 2))
  ;; 临时目录中保存 TRAMP auto-save 文件, 重启后清空。
  (setq tramp-allow-unsafe-temporary-files t)
  (setq tramp-auto-save-directory temporary-file-directory)
  ;; 连接历史文件。
  (setq tramp-persistency-file-name (expand-file-name "tramp-connection-history" user-emacs-directory))
  ;; 在整个 Emacs session 期间保存 SSH 密码.
  (setq password-cache-expiry nil)
  (setq tramp-default-method "ssh")
  (setq tramp-default-remote-shell "/bin/bash")
  (setq tramp-default-user "root")
  (setq tramp-terminal-type "tramp")
  ;; Backup (file~) disabled and auto-save (#file#) locally to prevent delays in editing remote files
  ;; https://stackoverflow.com/a/22077775
  (add-to-list 'backup-directory-alist (cons tramp-file-name-regexp nil))

  ;; 自定义远程环境变量。
  (let ((process-environment tramp-remote-process-environment))
    ;; 设置远程环境变量 VTERM_TRAMP, 远程机器的 ~/.emacs_bashrc 根据这个变量设置 VTERM 参数。
    (setenv "VTERM_TRAMP" "true")
    (setq tramp-remote-process-environment process-environment)))

;; 远程机器列表。
(require 'epa-file)
(epa-file-enable)
(load "~/.emacs.d/sshenv.el.gpg")

;; 切换 buffer 时自动设置 VTERM_HOSTNAME 环境变量为多跳的最后一个主机名，并通过 vterm-environment 传递到远程环境中。远程
;; 机器的 ~/.emacs_bashrc 根据这个变量设置 Buffer 名称和机器访问地址为主机名，正确设置目录跟踪。解决多跳时 IP 重复的问题。
(defvar my/remote-host "")
(add-hook 'buffer-list-update-hook
          (lambda ()
            (when (file-remote-p default-directory)
              (setq my/remote-host (file-remote-p default-directory 'host))
              ;; 动态计算 ENV=VALUE.
              (require 'vterm)
              (setq vterm-environment `(,(concat "VTERM_HOSTNAME=" my/remote-host))))))

(use-package consult-tramp
  :straight (:repo "Ladicle/consult-tramp" :host github))

;; 保存 Buffer 时自动更新 #+LASTMOD: 后面的时间戳。
(setq time-stamp-start "#\\+\\(LASTMOD\\|lastmod\\):[ \t]*")
(setq time-stamp-end "$")
(setq time-stamp-format "%Y-%m-%dT%02H:%02m:%02S%5z")
;; #+LASTMOD: 必须位于文件开头的 line-limit 行内, 否则自动更新不生效。
(setq time-stamp-line-limit 30)
(add-hook 'before-save-hook 'time-stamp t)

;; 当打开文件权限不足时，自动使用 sudo 打开该文件。
(use-package auto-sudoedit)
(add-hook 'find-file-hook #'(lambda () (require 'auto-sudoedit) (auto-sudoedit)))

;; 使用 fundamental-mode 打开大文件。
(defun my/large-file-hook ()
  (when (and (> (buffer-size) (* 1024 2))
             (or (string-equal (file-name-extension (buffer-file-name)) "json")
                 (string-equal (file-name-extension (buffer-file-name)) "yaml")
                 (string-equal (file-name-extension (buffer-file-name)) "yml")
                 (string-equal (file-name-extension (buffer-file-name)) "log")))
    (fundamental-mode)
    (setq buffer-read-only t)
    (font-lock-mode -1)
    (rainbow-delimiters-mode -1)
    (smartparens-global-mode -1)
    (show-smartparens-mode -1)
    (smartparens-mode -1)))
(add-hook 'find-file-hook 'my/large-file-hook)
;; 默认直接用 fundamental-mode 打开 json 和 log 文件, 确保其它 major-mode 不会先执行。
(add-to-list 'auto-mode-alist '("\\.log?\\'" . fundamental-mode))
(add-to-list 'auto-mode-alist '("\\.json?\\'" . fundamental-mode))

;; macOS 按键调整。
(setq mac-command-modifier 'meta)
;; option 作为 Super 键(按键绑定用 s- 表示，S- 表示 Shift)
(setq mac-option-modifier 'super)
;; fn 作为 Hyper 键(按键绑定用 H- 表示)
(setq ns-function-modifier 'hyper)

;; 关闭 mouse-wheel-text-scale 快捷键 (容易触碰误操作) 。
(global-unset-key (kbd "C-<wheel-down>"))
(global-unset-key (kbd "C-<wheel-up>"))
;; 避免执行 ns-print-buffer 命令。
(global-unset-key (kbd "s-p"))
;; 避免执行 ns-open-file-using-panel 命令。
(global-unset-key (kbd "s-o"))
(global-unset-key (kbd "s-t"))
(global-unset-key (kbd "s-n"))
;; 关闭 suspend-frame 。
(global-unset-key (kbd "C-z"))
;; 关闭 mouse-yank-primary 。
(global-unset-key (kbd "<mouse-2>"))
(global-set-key (kbd "RET") 'newline-and-indent)

(use-package emacs
  :straight (:type built-in)
  :ensure-system-package
  ;; artist-mode 依赖的两个程序。
  ((figlet . "brew install figlet")
   ;; 触摸板三指点按模拟鼠标中键。
   ("/Applications/MiddleClick.app" . "brew install --cask --no-quarantine middleclick"))
  :init
  ;; 粘贴于光标处, 而不是鼠标指针处。
  (setq mouse-yank-at-point t)
  (setq initial-major-mode 'fundamental-mode)
  ;; 按中文折行。
  (setq word-wrap-by-category t)
  ;; 退出自动杀掉进程。
  (setq confirm-kill-processes nil)
  (setq use-short-answers t)
  (setq confirm-kill-emacs #'y-or-n-p)
  (setq ring-bell-function 'ignore)
  ;; 不显示行号, 否则鼠标会飘。
  (add-hook 'artist-mode-hook (lambda () (display-line-numbers-mode -1)))
  ;; bookmark 发生变化时自动保存（默认是 Emacs 正常退出时保存）。
  (setq bookmark-save-flag 1)
  ;; 不创建 lock 文件。
  (setq create-lockfiles nil)
  ;; 启动 Server 。
  (unless (and (fboundp 'server-running-p)
               (server-running-p))
    (server-start)))


(use-package recentf
  :straight (:type built-in)
  :config
  ;; 不清理 recentf tramp buffers.
  (setq recentf-auto-cleanup 'never)
  (setq recentf-max-menu-items 100)
  (setq recentf-max-saved-items 600)
  (recentf-mode +1)
  (setq recentf-exclude `(,(expand-file-name "straight/" user-emacs-directory)
                          ,(expand-file-name "eln-cache/" user-emacs-directory)
                          ,(expand-file-name "etc/" user-emacs-directory)
                          ,(expand-file-name "var/" user-emacs-directory)
                          ,(expand-file-name ".cache/" user-emacs-directory)                          
                          ,tramp-file-name-regexp
                          "/tmp" ".gz" ".tgz" ".xz" ".zip" "/ssh:" ".png" ".jpg" "/\\.git/" ".gitignore" "\\.log" "COMMIT_EDITMSG"
                          ,(concat package-user-dir "/.*-autoloads\\.el\\'"))))

(setq global-mark-ring-max 5000)
(setq mark-ring-max 5000 )
(setq kill-ring-max 5000)

;; minibuffer 历史。
(use-package savehist
  :straight (:type built-in)
  :hook (after-init . savehist-mode)
  :config
  (setq history-length 200)
  (setq savehist-save-minibuffer-history t)
  (setq savehist-autosave-interval 200)
  (setq savehist-additional-variables
        '(mark-ring
          global-mark-ring
          search-ring
          regexp-search-ring
          extended-command-history)))

;; fill-column 的值应该小于 visual-fill-column-width，否则居中显示时行内容会过长而被隐藏。
(setq-default fill-column 100)
(setq-default comment-fill-column 0)
(setq-default tab-width 4)
;; 不插入 tab (按照 tab-width 转换为空格插入) 。
(setq-default indent-tabs-mode nil)
(setq-default message-log-max t)
(setq-default ad-redefinition-action 'accept)

;; 使用系统剪贴板，实现与其它程序相互粘贴。
(setq x-select-enable-clipboard t)
(setq select-enable-clipboard t)
(setq x-select-enable-primary t)
(setq select-enable-primary t)

(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(if (not (file-exists-p backup-dir))
    (make-directory backup-dir t))
;; 文件第一次保存时备份。
(setq make-backup-files t)
(setq backup-by-copying t)
(setq backup-directory-alist (list (cons ".*" backup-dir)))
;; 备份文件时使用版本号。
(setq version-control t)
;; 删除过多的版本。
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)

(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(if (not (file-exists-p autosave-dir))
    (make-directory autosave-dir t))
;; auto-save 访问的文件。
(setq auto-save-default t)
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))
;;(global-auto-revert-mode)

;; UTF8 中文字符。
(setq locale-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default buffer-file-coding-system 'utf8)
(prefer-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setenv "LANG" "zh_CN.UTF-8")
(setenv "LC_ALL" "zh_CN.UTF-8")
(setenv "LC_CTYPE" "zh_CN.UTF-8")

;; 删除文件时, 将文件移动到回收站。
(use-package osx-trash
  :ensure-system-package trash
  :config
  (when (eq system-type 'darwin)
    (osx-trash-setup))
  (setq-default delete-by-moving-to-trash t))

;; 在 Finder 中打开当前文件。
(use-package reveal-in-osx-finder
  :commands (reveal-in-osx-finder))

;; 在帮助文档底部显示 lisp demo.
(use-package elisp-demos
  :config
  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

;; 相比 Emacs 内置 Help, 提供更多上下文信息。
(use-package helpful
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function)
  (global-set-key (kbd "C-h C") #'helpful-command))

;; 在另一个 panel buffer 中展示按键。
(use-package command-log-mode
  :commands command-log-mode)

;; OSX 词典。
(use-package osx-dictionary
  :bind
  (("C-c d i" . osx-dictionary-search-input)
   ("C-c d w" . osx-dictionary-search-pointer))
  :config
  (use-package chinese-word-at-point :demand t)
  (setq osx-dictionary-use-chinese-text-segmentation t))

;; 以下自定义函数参考自：https://github.com/jiacai2050/dotfiles/blob/master/.config/emacs/i-edit.el
(defun my/json-format ()
  (interactive)
  (save-excursion
    (if mark-active
        (json-pretty-print (mark) (point))
      (json-pretty-print-buffer))))

(defun my/delete-file-and-buffer (buffername)
  "Delete the file visited by the buffer named BUFFERNAME."
  (interactive "bDelete file")
  (let* ((buffer (get-buffer buffername))
         (filename (buffer-file-name buffer)))
    (when filename
      (delete-file filename)
      (message "Deleted file %s" filename)
      (kill-buffer))))

(defun my/diff-buffer-with-file ()
  "Compare the current modified buffer with the saved version."
  (interactive)
  (let ((diff-switches "-u")) ;; unified diff
    (diff-buffer-with-file (current-buffer))
    (other-window 1)))

(defun my/copy-current-filename-to-clipboard ()
  "Copy `buffer-file-name' to system clipboard."
  (interactive)
  (let ((filename (if-let (f buffer-file-name)
                      f
                    default-directory)))
    (if filename
        (progn
          (message (format "Copying %s to clipboard..." filename))
          (kill-new filename))
      (message "Not a file..."))))

(defun my/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: ")))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))
