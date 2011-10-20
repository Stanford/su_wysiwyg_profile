<?php
// $Id$

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *  An array of modules to be enabled.
 * Our FEATURES will take care of enabling their dependencies, so we really only have to worry about the extras.
 */
function su_wysiwyg_profile_modules() {
    $modules = array(
      
      // core modules
      'block', 'comment', 'dblog', 'filter', 'help', 'menu', 'node', 'system', 
      'taxonomy', 'user',

      // contrib
      'install_profile_api',

      'diff', 'skinr', 'vertical_tabs','backup_migrate', 
      'transliteration', 'wysiwyg', 'better_formats',
      
      //development
      'admin_menu','devel', 'devel_generate', 'ctools', 'features', 'strongarm', 'exportables', 'wysiwyg_filter',
      
      'su_wysiwyg_tests', 'su_contributor_wysiwyg', 'su_wysiwyg_images',
    );
    // language conditions could trigger other module activations
    return $modules;  
}


/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile.
 */
function su_wysiwyg_profile_details() {
  return array(
    'name' => 'Stanford WYSIWYG',
    'description' => 'Install and get up and running with testing our WYSIWYG Features.'
  );
}

/**
 * Return a list of tasks that this profile supports.
 *
 * @return
 *   A keyed array of tasks the profile will perform during
 *   the final stage. The keys of the array will be used internally,
 *   while the values will be displayed to the user in the installer
 *   task list.
 */
function su_wysiwyg_profile_task_list() { }

/**
 * Perform any final installation tasks for this profile.
 *
 * @return
 *   An optional HTML string to display to the user on the final installation
 *   screen.
 */
function su_wysiwyg_profile_tasks(&$task, $url) {
  
  // We need to do this for install profile api
  install_include(su_wysiwyg_profile_modules());
  
  // Perform tasks common to all sites.
  su_wysiwyg_roles_add();
  su_wysiwyg_users_add();
  su_wysiwyg_menus_add();
  su_wysiwyg_types_add();

  // block all public sign-ups
  variable_set('user_register', 0);
  
   // disable all DB blocks
  db_query("UPDATE {blocks} SET status = 0, region = ''");
  db_query("UPDATE {system} SET status = 0 WHERE type = 'theme' and name ='%s'", 'garland');
  db_query("UPDATE {system} SET status = 0 WHERE type = 'theme' and name ='%s'", 'ginkgo');
   
  // Setup theme.
  install_disable_theme('garland');
  install_default_theme('acquia_prosper');
  //$theme_info['default_logo'] = 0;
  //$theme_info['logo_path'] = file_directory_path() .'/logo.png';

  //$logo = './profiles/su_wysiwyg/logo.png';
  //file_copy($logo, file_directory_path());
  //$form_state = array('values' => $theme_info);

  // Save theme specific settings.
  drupal_execute('system_theme_settings', $form_state);
  // Set a default footer message.
  variable_set('site_footer', 'Copyright '. l('Stanford University', 'http://stanford.edu') . ' &copy; ' . date('Y'), array('absolute' => TRUE)));


  // generate content
  su_wysiwyg_content_add();

  // create taxonomy tags vocabulary
  $vocab = array(
    'name' => st('tags'),
    'description' => st(' Keywords that best describe this post.'),
    'help' => st('Separate tags with commas.'),
    'hierarchy' => FALSE,
    'relations' => FALSE,
    'tags' => TRUE,
    'multiple' => TRUE,
    'required' => FALSE, // debatable
  );
  taxonomy_save_vocabulary($vocab);
  
    // Uninstall the install_profile_api helper module.
  module_disable(array('install_profile_api'));
  drupal_set_installed_schema_version('install_profile_api', SCHEMA_UNINSTALLED);
}


/**
 * Alter all the installer form.
 * This part seems to be causing issues
 * @TODO fix
 */
