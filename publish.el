;; tentative org- conf to publish the site


;;; Use the packages installed in my Emacs
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(message (format "Producing the website using org-move version %s"  org-version))

(setq base-directory "~/lavori/webpage/src/"
      publishing-directory "~/lavori/webpage/site-build/")

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
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|mp3\\|ogg\\|swf\\|tar.gz"
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
