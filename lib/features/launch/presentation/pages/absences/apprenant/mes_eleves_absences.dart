import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/eleve_absence_widget.dart';

// ignore: must_be_immutable
class MyStudentAbsence extends StatefulWidget {
  UserModel me;
  MyStudentAbsence({this.me});
  @override
  _MyStudentAbsenceState createState() => _MyStudentAbsenceState();
}

class _MyStudentAbsenceState extends State<MyStudentAbsence> {
  List<AbsenceApprenantModel> information = [];
  List<TypesAbsencesApprenant> typeAbs = [];
  GetInfoDto infoDto = GetInfoDto();
  ScrollController controller = ScrollController();
  List<String> eleves = [];
  int nbElev = 1;
  String annee;
  bool isLoading;
  bool error = false;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: nbElev,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('absences')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 20.0),
              icon: Icon(
                Icons.refresh_rounded,
                size: 30.0,
              ),
              onPressed: () {
                getInfos();
              },
            ),
          ],
          bottom: !isLoading
              ? PreferredSize(
                  preferredSize: Size.fromHeight(50),
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
          noDataText: Text(allTranslations.text('no_my_absence')),
          child: TabBarView(
            children: genTabView(),
          ),
        ),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getApprenantAbsences(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information.infos;
              typeAbs = a.information.typesAbsences;
              if (information.length > 0)
                for (var note in information) {
                  /* if (!matieres.contains(note.))
                    matieres.add(note.matiere);
                  if (!evaluations.contains(note.evaluation))
                    evaluations.add(note.evaluation);
                  if (!periodes.contains(note.decoupage))
                    periodes.add(note.decoupage); */
                  if (!eleves.contains(note.nameUser))
                    eleves.add(note.nameUser);
                }
              nbElev = eleves.length;
              annee = information.first.anneeScolaire;
            });
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
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  genTabBar() {
    List<Widget> tabs = [];
    for (var item in eleves) {
      tabs.add(Tab(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Text("$item\n ",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                "Classe: ${information.firstWhere((element) => element.nameUser == item).classe}",
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center),
          ],
        ),
      ));
    }
    return tabs;
  }

  genTabView() {
    List<Widget> tabs = [];
    for (var item in eleves) {
      tabs.add(EleveAbsenceWidget(
        information:
            information.where((element) => element.nameUser == item).toList(),
        typeAbs: typeAbs,
      ));
    }
    return tabs;
  }
}
