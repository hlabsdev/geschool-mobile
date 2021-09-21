import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/menu_list_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/widgets/menus/card_menu_btn.dart';
import 'package:geschool/features/launch/presentation/widgets/menus/list_menu_btn.dart';

// ignore: must_be_immutable
class BigItemMenu extends StatefulWidget {
  UserModel me;
  BigItemMenu(this.me);

  @override
  _BigItemMenuState createState() => _BigItemMenuState();
}

class _BigItemMenuState extends State<BigItemMenu> {
  bool isList = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // height: 800,
      // height: double.infinity,
      // padding: EdgeInsets.only(top: 17, left: 17, right: 17),
      padding: EdgeInsets.all(20),
      // decoration: BoxDecoration(color: Colors.grey[200]),
      // child: BigMenu(me),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  isList ? Icons.grid_view : Icons.list_outlined,
                  color: PafpeGreen,
                  size: 30,
                ),
                title: Text(
                  isList
                      ? "Cliquez pour voir en grille"
                      : "Cliquez pour voir en liste",
                  style: TextStyle(color: Grey[500], fontSize: 14),
                ),
                onTap: () {
                  setState(() {
                    isList = !isList;
                  });
                },
              )),
          BigMenu(widget.me, isList),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BigMenu extends StatelessWidget {
  UserModel me;
  bool isList;

  BigMenu(
    this.me,
    this.isList, {
    Key key,
  }) : super(key: key);
  double width = 150;
  double height = 150;
  double scale = 1.3;
  double cardFontsize = 15;
  double listFontsize = 18;
  List<MenuItem> menus = [];
  List<dynamic> menuPersonnel = [
    "taches",
    "missions",
    "absences_personnel",
    "permissions",
    "affectations",
    "depenses",
    "budgets",
  ];
  List<dynamic> menuApprenant = [
    "notes",
    "bulletins",
    "conduites",
    "absences",
    "permissions",
  ];
  List<dynamic> menuParent = [
    "notes",
    "bulletins",
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
      if (me.isProf == 1 || me.idcenters.contains("1")) {
        menuPersonnel.insert(menuPersonnel.length, 'notes');
        menuPersonnel.insert(menuPersonnel.length, 'appels');
      }
      for (var menu in menus) {
        if (menuPersonnel.contains(menu.libFonction)) {
          listMenu.add(
            isList
                ? ListMenuBtn(
                    imgpath: menu.logo,
                    text: menu.libFonction == "absences_personnel"
                        ? 'absences'.toUpperCase()
                        : menu.libFonction.toUpperCase(),
                    width: width,
                    color: PafpeGreen,
                    height: height,
                    scale: scale,
                    fontsize: listFontsize,
                    press: () {
                      Navigator.of(context)
                          .pushNamed('/personnel/${menu.libFonction}');
                    },
                  )
                : CardMenuBtn(
                    imgpath: menu.logo,
                    text: menu.libFonction == "absences_personnel"
                        ? 'absences'.toUpperCase()
                        : menu.libFonction.toUpperCase(),
                    width: width,
                    color: PafpeGreen,
                    height: height,
                    scale: scale,
                    fontsize: cardFontsize,
                    press: () {
                      Navigator.of(context)
                          .pushNamed('/personnel/${menu.libFonction}');
                    },
                  ),
          );
        }
      }
      /* listMenu.add(
        isList
            ? ListMenuBtn(
                imgpath:
                    "https://icon-library.com/images/budget-icon/budget-icon-11.jpg",
                text: "Budgets",
                width: width,
                color: PafpeGreen,
                height: height,
                scale: scale,
                fontsize: listFontsize,
                press: () {
                  Navigator.of(context).pushNamed('/personnel/budgets');
                },
              )
            : CardMenuBtn(
                imgpath:
                    "https://icon-library.com/images/budget-icon/budget-icon-11.jpg",
                text: "Budgets",
                width: width,
                color: PafpeGreen,
                height: height,
                scale: scale,
                fontsize: cardFontsize,
                press: () {
                  Navigator.of(context).pushNamed('/personnel/budgets');
                },
              ),
      ); */

    } else if (me.typeUser == 2) {
      // Apprenant
      for (var menu in menus) {
        if (menuApprenant.contains(menu.libFonction)) {
          listMenu.add(
            isList
                ? ListMenuBtn(
                    imgpath: menu.logo,
                    text: menu.libFonction.toUpperCase(),
                    width: width,
                    color: PafpeGreen,
                    height: height,
                    scale: scale,
                    fontsize: listFontsize,
                    press: () {
                      Navigator.of(context)
                          .pushNamed('/apprenant/${menu.libFonction}');
                    },
                  )
                : CardMenuBtn(
                    imgpath: menu.logo,
                    text: menu.libFonction.toUpperCase(),
                    width: width,
                    color: PafpeGreen,
                    height: height,
                    scale: scale,
                    fontsize: cardFontsize,
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
            isList
                ? ListMenuBtn(
                    imgpath: menu.logo,
                    text: menu.libFonction.toUpperCase(),
                    width: width,
                    color: PafpeGreen,
                    height: height,
                    scale: scale,
                    fontsize: listFontsize,
                    press: () {
                      Navigator.of(context)
                          .pushNamed('/parent/${menu.libFonction}');
                    },
                  )
                : CardMenuBtn(
                    imgpath: menu.logo,
                    text: menu.libFonction.toUpperCase(),
                    width: width,
                    color: PafpeGreen,
                    height: height,
                    scale: scale,
                    fontsize: cardFontsize,
                    press: () {
                      Navigator.of(context)
                          .pushNamed('/parent/${menu.libFonction}');
                    },
                  ),
          );
        }
      }
    }

    /*CardMenuBtn(
            imgpath: "assets/img/icons8-school-86_black.png",
            text: "Centres",
             width: width,
          height: height,
          scale: scale,
          press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeCenter()),
              );
            },
          ),*/
    /*CardMenuBtn(
            imgpath: "assets/img/icons8-user-group-86_black.png",
            text: allTranslations.text('personel').toUpperCase(),
             width: width,
          height: height,
          scale: scale,
          press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePersonnel()),
              );
            },
          ),*/
    /*CardMenuBtn(
            imgpath: "assets/img/icons8-school-director-86_black.png",
            text: allTranslations.text('parents').toUpperCase(),
             width: width,
          height: height,
          scale: scale,
          press: () {},
          ),*/

    return Container(
      padding: EdgeInsets.only(
        // left: 16,
        // right: 16,
        top: 18,
      ),
      child: Wrap(
        spacing: 20,
        direction: isList ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 20,
        children: listMenu.toList(),
      ),
    );
  }
}
