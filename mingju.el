;;; mingju.el --- 古诗文名句                         -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Xu Chunyang

;; Author: Xu Chunyang <mail@xuchunyang.me>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'json)

(defconst mingju-json (expand-file-name
                       "mingju.json"
                       (file-name-directory (or load-file-name buffer-file-name))))

;; Example:
;;
;; (mingju)
;; => ("滚滚长江东逝水，浪花淘尽英雄。" "杨慎《临江仙·滚滚长江东逝水》")

;;;###autoload
(defun mingju (&optional action)
  "随机返回一条古诗文名句.
ACTION 可为 nil 或 insert 或 message.
交互模式下，ACTION 默认为 message，但加了 Prefix Argument 时，则为 insert.

注意依赖 jq(1)."
  (interactive
   (list (if current-prefix-arg
             'insert
           'message)))
  (let (alist contents source)
    (with-temp-buffer
      (unless (zerop (call-process "jq"
                                   nil
                                   t
                                   nil
                                   (format ".[%s]" (random 10000))
                                   mingju-json))
        (error "[mingju] jq failed"))
      (goto-char (point-min))
      (setq alist (json-read)))
    (let-alist alist
      (setq contents .contents
            source .source))
    (cond ((eq action 'insert)
           (insert (format "%s -- %s\n" contents source)))
          ((eq action 'message)
           (message "%s -- %s" contents source)))
    (list contents source)))

(provide 'mingju)
;;; mingju.el ends here
