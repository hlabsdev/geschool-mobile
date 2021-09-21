import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/change_password.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/detail_center.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/profile_menu.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/custom_shape.dart';

class Parametres extends StatefulWidget {
  // const Parametres({Key? key}) : super(key: key);

  @override
  _ParametresState createState() => _ParametresState();
}

/*===== Class start =====*/
class _ParametresState extends State<Parametres> {
  AppSharedPreferences appSharedPreferences = AppSharedPreferences();
  String _defaultServer;
  // String _localServer;
  // String _onlineServer;
  UserModel me;

  var isSuperAdmin;

  @override
  void initState() {
    _defaultServer = UserPreferences().defaultServer;
    // _localServer = json.decode(UserPreferences().localServer);
    // _onlineServer = json.decode(UserPreferences().onlineServer);
    me = UserModel.fromJson(json.decode(UserPreferences().user));
    isSuperAdmin = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ClipPath(
            clipper:
                CustomShape(), // this is my own class which extendsCustomClipper
            child: Container(
              height: 150,
              color: PafpeGreen,
            ),
          ),
          /*General Separator deb*/

          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            color: LightGreyAccent,
            child: Text(allTranslations.text('general'),
                style: TextStyle(fontSize: 16)),
          ),
          // Profil
          ListTile(
            leading: Icon(Icons.person_rounded),
            title: Text(allTranslations.text('profile_title')),
            subtitle: Text(allTranslations.text('see_profil')),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProfileMenu(),
                ),
              );
            },
          ),
          // Info centre
          ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text(allTranslations.text('info_centre')),
            subtitle: Text(allTranslations.text('see_centre')),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DetailCenter(me: me),
                ),
              );
            },
          ),
          // Change password
          ListTile(
            leading: Icon(Icons.lock_outline_rounded),
            title: Text(allTranslations.text('password')),
            subtitle: Text(allTranslations.text('change_password')),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChangePassword(
                    user: me,
                  ),
                ),
              );
            },
          ),
          //  Logout
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red[300],
            ),
            title: Text(allTranslations.text('logout')),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              FunctionUtils.confirmLogout(context);
            },
          ),
          /* 
          // Language
          ListTile(
            leading: Icon(Icons.language),
            title: Text(allTranslations.text('language')),
            subtitle: Text(allTranslations.text('french')),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              showSetLanguageForm(context);
            },
          ), */
          /*général Separator end*/

          /*Server Separator deb*/
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            color: LightGreyAccent,
            child: Text(allTranslations.text('server'),
                style: TextStyle(fontSize: 16)),
          ),
          // Default Server
          ListTile(
            leading: Icon(Icons.settings_remote_rounded),
            title: Text(allTranslations.text('default_server')),
            // subtitle: Text(_defaultServer),
            subtitle: Text(_defaultServer),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              AppSharedPreferences _appSharedPreferences =
                  AppSharedPreferences();
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Continuer?"),
                      content: Text(
                        "Attention! Vous serrez déconnecté après la modification du serveur par defaut, continuer?",
                        textAlign: TextAlign.justify,
                      ),
                      actions: [
                        BasicDialogAction(
                          title: Text("Annuler"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        BasicDialogAction(
                          title: Text("Continuer"),
                          onPressed: () {
                            bool changed;
                            String actual = _defaultServer;
                            Navigator.of(context).pop();
                            FunctionUtils.showServerSelect(
                                    context, _defaultServer)
                                .then((value) {
                              changed = value;
                              setState(() {
                                _defaultServer =
                                    UserPreferences().defaultServer;
                              });
                            });
                            Timer(Duration(seconds: 6), () async {
                              if (changed == true) {
                                if (actual != _defaultServer) {
                                  _appSharedPreferences.logout();
                                  await _appSharedPreferences
                                      .loginFake(false)
                                      .then((value) =>
                                          print("Bien deconnceter $value"));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginPage(),
                                      ));
                                }
                              }
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          /* ===== For super admin only deb */
          // Local Server
          /* ListTile(
            leading: Icon(
              Icons.desktop_windows_rounded,
            ),
            title: Text(allTranslations.text('local_server')),
            subtitle: Text(_localServer, style: TextStyle(color: Colors.blue)),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            onTap: () {
              isSuperAdmin
                  ? FunctionUtils.showSetServerForm(context, true)
                  : print("Pas le droit de modifier");
            },
          ),*/
          // Online Server
          /*ListTile(
              leading: Icon(Icons.wifi_tethering_rounded),
              title: Text(allTranslations.text('online_server')),
              subtitle: Text(_onlineServer,
                  style: TextStyle(color: Colors.blueAccent))), */
          /* ===== For super admin only end */
          /*Server Separator end*/
          SizedBox(height: 30)
        ],
      ),
    );
  }

//TODO: Set Default Language
  void showSetLanguageForm(BuildContext context) {
    // TextEditingController languageController = TextEditingController();

    // languageController.text =
    // local ? UserPreferences().localServer : UserPreferences().onlineServer;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              // ignore: unused_local_variable
              GlobalKey formKey = GlobalKey();

              // saveServerUrl() {
              //   local
              //       ? UserPreferences().localServer = languageController.text
              //       : UserPreferences().onlineServer = languageController.text;
              //   local
              //       ? print("Local set to : " + languageController.text)
              //       : print("Online set to : " + languageController.text);
              // }

              return AlertDialog(
                // contentPadding: EdgeInsets.all(8),
                scrollable: true,
                content: Stack(
                  // fit: StackFit.loose,
                  children: <Widget>[
                    Center(
                      child: Text(
                        allTranslations.text('not_available_yet'),
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                    /*Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 15),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: languageController,
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                      contentPadding: Vx.m2,
                                      border: OutlineInputBorder(),
                                      labelText: allTranslations
                                          .text('enter_server_url'),
                                      prefixIcon: Icon(Icons.language_rounded),
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
                                print('Tache ajoutée');
                                saveServerUrl();
                                Navigator.of(context).pop();
                              },
                              buttontext: "${allTranslations.text('submit')}"),
                          // SizedBox(height: 30.0),
                        ],
                      ),
                    ),*/
                  ],
                ),
              );
            },
          );
        });
  }

//End
}
