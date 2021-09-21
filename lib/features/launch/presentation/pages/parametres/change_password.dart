import 'dart:convert';
import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/change_mdp_dto.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class ChangePassword extends StatefulWidget {
  UserModel user;

  ChangePassword({this.user});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();
  ChangeMdpDto _changeMdpDto = ChangeMdpDto();
  bool _obscureText = true;
  bool _obscureTextNew = true;
  bool _obscureTextConf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('change_password')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
      ),
      body: Center(
        child: Form(
            key: this.formKey,
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _oldPasswordController,
                              // autofocus: true,
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: Vx.m2,
                                border: OutlineInputBorder(),
                                labelText: allTranslations.text('old_password'),
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
                                    semanticLabel: _obscureText
                                        ? allTranslations.text('show')
                                        : allTranslations.text('hide'),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return allTranslations
                                      .text('pls_setold_password');
                                }
                                return null;
                              },
                            ).p16(),
                            TextFormField(
                              controller: _newPasswordController,
                              // autofocus: true,
                              obscureText: _obscureTextNew,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: Vx.m2,
                                border: OutlineInputBorder(),
                                labelText: allTranslations.text('newpassword'),
                                prefixIcon: Icon(
                                  Icons.lock,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureTextNew = !_obscureTextNew;
                                    });
                                  },
                                  child: Icon(
                                    _obscureTextNew
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    semanticLabel: _obscureTextNew
                                        ? allTranslations.text('show')
                                        : allTranslations.text('hide'),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return allTranslations
                                      .text('pls_setnew_password');
                                }
                                return null;
                              },
                            ).p16(),
                            TextFormField(
                              controller: _confirmNewPasswordController,
                              // autofocus: true,
                              obscureText: _obscureTextConf,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding: Vx.m2,
                                border: OutlineInputBorder(),
                                labelText: allTranslations
                                    .text('confirm_new_passxord'),
                                prefixIcon: Icon(
                                  Icons.lock,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureTextConf = !_obscureTextConf;
                                    });
                                  },
                                  child: Icon(
                                    _obscureTextConf
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    semanticLabel: _obscureTextConf
                                        ? allTranslations.text('show')
                                        : allTranslations.text('hide'),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return allTranslations
                                      .text('pls_confirm_new_passxord');
                                } else if (value.toString() !=
                                    _newPasswordController.text.toString()) {
                                  _displaySnackBar(allTranslations
                                      .text('password_identique'));
                                  return allTranslations
                                      .text('password_identique');
                                }
                                return null;
                              },
                            ).p16(),
                          ],
                        )),
                    Center(
                      child: InkValidationButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            if (_oldPasswordController.text.compareTo("") !=
                                    0 &&
                                _confirmNewPasswordController.text
                                        .compareTo("") !=
                                    0) {
                              _changeMdpDto.oldPassword =
                                  _oldPasswordController.text;
                              _changeMdpDto.newPassword =
                                  _confirmNewPasswordController.text;
                              _changeMdpDto.uIdentifiant = widget.user.authKey;
                              _changeMdpDto.registrationId = "";
                              changeMdp();
                            } else {
                              _displaySnackBar(
                                  allTranslations.text('emptyField'));
                            }
                          }
                        },
                        buttontext: allTranslations.text('submit'),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  // _connexion(ConfigModel configModel) async {
  changeMdp() async {
    print("mdp changing...");
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
                CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
                    )
              ],
            ),
          );
        });

    Api api = ApiRepository();
    api.updatePassword(_changeMdpDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            UserModel information = a.information.user;
            //enregistrement des informations de l'utilisateur dans la session
            UserPreferences().user = json.encode(information.toJson());
            // enregistrement des modules actifs;
            UserPreferences().menus =
                json.encode(a.information.menus.toList().toString());
            print(UserPreferences().user);
            print(UserPreferences().menus);
            print("User password update succes");
            setState(() {
              widget.user = information;
            });
            Navigator.of(context).pop(null);
            _displaySnackBar(a.message);
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop(null);
            });
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);
            _displaySnackBar(a.message);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        _displaySnackBar(allTranslations.text('error_process'));
        return false;
      }
    });
  }

  _displaySnackBar(message) {
    if (message == null) {
      message = "Operation en cours";
    }
    Flushbar(
      // title: allTranslations.text(''),
      title: "Information",
      message: message,
      duration: Duration(seconds: 2),
    )..show(context);
  }
/*(BuildContext context, ) {
    if (message == null) {
      message = "Opération en cours ...";
    }
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }*/

//  end
}
