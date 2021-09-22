import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:geschool/features/common/data/datasources/remote/api.dart';

import 'package:geschool/features/common/data/repositories/api_repository.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/mission_model.dart';
import 'package:geschool/features/common/data/models/basemodels/tache_model.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

enum ServerUrl { local, online }

class FunctionUtils {
  static const String TOPICGLOBAL = "global_geschool";
  static const String TOPICUNREGISTER = "unregister_geschool";
  static const String TOPICREGISTER = "register_geschool";

/*Utilitaires debut*/
  static String convertirCourtMois(String mois) {
    String convertirMois = "";
    switch (int.parse(mois)) {
      case 1:
        convertirMois = allTranslations.text('month_1');
        break;
      case 2:
        convertirMois = allTranslations.text('month_2');
        break;
      case 3:
        convertirMois = allTranslations.text('month_3');
        break;
      case 4:
        convertirMois = allTranslations.text('month_4');
        break;
      case 5:
        convertirMois = allTranslations.text('month_5');
        break;
      case 6:
        convertirMois = allTranslations.text('month_6');
        break;
      case 7:
        convertirMois = allTranslations.text('month_7');
        break;
      case 8:
        convertirMois = allTranslations.text('month_8');
        break;
      case 9:
        convertirMois = allTranslations.text('month_9');
        break;
      case 10:
        convertirMois = allTranslations.text('month_10');
        break;
      case 11:
        convertirMois = allTranslations.text('month_11');
        break;
      case 12:
        convertirMois = allTranslations.text('month_12');
        break;
    }

    return convertirMois;
  }

  static String convertFormatDate(String dateRecup) {
    // if (!dateRecup.isEmptyOrNull) {
    if (dateRecup != null) {
      var alltabDate = dateRecup.split(' ');

      var tabDate = alltabDate[0].split('-');
      if (tabDate.length == 3) {
        return "${tabDate[2]} ${convertirCourtMois(tabDate[1])} ${tabDate[0]}";
      } else
        return "Non defini..";
    } else
      return "Non defini..";
  }

  static String convertFormatDateTime(String timestamp) {
    if (timestamp != null) {
      var alltabDate = timestamp.split(' ');

      var tabDate = alltabDate[0].split('-');
      if (tabDate.length == 3) {
        return "${tabDate[2]} ${convertirCourtMois(tabDate[1])} ${tabDate[0]} à ${alltabDate[1].substring(0, 5)}";
      } else
        return "Mauvais format de date";
    } else
      return "Non defini..";
  }

