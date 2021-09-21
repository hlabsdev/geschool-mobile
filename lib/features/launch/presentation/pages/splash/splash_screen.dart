import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geschool/features/launch/presentation/pages/login/login_screen.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/launch/presentation/pages/login/set_default_server_page.dart';
import 'package:geschool/features/launch/presentation/pages/home/home_screen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppSharedPreferences _appSharedPreferences = AppSharedPreferences();
  bool _isLogged = false;
  int startupNumber;

  @override
  void initState() {
    super.initState();
    startupNumber = _getStartupNumber();
    getLoginInfo();
    setOnBoardingVariables();
    Future.delayed(Duration(seconds: 2)).then(
      (value) {
        onDonePress();
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LoginPage(),
        //   ),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext myContext) {
      return Stack(
        children: <Widget>[
          Image.asset(
            'assets/img/bg.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Center(
            child: Text(
              allTranslations.text('project_name'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w700,
                fontFamily: 'ProductSans',
              ),
            ),
          ),
        ],
      );
    }));
  }

  setOnBoardingVariables() {
    if (startupNumber < 1 || startupNumber == 0) {
      UserPreferences().localServer =
          json.encode("http://192.168.20.11/geschool/api/web/mobile_v1");
      UserPreferences().onlineServer =
          json.encode("https://testgeschool.datawise.site/api/web/mobile_v1");
      UserPreferences().defaultServer = allTranslations.text('online');
    }
  }

  Future getLoginInfo() async {
    bool logged = await _appSharedPreferences.getLoginState();
    setState(() {
      _isLogged = logged;
    });
    print(_isLogged ? "Connecte" : "Non Connecte");
  }

  _incrementStartup() {
    int lastStartupNumber = _getStartupNumber();
    int currentStartupNumber = ++lastStartupNumber;
    UserPreferences().startupNumber = currentStartupNumber.toString();
  }

  int _getStartupNumber() {
    String startupNbr = UserPreferences().startupNumber;
    if (startupNbr == null || startupNbr == "") {
      return 0;
    }
    return int.parse(startupNbr);
  }

  void onDonePress() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, __, ___) => _isLogged
            ? Home()
            : startupNumber >= 1
                ? LoginPage()
                : SetServerPage(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        },
      ),
    );
    _incrementStartup();
  }
}
