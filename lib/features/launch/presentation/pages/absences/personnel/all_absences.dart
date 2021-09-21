import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/absence_personnel_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/launch/presentation/widgets/filter_pane_widget.dart';

// ignore: must_be_immutable
class AllAbsences extends StatefulWidget {
  List<TypesAbsencesPersonnel> typeAbs;
  UserModel me;
  List<AbsenceModel> absences = [];
  AllAbsences({this.me, this.absences, this.typeAbs});
  @override
  _AllAbsencesState createState() => _AllAbsencesState();
}

class _AllAbsencesState extends State<AllAbsences> {
  // ignore: unused_field
  final formKey = GlobalKey<FormState>();

  TextEditingController motifController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  // ignore: unusedfield
  TextEditingController heureDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  TextEditingController heureFinController = TextEditingController();
  TextEditingController heureRestantController = TextEditingController();
  TextEditingController centreController = TextEditingController();
  TextEditingController userController = TextEditingController();

  List<AbsenceModel> information = [];
  List<AbsenceModel> autorise = [];
  List<AbsenceModel> nonautorise = [];
  List<CentreModel> centres = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  bool allChk = true;
  int isExpanded1 = 1;
  int isExpanded2 = 2;
  int isExpanded3 = 3;
  int selected = -1;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    isLoading = false;
    widget.absences.sort((abs1, abs2) => (DateTime.parse(abs1.datedebutabsence)
        .compareTo(DateTime.parse(abs2.datedebutabsence))));
    information.addAll(widget.absences);
    separate(information);
    allChk = true;
    getCentre();
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
        title: Text(allTranslations.text('all_absences')),
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
          )
        ],
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: widget.absences,
        noDataText: Text(allTranslations.text('no_absence')),
        child: ListView(
          children: [
            SizedBox(height: 10),
            /* Filtre par centre et personnel deb */
            SingleFilterPaneWidget(
                hint: centreController.text == ""
                    ? Text("Centre")
                    : Text(getCenterName(int.parse(centreController.text))),
                isSearchable: false,
                items: centres
                    .map((centre) => DropdownMenuItem(
                          child: Text(centre.denominationCenter),
                          value: centre.idCenter,
                        ))
                    .toList(),
                onChanged: (int value) {
                  setState(() {
                    centreController.text = value.toString();
                    // getCenterId(value).toString();
                  });
                  filterInfo(
                    false,
                    centreController.text,
                  );
                },
                onChecked: (valueNew) {
                  setState(() {
                    allChk = valueNew;
                    centreController.clear();
                    information.clear();
                    information.addAll(widget.absences);
                    separate(information);
                  });
                },
                listAll: () {
                  information.clear();
                  information.addAll(widget.absences);
                  separate(information);
                }),
            SizedBox(height: 5),
            /* Filtre par centre et personnel end */

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
                          absence: typeAbsence[index][1][i],
                          typeAbs: widget.typeAbs),
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
              widget.absences = a.information.infos;
              widget.typeAbs = a.information.typesAbsences;
            });
            separate(widget.absences);
            getCentre();
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

  void getCentre() {
    print("En recuperation...");
    Api api = ApiRepository();
    api.getCentre(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              if (widget.me.idcenters.contains("1")) {
                centres = a.information;
              } else {
                for (var cent in a.information) {
                  for (var item in widget.me.idcenters) {
                    if (cent.idCenter.toString() == item &&
                        !centres.contains(cent)) {
                      centres.add(cent);
                    }
                  }
                }
              }
            });
            return true;
          } else {
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message);
            return false;
          }
        });
      } else if (value.isLeft()) {
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
      }
    }, onError: (error) {
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  int getCenterId(String name) {
    int id;
    id = centres
        .firstWhere((element) => element.denominationCenter == name)
        .idCenter;
    return id;
  }

  String getCenterName(int id) {
    String name;
    name = centres
        .firstWhere((element) => element.idCenter == id)
        .denominationCenter;
    return name;
  }

  void filterInfo(bool tout, [String centre]) {
    // print("Filtering by: " + critere);
    setState(() {
      if (!tout) {
        information = widget.absences
            .where((absence) => absence.idCenter == int.parse(centre))
            .toList();
        separate(information);
        allChk = false;
        print("Filter: $centre");
      } else {
        centreController.text = "";
        if (information.length > 0) information.clear();
        information.addAll(widget.absences);
        separate(information);
        allChk = true;
      }
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
