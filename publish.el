;; tentative org- conf to publish the site

(require 'org-publish)
(setq org-publish-project-alist
      '(

       ;; ... all the components ...
        ("org-notes"
         :base-directory "~/lavori/webpage/org/"
         :base-extension "org"
         :publishing-directory "~/lavori/webpage/site-build/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 3             ; Just the default for this project.
         :auto-preamble nil
         :htmlized-source t ;; this enables htmlize, which means that I can use css for code!
         :section-numbers nil
         :with-toc nil
         :with-drawers t
         :with-sub-superscript nil ;; important!!
         )
        ("main" :components ("org-notes" ))
      ))
