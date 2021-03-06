; $ drush make su_wysiwyg.make su_wysiwyg  

core = 6.x
api = 2
projects[drupal][version] = "6.22"


; ======= Contrib Modules ======= 
projects[ctools][version] = "1.8"
projects[cck][version] = "2.9"
projects[views][version] = "2.12"

; DEVELOPMENT
projects[admin_menu][version] = "1.6"

projects[devel][version] = "1.26"
projects[diff][version] = "2.1"
projects[backup_migrate][version] = "2.4"
projects[install_profile_api][version] = "2.1"
projects[masquerade][version] = "1.6"


; HELPERS
projects[vertical_tabs][version] = "1.0-rc1"

projects[better_formats][version] = "1.2"


; PATHS
projects[pathauto][version] = "1.5"
projects[token][version] = "1.15"
projects[transliteration][version] = "3.0"


; FILE HANDLING
projects[filefield][version] = "3.9"
projects[filefield_paths][version] = "1.4"

projects[filefield_sources][version] = "1.4"

projects[image_resize_filter][version] = "1.12"

projects[imageapi][version] = "1.9"

projects[imagecache][version] = "2.0-beta10"

projects[imagefield][version] = "3.9"
projects[imagefield_tokens][version] = "1.0"

projects[imce][version] = "2.1"
projects[imce_tools][version] = "1.1"
projects[imce_wysiwyg][version] = "1.1"

projects[input_formats][version] = "1.0-beta6"

projects[insert][version] = "1.0"


; WYSIWYG
projects[wysiwyg][version] = "2.3"
; Add a patch to make wysiwyg exportable.
projects[wysiwyg][patch][] = "http://drupal.org/files/issues/wysiwyg-624018-ctools-export-input-formats-2.patch"

projects[wysiwyg_filter][version] = "1.5"


; FEATURES
projects[exportables][version] = "2.0-beta1"
projects[features][version] = "1.1"
projects[strongarm][version] = "2.0"


; ======= Custom Modules ======= 

projects[ideograph_wysiwyg][type] = "module"
projects[ideograph_wysiwyg][download][type] = "git"
projects[ideograph_wysiwyg][subdir] = "sites/all/modules/custom"
projects[ideograph_wysiwyg][download][url] = "http://git.drupal.org/sandbox/Andrew_Mallis/1315584.git"


; ======= Features ======= 

; includes su_contributor_wysiwyg, su_wysiwyg_images, su_wysiwyg_tests
projects[su_wysiwyg_features][type] = "module"
projects[su_wysiwyg_features][download][type] = "git"
projects[su_wysiwyg_features][subdir] = "sites/all/modules/custom"
projects[su_wysiwyg_features][download][url] = "git@github.com:Stanford/su_wysiwyg_features.git"


projects[ideograph_dev][type] = "module"
projects[ideograph_dev][download][type] = "git"
projects[ideograph_dev][download][url] = "git://github.com/ideograph/ideograph_dev.git"
projects[ideograph_dev][subdir] = "sites/all/modules/custom"



; ======= Themes =======

; projects[rubik][version] = "3.0-beta2"

projects[fusion][version] = "1.12"
projects[acquia_prosper][version] = "1.1"



; ======= Libraries ======= 

; TinyMCE 3.2.7
;libraries[tinymce][download][type] = "get"
;libraries[tinymce][download][url] = "http://downloads.sourceforge.net/project/tinymce/TinyMCE/3.2.7/tinymce_3_2_7.zip"
;libraries[tinymce][directory_name] = "tinymce"

; TinyMCE 3.3.9.2
libraries[tinymce][download][type] = "get"
libraries[tinymce][download][url] = "http://sourceforge.net/projects/tinymce/files/TinyMCE/3.3.9.2/tinymce_3_3_9_2.zip"
libraries[tinymce][directory_name] = "tinymce"


; CKEditor 3.5.7
libraries[ckeditor][download][type] = "get"
libraries[ckeditor][download][url]  = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.5.3/ckeditor_3.5.3.zip"
libraries[ckeditor][directory_name] = "ckeditor"
libraries[ckeditor][destination] = "libraries"

; latest CKEditor stable release
;libraries[ckeditor][download][type] = "svn"
;libraries[ckeditor][download][url] = "http://svn.ckeditor.com/CKEditor/releases/stable/"
;libraries[ckeditor][directory_name] = "ckeditor"

; jQuery UI
;libraries[jquery_ui][download][type] = "get"
;libraries[jquery_ui][download][url] = "http://jquery-ui.googlecode.com/files/jquery-ui-1.7.2.zip"
;libraries[jquery_ui][directory_name] = "jquery.ui"
;libraries[jquery_ui][destination] = "modules/jquery_ui"


; ======= Profiles ======= 

; Base Stanford Profile
; We could use this, but there are extra module dependencies and recursion that complicate the matter for now
; projects[stanford][type] = "profile"
; projects[stanford][download][type] = "git"
; projects[stanford][download][url] = "git@github.com:mistermarco/Stanford-Drupal-Profile.git"

projects[su_wysiwyg_profile][type] = "profile"
projects[su_wysiwyg_profile][download][type] = "git"
projects[su_wysiwyg_profile][download][url] = "git@github.com:Stanford/su_wysiwyg_profile.git"
