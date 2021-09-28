import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/mission_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/mission_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

// ignore: must_be_immutable
class AllMissions extends StatefulWidget {
  UserModel me;
  List<MissionModel> missions;
  AllMissions({this.me, this.missions});
  @override
  _MyMissionsState createState() => _MyMissionsState();
}

class _MyMissionsState extends State<AllMissions> {
  final formKey = GlobalKey<FormState>();
  GetInfoDto infoDto = GetInfoDto();
  List<MissionModel> missionFilter = [];
  List<MissionModel> avenir = [];
  List<MissionModel> encour = [];
  List<MissionModel> passee = [];
  List<CentreModel> centres = [];
  bool isLoading;
  bool error = false;
  bool isAdmin = true;
  int isExpanded1 = 1;
  int isExpanded2 = 2;
  int isExpanded3 = 3;
  int selected = 0;

  TextEditingController _motifController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _datedepartController = TextEditingController();
  TextEditingController _heureDebutController = TextEditingController();
  TextEditingController _dateretourprobController = TextEditingController();
  TextEditingController _heureFinController = TextEditingController();
  TextEditingController _heureRestantController = TextEditingController();
  TextEditingController centreController = TextEditingController();
  TextEditingController userController = TextEditingController();

  bool allChk = true;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    isAdmin = true;
    isLoading = false;
    centreController.text = "";
    missionFilter.addAll(widget.missions);
    separate(missionFilter);
    allChk = true;
    getCentre();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('all_missions')),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: [
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
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: widget.missions,
        noDataText: Text(allTranslations.text('no_mission')),
        child: ListView(
          children: [
            SizedBox(height: 10),
            /* Filtre par centre et personnel deb */
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        child: SearchableDropdown(
                          closeButton: "Fermer",
                          isExpanded: true,
                          items: centres
                              .map((centre) => DropdownMenuItem(
                                    child: Text(centre.denominationCenter),
                                    value: centre.denominationCenter,
                                  ))
                              .toList(),
                          hint: centreController.text == ""
                              ? Text("Centre")
                              // : Text(getCenterName(
                              //     int.parse(centreController.text))),
                              : Text(centreController.text),
                          onChanged: (value) {
                            setState(() {
                              centreController.text = value;
                              // centreController.text = getCenterId(value).toString();
                            });
                            filterInfo(
                              false,
                              centreController.text,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        child: CheckboxListTile(
                          tristate: false,
                          secondary: const Text('Tout'),
                          // subtitle: Text(allTranslations.text('can_filter_per_date')),
                          value: allChk,
                          onChanged: (valueNew) {
                            setState(() {
                              allChk = valueNew;
                              centreController.clear();
                              missionFilter.clear();
                              missionFilter.addAll(widget.missions);
                              separate(missionFilter);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            /* Filtre par centre et personnel end */
            /* Expansions deb */
            SizedBox(height: 8),
            ExpansionTile(
              collapsedBackgroundColor: Colors.orange[100],
              initiallyExpanded: isExpanded1 == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = isExpanded1;
                  });
                else
                  setState(() {
                    selected = -1;
                  });
              },
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  ("Missions à venir").toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  avenir.length,
                  (i) =>
                      MissionCardWidget(isAdmin: isAdmin, mission: avenir[i]),
                  growable: true),
            ),
            SizedBox(height: 8),
            ExpansionTile(
              collapsedBackgroundColor: Colors.green[100],
              initiallyExpanded: isExpanded2 == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = isExpanded2;
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
                  color: Colors.green[100],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  ("Missions en cours").toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  encour.length,
                  (i) =>
                      MissionCardWidget(isAdmin: isAdmin, mission: encour[i]),
                  growable: true),
            ),
            SizedBox(height: 8),
            ExpansionTile(
              collapsedBackgroundColor: Colors.grey[400],
              initiallyExpanded: isExpanded3 == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = isExpanded3;
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
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  ("Missions passées").toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  passee.length,
                  (i) =>
                      MissionCardWidget(isAdmin: isAdmin, mission: passee[i]),
                  growable: true),
            ),
            /* Expansions end */
            // GroupedListView<MissionModel, int>(
            //   shrinkWrap: true,
            //   elements: missionFilter,
            //   groupBy: (element) => FunctionUtils.getDateEtat(
            //       element.datedepart, element.dateretourprob),
            //   groupSeparatorBuilder: (value) => Container(
            //     height: 30,
            //     alignment: Alignment.center,
            //     margin: EdgeInsets.symmetric(horizontal: 35.0),
            //     decoration: BoxDecoration(
            //       color: Grey,
            //       borderRadius: BorderRadius.all(Radius.circular(20)),
            //     ),
            //     child: Text(
            //       ("Missions " + FunctionUtils.getEtatMission(value))
            //           .toUpperCase(),
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            //   // useStickyGroupSeparators: true,
            //   // floatingHeader: true,
            //   itemComparator: (item1, item2) =>
            //       (DateTime.parse(item1.datedepart).compareTo(
            //     DateTime.parse(item2.datedepart),
            //   )),
            //   groupComparator: (item1, item2) => ((item1).compareTo((item2))),
            //   order: GroupedListOrder.DESC,

            //   itemBuilder: (context, element) {
            //     return MissionCardWidget(isAdmin: isAdmin, mission: element);
            //   },
            //   // itemCount: information.length,
            //   // separatorBuilder: (context, i) => Divider(),
            // ),
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

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getMissions(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            widget.missions = a.information;

            separate(a.information);
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

  void showAddForm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(8),
            scrollable: true,
            content: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /* SizedBox(
                            width: 300,
                            height: 50,
                            child: DropdownButton<String>(
                              items:
                                  // <String>typeAbs.map((String value) {
                                  <String>["Permission", "Congé"]
                                      .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                              // hint: new Text("Type d'information"),
                            ),
                          ),*/
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          // onTap: () {
                          //   FunctionUtils.selectDate(context);
                          // },
                          controller: _motifController,
                          decoration: InputDecoration(
                            labelText: "Motif",
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 50,
                            child: TextFormField(
                              controller: _datedepartController,
                              onTap: () {
                                FunctionUtils.selectDate(
                                    context, _datedepartController);
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "allTranslations.text('start')",
                              ),
                            ),
                          ),
                          Text(":"),
                          SizedBox(
                            width: 110,
                            height: 50,
                            child: TextFormField(
                              controller: _heureDebutController,
                              onTap: () {
                                FunctionUtils.selectTime(
                                    context, _heureDebutController);
                              },
                              readOnly: true,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: "Heure",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 50,
                            child: TextFormField(
                              controller: _dateretourprobController,
                              onTap: () {
                                FunctionUtils.selectDate(
                                    context, _dateretourprobController);
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Fin",
                              ),
                            ),
                          ),
                          Text(":"),
                          SizedBox(
                            width: 110,
                            height: 50,
                            child: TextFormField(
                              controller: _heureFinController,
                              onTap: () {
                                FunctionUtils.selectTime(
                                    context, _heureFinController);
                              },
                              readOnly: true,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: "Heure",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          controller: _destinationController,
                          /*   onTap: () {
                                FunctionUtils.selectTime(context);
                              }, */
                          decoration: InputDecoration(
                            labelText: "Destination",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          controller: _heureRestantController,
                          /*   onTap: () {
                                FunctionUtils.selectTime(context);
                              }, */
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: "Heures à rattraper",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Enoyer la demande"),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              // saveNewDemande();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
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

  void filterInfo(bool tout, [String centre]) {
    // print("Filtering by: " + critere);
    setState(() {
      if (!tout) {
        // .where((mission) => mission.idCenter == )
        missionFilter = widget.missions
            // .where((mission) => mission.idCenter == int.parse(centre))
            .where((mission) => mission.nameCentre == (centre))
            .toList();

        separate(missionFilter);
        allChk = false;
      } else {
        centreController.text = "";
        if (missionFilter.length > 0) missionFilter.clear();
        missionFilter.addAll(widget.missions);
        separate(widget.missions);
        allChk = true;
      }
    });
  }

  missionCardColor(MissionModel mission) {
    int value =
        FunctionUtils.getDateEtat(mission.datedepart, mission.dateretourprob);
    if (value == 3)
      return Colors.green[100];
    else if (value == 2) {
      return Colors.grey[100];
    } else if (value == 1) {
      return Colors.grey[400];
    }
  }

  void separate(List<MissionModel> allList) {
    setState(() {
      passee.clear();
      avenir.clear();
      encour.clear();
      passee = allList
          .where((element) =>
              FunctionUtils.getDateEtat(
                  element.datedepart, element.dateretourprob) ==
              1)
          .toList();
      avenir = allList
          .where((element) =>
              FunctionUtils.getDateEtat(
                  element.datedepart, element.dateretourprob) ==
              2)
          .toList();
      encour = allList
          .where((element) =>
              FunctionUtils.getDateEtat(
                  element.datedepart, element.dateretourprob) ==
              3)
          .toList();
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

/* End */
}
