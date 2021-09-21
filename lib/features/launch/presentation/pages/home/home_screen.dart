import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/menu_list_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/home/maincomponent/home_menu.dart';
import 'package:geschool/features/launch/presentation/pages/home/maincomponent/other_menu.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/profile_menu.dart';
import 'package:geschool/features/launch/presentation/pages/parametres/notifiactions.dart';
import 'package:geschool/features/launch/presentation/pages/home/maincomponent/parametres.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel me = UserModel();
  int curentIndex = 0;
  List<Widget> children = [];
  DateTime currentBackPressTime;
  List<MenuItem> menus = [];

  GetInfoDto infoDto = GetInfoDto();
  initSate() {
    print("Index sous menu: " + curentIndex.toString());
    _getUserInfo();
    setState(() {
      infoDto.uIdentifiant = me.authKey;
      infoDto.registrationId = "";
    });
    getMenus();
  }

  @override
  Widget build(BuildContext context) {
    children = [
      HomeMenu(),
      OtherMenu("0"),
      Parametres(),
    ];
    List<Widget> listIcon = [
      iconBtnAppbar("assets/icons/Home.svg", "Acueil", 0),
      iconBtnAppbar("assets/icons/Orders.svg", "Menu", 1),
      iconBtnAppbar("assets/icons/Settings.svg", "Paramètres", 2),
    ];
    return Scaffold(
      backgroundColor: BgColor,
      appBar: AppBar(
        elevation: 0,
        title: ElevatedButton(
          onPressed: () {
            getMenus();
          },
          child: Text(
            'GeSchool',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFamily: 'ProductSans',
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 20.0),
            enableFeedback: true,
            tooltip: "Notifications",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyNotifications(),
                ),
              );
            },
            icon: Icon(
              Icons.notifications_on,
              size: 35.0,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 20.0),
            enableFeedback: true,
            tooltip: "Profil",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileMenu()));
            },
            icon: Icon(
              Icons.person_rounded,
              size: 35.0,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 5),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomAppBar(
            elevation: 5,
            child: Container(
              height: 50,
              // width: 200,
              color: Colors.black12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: listIcon,
              ),
            ),
          ),
        ),
      ),
      body: WillPopScope(onWillPop: onWillPop, child: children[curentIndex]),
    );
  }

  _getUserInfo() {
    setState(() {
      me = (UserModel.fromJson(json.decode(UserPreferences().user)));
    });
    print("current user " + me.toJson().toString());
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

  getMenus() {
    _getUserInfo();
    setState(() {
      infoDto.uIdentifiant = me.authKey;
    });
    print("Dtao : " + infoDto.toJson().toString());
    print("user changing...");
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
                // Text(allTranslations.text('processing')),
                Text("Rechargement des menus..."),
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
    api.getMenus(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            // enregistrement des modules actifs
            setState(() {
              menus = a.information;
            });
            UserPreferences().menus = jsonEncode(menus);
            print("Shared menus: ");
            print((UserPreferences().menus));
            Navigator.of(context).pop(null);
            // _displaySnackBar(a.message);
            return true;
          } else {
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'),
            type: 0);
        // _displaySnackBar(allTranslations.text('error_process'));
        return false;
      }
    });
  }

  Widget iconBtnAppbar(String iconpath, String title, int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          curentIndex = index;
        });
      },
      iconSize: 50,
      tooltip: title,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            iconpath,
            height: 20,
            color: curentIndex == index ? GreenLight : BottomIcon,
          ),
          SizedBox(
            height: 2,
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight:
                      curentIndex == index ? FontWeight.w700 : FontWeight.w600,
                  color: curentIndex == index ? GreenLight : BottomIcon),
            ),
          )
        ],
      ),
    );
  }

/* End */
}
