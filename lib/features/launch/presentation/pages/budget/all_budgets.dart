import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/budget_chart.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/budget_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class AllBudgets extends StatefulWidget {
  UserModel me;
  AllBudgets({this.me});

  @override
  _AllBudgetsState createState() => _AllBudgetsState();
}

class _AllBudgetsState extends State<AllBudgets> {
  GetInfoDto infoDto = GetInfoDto();
  TextEditingController centreController = TextEditingController();
  bool allChk = false;

  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  List<dynamic> data = [
    new OrdinalSales('2014', 5),
    new OrdinalSales('2015', 25),
    new OrdinalSales('2016', 100),
    new OrdinalSales('2017', 75),
    // {"Saisie budgetaires", 6180000},
    // {"Paiement scolarite", 110000},
    // {"Total prestations", 2351135},
  ];

  /* Imported prepared for parsing deb */

  List<PermissionApprenantModel> information = [];
  List<PermissionApprenantModel> permissionFilter = [];
  List<CentreModel> centres = [];
  List<PermissionApprenantModel> attente = [];
  List<PermissionApprenantModel> acordee = [];
  List<PermissionApprenantModel> noacordee = [];

  /* For form deb */
  TextEditingController _centreController = TextEditingController();
  TextEditingController _deposantController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateoperationController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _heuredebutController = TextEditingController();
  TextEditingController _datefinController = TextEditingController();
  TextEditingController _heurefinController = TextEditingController();
  /* For form end */
  TextEditingController periodeController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  TextEditingController matiereController = TextEditingController();

  SlidableController slidableController;
  Icon _arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  Animation<double> rotationAnimation;
  ValidatePermDto validateDto = ValidatePermDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();

  int selected = -1;
  bool expandFlag = false;

