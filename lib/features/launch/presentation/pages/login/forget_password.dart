import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/reset_password_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

enum ResetMethod { by_mail, by_tel }

class _ForgetPasswordState extends State<ForgetPassword> {
  final _modeFormKey = GlobalKey<FormState>();
  final usernameFieldKey = GlobalKey();
  final _codeFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  AppSharedPreferences appSharedPreferences = AppSharedPreferences();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool isTel = true;
  ResetMethod _resetMethod = ResetMethod.by_tel;
  ResetPasswordDto forgetPasswordDto = ResetPasswordDto();
  ResetPasswordDto resetPasswordDto = ResetPasswordDto();

  // OTPTextEditController _codeController;
  String codeFromSms;
  final scaffoldKey = GlobalKey();

  List<StepState> _listState;

  int steps = 3;
  int currentStep = 0;
  bool complete = false;
  bool isOktoNext;
  bool step1Error = false;
  bool step2Error = false;
  bool step3Error = false;

  @override
  void initState() {
    currentStep = 0;
    _listState = [
      StepState.indexed,
      StepState.editing,
      StepState.complete,
      StepState.error,
    ];
    isTel = true;
    _resetMethod = ResetMethod.by_tel;
    super.initState();
  }

  List<Step> _createSteps(BuildContext context) {
    List<Step> steps = <Step>[
      // Step 1
      Step(
        // Step 1
        title: Text("Mode"),
        isActive: currentStep == 0 ? true : false,
        state: currentStep == 0
            ? _listState[1]
            // : step1Error? _listState[3] :_listState[2],
            : step1Error
                ? _listState[3]
                : currentStep > 0
                    ? _listState[2]
                    : _listState[0],
        content: Form(
          key: _modeFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Radio<ResetMethod>(
                            value: ResetMethod.by_tel,
                            visualDensity: VisualDensity.compact,
                            groupValue: _resetMethod,
                            onChanged: (ResetMethod value) {
                              setState(() {
                                _resetMethod = value;
                              });
                            },
                          ),
                          Radio<ResetMethod>(
                            value: ResetMethod.by_mail,
                            visualDensity: VisualDensity.compact,
                            groupValue: _resetMethod,
                            onChanged: (ResetMethod value) {
                              setState(() {
                                _resetMethod = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allTranslations.text('by_tel'),
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            allTranslations.text('by_mail'),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                key: usernameFieldKey,
                keyboardType: TextInputType.text,
                controller: _usernameController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  _modeFormKey.currentState.validate();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: allTranslations.text('username'),
                  contentPadding: Vx.m2,
                  hintText: "Exemple : johndoe",
                  prefixIcon: Icon(Icons.account_circle),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return allTranslations.text('pls_set_username');
                  }
                  return null;
                },
              ).p16(),
            ],
          ),
        ),
      ),
      // Step 2
      Step(
        isActive: currentStep == 1 ? true : false,
        state: currentStep == 1
            ? _listState[1]
            : step2Error
                ? _listState[3]
                : currentStep > 1
                    ? _listState[2]
                    : _listState[0],
        title: Text("Code"),
        content: Form(
          key: _codeFormKey,
          child: Column(
            children: [
              Container(
                child: Text(
                  _resetMethod == ResetMethod.by_tel
                      ? allTranslations.text('enter_code_received_by_tel')
                      : allTranslations.text('enter_code_received_by_mail'),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _codeController,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  if (value.length == 6) {}
                  _codeFormKey.currentState.validate();
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: allTranslations.text('confirmcode'),
                  contentPadding: Vx.m2,
                  hintText: "Exemple : 12345",
                  prefixIcon: Icon(
                    Icons.confirmation_number_rounded,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return allTranslations.text('pls_set_code');
                  } else if (value.length < 5) {
                    return allTranslations.text('pls_enter_all_code');
                  }
                  return null;
                },
              ).p16(),
              SizedBox(),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: getCode,
                  child: Text(allTranslations.text('code_notreceived')),
                ),
              ),
            ],
          ),
        ),
      ),
      // Step 3
      Step(
        isActive: currentStep == 2 ? true : false,
        state: currentStep == 2
            ? _listState[1]
            : step3Error
                ? _listState[3]
                : currentStep > 2
                    ? _listState[2]
                    : _listState[0],
        title: Text(allTranslations.text('password')),
        content: Form(
          key: _passwordFormKey,
          child: Column(
            children: [
              Container(
                child: Text(allTranslations.text('setnew_password')),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  _passwordFormKey.currentState.validate();
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: allTranslations.text('newpassword'),
                  contentPadding: Vx.m2,
                  // hintText: "Exemple : 123456",
                  prefixIcon: Icon(
                    Icons.enhanced_encryption,
                  ),
                  suffixIcon: GestureDetector(
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
                    return allTranslations.text('pls_set_password');
                  }
                  return null;
                },
              ).p16(),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordConfirmController,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  _passwordFormKey.currentState.validate();
                },
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: allTranslations.text('confirmpassword'),
                  contentPadding: Vx.m2,
                  // hintText: "Exemple : 123456",
                  prefixIcon: Icon(
                    Icons.enhanced_encryption,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText2 = !_obscureText2;
                      });
                    },
                    child: Icon(
                      _obscureText2 ? Icons.visibility : Icons.visibility_off,
                      semanticLabel: _obscureText2 ? 'Voir' : 'Cacher',
                    ),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return allTranslations.text('pls_set_password');
                  }
                  return null;
                },
              ).p16(),
            ],
          ),
        ),
      ),
    ];

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    List<Step> _stepList = _createSteps(context);

    return Scaffold(
      // appBar: AppBar(
      //   //title: Text(allTranslations.text('personel')),
      // ),
      body: Column(
        children: [
          Container(
            // margin: EdgeInsets.,
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: Text(
                allTranslations.text('project_name'),
                style: TextStyle(
                  color: PafpeGreen,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'ProductSans',
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: Text(
                allTranslations.text('new_password'),
                style: TextStyle(
                  color: GreenLight,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'ProductSans',
                ),
              ),
            ),
          ),
          Expanded(
            child: Stepper(
              steps: _stepList,
              type: StepperType.horizontal,
              currentStep: currentStep,
              // onStepContinue: next,
              onStepContinue: () {
                checkError(context);
              },
              // onStepTapped: (step) => goTo(step),
              onStepTapped: (int i) {
                setState(() {
                  currentStep = i;
                });
              },
              // onStepCancel: cancel,
              onStepCancel: () {
                setState(() {
                  if (currentStep > 0) {
                    currentStep--;
                  } else if (currentStep == 0) {
                    Navigator.pop(context);
                    // currentStep = 0;
                  }
                  //_setStep(context);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void goToNextStep() {
    setState(() {
      if (currentStep < 2) {
        currentStep++;
      } else {
        currentStep = 2;
      }
    });
  }

  getCode() {
    if (!step1Error) {
      forgetPasswordDto.username = _usernameController.text ?? "";
      forgetPasswordDto.typeField =
          _resetMethod == ResetMethod.by_tel ? "telephone" : "email";
      forgetPasswordDto.registrationId = "";
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

      Api api = ApiRepository();
      print(forgetPasswordDto.toJson());
      api.forgetPassword(forgetPasswordDto).then((value) {
        if (value.isRight()) {
          value.all((a) {
            if (a != null && a.status.compareTo("000") == 0) {
              setState(() {
                codeFromSms = a.message;
              });
              UserModel information = a.information.user;
              //enregistrement des informations de l'utilisateur dans la session
              UserPreferences().user = json.encode(information.toJson());
              // enregistrement des modules actifs;
              UserPreferences().menus =
                  json.encode(a.information.menus.toList().toString());
              print(UserPreferences().user);
              print(UserPreferences().menus);
              Navigator.of(context).pop(null);
              showInfoFlushbar(context, "Code envoyé".toUpperCase(),
                  allTranslations.text('code_send_success'));
              goToNextStep();
              return true;
            } else {
              Navigator.of(context).pop(null);
              showInfoFlushbar(context, "Erreur!", a.message);
              return false;
            }
          });
        } else {
          Navigator.of(context).pop(null);
          showInfoFlushbar(
              context, "Erreur!", allTranslations.text('error_process'));
          return false;
        }
      });
    } else {
      showInfoFlushbar(context, "Erreur de saisie",
          "Verifier si vous avez rempli tout les champs");
    }

    return isOktoNext;
  }

  resetMyPassword() {
    if (!step3Error) {
      resetPasswordDto.username = _usernameController.text ?? "";
      resetPasswordDto.typeField =
          _resetMethod == ResetMethod.by_tel ? "telephone" : "email";
      resetPasswordDto.registrationId = "";

      if (_passwordController.text == _passwordConfirmController.text) {
        resetPasswordDto.password = _passwordConfirmController.text;
        resetPasswordDto.codeValidation = _codeController.text;
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

        Api api = ApiRepository();
        print(resetPasswordDto.toJson());
        api.resetPassword(resetPasswordDto).then((value) {
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
                Navigator.of(context).pop(null);
                showInfoFlushbar(
                    context, a.message, allTranslations.text('success_reset'));
                Future.delayed(Duration(milliseconds: 2000), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                      ));
                });
                goToNextStep();
                return true;
              } else if ((a != null && a.status.compareTo("007") == 0) ||
                  a.message == "Code de validation incorrect") {
                //Verification du code
                Navigator.of(context).pop(null);
                showInfoFlushbar(
                    context, a.message, allTranslations.text('code_incorrect'));
                setState(() {
                  currentStep = 1;
                });
                return false;
              } else {
                Navigator.of(context).pop(null);
                showInfoFlushbar(context, "Erreur!", a.message);
                return false;
              }
            });
          } else {
            Navigator.of(context).pop(null);
            showInfoFlushbar(
                context, "Erreur!", allTranslations.text('error_process'));
            return false;
          }
        });
      } else {
        showInfoFlushbar(context, allTranslations.text('non_conform_password'),
            allTranslations.text('non_conform_password_message'));
        return false;
      }
    } else {
      showInfoFlushbar(context, "Erreur de saisie",
          "Verifier si vous avez bien rempli tout les champs");
    }
  }

  // Future<bool> checkError(BuildContext context) async {
  checkError(BuildContext context) {
    // GlobalKey<FormState> formKey;
    isOktoNext = false;
    switch (currentStep) {
      //Getting Code
      case 0:
        {
          _modeFormKey.currentState.validate();
          setState(() {
            step1Error = !_modeFormKey.currentState.validate();
            // isOktoNext = true;
          });

          if (!step1Error) {
            getCode();
            print("Tel $isOktoNext");
          }
          break;
        }

      //Check Code
      case 1:
        {
          _codeFormKey.currentState.validate();
          setState(() {
            step2Error = !_codeFormKey.currentState.validate();
            if (!step2Error) {
              if (_codeController.text == codeFromSms) {
                goToNextStep();
              } else {
                FunctionUtils.displaySnackBar(context,
                    "Code incorrect! Assurez vous d'entrer le bon code",
                    type: 0);
              }
            }
          });
          break;
        }

      //Change password
      case 2:
        {
          _passwordFormKey.currentState.validate();
          setState(() {
            step3Error = !_passwordFormKey.currentState.validate();
          });
          //Validation and login deb
          if (!step3Error) {
            resetMyPassword();
            print("Mot de passe $isOktoNext");
            print("Mot de passe change avec success");
          } //Validation and login end
          break;
        }
    }
    return isOktoNext;
  }

  void showInfoFlushbar(BuildContext context, String title, String message) {
    Flushbar(
      title: title ?? "Infos",
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: GreenLight,
      duration: Duration(seconds: 5),
    )..show(context);
  }

  /* End */
}
