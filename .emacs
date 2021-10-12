;; RELATIVE Line Numbers
(global-display-line-numbers-mode)
(menu-bar-display-line-numbers-mode 'relative)

;; Don't ask me to follow symlinks
(setq vc-follow-symlinks t)

(global-set-key (kbd "C-s") 'save-buffer)
;; Package Installs
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; (package-refresh-contents) ;; Run this now and again, slow on boot (1-2s)

(defun install(package)
(unless (package-installed-p package)
  (package-install package))
)

(install 'evil)
(evil-mode 1)

(install 'evil-commentary)
(evil-commentary-mode)

(install 'evil-escape)
(evil-escape-mode)
(setq-default evil-escape-key-sequence "jk")

(install 'evil-goggles)
(evil-goggles-mode)

(install 'fzf)
(define-key evil-normal-state-map "\C-p" 'fzf-git-files)

(install 'wakatime-mode)
(global-wakatime-mode)

;; vim-tmux-navigator stolen from https://github.com/keith/evil-tmux-navigator
(global-unset-key (kbd "C-h"))

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(defun tmux-navigate (direction)
  (let
    ((cmd (concat "windmove-" direction)))
      (condition-case nil
          (funcall (read cmd))
        (error
	 (tmux-command direction)))))

(defun tmux-command (direction)
  (shell-command-to-string
    (concat "tmux select-pane -"
      (tmux-direction direction))))

(defun tmux-direction (direction)
  (upcase
    (substring direction 0 1)))

(define-key evil-normal-state-map
            (kbd "C-h")
            (lambda ()
              (interactive)
              (tmux-navigate "left")))
(define-key evil-normal-state-map
            (kbd "C-j")
            (lambda ()
              (interactive)
              (tmux-navigate "down")))
(define-key evil-normal-state-map
            (kbd "C-k")
            (lambda ()
              (interactive)
              (tmux-navigate "up")))
(define-key evil-normal-state-map
            (kbd "C-l")
            (lambda ()
              (interactive)
              (tmux-navigate "right")))