  /* Imported prepared for parsing end */

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('saisie_budget')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getInfos();
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 26.0,
            ),
          ),
        ],
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
        noDataText: Text(allTranslations.text('no_budget')),
        child: ListView(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          children: <Widget>[
            /* Filtre par centre et personnel deb */
            // Container(
            //   padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             width: (MediaQuery.of(context).size.width / 2.3),
            //             child: SearchableDropdown(
            //               closeButton: "Fermer",
            //               isExpanded: true,
            //               items: widget.centres
            //                   .map((centre) => DropdownMenuItem(
            //                         child: Text(centre),
            //                         value: centre,
            //                       ))
            //                   .toList(),
            //               hint: centreController.text == ""
            //                   ? Text("Centre")
            //                   : Text((centreController.text)),
            //               onChanged: (value) {
            //                 setState(() {
            //                   centreController.text = value;
            //                 });
            //                 filterInfo(
            //                   false,
            //                   centreController.text,
            //                 );
            //               },
            //             ),
            //           ),
            //           Container(
            //             width: (MediaQuery.of(context).size.width / 2.3),
            //             color: Colors.grey[100],
            //             child: CheckboxListTile(
            //               tristate: false,
            //               secondary: const Text('Tout'),
            //               // subtitle: Text(allTranslations.text('can_filter_per_date')),
            //               value: allChk,
            //               onChanged: (valueNew) {
            //                 setState(() {
            //                   allChk = valueNew;
            //                   centreController.clear();
            //                 });
            //                 listAll();
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            /* Filtre par centre et personnel end */
            /* ====== Exnasion de liste de saisie budgetaire  deb*/
            ExpansionTile(
              collapsedBackgroundColor: Colors.grey[300],
              backgroundColor: Colors.grey[300],
              initiallyExpanded: false,
              title: Container(
                // margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Detail budgetaires",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(information.length,
                  (i) => BudgetCardWidget(budget: information[i]),
                  growable: true),
            ),
            /* ====== Exnasion de liste de saisie budgetaire  end*/
            /* ===== Graphe deb */
            SizedBox(height: 10, width: 0),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Text(
                  'Graphe comparant les entrés et le \ntotal des détails budgetaires',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 50,
                maxHeight: MediaQuery.of(context).size.height / 2 - 30,
              ),
              child: SimpleBarChart.withSampleData(),
              // child: BudgetChart(data: data),
            ),
            /* ===== Graphe end */
            SizedBox(height: 20, width: 0),
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
    api.getPerms(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information;

              if (permissionFilter.length > 0) permissionFilter.clear();
              permissionFilter.addAll(information);
              allChk = true;

              permissionFilter.sort((note1, note2) => note1
                  .datedemandepermission
                  .compareTo(note2.datedemandepermission));
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
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      // Navigator.of(context).pop(null);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  /// envoie des donnees de validation au serveur
  validate(bool accorded) async {
    setState(() {
      validateDto.operation = accorded ? "1" : "2";
    });
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
                Text(allTranslations.text('processing')),
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
    api.validatePerm(validateDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de l'utilisateur dans la session
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 1);
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);

            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    });
  }

  sendPerm() async {
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
                Text(allTranslations.text('processing')),
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
    api.sendPerm(addPermDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de l'utilisateur dans la session
            Navigator.of(context).pop(null);
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 1);
            clearController();
            setState(() {
              information = a.information;
              /* Listes */
              matiereController.text = "";
              classeController.text = "";
              periodeController.text = "";
              if (permissionFilter.length > 0) permissionFilter.clear();
              permissionFilter.addAll(information);
              allChk = true;

              permissionFilter.sort((a, b) =>
                  a.datedemandepermission.compareTo(b.datedemandepermission));
            });
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    });
  }

  void listAll() {
    filterInfo(null);
    // setState(() {
    //   allChk = !allChk;
    // });
  }

  void filterInfo(bool tout, [String centre, String apprenant]) {
    setState(() {
      if (!tout) {
        permissionFilter = information
            .where(
              (perm) => ((centre.isEmptyOrNull
                      ? perm.keypermission.isNotEmpty
                      : perm.denominationCenter == centre) &&
                  (apprenant.isEmptyOrNull
                      ? perm.keypermission.isNotEmpty
                      : perm.keyapprenant == apprenant)),
            )
            .toList();
        allChk = false;
      } else {
        _centreController.text = "";
        _deposantController.text = "";
        if (permissionFilter.length > 0) permissionFilter.clear();
        // permissionFilter.addAll(mesInformations);
        permissionFilter.addAll(information);

        allChk = true;
      }
    });
  }

  void clearController() {
    _centreController.text = "";
    _deposantController.text = "";
    _descriptionController.text = "";
    _montantController.text = "";
    _datefinController.text = "";
    _heuredebutController.text = "";
    _heurefinController.text = "";
    _dateoperationController.text = "";
  }

  void showAddForm(PermissionApprenantModel permission) {
    if (permission != null) {
      _descriptionController.text = permission.motifpermission;
      _montantController.text = permission.datedebutpermission;
      _datefinController.text = permission.datefinpermission;
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
                          addPermDto.motif = _descriptionController.text ?? "";
                          addPermDto.dateDebut = _montantController.text ?? "";
                          addPermDto.dateFin = _datefinController.text ?? "";
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

  /// Confirmer l'accord ou le refus d'une permission
  // confirmDeleteTask(BuildContext context, PermissionApprenantModel permission) {
  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Centre
          centres.length > 1
              ? SearchableDropdown(
                  isExpanded: true,
                  items: centres
                      .map((perso) => DropdownMenuItem(
                            child: Text(perso.denominationCenter),
                            value: perso.denominationCenter,
                          ))
                      .toList(),
                  hint: _centreController.text == ""
                      ? Text("Centre")
                      : Text(FunctionUtils.getCenterName(
                          int.parse(_centreController.text), centres)),
                  onChanged: (value) {
                    setState(() {
                      _centreController.text =
                          FunctionUtils.getCenterId(value, centres).toString();
                    });
                  },
                ).py12()
              : SizedBox(height: 0),
          // Nature des fonds
          DropdownButtonFormField(
            isExpanded: true,
            items: centres
                .map((perso) => DropdownMenuItem(
                      child: Text(perso.denominationCenter),
                      value: perso.denominationCenter,
                    ))
                .toList(),
            hint: _centreController.text == ""
                ? Text("Nature des fonds")
                : Text(FunctionUtils.getCenterName(
                    int.parse(_centreController.text), centres)),
            onChanged: (value) {
              setState(() {
                _centreController.text =
                    FunctionUtils.getCenterId(value, centres).toString();
              });
            },
          ).py12(),
          // Mode de payement
          DropdownButtonFormField(
            isExpanded: true,
            items: centres
                .map((perso) => DropdownMenuItem(
                      child: Text(perso.denominationCenter),
                      value: perso.denominationCenter,
                    ))
                .toList(),
            hint: _centreController.text == ""
                ? Text("Mode de paiement")
                : Text(FunctionUtils.getCenterName(
                    int.parse(_centreController.text), centres)),
            onChanged: (value) {
              setState(() {
                _centreController.text =
                    FunctionUtils.getCenterId(value, centres).toString();
              });
            },
          ).py12(),
          // Date de l'operation
          DateTimePicker(
            type: DateTimePickerType.dateTime,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _dateoperationController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            // icon: Icon(Icons.event),
            dateLabelText: 'Date Fin',
            timeLabelText: "Heure",
            onChanged: (val) {
              print(val);
              setState(() {
                _dateoperationController.text = val.toString().split(".")[0];
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
                _dateoperationController.text = val.toString().split(".")[0];
              });
            },
          ),
          // Montant
          TextFormField(
            controller: _montantController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              labelText: allTranslations.text('montant'),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_montant');
              }
              return null;
            },
          ),
          // Nom prenoms Deponsant
          TextFormField(
            controller: _deposantController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              labelText: allTranslations.text('name_deposant'),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_name_deposant');
              }
              return null;
            },
          ),
          // Description
          TextFormField(
            controller: _descriptionController,
            maxLines: 20,
            minLines: 1,
            // expands: true,
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
        ],
      ),
    );
  }

/* End */
}