  static String convertDateTimeToHour(String timestamp) {
    if (timestamp != null) {
      var alltabDate = timestamp.split(' ');

      if (alltabDate.length == 2) {
        return "${alltabDate[1].substring(0, 5)}";
      } else
        return "Non defini..";
    } else
      return "Non defini..";
  }

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static MaterialColor createMaterialColor(String hexColor) {
    Color color = colorFromHex(hexColor);
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  // static Future<String> getDeviceInfo() async {
  //   String jsonPhone = "";
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     jsonPhone =
  //         "{'MANUFACTURER':'${androidInfo.manufacturer}','MODEL': '${androidInfo.model}','DEVICE':'${androidInfo.device}','BOARD':'${androidInfo.board}','BRAND':'${androidInfo.brand}','SERIAL':' ${androidInfo.id}','VERSION':'${androidInfo.version.sdkInt}','VERSIONRELEASE':'${androidInfo.version.release}'}";
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     jsonPhone =
  //         "{'MANUFACTURER':'${iosInfo.name}','MODEL':'${iosInfo.model}','DEVICE':'${iosInfo.systemName}','BOARD':'${iosInfo.systemVersion}','BRAND':'${iosInfo.utsname.machine}','SERIAL':'${iosInfo.utsname.nodename}','VERSION':'${iosInfo.systemVersion}','VERSIONRELEASE':'${iosInfo.systemVersion}'}";
  //   }

  //   return jsonPhone;
  // }
/*
  static Future<bool> saveUserDate(
      UserInformationModel userInfo, String type) async {
    final _appSharedPreferences = AppSharedPreferences();

    if (type.compareTo("created") == 0) {
      suscribeFirebase(2, TOPICUNREGISTER);
      suscribeFirebase(1, TOPICREGISTER);
    }

    return await _appSharedPreferences.createLoginSession(userInfo);
  }*/
/*

  static suscribeFirebase(int type, String topic) {
    //print("SOUSCRIPTION AU TOPIC $topic avec type $type");
    if (type == 1) {
      //souscrire au notification de cette topic (firebase Topic)
      FirebaseMessaging().subscribeToTopic(topic).then((value) {
        // print("Topic Subscribed Successfully");
      }).catchError((onError) {
        //print("error subscribing to topic ${onError.toString()}");
      });
    } else {
      //desouscrire au notification de cette topic
      FirebaseMessaging().unsubscribeFromTopic(topic).then((value) {
        // print("Topic unSubscribed Successfully");
      }).catchError((onError) {
        //print("error unSubscribed to topic ${onError.toString()}");
      });
    }
  }
*/

  static int nowExpire(int type) {
    DateFormat initsdf = DateFormat('yyyy-MM-dd hh:mm');
    if (type == 1) {
      initsdf = DateFormat('yyyy-MM-dd');
    }
    String currentDate = initsdf.format(DateTime.now());
    return (initsdf.parse(currentDate).millisecondsSinceEpoch) ~/ 1000;
  }

//==========

  static String convertFormat(String timestamp) {
    var _alltabDate = timestamp.split(' ');
    var _tabDate = _alltabDate[0].split('/');
    if (_tabDate.length == 3) {
      return "${_tabDate[2]}-${_tabDate[1]}-${_tabDate[0]}";
    } else {
      return "2020-01-01";
    }
  }

  static String disponibiliteDate(String timestamp) {
    var _alltabDate = timestamp.split(' ');
    var _tabDate = _alltabDate[0].split('/');
    if (_tabDate.length == 3) {
      return "${convertirCourtMois(_tabDate[1])} ${_tabDate[2].substring(0, 5)}";
    } else {
      return "janvier 2019";
    }
  }

  static int concatDate(String timestamp) {
    var _alltabDate = timestamp.split(' ');
    var _tabDate = _alltabDate[0].split('/');
    if (_tabDate.length == 3) {
      return int.parse("${_tabDate[2]}${_tabDate[1]}${_tabDate[0]}");
    } else {
      return 0;
    }
  }

/*

  static Future <Position> getCurrentLocation() async {

    Position userposition;
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {

      userposition=position;
    }).catchError((e) {});

    return userposition;
  }
*/

  static expireDate(int time, int duree) {
    int todaytime = DateTime.now().millisecondsSinceEpoch;

    duree = duree * 24 * 60 * 60 * 1000;

    if ((time * 1000 + duree) > todaytime) {
      int diffJour = (time * 1000 + duree) - todaytime;
      return "${diffJour ~/ (24 * 60 * 60 * 1000)} ${allTranslations.text('days')}";
    } else {
      return allTranslations.text('expired');
    }
  }

//==========
/*Utilitaires fin*/

/*Enregistrment local des donnees debut*/

/*Enregistrment local des donnees fin*/

  static Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    selectedTime = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      // locale: Locale('fr', 'FR'),
    ));
    String formattedTime = selectedTime.format(context);
    print(formattedTime); //output 14:59:00
    controller.text = formattedTime;
  }

  static Future<void> selectDate(
      BuildContext context, TextEditingController controller,
      [DateTime limit]) async {
    DateTime selectedDate = DateTime.now();
    selectedDate = (await showDatePicker(
      locale: Locale('fr'),
      // currentDate: DateTime.parse(controller.text),
      errorFormatText: 'jj/mm/yyyy',
      initialEntryMode: DatePickerEntryMode.calendar,
      // initialDatePickerMode: DatePickerMode.year,
      context: context,
      initialDate: limit ?? selectedDate,
      firstDate: DateTime(1900),
      lastDate: limit ?? DateTime(2101),
    ));
    print(selectedDate.toString().split(" ")[0]);
    controller.text = selectedDate.toString().split(" ")[0];
  }

  static Future<void> selectDateRange(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    DateTimeRange selectedDater =
        DateTimeRange(start: selectedDate, end: selectedDate);
    selectedDater = (await showDateRangePicker(
      context: context,
      initialDateRange: selectedDater,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      locale: Locale('fr', 'FR'),
    ));
    print(selectedDater);
  }

  static int getDateEtat(String debut, String fin) {
    if (DateTime.parse(debut).isBefore(DateTime.now()) &&
        DateTime.parse(fin).isAfter(DateTime.now())) {
      return 3;
    } else if (DateTime.parse(debut).isAfter(DateTime.now())) {
      return 2;
    } else if (DateTime.parse(fin).isBefore(DateTime.now())) {
      return 1;
    } else {
      return 0;
    }
  }

  static String getEtatMission(int lib) {
    return lib == 3
        ? "En cours"
        : lib == 2
            ? "A venir"
            : lib == 1
                ? "Passée"
                : "Indefini";
  }

  static Future<bool> showServerSelect(BuildContext context,
      [String defaultServer]) async {
    AppSharedPreferences _appSharedPreferences = AppSharedPreferences();
    ServerUrl serverSelected;
    bool value = false;
    if (defaultServer.isEmptyOrNull) {
      serverSelected = ServerUrl.online;
    } else {
      serverSelected = defaultServer == allTranslations.text('local')
          ? ServerUrl.local
          : ServerUrl.online;
    }

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                // key: _defaultServerFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(allTranslations.text('pls_select_default_server')),
                    RadioListTile<ServerUrl>(
                      groupValue: serverSelected,
                      value: ServerUrl.online,
                      onChanged: (ServerUrl value) {
                        setState(() {
                          serverSelected = value;
                        });
                      },
                      title: Text(
                        allTranslations.text('online'),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    RadioListTile(
                      groupValue: serverSelected,
                      value: ServerUrl.local,
                      onChanged: (ServerUrl value) {
                        setState(() {
                          serverSelected = value;
                        });
                      },
                      title: Text(
                        allTranslations.text('local'),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Annuler"),
                  onPressed: () {
                    setState(() {
                      value = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(allTranslations.text('submit')),
                  onPressed: () async {
                    setState(() {
                      value = true;
                    });
                    Navigator.pop(context);
                    UserPreferences().defaultServer =
                        serverSelected == ServerUrl.local
                            ? allTranslations.text('local')
                            : allTranslations.text('online');
                    await _appSharedPreferences
                        .setDefaultServerEndpoint(
                            serverSelected == ServerUrl.local ? true : false)
                        .then((value) {
                      displaySnackBar(context,
                          "Serveur par défaut: ${serverSelected == ServerUrl.local ? allTranslations.text('local') : allTranslations.text('online')}\n");
                      print(
                        "Setting default server to " +
                            (serverSelected == ServerUrl.local
                                ? allTranslations.text('local')
                                : allTranslations.text('online')),
                      );
                      print("Setting the server_url to " + value);
                    });
                  },
                ),
              ],
            );
          });
        });

    return value;
  }

  static void showSetServerForm(BuildContext context, bool local) {
    TextEditingController serverUrlController = TextEditingController();
    serverUrlController.text = local
        ? json.decode(UserPreferences().localServer)
        : json.decode(UserPreferences().onlineServer);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              GlobalKey formKey = GlobalKey();

              saveServerUrl() {
                setState(() {
                  local
                      ? UserPreferences().localServer =
                          json.encode(serverUrlController.text)
                      : UserPreferences().onlineServer =
                          json.encode(serverUrlController.text);
                  local
                      ? print("Local set to : " + serverUrlController.text)
                      : print("Online set to : " + serverUrlController.text);
                });
              }

              return AlertDialog(
                // contentPadding: EdgeInsets.all(8),
                scrollable: true,
                content: Stack(
                  // fit: StackFit.loose,
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 15),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: serverUrlController,
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                      contentPadding: Vx.m2,
                                      // border: OutlineInputBorder(),
                                      labelText: allTranslations
                                          .text('enter_server_url'),
                                      // prefixIcon: Icon(Icons.language_rounded),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return allTranslations
                                            .text('pls_set_server_url');
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              )),
                          InkValidationButton(
                              onPressed: () {
                                print('serveur modifie');
                                saveServerUrl();
                                Navigator.of(context).pop();
                              },
                              buttontext: "${allTranslations.text('submit')}"),
                          // SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static confirmLogout(BuildContext context) {
    AppSharedPreferences _appSharedPreferences = AppSharedPreferences();
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(allTranslations.text('confirm_logout')),
        content: Text(allTranslations.text('logout_message')),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Valider"),
            onPressed: () async {
              Navigator.pop(context);
              _appSharedPreferences.logout();
              await _appSharedPreferences
                  .loginFake(false)
                  .then((value) => print("Bien deconnceter $value"));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }

  ///afficher un snackbar avec un message(obligatoire) et le type(int): 0 pour echec, 1 pour succes et null pour infos simple
  static displaySnackBar(

      ///Le context de la page actuel
      BuildContext context,

      /// le message (String)
      message,

      /// le type du message(int):0 pour echec, 1 pour succes et null pour infos simple
      {int type}) {
    if (message == null) {
      message = "Operation en cours";
    }
    Color _backColor(int type) {
      Color back;
      if (type == null) back = Colors.black87;
      if (type == 1) back = Colors.green[300];
      if (type == 0) back = Colors.red[300];
      return back;
    }

    String _title(int type) {
      String tilte = "";
      if (type == null) tilte = "Information";
      if (type == 1) tilte = "Succès";
      if (type == 0) tilte = "Attention!";
      return tilte;
    }
/* ===== Scaffold messenger ===== */
    /*final snackBar = SnackBar(
      content: Text(message),
    );
    // widget._materialKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar); */

    Flushbar(
      // title: allTranslations.text(''),
      title: _title(type),
      backgroundColor: _backColor(type),
      message: message,

      duration: Duration(seconds: 5),
      isDismissible: true,
    )..show(context);
  }

  static void shoDetailPop(BuildContext context, String title, String content) {
    // flutter defined function
    TextEditingController controller = TextEditingController();
    controller.text = content;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: TextField(
            controller: controller,
            readOnly: true,
            maxLines: 10,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static missionCardColor(MissionModel mission) {
    int value =
        FunctionUtils.getDateEtat(mission.datedepart, mission.dateretourprob);
    if (value == 3)
      return Colors.green[100];
    else if (value == 2) {
      return Colors.orange[100];
    } else if (value == 1) {
      return Colors.grey[300];
    }
  }

  static String renderTypeAbs(String key, List<dynamic> typeAbs) {
    String result = typeAbs
        .firstWhere(
          (elmt) => elmt.key == key,
          orElse: () => null,
        )
        .value;
    return result ?? allTranslations.text('not_defined');
  }

  /// get center id
  static String getCenterKey(String name, List<CentreModel> centres) {
    String key;
    key = centres
        .firstWhere((element) => element.denominationCenter == name)
        .keyCenter;
    return key;
  }

  /// get center id
  static int getCenterId(String name, List<CentreModel> centres) {
    int id;
    id = centres
        .firstWhere((element) => element.denominationCenter == name)
        .idCenter;
    return id;
  }

  /// get center name by key
  static String getCenterNameByKey(String key, List<CentreModel> centres) {
    String name;
    name = centres
        .firstWhere((element) => element.keyCenter == key)
        .denominationCenter;
    return name;
  }

  /// get center name by id
  static String getCenterName(int id, List<CentreModel> centres) {
    String name;
    name = centres
        .firstWhere((element) => element.idCenter == id)
        .denominationCenter;
    return name;
  }

  static String getApprenantName(String key, List<ApprenantModel> apprenants) {
    String name;
    ApprenantModel apprenant = ApprenantModel();
    apprenant = apprenants.firstWhere((element) => element.keyapprenant == key,
        orElse: () => null);
    name = "${apprenant.nom} ${apprenant.prenoms}";
    return name;
  }

  static String getApprenantKey(String name, List<ApprenantModel> apprenants) {
    String key;
    ApprenantModel apprenant = ApprenantModel();
    apprenant = apprenants.firstWhere(
      (element) =>
          (element.nom + " " + element.prenoms).toLowerCase() ==
          name.toLowerCase(),
      orElse: () => null,
    );
    key = apprenant.keyapprenant;
    return key;
  }

  static renderTacheColor(TacheModel tache) {
    Color result = tache.rapportTache.isEmptyOrNotNull
        ? Colors.grey[100]
        : Colors.grey[300];
    return result;
  }

  static sortTaches(List<TacheModel> allList) {
    allList.sort((a, b) => DateTime.tryParse(b.dateTache)
        .compareTo(DateTime.tryParse(a.dateTache)));

    // List<TacheModel> pendings = allList.where((element) => false);
    // List<TacheModel> rapporteds = allList.where((element) => false);
    List<TacheModel> pendings = [];
    List<TacheModel> rapporteds = [];
    // We create  two lists one for the pendings tasks and one for the rapporteds tasks
    for (var tache in allList) {
      tache.rapportTache.isEmptyOrNull
          ? pendings.add(tache)
          : rapporteds.add(tache);
    }
// Sorting desc
    pendings.sort((a, b) => DateTime.tryParse(b.dateTache)
        .compareTo(DateTime.tryParse(a.dateTache)));
    rapporteds.sort((a, b) => DateTime.tryParse(b.dateTache)
        .compareTo(DateTime.tryParse(a.dateTache)));

    // Clearing the orinal list
    allList.clear();

// Sorted list ready to be used
    allList.addAll(pendings);
    allList.addAll(rapporteds);
    // return allList;
  }

  ///@Hlabs: Send data to server via a form (Ajout, modification a travers un formulaire)
  static sendData({
    BuildContext context,

    ///le nom du dto ici exemple: getInfoDto
    dynamic dto,

    /// Fonction du api_repository qui servira a envoyer les donnees au serveur. Ecrire le nom precede de "api" exemple: api.sendTache
    Function repositoryFunction,

    /// Fonction pour netoyer les champs du formulaire
    Function clearController,

    /// Fonction a executer quand l'envoie de donnee s'est bien passee
    Function onSuccess,

    /// Fonction a executer quand l'envoie de donnee n'a pas abouti ou a generer une erreur
    Function onFailure,

    /// Message de chargement
    String loadingMessage,
  }) {
    print("sending data ...");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(loadingMessage ?? allTranslations.text('processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
                    )
              ],
            ),
          );
        });
    Api api = ApiRepository();
    repositoryFunction(dto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            /* ===== quand l'api retourne un code "000" ===== */
            ///On ferme l'animation du loading
            Navigator.of(context).pop(null);

            ///On ferme le formulaire
            Navigator.of(context).pop(null);

            ///On netoie les champs du formulaire
            clearController();

            ///On affiche pendant 5 secondes le message de succes
            displaySnackBar(context, a.message, type: 1);

            /* ===== quand l'api retourne un code different de "000" ===== */
            /// On execute les autres instructions qu'on veut en csas de success de l'operation (Les setState ect...)
            onSuccess(a);
            return true;
          } else {
            /* ===== quand l'api retourne une erreur d'execution ===== */

            ///On ferme l'animation du loading
            Navigator.of(context).pop(null);

            ///On affiche pendant 5 secondes le message d'erreur
            displaySnackBar(context, a.message, type: 0);

            /// On execute les autres instructions qu'on veut en cas d'erreur de l'operation (Les setState ect...)
            onFailure();
            return false;
          }
        });
      } else {
        /* ===== quand le serveur est introuvable (Pas de connexion ou mauvais url) ===== */

        ///On ferme l'animation du loading
        Navigator.of(context).pop(null);

        ///On affiche pendant 5 secondes le message d'erreur
        displaySnackBar(context, allTranslations.text('error_process'));
        return false;
      }
    });
  }

  ///@Hlabs: get data from server (Tout ce qui est getInfos, getCentres....)
  static getData({
    BuildContext context,

    ///le nom du dto ici exemple: getInfoDto
    dynamic dto,

    /// Fonction loading avec comme parametre [true], ou tout autre fonction a executer avant la recuperation des données
    Function startFunction,

    /// Fonction loading avec comme parametre [false], ou tout autre fonction a executer a la fin de la recuperation des données
    Function stopFunction,

    /// Fonction du api_repository qui servira a recuperer les donnees du serveur. Ecrire le nom precede de "api" exemple: api.getPermisssions
    Function repositoryFunction,

    /// Fonction a executer quand la reception de donnee s'est bien passee
    Function(dynamic) onSuccess,

    /// Fonction a executer en cas d'erreur lors de la reception de donnees
    Function onEmpty,

    /// Fonction a executer en cas d'erreur au niveau du serveur
    Function(bool value) onFailure,

    /// Fonction a executer en cas d'erreur dans la reponse du serveur
    Function onServerError,

    /// Erreur d'execution ou pas
    bool error,
  }) {
    print("En recuperation...");
    startFunction();
    repositoryFunction(dto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            /* ===== quand l'api retourne un code "000" ===== */
            /// Les setState necessaires
            onSuccess(a);
            stopFunction();
            return true;
          } else {
            /* ===== quand l'api retourne un code different de "000" liste probablement vide ou pas d'acces au contenu ===== */
            displaySnackBar(context, a.message);
            onEmpty();
            return false;
          }
        });
      }
      if (value.isLeft()) {
        /* ===== quand le serveur est introuvable (Pas de connexion ou mauvais url) ===== */
        onFailure(true);
        stopFunction();
        displaySnackBar(context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      /* ===== quand l'api retourne une erreur d'execution niveau serveur ===== */
      stopFunction();
      displaySnackBar(context, error.message);
      onServerError();
      return false;
    });
  }
/* End of class */
}
