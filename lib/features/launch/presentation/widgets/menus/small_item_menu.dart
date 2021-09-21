import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/menu_list_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/widgets/menus/card_menu_btn.dart';

// ignore: must_be_immutable
class SmallItemMenu extends StatelessWidget {
  UserModel me;
  SmallItemMenu(this.me);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Accès Rapide',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SmallMenu(me),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SmallMenu extends StatelessWidget {
  UserModel me;

  SmallMenu(
    this.me, {
    Key key,
  }) : super(key: key);
  List<MenuItem> menus = [];
  List<dynamic> menuPersonnel = [
    "taches",
    "missions",
    "absences_personnel",
    "affectations",
    // "permissions",
    // "notes",
    // "appels",
  ];
  List<dynamic> menuApprenant = [
    "notes",
    // "bulletins",
    "conduites",
    "absences",
    "permissions",
  ];
  List<dynamic> menuParent = [
    "notes",
    // "bulletins",
    "conduites",
    "absences",
    "permissions",
  ];

  @override
  Widget build(BuildContext context) {
    for (var item in jsonDecode(UserPreferences().menus)) {
      menus.add(MenuItem.fromJson(item));
    }
    List<Widget> listMenu = [];
    if (me.typeUser == 1) {
      // Personnels
      // if (me.isProf == 1 || me.idcenters.contains("1")) {
      //   menuPersonnel.insert(menuPersonnel.length, 'notes');
      //   menuPersonnel.insert(menuPersonnel.length, 'appels');
      // }
      for (var menu in menus) {
        if (menuPersonnel.contains(menu.libFonction)) {
          listMenu.add(
            CardMenuBtn(
              imgpath: menu.logo,
              text: menu.libFonction == "absences_personnel"
                  ? 'absences'.toUpperCase()
                  : menu.libFonction.toUpperCase(),
              color: PafpeGreen,
              press: () {
                Navigator.of(context)
                    .pushNamed('/personnel/${menu.libFonction}');
              },
            ),
          );
        }
      }
    } else if (me.typeUser == 2) {
      // Apprenant
      for (var menu in menus) {
        if (menuApprenant.contains(menu.libFonction)) {
          listMenu.add(
            CardMenuBtn(
              imgpath: menu.logo,
              text: menu.libFonction.toUpperCase(),
              color: PafpeGreen,
              press: () {
                Navigator.of(context)
                    .pushNamed('/apprenant/${menu.libFonction}');
              },
            ),
          );
        }
      }
    } else if (me.typeUser == 3) {
      // Parents
      for (var menu in menus) {
        if (menuParent.contains(menu.libFonction)) {
          listMenu.add(
            CardMenuBtn(
              imgpath: menu.logo,
              text: menu.libFonction.toUpperCase(),
              color: PafpeGreen,
              press: () {
                Navigator.of(context).pushNamed('/parent/${menu.libFonction}');
              },
            ),
          );
        }
      }
    }

    return Container(
      padding: EdgeInsets.only(
        // left: 16,
        // right: 16,
        top: 18,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: listMenu.toList(),
      ),
    );
  }
}
