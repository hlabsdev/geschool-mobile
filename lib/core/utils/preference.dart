import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/connection_status.dart';
import 'package:geschool/core/utils/core_constantes.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_filter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  // final String _kNotificationsPrefs = "allowNotifications";
  final String userLogin = "isLoggin";
  final String registrationId = "userRegistration";
  final String userLanguage = "userLanguage";
  final String userCountry = "userCountry";

  final String lastUpdate = "lastUpdateCompany";
  final String lastAUpdate = "lastUpdateAnnonce";

  /*User deb*/
  final String userId = "userID";
  final String userKey = "userKey";
  final String nom = "nom";
  final String prenoms = "prenoms";
  final String provenance = "provenance";
  final String email = "email";
  final String telephoneuser = "telephoneuser";
  final String photo = "photo";
  final String dateInscription = "dateInscription";
  final String defaultCentre = "defaultCentre";
  final String status = "status";
  final String profil = "profil";
  final String authkey = "authkey";
  final String idcentre = "idcentre";
  final String datenaissance = "datenaissance";
  final String adresseuser = "adresseuser";

  /*User end*/

  /*Serveur endpoint deb*/
  final String defaultServerEndpoint = "serverToReach";
  final String localServer = LOCAL_SERVER_URL;
  final String onlineServer = LOCAL_SERVER_URL;

  /*Serveur endpoint end*/

  final String filteridCountry1 = "filteridCountry1";
  final String filterCountry1 = "filterCountry1";
  final String filterCity1 = "filterCity1";

  final String filteridCountry2 = "filteridCountry2";
  final String filterCountry2 = "filterCountry2";
  final String filterCity2 = "filterCity2";

  final String filterCompany = "filterCompany";
  final String filterType = "filterType";
  final String filterDate1 = "filterDate1";
  final String filterDate2 = "filterDate2";
  final String filterPrice = "filterPrice";
  final String filterLieu1 = "filterLieu1";
  final String filterLieu2 = "filterLieu2";
  final String filterMethode = "filterMethode";

  final List<AbsenceModel> myabsences = [];

  Future createFilterInfo(UserFilterModel userFilter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(filterCountry1, userFilter.filterCountry1);
  }

  Future<bool> setLanguage(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await allTranslations.setNewLanguage(value);
    return prefs.setString(userLanguage, value);
  }

  Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userLanguage) ?? "fr";
  }

  Future<bool> setLastUpdate(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(lastUpdate, value);
  }

  Future<String> getLastUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastUpdate) ?? "0";
  }

/*
  Future<bool> setLastAUpdate(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(lastAUpdate, value);
  }

  Future<String> getLastAUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(lastAUpdate) ?? "0";
  }
  */
