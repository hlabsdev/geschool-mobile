import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class SetServerPage extends StatefulWidget {
  const SetServerPage({Key key}) : super(key: key);
  @override
  _SetServerPageState createState() => _SetServerPageState();
}

class _SetServerPageState extends State<SetServerPage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  TextEditingController _localServerController = TextEditingController();
  TextEditingController _onlineServerController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String defaultServer = "";
  DateTime currentBackPressTime;

  bool _obscureText = true;

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
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      "assets/img/pafpe.png",
                                    ),
                                    height: 110.0,
                                    width: 120.0,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  allTranslations
                                      .text('setting_default_server'),
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
                        SizedBox(height: 10),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Vous êtes actuellement sur le serveur:",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ProductSans',
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${(defaultServer ?? "").toUpperCase()}",
                                style: TextStyle(
                                  color: Colors.redAccent[100],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ProductSans',
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              /* Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  onPressed: () {
                                    showAddForm();
                                  },
                                  child: ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text(
                                      "Définir les urls des serveurs",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    subtitle: Text(
                                      "Super-Admin uniquement",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ).p16(),
                              ), */
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                // ignore: deprecated_member_use
                                child: RaisedButton(
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
                                    leading:
                                        Icon(Icons.settings_remote_rounded),
                                    title: Text(
                                      "Choix du " +
                                          allTranslations
                                              .text('default_server'),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ).p16(),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: InkValidationButton(
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  if (_localServerController.text
                                          .compareTo("") !=
                                      0) {
                                    _onServerSet();
                                    // setServers();
                                  } else {
                                    _displaySnackBar(context,
                                        allTranslations.text('emptyField'));
                                  }
                                }
                              },
                              buttontext: allTranslations.text('continuous'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          )),
    );
  }

  void showAddForm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Vous devez avoir les droits d’administrateur pour pouvoir modifier les urls",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                serverForm(context)
              ],
            ),
            scrollable: true,
            actions: [
              TextButton(
                onPressed: () {
                  _usernameController.text = "";
                  _passwordController.text = "";
                  _localServerController.text =
                      json.decode(UserPreferences().localServer);
                  _onlineServerController.text =
                      json.decode(UserPreferences().onlineServer);
                  Navigator.of(context).pop();
                },
                child: Text(allTranslations.text('cancel')),
              ),
              TextButton(
                onPressed: () {
                  if (formKey2.currentState.validate()) {
                    print('Tache ajoutée');
                    Navigator.of(context).pop();
                    setServers();
                  }
                },
                child: Text(allTranslations.text('submit')),
              )
            ],
          );
        });
  }

  Form serverForm(BuildContext context) {
    return Form(
      key: formKey2,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Identifiant Admin",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Veuillez saisir votre identifiant';
              }
              return null;
            },
          ).p16(),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Mot de passe Admin",
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText ? 'Voir' : 'Cacher',
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Veuillez saisir votre mot de passe';
              }
              return null;
            },
          ).p16(),
          TextFormField(
            controller: _localServerController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: allTranslations.text('local_server'),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_local_server');
              }
              return null;
            },
          ).p16(),
          TextFormField(
            controller: _onlineServerController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: allTranslations.text('online_server'),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_online_server');
              }
              return null;
            },
          ).p16(),
        ],
      ),
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
        // barrierDismissible: false,
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
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });

    setState(() {
      UserPreferences().localServer = json.encode(_localServerController.text);
      UserPreferences().onlineServer =
          json.encode(_onlineServerController.text);
      print("Local set to : " + _localServerController.text);
      print("Online set to : " + _onlineServerController.text);

      _usernameController.text = "";
      _passwordController.text = "";
      _localServerController.text = json.decode(UserPreferences().localServer);
      _onlineServerController.text =
          json.decode(UserPreferences().onlineServer);
    });

    _displaySnackBar(context,
        """Serveur Locale: ${_localServerController.text}\n\nServeur En Ligne: ${_onlineServerController.text}\n""");
    // Timer(Duration(seconds: 1), () {
    //   Navigator.of(context).pop();
    // });
  }

  _displaySnackBar(BuildContext context, message) {
    if (message == null) {
      message = "Opération en cours ...";
    }
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      behavior: SnackBarBehavior.floating,
    );
    // widget._materialKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // _displaySnackBar(message) {
  //   if (message == null) {
  //     message = "Operation en cours";
  //   }
  //   Flushbar(
  //     // title: allTranslations.text(''),
  //     title: "Information",
  //     message: message,
  //     duration: Duration(seconds: 5),
  //   )..show(context);
  // }

  _onServerSet() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, __, ___) => LoginPage(),
        transitionDuration: const Duration(seconds: 1),
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