// function su_wysiwyg_form_alter(&$form, &$form_state, $form_id) {
//   switch ($form_id) {
//     case 'install_configure':
//     
//       $form['site_information']['site_name']['#default_value'] = 'Stanford wysiwyg Tests';
//      
//       $form['site_information']['site_mail']['#default_value'] = 'webmaster+wysiwyg@ideograph.ca';
//       $form['admin_account']['account']['name']['#default_value'] = 'root';
//       $form['admin_account']['account']['mail']['#default_value'] = 'webmaster+wysiwyg@ideograph.ca';
//       $form['admin_account']['account']['pass']['#default_value'] = '123';
//       $form['admin_account']['account']['pass']['#type'] = 'textfield';
//       $form['admin_account']['account']['pass']['#title'] = t('Password');
//       $form['admin_account']['account']['pass']['#description'] = t('This password field has been changed to plain text to ease the installation process.');
//       
//       // allow setting the default timezone on install
//       if (function_exists('date_timezone_names') && function_exists('date_timezone_update_site')) {
//         $form['server_settings']['date_default_timezone']['#access'] = FALSE;
//         $form['server_settings']['#element_validate'] = array('date_timezone_update_site');
//         $form['server_settings']['date_default_timezone_name'] = array(
//           '#type' => 'select',
//           '#title' => t('Default time zone'),
//           '#default_value' => NULL,
//           '#options' => date_timezone_names(FALSE, TRUE),
//           '#description' => t('Select the default site time zone. If in doubt, choose the timezone that is closest to your location which has the same rules for daylight saving time.'),
//           '#required' => TRUE,
//         );
//       }
//       break;
//
//      case 'install_settings_form':
//        $form['db_path']['#default_value'] = 'suwysiwyg';
//        $form['db_user']['#default_value'] = 'suwysiwyg';
//        $form['db_pass']['#default_value'] = 'suwysiwyg';
//        break;
//
//   }
// 
// }

/**
 * Set English as default language.
 * 
 * If no language selected, the installation crashes. I guess English should be the default 
 * but it isn't in the default install. @todo research, core bug?
 */
function system_form_install_select_locale_form_alter(&$form, $form_state) {
  $form['locale']['en']['#value'] = 'en';
}

/**
 * @TODO: This might be impolite/too aggressive. We should at least check that
 * other install profiles are not present to ensure we don't collide with a
 * similar form alter in their profile.
 *
 * Set su_wysiwyg as default install profile.
 */
function system_form_install_select_profile_form_alter(&$form, $form_state) {
  foreach($form['profile'] as $key => $element) {
    $form['profile'][$key]['#value'] = 'su_wysiwyg';
  }
}




/**
 * Add our basic roles.
 */
function su_wysiwyg_roles_add() {
  install_add_role('admin');
  install_add_role('editor');
  install_add_role('contributor');
}

/**
 * Add some basic users with our given roles
 */
function su_wysiwyg_users_add() {
  install_add_user('admin', 'su_wysiwyg', 'webmaster+admin@ideograph.ca', array('admin'));
  install_add_user('user', 'su_wysiwyg', 'webmaster+user@ideograph.ca');
  install_add_user('editor', 'su_wysiwyg', 'webmaster+editor@ideograph.ca', array('editor'));
  install_add_user('contributor', 'su_wysiwyg', 'webmaster+contributor@ideograph.ca', array('contributor'));
}

/**
 * Add a "Home" link to the frontpage.
 */
function su_wysiwyg_menus_add() {
  install_menu_create_menu_item('<front>', st('Home'), st('Back to the home page'), 'primary-links', 0 , -10);
}


/**
 * Add node types.
 */
function su_wysiwyg_types_add() {
  // Insert default user-defined node types into the database. For a complete
  // list of available node type attributes, refer to the node type API
  // documentation at: http://api.drupal.org/api/HEAD/function/hook_node_info.
  $types = array(
    array(
      'type' => 'page',
      'name' => st('Page'),
      'module' => 'node',
      'description' => st('If you want to add a static page, like a contact page or an about page, use a page.'),
      'custom' => TRUE,
      'modified' => TRUE,
    ),
    array(
      'type' => 'story',
      'name' => st('Story'),
      'module' => 'node',
      'description' => st("A <em>story</em>, similar in form to a <em>page</em>, is ideal for creating and displaying content that informs or engages website visitors. Press releases, site announcements, and informal blog-like entries may all be created with a <em>story</em> entry. By default, a <em>story</em> entry is automatically featured on the site's initial home page, and provides the ability to post comments."),
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
    ),
  );

  foreach ($types as $type) {
    $type = (object) _node_type_set_defaults($type);
    node_type_save($type);
  }

  // Default page to not be promoted and have comments disabled.
  variable_set('node_options_page', array('status'));
  variable_set('comment_page', COMMENT_NODE_DISABLED);

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;
  variable_set('theme_settings', $theme_settings);

  // Update the menu router information.
  menu_rebuild();

}


function su_wysiwyg_content_add() {
  // Create a homepage for the site, so it isn't empty
  
  // Create a Home page.
  $node = new stdClass();
  $node->type = 'page';
  $node->title = st('About');
  $node->body = st('<p>Welcome to the test site for the Stanford WYSIWYG project.</p><p>Make nodes. Be happy.</p>');
  $node->format = 1;
  $node->status = 1;
  $node->revision = 1;
  $node->promote = 1;

  $node = node_submit($node);
  $node->uid = 4;
  node_save($node);
  // Set site front page to welcome page.
  variable_set('site_frontpage', 'node/1');
  
}