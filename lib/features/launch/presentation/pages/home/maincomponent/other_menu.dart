import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/pages/absences/apprenant/mes_absences_apprenant.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/mes_absences.dart';
import 'package:geschool/features/launch/presentation/pages/affectations/mes_affectations.dart';
import 'package:geschool/features/launch/presentation/pages/missions/mes_missions.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/list_evaluations.dart';
import 'package:geschool/features/launch/presentation/pages/taches/mes_taches.dart';
import 'package:geschool/features/launch/presentation/widgets/menus/big_item_menu.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/custom_shape.dart';

// ignore: must_be_immutable
class OtherMenu extends StatefulWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String type;

  OtherMenu(
    this.type,
  );

  @override
  _OtherMenuState createState() => _OtherMenuState();
}

class _OtherMenuState extends State<OtherMenu> {
  AppSharedPreferences appSharedPreferences = AppSharedPreferences();
  UserModel me = UserModel();
  UserModel menus = UserModel();
  bool haveCentre = false;
  bool isLoading = false;
  String userKey = "";
  String userToken = "";
  String idSearch = "0";

  @override
  void initState() {
    super.initState();
    me = UserModel.fromJson(json.decode(UserPreferences().user));
    menus = UserModel.fromJson(json.decode(UserPreferences().user));
    // getUserInformation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage());
  }

  void _showMessage() {
    if (widget.type.compareTo("-1") == 0) {
      _displaySnackBar(context, allTranslations.text('annonce_success'));
    }
  }

  final titles = [
    'Mon Centre',
    'Mes Missions',
    'Mes Abences',
    'Mes Affectations',
    'Mes Eleves',
    'Le Personnel'
  ];

  @override
  Widget build(BuildContext context) {
    var listMenus = [];
    // listMenus.add([MenuCenter(), 'Mon Centre']);
    // listMenus.add([MenuCenter(), 'Mon Centre']);
    if (me.typeUser == 1) {
      listMenus.add([
        MyMissions(
          me: me,
        ),
        allTranslations.text('my_missions'),
        "assets/images/icons8-shop-86_black.png"
      ]);
      listMenus.add([
        MyAbsences(
          me: me,
        ),
        allTranslations.text('my_absences'),
        "assets/images/icons8-school-86_black.png"
      ]);
      listMenus.add([
        MyAffectations(me: me),
        allTranslations.text('my_affectations'),
        "assets/images/icons8-school-director-86_black.png"
      ]);
      if (me.isProf == 1) {
        listMenus.add([
          ListEvaluations(me: me),
          allTranslations.text('notes'),
          "assets/images/icons8-stocks-86_black.png"
        ]);
        listMenus.add([
          MyTasks(
            me: me,
          ),
          allTranslations.text('my_tasks'),
          "assets/images/icons8-list-86_black.png"
        ]);
      }
    } else {
      if (me.typeUser == 2) {
        listMenus.add([
          MyAbsencesApprenant(
            me: me,
          ),
          allTranslations.text('my_absences'),
          "assets/images/icons8-school-86_black.png"
        ]);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(color: Colors.grey[200]),
          child: Column(
            children: [
              ClipPath(
                clipper:
                    CustomShape(), // this is my own class which extendsCustomClipper
                child: Container(
                  height: 150,
                  color: PafpeGreen,
                ),
              ),
              SizedBox(height: 10),
              // Center(child: ServiceMenu(me)),
              Center(child: BigItemMenu(me)),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),

      /*  Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 10.0),
            //SearchBar(),
            ClipPath(
              clipper:
                  CustomShape(), // this is my own class which extendsCustomClipper
              child: Container(
                height: 150,
                color: PafpeGreen,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisCount: 2,
                addRepaintBoundaries: true,
                addAutomaticKeepAlives: true,
                // childAspectRatio: .85,
                // crossAxisSpacing: 15,
                // mainAxisSpacing: 15,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                // children: List.generate(allCentres.length, (index) {
                // children: List.generate(titles.length, (index) {
                children: List.generate(listMenus.length, (index) {
                  //With Api
                  /*return ElementCard(
                    title:
                        "${allCentres[index].denomination}",
                    pngSrc: "assets/images/icons8-school-86_black.png",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCenter(
                            infoCentre: allCentres[index],
                          ),
                        ),
                      );
                    },
                  );*/
                  //Without Api
                  return ElementCard(
                    title: "${listMenus[index][1]}",
                    // pngSrc: "assets/images/icons8-school-86_black.png",
                    pngSrc: listMenus[index][2],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => listMenus[index][0],
                          // MenuCenter("${listMenus[index][1]}")),
                          // MyAbsences(),
                        ),
                      );
                    },
                  );
                }, growable: true),
              ),
            ),
          ],
        ),
      ), */
    );
  }

  _displaySnackBar(BuildContext context, message) {
    if (message == null) {
      message = "Opération en cours ...";
    }
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /* 
  getCentreListview() {
    if (allCentres == null ||
        allCentres.length == 0 ||
        haveCentre == false) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Image.asset('assets/img/splash.jpg', height: 250),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              width: 300,
              child: Text(
                allTranslations.text('searching_aempty'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: ListeCentreWidget(
            allCentre: allCentres,
            scaffoldKey: widget.scaffoldKey,
            userKey: userKey,
            idSearch: idSearch,
          ));
    }
  }
 */

/* End of class */
}
/* 
class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(""),
      ),
    );
  }

  final List<CentreModel> listExample;
  List<CentreModel> suggestionList;
  GlobalKey<ScaffoldState> scaffoldKey;
  String userKey;
  String idSearch;

  Search(this.listExample, this.userKey, this.scaffoldKey, this.idSearch)
      : super(searchFieldLabel: allTranslations.text('search'));

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionList = [];
    String search = query.toLowerCase();
    search.isEmpty
        ? suggestionList = listExample //In the true case
        : suggestionList.addAll(listExample.where(
            (element) =>
                element.denomination.toLowerCase().contains(search) ||
                element.localite.toLowerCase().contains(search) ||
                element.prefecture.toLowerCase().contains(search) ||
                element.key.toLowerCase().contains(search) ||
                element.nomcourt.toLowerCase().contains(search) ||
                element.email.toLowerCase().contains(search) ||
                element.telephone.toLowerCase().contains(search),
          ));

    if (suggestionList == null || suggestionList.length == 0) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Image.asset('assets/img/splash.jpg', height: 250),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              width: 300,
              child: Text(
                allTranslations.text('searching_aempty'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
          decoration:
              BoxDecoration(color: FunctionUtils.colorFromHex("DDDDDD")),
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: ListeCentreWidget(
            allCentre: suggestionList,
            userKey: userKey,
            scaffoldKey: scaffoldKey,
            idSearch: idSearch,
          ));
    }
  }
}
 */
