;; tentative org- conf to publish the site


(defun my-file-content (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (buffer-string)))

(setq org-publish-project-alist
      '(

        ;; ... pages the main website ...
        ("pages"
         :base-directory "~/lavori/webpage/org/"
         :base-extension "org"
         :publishing-directory "~/lavori/webpage/site-build2/"
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
         :html-head-extra "<link rel='stylesheet' href='css/default.css' />\n<script type=\"text/javascript\" charset=\"utf-8\" src=\"js/highlight.js\"></script>"
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
         :html-preamble "<header>
      <nav>
        <ul id=\"nav\">
          <li> <a href=\"index.html\"> Home</a></li>
          <li> <a href=\"research.html\">Research</a></li>
          <li> <a href=\"writings.html\">Papers</a></li>
          <li> <a href=\"teaching.html\">Teaching</a></li>
          <li> <a href=\"downloads.html\">Software</a></li>
        </ul>
      </nav>
    </header>

    <script type=\"text/javascript\">highlightCurrentPage()</script>"
         :html-postamble "<footer>
This site belongs to <a href=\"mailto:massimo.lauria@uniroma1.it\">Massimo Lauria</a> and the content is published under
      <a href=\"http://creativecommons.org/licenses/by-nc-sa/4.0/\">CC BY-NC-SA 4.0</a> license.
      Icons belong by <a href=\"http://brsev.com\">Evan Brooks</a>.
    </footer>"

         :htmlized-source t ;; this enables htmlize, which means that I can use css for code!

         ;; Finetune
         )

        
        ;; Other stuff that must just be copied
        ("pages-html"
         :base-directory "~/lavori/webpage/org/"
         :base-extension "html"
         :publishing-directory "~/lavori/webpage/site-build2/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("assets"
         :base-directory "~/lavori/webpage/org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|mp3\\|ogg\\|swf\\|tar.gz"
         :publishing-directory "~/lavori/webpage/site-build2/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("papers"
         :base-directory "~/lavori/webpage/org/"
         :base-extension "pdf\\|ps\\|ps.gz"
         :publishing-directory "~/lavori/webpage/site-build2/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("main" :components ("pages" "pages-html" "papers" "assets"))
      ))
