;;; lang/emacs-lisp/autoload.el

;; ---- emacs-lisp ---------------------------------------------------

;;;###autoload
(defun +emacs-lisp/find-function (&optional arg)
  "Jump to the definition of the function at point. If ARG (the prefix) is
non-nil, the function will be revealed in another window. If ARG is 16 (C-u
C-u), then reveal the function in a popup window."
  (interactive "p")
  (when-let (func (function-called-at-point))
    (cond ((= arg 16)
           (let ((buf (find-function-noselect func t)))
             (doom-popup-buffer (car buf) :align t :size 30 :select t)
             (goto-char (cdr buf))))
          ((> arg 1)
           (find-function-other-window func))
          (t
           (find-function func)))))

;;;###autoload
(defun +emacs-lisp/repl ()
  "Open an ielm REPL for Emacs Lisp."
  (interactive)
  (ielm)
  (let ((buf (current-buffer)))
    (bury-buffer)
    (pop-to-buffer buf)))


;; ---- ert ---------------------------------------------------

(defsubst +ert--pre ()
  (save-buffer) (eval-buffer))

;;;###autoload
(defun +ert/run-test ()
  (interactive)
  (let (case-fold-search thing)
    (+ert--pre)
    (setq thing (thing-at-point 'defun t))
    (if thing
        (if (string-match "(ert-deftest \\([^ ]+\\)" thing)
            (ert-run-tests-interactively
             (substring thing (match-beginning 1) (match-end 1)))
          (user-error "Invalid test at point"))
      (user-error "No test found at point"))))

;;;###autoload
(defun +ert/rerun-test ()
  (interactive)
  (let (case-fold-search thing)
    (+ert--pre)
    (setq thing (car-safe ert--selector-history))
    (if thing
        (ert-run-tests-interactively thing)
      (message "No test found in history, looking for test at point")
      (+ert-run-test))))

;;;###autoload
(defun +ert/run-all-tests ()
  (interactive)
  (ert-delete-all-tests)
  (+ert--pre)
  (ert-run-tests-interactively t))