/*
  Future<bool> addAbsence(AbsenceModel absenceModel) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  }*/

  Future<bool> loginFake(bool val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool response = true;
    prefs.setBool(userLogin, val);
    // val ? print("login successfull") : logout();
    return response;
  }

  Future<bool> getLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLogin) ?? false;
  }

  /* Future<bool> createLoginSession(UserInformationModel userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool response = true;
    // if (userInfo.status.compareTo("000") == 0) {
    // prefs.setBool(userLogin, true);
    // } else {
    // prefs.setBool(userLogin, false);
    // }

    // prefs.setString(userKey, userInfo.key);
    // prefs.setInt(idcentre, userInfo.idcentre);
    // prefs.setInt(defaultCentre, userInfo.defaultCentre);
    // prefs.setString(nom, userInfo.nom);
    // prefs.setString(prenoms, userInfo.prenoms);
    // prefs.setString(email, userInfo.email);
    // prefs.setString(telephoneuser, userInfo.telephoneuser);
    // prefs.setString(photo, userInfo.photo);
    // prefs.setString(datenaissance, userInfo.datenaissance);
    // prefs.setString(adresseuser, userInfo.adresseuser);
    // prefs.setString(profil, userInfo.typeuser);
    // prefs.setInt(status, userInfo.status);
    // prefs.setString(status, userInfo.status);
    return response;
  } */

  Future<String> getRegistrationId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(registrationId) ?? "";
  }

  Future<bool> setRegistrationId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(registrationId, value);
  }

  Future<String> getUserKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(userKey) ?? "";
  }

  Future<LoginStatus> getConnectionState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool(userLogin) ?? false;
    String hasCountry = prefs.getString(userCountry) ?? "";

    if (isLogin == false) {
      return LoginStatus.disconnected;
    } else if (hasCountry.compareTo("") == 0) {
      return LoginStatus.notcompleted;
    } else {
      return LoginStatus.connected;
    }
  }

  Future<OnLineStatus> getOnLineState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isOnline = prefs.getBool(userLogin) ?? false;

    if (isOnline == false) {
      return OnLineStatus.onLocal;
    } else {
      return OnLineStatus.onLine;
    }
  }

  Future<String> setDefaultServerEndpoint(bool local) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      defaultServerEndpoint,
      local ? UserPreferences().localServer : UserPreferences().onlineServer,
    );
    UserPreferences().defaultServerEndpoint =
        local ? UserPreferences().localServer : UserPreferences().onlineServer;

    UserPreferences().defaultServer =
        local ? allTranslations.text('local') : allTranslations.text('online');

    return prefs.getString(defaultServerEndpoint);
  }

  Future<String> setLocalServerEndpoint(String local) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(localServer, local);
    return prefs.getString(defaultServerEndpoint);
  }

  Future<String> setOnlineServerEndpoint(String online) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(onlineServer, online);
    // UserPreferences().onlineServer = online;
    return prefs.getString(defaultServerEndpoint);
  }

  Future<String> getDefaultServerEndpoint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(defaultServerEndpoint) ??
        UserPreferences().localServer;
  }

  /* Future<UserInformationModel> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    UserInformationModel information = new UserInformationModel();
    information.key = prefs.getString(userKey) ?? "";
    // information.idcentre = prefs.getInt(idcentre) ?? 0;
    // information.defaultCentre = prefs.getInt(defaultCentre) ?? 0;
    information.nom = prefs.getString(nom) ?? "";
    information.prenoms = prefs.getString(prenoms) ?? "";
    information.email = prefs.getString(email) ?? "";
    information.telephoneuser = prefs.getString(telephoneuser) ?? "";
    information.photo = prefs.getString(photo) ?? "";
    information.datenaissance = prefs.getString(datenaissance) ?? "";
    information.adresseuser = prefs.getString(adresseuser) ?? "";
    information.typeuser = prefs.getString(profil) ?? "";
    information.authkey = prefs.getString(authkey) ?? "";
    information.status = prefs.getInt(status) ?? 0;
    // information.status = prefs.getString(status) ?? "000";

    return information;
  } */

  logout() async {
    UserPreferences().user = null;
  }
//end
}

/*Hermann's User prefences*/
class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /* Startup number deb */
  get startupNumber {
    return _prefs.getString("startupNumber") ?? "";
  }

  set startupNumber(String value) {
    _prefs.setString("startupNumber", value);
  }

  /* Startup number end */

  /* Authentication deb */
  get user {
    return _prefs.getString("user") ?? "";
  }

  set user(String value) {
    _prefs.setString("user", value);
  }

  get authkey {
    return _prefs.getString("authkey") ?? "";
  }

  set authkey(String value) {
    _prefs.setString("authkey", value);
  }

  get userLogin {
    return _prefs.getBool("userLogin") ?? "";
  }

  set userLogin(bool value) {
    _prefs.setBool("userLogin", value);
  }
  /* Authentication end */

  /* Compte Client deb */
  get localServer {
    return _prefs.getString("localServer") ?? "";
  }

  set localServer(String value) {
    _prefs.setString("localServer", value);
  }

  get onlineServer {
    return _prefs.getString("onlineServer") ?? "";
  }

  set onlineServer(String value) {
    _prefs.setString("onlineServer", value);
  }

  get defaultServerEndpoint {
    return _prefs.getString("defaultServerEndpoint") ?? "";
  }

  set defaultServerEndpoint(String value) {
    _prefs.setString("defaultServerEndpoint", value);
  }

  get defaultServer {
    return _prefs.getString("defaultServer") ?? "";
  }

  set defaultServer(String value) {
    _prefs.setString("defaultServer", value);
  }

  get menus {
    return _prefs.getString("menus") ?? "";
  }

  set menus(String value) {
    _prefs.setString("menus", value);
  }

  get retraitTontine {
    return _prefs.getString("retraitTontine") ?? "";
  }

  set retraitTontine(String value) {
    _prefs.setString("retraitTontine", value);
  }
}
