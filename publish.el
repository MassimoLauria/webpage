;;; publish.el --- Emacs-lisp which produces my webpage

;; Copyright (C) 2010, 2013, 2015, 2018, 2019, 2021  Massimo Lauria

;; Author: Massimo Lauria <lauria.massimo@gmail.com>
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
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Contains the main elisp code to produce and publish and org-mode
;; base website.

;;; Code:
;;


;;; Use the packages installed in my Emacs
(require 'package)
(package-initialize)


(message (format "Producing the website using org-move version %s"  (org-version)))
(message (format "Running from %s"  default-directory))


(setq base-directory       (concat default-directory "src/")
      publishing-directory (concat default-directory "site-build/"))

(defun my-file-content (filename)
  (with-temp-buffer
    (insert-file-contents (concat base-directory filename))
    (buffer-string)))


(setq org-publish-project-alist
      `(

        ;; ... pages the main website ...
        ("pages"
         :base-directory ,base-directory
         :base-extension "org"
         :publishing-directory ,publishing-directory
         :recursive t
         :publishing-function org-html-publish-to-html

         ;; Export options
         :with-author t
         :with-creator nil
         :with-date t

         :section-numbers nil

         :with-toc nil
         :with-title nil

         :with-drawers t
         :with-sub-superscript nil      ; important!!
         :headline-levels 3       ; Just the default for this project.
         :with-latex t

         ;; HTML type of output
         :html-doctype "html5"

         ;; Empty head
         ;;:html-head-extra "<link rel='stylesheet' href='css/default.css' />\n<script type=\"text/javascript\" charset=\"utf-8\" src=\"js/highlight.js\"></script>"
         :html-head-extra ,(my-file-content "head-extra.inc")
         :html-head-include-default-style t
         :html-head-include-scripts nil
         :html-container "article"
         ;; Header

         ;; Content
         :html-toplevel-hlevel 1
         :html-divs ((preamble  "div"    "preamble")
                     (content   "main"   "content")
                     (postamble "div"    "postamble"))

         ;; Footer
         :html-preamble  ,(my-file-content "preamble.inc")
         :html-postamble ,(my-file-content "postamble.inc")

         :htmlized-source t ;; this enables htmlize, which means that I can use css for code!

         ;; Finetune
         )


        ;; Other stuff that must just be copied
        ("pages-html"
         :base-directory ,base-directory
         :base-extension "html"
         :publishing-directory ,publishing-directory
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("assets"
         :base-directory ,base-directory
         :base-extension "txt\\|css\\|js\\|png\\|ico\\|jpg\\|gif\\|mp3\\|ogg\\|swf\\|tar.gz\\|zip\\|ico"
         :publishing-directory ,publishing-directory
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("papers"
         :base-directory ,base-directory
         :base-extension "pdf\\|ps\\|ps.gz\\|tex"
         :publishing-directory ,publishing-directory
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("main" :components ("pages" "pages-html" "papers" "assets"))
        ))
