;; tentative org- conf to publish the site

(setq org-publish-project-alist
      '(

        ;; ... pages of the main website ...
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
         :with-latex nil
         
         ;; HTML type of output
         :html-doctype "html5"
         
         ;; Empty head
         :html-head nil
         :html-head-extra "<link rel='stylesheet' href='css/default.css' />"
         :html-head-include-default-style t
         :html-head-include-scripts nil
         :html-mathjax ""
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
        <ul class=\"nav\">
          <li> <a href=\"index.html\"> Home</a></li>
          <li> <a href=\"research.html\">Research</a></li>
          <li> <a href=\"writings.html\">Papers</a></li>
          <li class=\"current\"> <a href=\"teaching.html\">Teaching</a></li>
          <li> <a href=\"downloads.html\">Software</a></li>
        </ul>
      </nav>
    </header>"
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
         :base-extension "pdf\\|ps\\|ps.gz\\|jpg\\|gif\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/lavori/webpage/site-build2/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("main" :components ("pages" "pages-html" "papers" "assets"))
      ))
