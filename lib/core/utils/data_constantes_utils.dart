class DataConstantesUtils {
  static const String APP_SERVER_TOKEN = "SzrQt6TazKv2ayDHqs754qvvAvD";

  static const String LOGIN_SERVER_URL = "/accounts/connecte_useraccount";
  static const String INSCRIPTION_SERVER_URL =
      "api/web/mobile_v1/accounts/create-account";
  /*Passords urls debut*/
  static const String UPDATE_PSSWD_SERVER_URL = "/accounts/update_password";
  static const String FORGET_PSSWD_SERVER_URL = "/accounts/forget_password1";
  static const String RESET_PSSWD_SERVER_URL = "/accounts/forget_password2";
  /*Passords urls fin*/
  static const String UPDATE_PROFIL_SERVER_URL = "/accounts/update_userinfo";
  static const String UPDATE_PROFIL_PIC_SERVER_URL = "/accounts/update_photo";
  static const String USER_INFO_URL = "/accounts/get_userinfo";
  // static const String UPDATE_PROFIL_SERVER_URL = "api/web/mobile-v1/accounts/update-profil";

  /*
  lists deb*/
  static const String ALL_MISSIONS_SERVER_URL = "/missions/all";
  static const String ALL_ABSENCES_SERVER_URL = "/absences/all";
  static const String ALL_TACHES_SERVER_URL = "/taches/all";
  static const String ALL_NOTES_SERVER_URL = "/notes/all";
  static const String ALL_BULLETIN_SERVER_URL = "/bulletins/all";
  static const String ALL_CONDUITE_SERVER_URL = "/conduites/all";
  static const String ALL_AFFECTATIONS_SERVER_URL = "/affectations/all";
  static const String ALL_PERMISSIONS_SERVER_URL = "/permissions/all";
  static const String ALL_APPRENANTS_SERVER_URL = "/apprenants/all";
  static const String ALL_CLASSES_SERVER_URL = "/absences/add_absence1";
  static const String ALL_BUDGETS_SERVER_URL = "/budgets/all";
  static const String ALL_DEPENSES_SERVER_URL = "/depenses/all";
  /*lists end*/

  /* Ajout deb */
  static const String NEW_NOTE_SERVER_URL = "/notes/addnote2";
  static const String NEW_TACHE_SERVER_URL = "/taches/addtache2";
  static const String NEW_ABSENCE_APPRENANT_SERVER_URL =
      "/absences/add_absence3";
  static const String NEW_PERMISSION_URL = "/permissions/add";
  static const String NEW_BUDGET_URL = "/budgets/add";
  static const String NEW_DEPENSE_URL = "/depenses/add";
  /* Ajout end */

  /* Auxiliaires deb */
  static const String CENTRE_SERVER_URL = "/centers/get_info";
  static const String NOTES_EVALS_SERVER_URL = "/notes/addnote1";
  static const String APPRENANT_EVALS_SERVER_URL =
      "/notes/get_evaluation_eleves";
  static const String BULLETIN_LINK_SERVER_URL = "/bulletins/print";
  static const String APPRENANT_CLASSE_SERVER_URL = "/absences/add_absence2";
  static const String TACHE_USERS_SERVER_URL = "/taches/addtache1";
  static const String MENU_LIST_SERVER_URL = "/configs/get_info";
  static const String VALIDATE_PERMISSION_SERVER_URL = "/permissions/treat";
  static const String VALIDATE_DEPENSE_SERVER_URL = "/depenses/manage";
  /* Auxiliaires end */

  static const int APP_SERVER_PORT = 0;

  static const String SERVER_TOKEN = 'SzrQt6TazKv2ayDHqs754qvvAvD';

  // static const String CGU_SERVER_URL = '';
  static const String CGU_SERVER_URL =
      'https://www.captaincontrat.com/contrats-commerciaux-cgv/cgv-cgu-cga/cgu-conditions-generales-utilisation';

  static const String MPHOTO_SERVER_URL = '';
}
