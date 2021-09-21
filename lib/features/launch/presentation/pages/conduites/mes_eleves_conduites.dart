import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/conduite_list_reponse_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/eleve_conduite_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class MyStudentConduite extends StatefulWidget {
  UserModel me;
  MyStudentConduite({this.me});
  @override
  _MyStudentConduiteState createState() => _MyStudentConduiteState();
}

class _MyStudentConduiteState extends State<MyStudentConduite> {
  List<DetailApprenantConduite> information = [];
  int nbElev = 0;
  String annee;
  GetInfoDto infoDto = GetInfoDto();
  ScrollController controller = ScrollController();
  bool isLoading;
  bool error = false;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

/* 
          */
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: nbElev,
      child: Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('conduites')),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 20.0),
              onPressed: () {
                getInfos();
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: 26.0,
              ),
            ),
          ],
          bottom: !isLoading
              ? PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Scrollbar(
                    radius: Radius.circular(10),
                    thickness: 5,
                    isAlwaysShown: true,
                    controller: controller,
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      tabs: genTabBar(),
                      labelPadding: EdgeInsets.only(
                          bottom: 0.5, top: 2, left: 15, right: 15),
                      isScrollable: true,
                      indicator: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(10)),
                      // physics: AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                )
              : null,
        ),
        body: RefreshableWidget(
            onRefresh: getInfos,
            isLoading: isLoading,
            error: error,
            information: information,
            noDataText: Text(allTranslations.text('no_note')),
            child: TabBarView(
              children: genTabView(),
            )),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getConduites(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            // setState(() {
            information = a.information;
            nbElev = a.information.length;
            // });
            print(information.length);
            print(nbElev);
            loading(false);
            return true;
          } else {
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message);
            return false;
          }
        });
      } else if (value.isLeft()) {
        setState(() {
          error = true;
        });
        loading(false);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      loading(false);
      FunctionUtils.displaySnackBar(context, error.toString());
    });
  }

  genTabBar() {
    List<Widget> tabs = [];
    for (var item in information) {
      print(information.length);
      String classe =
          item.classe.libellespecialite + " " + item.classe.libelleclasse;
      tabs.add(
        Tab(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Text("${item.nom}\n ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Classe: $classe",
                  style: TextStyle(fontSize: 13), textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return tabs;
  }

  genTabView() {
    List<Widget> tabs = [];
    for (var item in information) {
      tabs.add(EveleConduiteWidget(
        information: item,
      ));
      /* tabs.add(EleveNoteWidget(
        evaluations: evaluations,
        matieres: matieres,
        periodes: periodes,
        information:
            information.where((element) => element.nameUser == item).toList(),
      )); */
    }
    return tabs;
  }

/* End */
}
