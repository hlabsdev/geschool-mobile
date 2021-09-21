// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/connection_status.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/domain/repositories/local_alert_repository.dart';
import 'package:geschool/features/launch/presentation/pages/absences/apprenant/detail_absence_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/absences/apprenant/mes_absences_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/absences/apprenant/mes_eleves_absences.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/add_absence_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/all_absences.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/detail_absence.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/list_classe.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/mes_absences.dart';
import 'package:geschool/features/launch/presentation/pages/affectations/all_affectations.dart';
import 'package:geschool/features/launch/presentation/pages/affectations/mes_affectations.dart';
import 'package:geschool/features/launch/presentation/pages/budget/all_budgets.dart';
import 'package:geschool/features/launch/presentation/pages/bulletins/list_bulletins.dart';
import 'package:geschool/features/launch/presentation/pages/bulletins/mes_eleves_list_bulletins.dart';
import 'package:geschool/features/launch/presentation/pages/conduites/mes_conduites.dart';
import 'package:geschool/features/launch/presentation/pages/conduites/mes_eleves_conduites.dart';
import 'package:geschool/features/launch/presentation/pages/depense/all_depenses.dart';
import 'package:geschool/features/launch/presentation/pages/home/home_screen.dart';
import 'package:geschool/features/launch/presentation/pages/login/forget_password.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:geschool/features/launch/presentation/pages/login/set_default_server_page.dart';
import 'package:geschool/features/launch/presentation/pages/missions/all_missions.dart';
import 'package:geschool/features/launch/presentation/pages/missions/detail_mission.dart';
import 'package:geschool/features/launch/presentation/pages/missions/mes_missions.dart';
import 'package:geschool/features/launch/presentation/pages/notes/apprenant/mes_eleves_note.dart';
import 'package:geschool/features/launch/presentation/pages/notes/apprenant/mes_notes.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/list_eleves.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/list_evaluations.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/note_par_classe.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/detail_center.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/profile_menu.dart';
import 'package:geschool/features/launch/presentation/pages/permissions/personnel/all_permissions_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/permissions/apprenant/mes_eleves_permissions.dart';
import 'package:geschool/features/launch/presentation/pages/permissions/apprenant/mes_permissions_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/permissions/personnel/detail_permission_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/splash/splash_screen.dart';
import 'package:geschool/features/launch/presentation/pages/taches/all_taches.dart';
import 'package:geschool/features/launch/presentation/pages/taches/detail_tache.dart';
import 'package:geschool/features/launch/presentation/pages/taches/mes_taches.dart';
import 'package:geschool/helpers/database_helper.dart';
import 'package:provider/provider.dart';
import 'features/common/data/function_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await allTranslations.init();
  final _appSharedPreferences = AppSharedPreferences();
  await UserPreferences().init();
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _appSharedPreferences),
        FutureProvider<LoginStatus>(
          create: (_) => _appSharedPreferences.getConnectionState(),
          initialData: LoginStatus.disconnected,
        ),
      ],
      child: MyApp(),
    ),
  );
  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FirebaseMessaging _fcm = FirebaseMessaging();
  AppSharedPreferences _appSharedPreferences = AppSharedPreferences();
  DateTime currentBackPressTime;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    DatabaseHelper.initDb();
    super.initState();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: MaterialApp(
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('en'), const Locale('fr')],
          debugShowCheckedModeBanner: false,
          title: 'GeSchool',
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (_) => SplashPage(),
            '/home': (_) => Home(),
            '/login': (_) => LoginPage(),
            '/setserver': (_) => SetServerPage(),
            '/passwordforget': (_) => ForgetPassword(),
            '/profil': (_) => ProfileMenu(),
            '/centres': (_) => DetailCenter(),
            /* ================= Route personnels deb ================= */
            // Tache
            '/personnel/taches': (_) => MyTasks(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/alltasks': (_) => AllTasks(),
            '/personnel/detailtask': (_) => DetailTache(),

            // Mission
            '/personnel/missions': (_) => MyMissions(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/allmissions': (_) => AllMissions(),
            '/personnel/detailmission': (_) => DetailMission(),

            // Absence personnel
            '/personnel/absences_personnel': (_) => MyAbsences(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/allabsences': (_) => AllAbsences(),
            '/personnel/detailabsence': (_) => DetailAbsence(),

            // Affectation
            '/personnel/affectations': (_) => MyAffectations(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/allaffectations': (_) => AllAffectations(),

            // Note
            '/personnel/notes': (_) => ListEvaluations(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/listeleves': (_) => ListEleves(),
            '/personnel/addnotes': (_) => NoteClasse(),

            // Absence apprenants
            '/personnel/appels': (_) => ListClasse(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/addabsence': (_) => AddApprenantAbsence(),

            //Permission apprenant
            '/personnel/permissions': (_) => AllPermissionsApprenant(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            '/personnel/budgets': (_) => AllBudgets(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/personnel/depenses': (_) => AllDepenses(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            /* ================= Route personnels end ================= */

            /* ================= Route apprenants deb ================= */
            // Note
            '/apprenant/notes': (_) => MesNotes(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            // Absence
            '/apprenant/absences': (_) => MyAbsencesApprenant(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/apprenant/detailabsence': (_) => DetailAbsenceApprenant(),

            // Permission
            '/apprenant/permissions': (_) => MyPermisionsApprenant(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/apprenant/detailpermission': (_) => DetailPermissionApprenant(),

            // Bulletin
            '/apprenant/bulletins': (_) => ListBulletin(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            // Conduite
            '/apprenant/conduites': (_) => MyConduite(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            /* ================= Route apprenants end ================= */

            /* ================= Route parent deb ================= */
            // Note
            '/parent/notes': (_) => MyStudentNote(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            // Absence

            '/parent/absences': (_) => MyStudentAbsence(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/parent/detailabsence': (_) => DetailAbsenceApprenant(),

            // Permission
            '/parent/permissions': (_) => MyStudentPermisions(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),
            '/parent/detailpermission': (_) => DetailPermissionApprenant(),

            // Bulletin
            '/parent/bulletins': (_) => MyStudentListBulletin(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            // Conduite
            '/parent/conduites': (_) => MyStudentConduite(
                me: (UserModel.fromJson(json.decode(UserPreferences().user)))),

            /* ================= Route parent end ================= */
          },
          theme: ThemeData(
              brightness: Brightness.light,
              // primaryColor: FunctionUtils.createMaterialColor(contentPrimaryColor),
              primaryColor: PafpeGreen,
              // primaryColor: GreenLight,
              //Changing this will change the color of the TabBar
              accentColor: Colors.green[700],
              backgroundColor: Colors.grey[200],
              scaffoldBackgroundColor: Colors.grey[200],
              // primarySwatch: FunctionUtils.createMaterialColor(validBtn),
              primarySwatch: FunctionUtils.createMaterialColor("137C04"),
              cardColor: Colors.grey[100],
              /* Theme pour les pop up deb */
              dialogTheme: DialogTheme(
                backgroundColor: Colors.grey[200],
              ),

              /* Theme pour les pop up end */

              primaryTextTheme: TextTheme(
                // ignore: deprecated_member_use
                title: TextStyle(color: Colors.white),
                // ignore: deprecated_member_use
                subtitle: TextStyle(color: Colors.white),
                // ignore: deprecated_member_use
                subhead: TextStyle(color: Colors.white),
              ),
              appBarTheme: AppBarTheme(
                //color: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                actionsIconTheme: IconThemeData(color: Colors.white),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor:
                    FunctionUtils.colorFromHex(contentPrimaryColor),
                // backgroundColor: Colors.grey[200],
              ),
              textTheme: Theme.of(context).textTheme.apply(
                    // fontFamily: 'Montserrat',
                    fontFamily: 'ProductSans',
                    bodyColor: Colors.black,
                    fontSizeFactor: 0.9,
                    fontSizeDelta: 2.0,
                    //displayColor: primaryColor
                  )),
        ));
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime) > Duration(seconds: 3);

    if (backButton) {
      currentBackPressTime = currentTime;
      FunctionUtils.displaySnackBar(context, "Double-cliquez pour quitter");
      return false;
    }
    return true;
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
  }

  registerInfo(Map<String, dynamic> notifInfo) async {
    print(notifInfo);

    _appSharedPreferences.getUserKey().then((_memberKey) {
      String status = notifInfo['data']['status'];
      String keyAlert = notifInfo['data']['key_alert'];
      if (status != null && status.compareTo("000") == 0) {
        LocalAlertRepository localAlertRepository = LocalAlertRepository();
        localAlertRepository.existAlert(keyAlert.trim()).then((response) {
          if (response.length > 0) {
            // response[0].nbreAlert++;
            // localAlertRepository.update(response[0],response[0].idAlert);
          }
        });
      }
    });
  }

/*

    if (Platform.isIOS) _iosPermission();

    _fcm.getToken().then((token){
      _appSharedPreferences.setRegistrationId(token);

      //sucribe to our topic
      _fcm.subscribeToTopic(FunctionUtils.TOPICGLOBAL);
      _appSharedPreferences.getUserKey().then((response){

        if(response.compareTo("")==0){
          _fcm.subscribeToTopic(FunctionUtils.TOPICUNREGISTER);
        }else{
          _fcm.subscribeToTopic(FunctionUtils.TOPICREGISTER);
        }

      });

    });
*/

/*

    _fcm.configure(
      onMessage: (Map<String, dynamic> notifInfo) async {
        if (notifInfo.containsKey('data')) {
          _registerInfo(notifInfo);
        }
      },
*/
/*


      onLaunch: (Map<String, dynamic> notifInfo) async {
        if (notifInfo.containsKey('data')) {
          _registerInfo(notifInfo);
        }
      },
      onResume: (Map<String, dynamic> notifInfo) async {
        if (notifInfo.containsKey('data')) {
          _registerInfo(notifInfo);
        }
      },
    );
*/
/*
  void _iosPermission() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _fcm.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }
*/

  /* End */
}
