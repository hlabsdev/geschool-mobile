import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/all_absences.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/absence_personnel_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class MyAbsences extends StatefulWidget {
  UserModel me;
  MyAbsences({this.me});
  @override
  _MyAbsencesState createState() => _MyAbsencesState();
}

class _MyAbsencesState extends State<MyAbsences> {
  List<AbsenceModel> information = [];
  List<TypesAbsencesPersonnel> typeAbs = [];
  List<AbsenceModel> mesInformations = [];
  List<AbsenceModel> autorise = [];
  List<AbsenceModel> nonautorise = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  int selected = 0;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> typeAbsence = [
      ["Absences non autorisées", nonautorise],
      ["Absences autorisées", autorise],
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('my_absences')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
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
          isAdmin
              ? IconButton(
                  padding: EdgeInsets.only(right: 20.0),
                  icon: Icon(
                    Icons.list_rounded,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllAbsences(
                              me: widget.me,
                              absences: information,
                              typeAbs: typeAbs),
                        ));
                  },
                )
              : Text(''),
        ],
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: mesInformations,
        noDataText: isAdmin
            ? Text(
                allTranslations.text('no_my_absence') +
                    "\n" +
                    allTranslations.text('can_see_all').toLowerCase() +
                    allTranslations.text('absences').toLowerCase(),
                textAlign: TextAlign.center)
            : Text(allTranslations.text('no_my_absence')),
        child: ListView(
          children: [
            SizedBox(height: 10),

            /* Expansions deb */
            SizedBox(height: 8),
            SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              primary: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: typeAbsence.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  collapsedBackgroundColor:
                      typeAbsence[index][0] == "Absences non autorisées"
                          ? Colors.red[100]
                          : Colors.green[100],
                  initiallyExpanded: index == selected,
                  onExpansionChanged: (value) {
                    if (value)
                      setState(() {
                        Duration(seconds: 20000);
                        selected = index;
                      });
                    else
                      setState(() {
                        selected = -1;
                      });
                  },
                  title: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 20.0),
                    height: 40,
                    decoration: BoxDecoration(
                      color: typeAbsence[index][0] == "Absences non autorisées"
                          ? Colors.red[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      typeAbsence[index][0].toUpperCase(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  children: List.generate(
                      typeAbsence[index][1].length,
                      (i) => AbsencePersonnelCardWidget(
                          absence: typeAbsence[index][1][i], typeAbs: typeAbs),
                      growable: true),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
            /* Expansions end */
          ],
        ),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  void checkAdmin(int value) {
    setState(() {
      isAdmin = value == 1 ? true : false;
    });
  }

  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getPersonnelAbsences(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information.infos;
              typeAbs = a.information.typesAbsences;
              mesInformations = a.information.infos
                  .where((element) => element.isMe == 1)
                  .toList();

              separate(mesInformations);
            });
            loading(false);
            checkAdmin(a.isAdmin);
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

  void separate(List<AbsenceModel> allList) {
    setState(() {
      autorise.clear();
      nonautorise.clear();
      autorise =
          allList.where((element) => element.autoriseAbsence == 1).toList();

      nonautorise =
          allList.where((element) => element.autoriseAbsence == 2).toList();
    });
  }

/* End */
}
