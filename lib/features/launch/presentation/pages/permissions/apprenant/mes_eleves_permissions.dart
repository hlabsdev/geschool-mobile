import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/eleve_permission_widget.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class MyStudentPermisions extends StatefulWidget {
  UserModel me;
  MyStudentPermisions({this.me});
  @override
  _MyStudentAbsenceState createState() => _MyStudentAbsenceState();
}

class _MyStudentAbsenceState extends State<MyStudentPermisions> {
  List<PermissionApprenantModel> information = [];
  List<CentreModel> centres = [];
  GetInfoDto infoDto = GetInfoDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();
  ScrollController controller = ScrollController();
  /* For form deb */
  TextEditingController _centreController = TextEditingController();
  TextEditingController _apprenantController = TextEditingController();
  TextEditingController _motifController = TextEditingController();
  TextEditingController _datedemandeController = TextEditingController();
  TextEditingController _datedebutController = TextEditingController();
  TextEditingController _heuredebutController = TextEditingController();
  TextEditingController _datefinController = TextEditingController();
  TextEditingController _heurefinController = TextEditingController();
  /* For form end */
  List<ApprenantModel> eleves = [];
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
          title: Text(allTranslations.text('permissions')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddForm(null);
          },
          child: Icon(Icons.add_rounded),
        ),
        body: RefreshableWidget(
          onRefresh: getInfos,
          isLoading: isLoading,
          error: error,
          information: information,
          noDataText: Text(allTranslations.text('no_permission')),
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
    api.getPerms(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              eleves.clear();
              centres.clear();
              information = a.information;
              if (information.length > 0)
                information.sort((a, b) =>
                    DateTime.tryParse(b.datedemandepermission)
                        .compareTo(DateTime.tryParse(a.datedemandepermission)));
              for (var perm in information) {
                if (!centres.any(
                    (element) => element.idCenter.toString() == perm.idCenter))
                  centres.add(
                    CentreModel(
                      idCenter: int.parse(perm.idCenter),
                      denominationCenter: perm.denominationCenter,
                    ),
                  );

                if (!eleves.any(
                    (element) => element.keyapprenant == perm.keyapprenant))
                  eleves.add(
                    ApprenantModel(
                      nom: perm.nom,
                      prenoms: perm.prenoms,
                      keyapprenant: perm.keyapprenant,
                    ),
                  );
              }
              centres.forEach((element) {
                print("\n Centre: ${element.toJson()}\n");
              });

              eleves.forEach((element) {
                print("\n Eleve: ${element.toJson()}\n");
              });
              nbElev = eleves.length;
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

  sendPerm() {
    print("En envoie...");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Center(
            child: Column(
              children: [
                Text(allTranslations.text('pls_wait')),
                CircularProgressIndicator(
                  semanticsLabel: allTranslations.text('pls_wait'),
                ),
              ],
            ),
          ),
        );
      },
    );
    Api api = ApiRepository();
    debugPrint("\n${addPermDto.toJson()}");
    api.sendPerm(addPermDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            ///enregistrement des informations de recuperes
            setState(() {
              information = a.information;
            });
            getInfos();
            Navigator.of(context).pop(null);
            clearController();
            Navigator.of(context).pop(null);
            clearController();
            // context, "Opération effectuée avec succès",
            FunctionUtils.displaySnackBar(
                context, "Opération effectuée avec succès",
                type: 1);
            return true;
          } else {
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else if (value.isLeft()) {
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'),
            type: 0);
        return false;
      }
    }, onError: (error) {
      Navigator.of(context).pop(null);
      FunctionUtils.displaySnackBar(context, error.message, type: 0);
    });
  }

  void showAddForm(PermissionApprenantModel permission) {
    if (permission != null) {
      _motifController.text = permission.motifpermission;
      _datedebutController.text = permission.datedebutpermission +
          " " +
          permission.heuredebutpermission;
      _datefinController.text =
          permission.datefinpermission + " " + permission.heurefinpermission;
      _heuredebutController.text = permission.heuredebutpermission;
      _heurefinController.text = permission.heurefinpermission;
      addPermDto.permissionKey = permission.keypermission;
      addPermDto.operation = "2";
    } else {
      addPermDto.operation = "1";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (centres.length == 1)
            _centreController.text = centres.first.idCenter.toString();
          addPermDto.demande = "1";
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Stack(
                  children: <Widget>[permForm(context)],
                ),
                scrollable: true,
                actions: [
                  TextButton(
                    onPressed: () {
                      clearController();
                      Navigator.of(context).pop();
                    },
                    child: Text(allTranslations.text('cancel')),
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        print('Tâche ajoutée');
                        setState(() {
                          addPermDto.demande = "1";
                          addPermDto.motif = _motifController.text ?? "";
                          addPermDto.dateDemande =
                              DateTime.now().toString().split(".")[0];
                          addPermDto.uIdentifiant = widget.me.authKey;
                          addPermDto.idCenter = _centreController.text ?? "";
                          addPermDto.keyApprenant =
                              _apprenantController.text ?? "";
                          addPermDto.dateDebut =
                              _datedebutController.text.split(" ")[0] ?? "";
                          addPermDto.dateFin =
                              _datefinController.text.split(" ")[0] ?? "";
                          addPermDto.heureDebut =
                              _heuredebutController.text ?? "";
                          addPermDto.heureFin = _heurefinController.text ?? "";
                        });
                        sendPerm();
                      }
                    },
                    child: Text(allTranslations.text('submit')),
                  )
                ],
              );
            },
          );
          // });
        }).then((value) => clearController());
  }

  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          centres.length > 1
              ? DropdownButtonFormField(
                  isExpanded: true,
                  items: centres
                      .map((perso) => DropdownMenuItem(
                            child: Text(perso.denominationCenter),
                            value: perso.idCenter.toString(),
                          ))
                      .toList(),
                  hint: _centreController.text == ""
                      ? Text("Centre")
                      : Text(FunctionUtils.getCenterName(
                          int.parse(_centreController.text), centres)),
                  onChanged: (value) {
                    setState(() {
                      _centreController.text = value;
                    });
                  },
                ).py12()
              : SizedBox(height: 0),
          DropdownButtonFormField<String>(
            isExpanded: true,
            // items: personnelsFilter
            items: eleves
                .map((apprenant) => DropdownMenuItem(
                      child: Text(FunctionUtils.getApprenantName(
                          apprenant.keyapprenant, eleves)),
                      // value: perso.keypersonnel,
                      value: apprenant.keyapprenant,
                      onTap: () => print(apprenant.keyapprenant),
                    ))
                .toList(),
            hint: _apprenantController.text == ""
                ? Text("Apprenant")
                : Text(FunctionUtils.getApprenantName(
                    _apprenantController.text, eleves)),
            onChanged: (value) {
              setState(() {
                _apprenantController.text = value;
              });
            },
          ).py12(),
          TextFormField(
            controller: _motifController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              // border: OutlineInputBorder(),
              labelText: allTranslations.text('motif'),
              // prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_motif');
              }
              return null;
            },
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            // cursorColor: GreenLight,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _datedebutController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: Icon(Icons.date_range),
            use24HourFormat: true,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datedebut');
              }
              return null;
            },
            dateLabelText: 'Date Début',
            timeLabelText: "Heure",
            onChanged: (val) {
              print(val);
              setState(() {
                _datedebutController.text = val.toString().split(".")[0];
                var split = val.toString().split(" ");
                if (split.length > 1) {
                  _heuredebutController.text = val.toString().split(" ")[1];
                }
              });
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _datedebutController.text = val.toString().split(".")[0];
                var split = val.toString().split(" ");
                if (split.length > 1) {
                  _heuredebutController.text = val.toString().split(" ")[1];
                }
              });
            },
          ).py12(),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _datefinController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Date Fin',
            timeLabelText: "Heure",
            onChanged: (val) {
              print(val);
              setState(() {
                _datefinController.text = val.toString().split(".")[0];
                var split = val.toString().split(" ");
                if (split.length > 1) {
                  _heurefinController.text = val.toString().split(" ")[1];
                }
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datefin');
              }
              return null;
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _datefinController.text = val.toString().split(".")[0];
                var split = val.toString().split(" ");
                if (split.length > 1) {
                  _heurefinController.text = val.toString().split(" ")[1];
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void clearController() {
    _centreController.text = "";
    _apprenantController.text = "";
    _datedemandeController.text = "";
    _motifController.text = "";
    _datedebutController.text = "";
    _datefinController.text = "";
    _heuredebutController.text = "";
    _heurefinController.text = "";
  }

  genTabBar() {
    List<Widget> tabs = [];
    for (var item in eleves) {
      tabs.add(Tab(
        child: Text("${item.nom} ${item.prenoms}",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ));
    }
    return tabs;
  }

  genTabView() {
    List<Widget> tabs = [];
    for (var item in eleves) {
      tabs.add(ElevePermissionWidget(
        information: information
            .where((perm) => perm.keyapprenant == item.keyapprenant)
            .toList(),
        me: widget.me,
      ));
    }
    return tabs;
  }
}
