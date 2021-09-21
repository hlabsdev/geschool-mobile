import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/depense/detail_depense.dart';
import 'package:geschool/features/launch/presentation/widgets/budget_chart.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/depense_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/permission_apprenant_card_widget_card.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class AllDepenses extends StatefulWidget {
  UserModel me;
  AllDepenses({this.me});

  @override
  _AllDepensesState createState() => _AllDepensesState();
}

class _AllDepensesState extends State<AllDepenses> {
  GetInfoDto infoDto = GetInfoDto();
  TextEditingController centreController = TextEditingController();
  bool allChk = false;

  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  var data = [
    {"Saisie budgetaires", 6180000},
    {"Paiement scolarite", 110000},
    {"Total prestations", 2351135},
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
  TextEditingController _apprenantController = TextEditingController();
  TextEditingController _motifController = TextEditingController();
  TextEditingController _datedemandeController = TextEditingController();
  TextEditingController _datedebutController = TextEditingController();
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
    List<dynamic> etatPermission = [
      ["Demandes en attentes", attente, Colors.grey[300]],
      ["Demandes en cours de décaissements", acordee, Colors.green[100]],
      ["Demandes Traitées", noacordee, Colors.red[100]],
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('demande_depense')),
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
            /* ====== Exnasion de liste de depenses  deb*/

            ListView.builder(
              shrinkWrap: true,
              primary: false,
              // itemCount: permissionFilter.length,
              // itemBuilder: (context, i) {
              itemCount: etatPermission.length,
              itemBuilder: (context, index) {
                List<dynamic> curentperm = etatPermission[index];
                return ExpansionTile(
                  collapsedBackgroundColor: curentperm[2],
                  backgroundColor: curentperm[2],
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
                      color: curentperm[2],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      curentperm[0].toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  children: List.generate(
                      curentperm[1].length,
                      (i) => Slidable(
                            controller: slidableController,
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Detail',
                                color: Grey,
                                icon: Icons.remove_red_eye_rounded,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DetailDepense(
                                        me: widget.me,
                                        depense: curentperm[1][i],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              curentperm[1][i].status == "2"
                                  ? SizedBox(height: 0, width: 0)
                                  : IconSlideAction(
                                      caption: 'Plus',
                                      color: GreenLight,
                                      icon: Icons.edit,
                                      onTap: () {
                                        _moreAction(context, curentperm[1][i]);
                                      },
                                    ),
                            ],
                            child: DepenseCardWidget(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailDepense(
                                      me: widget.me,
                                      depense: curentperm[1][i],
                                    ),
                                  ),
                                );
                              },
                              depense: curentperm[1][i],
                              trailing: _arrowLeft,
                            ),
                          ),
                      growable: true),
                );
              },
            ),

            /* ====== Exnasion de liste de depenses  end*/

            /* ============================================================== */

            /* ===== Graphe deb */
            SizedBox(height: 10, width: 0),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Text(
                  "Graphe comparant les dépenses et le total \ndes dépenses de l'établissement.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 50,
                maxHeight: MediaQuery.of(context).size.height / 2 - 30,
              ),
              child: SimpleBarChart.withSampleData(),
            ),
            /* ===== Graphe end */
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

  void separate(List<PermissionApprenantModel> allList) {
    setState(() {
      attente.clear();
      acordee.clear();
      noacordee.clear();
      attente = allList.where((element) => element.status == "0").toList();
      acordee = allList.where((element) => element.status == "1").toList();
      noacordee = allList.where((element) => element.status == "2").toList();
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
              separate(permissionFilter);
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
        _apprenantController.text = "";
        if (permissionFilter.length > 0) permissionFilter.clear();
        // permissionFilter.addAll(mesInformations);
        permissionFilter.addAll(information);

        allChk = true;
      }
    });
  }

  void clearController() {
    _centreController.text = "";
    _apprenantController.text = "";
    _motifController.text = "";
    _datedebutController.text = "";
    _datefinController.text = "";
    _heuredebutController.text = "";
    _heurefinController.text = "";
    _datedemandeController.text = "";
  }

  showForm(BuildContext context, PermissionApprenantModel permission) {
    if (permission != null) {
      _centreController.text = permission.idCenter.toString();
      _apprenantController.text = permission.keyapprenant;
      _motifController.text = permission.motifpermission;
      _datedebutController.text = permission.datedebutpermission;
      _datefinController.text = permission.datefinpermission;
      _heuredebutController.text = permission.heuredebutpermission;
      _heurefinController.text = permission.heurefinpermission;
      _datedemandeController.text = permission.datedemandepermission;
      addPermDto.permissionKey = permission.keypermission;
      addPermDto.operation = "2";
    } else {
      addPermDto.operation = "1";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // title: Text("Confirmer"),
        content: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 1.5),
          child: permForm(context),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Valider"),
            onPressed: () {
              setState(() {
                addPermDto.idCenter = _centreController.text;
                addPermDto.keyApprenant = _apprenantController.text;
                addPermDto.motif = _motifController.text ?? "";
                addPermDto.dateDemande =
                    _datedemandeController.text.split(" ")[0] ?? "";
                addPermDto.dateDebut =
                    _datedebutController.text.split(" ")[0] ?? "";
                addPermDto.dateFin =
                    _datefinController.text.split(" ")[0] ?? "";
                addPermDto.heureDebut = _heuredebutController.text ?? "";
                addPermDto.heureFin = _heurefinController.text ?? "";
              });
              sendPerm();
            },
          ),
        ],
      ),
    );
  }

  /// Confirmer l'accord ou le refus d'une depense
  _confirmPermValidation(
      BuildContext context, dynamic permission, bool accepted) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Confirmer"),
        content: Text(
          "Confirmer " +
              (accepted ? "l'accord" : "le refus") +
              " de cette permission",
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Valider"),
            onPressed: () {
              setState(() {
                validateDto.uIdentifiant = widget.me.authKey;
                validateDto.registrationId = "";
                validateDto.idCenter = permission.idCenter;
                validateDto.permissionKey = permission.keypermission;
              });
              Navigator.pop(context);
              validate(accepted);
            },
          ),
        ],
      ),
    );
  }

  // void _moreAction(context,  permission) {
  void _moreAction(context, PermissionApprenantModel permission) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        ///Liste de des actions
        List<Widget> listAction = <Widget>[];

        //si la pemission est deja validee on ne peut plus la modifier
        if (permission.status == "2") {
          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel,
              color: Grey,
            ),
            title: Text('Aucune action supplémentaire disponible'),
            /* onTap: () {
                // showRapportForm(permission);
              }, */
          ));
        } else {
          /* listAction.add(ListTile(
            leading: Icon(
              Icons.edit_rounded,
              color: Colors.blue[300],
            ),
            title: Text("Modifier"),
            onTap: () => {
              showForm(context, permission),
            },
          )); */
          if (permission.status == "0") {
            listAction.add(ListTile(
              leading: Icon(
                Icons.check_circle_rounded,
                color: GreenLight,
              ),
              title: Text('Accorder'),
              onTap: () {
                _confirmPermValidation(context, permission, true);
              },
            ));
          }
          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel_rounded,
              color: Colors.red[300],
            ),
            title: Text('Refuser'),
            onTap: () {
              _confirmPermValidation(context, permission, false);
            },
          ));
        }
        // } else {

        // }
        listAction.add(SizedBox(height: 10.0));
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: listAction,
        );
      },
    );
  }

  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
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
          // DropdownButtonFormField<String>(
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
          TextFormField(
            controller: _datedemandeController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              // border: OutlineInputBorder(),
              labelText: _datedemandeController.text.isEmptyOrNull
                  ? allTranslations.text('datedemande')
                  : FunctionUtils.convertFormatDate(
                      _datedemandeController.text),
              // prefixIcon: Icon(Icons.description),
            ),
            readOnly: true,
            onTap: () {
              FunctionUtils.selectDate(
                  context, _datedemandeController, DateTime.now());
            },
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datedemande');
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
                _heuredebutController.text = val.toString().split(" ")[1];
              });
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _datedebutController.text = val.toString().split(".")[0];
                _heuredebutController.text = val.toString().split(" ")[1];
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
                _heurefinController.text = val.toString().split(" ")[1];
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
                _heurefinController.text = val.toString().split(" ")[1];
              });
            },
          ),
        ],
      ),
    );
  }

/* End */
}
