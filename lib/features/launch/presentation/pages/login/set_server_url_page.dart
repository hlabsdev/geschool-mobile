import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class SetServerUrlPage extends StatefulWidget {
  const SetServerUrlPage({Key key}) : super(key: key);
  @override
  _SetServerUrlPageState createState() => _SetServerUrlPageState();
}

class _SetServerUrlPageState extends State<SetServerUrlPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _localServerController = TextEditingController();
  TextEditingController _onlineServerController = TextEditingController();
  String defaultServer = "";
  DateTime currentBackPressTime;

  @override
  void initState() {
    _localServerController.text = json.decode(UserPreferences().localServer);
    _onlineServerController.text = json.decode(UserPreferences().onlineServer);
    defaultServer = UserPreferences().defaultServer;
    print("Locale = " + _localServerController.text);
    print("Online = " + _onlineServerController.text);
    print("Defaut = " + defaultServer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: onWillPop,
          child: Center(
            child: Form(
                key: this.formKey,
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  allTranslations.text('project_name'),
                                  style: TextStyle(
                                    color: PafpeGreen,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'ProductSans',
                                  ),
                                ),
                                Text(
                                  allTranslations.text('setting_server_url'),
                                  style: TextStyle(
                                    color: Black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'ProductSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _localServerController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: Vx.m2,
                                  border: OutlineInputBorder(),
                                  labelText:
                                      allTranslations.text('local_server'),
                                  prefixIcon: Icon(
                                      Icons.desktop_windows_rounded,
                                      size: 20),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return allTranslations
                                        .text('pls_set_local_server');
                                  }
                                  return null;
                                },
                              ).p16(),
                              TextFormField(
                                controller: _onlineServerController,
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: Vx.m2,
                                  border: OutlineInputBorder(),
                                  labelText:
                                      allTranslations.text('online_server'),
                                  prefixIcon: Icon(Icons.wifi_tethering_rounded,
                                      size: 20),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return allTranslations
                                        .text('pls_set_online_server');
                                  }
                                  return null;
                                },
                              ).p16(),
                              ElevatedButton(
                                onPressed: () {
                                  FunctionUtils.showServerSelect(
                                          context, defaultServer)
                                      .then((value) {
                                    setState(() {
                                      defaultServer =
                                          UserPreferences().defaultServer;
                                    });
                                  });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.settings_remote_rounded),
                                  title: Text(
                                    "Choix du " +
                                        allTranslations.text('default_server'),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ).p16(),
                              "Actuellement défini sur: ${defaultServer ?? ""}"
                                  .text
                                  .sm
                                  .textStyle(context.captionStyle)
                                  .make()
                                  .objectCenter()
                                  .p8(),
                            ],
                          ),
                        ),
                        Center(
                          child: InkValidationButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                if (_localServerController.text.compareTo("") !=
                                    0) {
                                  setServers();
                                } else {
                                  _displaySnackBar(
                                      allTranslations.text('emptyField'));
                                }
                              }
                            },
                            buttontext: allTranslations.text('continuous'),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          )),
    );
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

  setServers() async {
    print("server updating...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(allTranslations.text('processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });
    // saveThe servers
    Timer(Duration(seconds: 4), () {
      UserPreferences().localServer = json.encode(_localServerController.text);
      UserPreferences().onlineServer =
          json.encode(_onlineServerController.text);
    });
    _displaySnackBar(
        """Serveur Locale: ${_localServerController.text}\n\nServeur En Ligne: ${_onlineServerController.text}\n""");
    Navigator.of(context).pop(null);
    _onServerSet();
  }

  _displaySnackBar(message) {
    if (message == null) {
      message = "Operation en cours";
    }
    Flushbar(
      // title: allTranslations.text(''),
      title: "Information",
      message: message,
      duration: Duration(seconds: 5),
    )..show(context);
  }

  _onServerSet() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, __, ___) => LoginPage(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        },
      ),
    );
  }

//  end
}
