import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/connection_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/menu_list_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/home/home_screen.dart';
import 'package:geschool/features/launch/presentation/pages/login/forget_password.dart';
import 'package:geschool/features/launch/presentation/pages/login/set_default_server_page.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  final _materialKey = GlobalKey<ScaffoldState>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  ConnectionDto _connectionDto = ConnectionDto();
  String _registrationId = "";
  String defaultServer = "";
  AppSharedPreferences _appSharedPreferences = AppSharedPreferences();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();

  Flushbar<List<String>> flush;
  // final GlobalKey<FormState> _defaultServerFormKey = GlobalKey<FormState>();
  bool _obscureText = true;
  DateTime currentBackPressTime;

  // ValueNotifier<ServerUrl> _serverSelected = ValueNotifier<ServerUrl>(ServerUrl.online);
  // ServerUrl _serverSelected = ServerUrl.online;

  @override
  void initState() {
    super.initState();
    // _serverSelected = ServerUrl.online;
    defaultServer = UserPreferences().defaultServer;
    _getUserOtherInfo();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._materialKey,
      body: WillPopScope(
          onWillPop: onWillPop,
          child: Form(
            key: this.formKey,
            child: Center(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(20.0),
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

                          /* CircleAvatar(
                        backgroundImage: AssetImage("assets/img/pafpe.png"),
                        radius: 50,
                        backgroundColor: Colors.transparent,
                      ), */
                        ],
                      ),
                    ),
                  ),
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _telephoneController,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      formKey.currentState.validate();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Identifiant",
                      contentPadding: Vx.m2,
                      hintText: "Exemple : jonhdoe01",
                      prefixIcon: Icon(
                        Icons.account_circle_rounded,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Veuillez saisir votre identifiant';
                      }
                      return null;
                    },
                  ).p16(),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      formKey.currentState.validate();
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      contentPadding: Vx.m2,
                      border: OutlineInputBorder(),
                      labelText: "Mot de passe",
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SetServerPage()));
                        },
                        child: "Choisir le \nserveur par défaut?"
                            .text
                            .sm
                            .textStyle(context.captionStyle)
                            .make()
                            .objectCenterLeft()
                            .p16(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgetPassword()));
                        },
                        child: "Mot de passe oublié ?"
                            .text
                            .sm
                            .textStyle(context.captionStyle)
                            .make()
                            .objectCenterRight()
                            .p16(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: InkValidationButton(
                        onPressed: () async {
                          /*print("En login...");
                      if (formKey.currentState.validate()) {
                        await _appSharedPreferences
                            .loginFake(true)
                            .then((value) => print("Bien logger $value"));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Home()));
                      }*/
                          if (_telephoneController.text.compareTo("") != 0 &&
                              _passwordController.text.compareTo("") != 0) {
                            _connectionDto.password = _passwordController.text;
                            _connectionDto.username = _telephoneController.text;
                            _connectionDto.registrationId = _registrationId;
                            /* FunctionUtils.showServerSelect(context).then(
                          (value) {
                            print(value);
                            value ? _connexion() : print(value);
                          },
                        ); */
                            _connexion();
                          } else {
                            _displaySnackBar(
                                context, allTranslations.text('emptyField'));
                          }
                        },
                        buttontext: "${allTranslations.text('login')}",
                      ),
                    ),
                  )
                ],
              ),
            ),
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

  Future _getUserOtherInfo() async {
    _registrationId = await _appSharedPreferences.getRegistrationId();
  }

  // _connexion(ConfigModel configModel) async {
  _connexion() async {
    print("En login...");
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
                Text(allTranslations.text('login_processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });

    Api api = ApiRepository();
    api.signin(_connectionDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            UserModel information = a.information.user;
            List<MenuItem> menus = a.information.menus;
            //enregistrement des informations de l'utilisateur dans la session
            UserPreferences().user = json.encode(information.toJson());
            // enregistrement des modules actifs;
            UserPreferences().menus = jsonEncode(menus);
            print(UserPreferences().user);
            print(UserPreferences().menus);
            print(json.decode(UserPreferences().user));
            _appSharedPreferences.loginFake(true).then((value) {
              Navigator.of(context).pop(null);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return Home();
                },
              ), ModalRoute.withName("/"));
            });

            return true;
          } else {
            Navigator.of(context).pop(null);
            _displaySnackBar(context, a.message);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        _displaySnackBar(context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      Navigator.of(context).pop(null);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  _displaySnackBar(BuildContext context, message) {
    if (message == null) {
      message = "Opération en cours ...";
    }
    final snackBar = SnackBar(content: Text(message));
    // widget._materialKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

/*End*/
}
