import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/depense_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/depense_list_response_model.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_fab.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class DetailDepense extends StatefulWidget {
  DepenseModel depense;
  UserModel me;
  Sections section;
  List<ApprenantModel> apprenants;
  List<CentreModel> centres;

  DetailDepense({
    Key key,
    this.depense,
    this.me,
    this.section,
    this.apprenants,
    this.centres,
  }) : super(key: key);

  @override
  _DetailDepenseState createState() => _DetailDepenseState();
}

class _DetailDepenseState extends State<DetailDepense> {
  ValidatePermDto validateDto = ValidatePermDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();

  TextEditingController _centreController = TextEditingController();
  TextEditingController _apprenantController = TextEditingController();
  TextEditingController _motifController = TextEditingController();
  TextEditingController _datedemandeController = TextEditingController();
  TextEditingController _datedebutController = TextEditingController();
  TextEditingController _heuredebutController = TextEditingController();
  TextEditingController _datefinController = TextEditingController();
  TextEditingController _heurefinController = TextEditingController();

  var apprenantsFilter;

  @override
  void initState() {
    validateDto.idCenter = widget.depense.idcentre;
    validateDto.uIdentifiant = widget.me.authKey;
    validateDto.permissionKey = widget.depense.keydepense;
    validateDto.registrationId = "";
    // Perm
    addPermDto.uIdentifiant = widget.me.authKey;
    addPermDto.registrationId = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('detail_depense')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
      ),
      floatingActionButton: widget.depense.status == "2"
          ? SizedBox(height: 0, width: 0)
          : ExpandableFab(
              distance: 100.0,
              icon: const Icon(Icons.edit_rounded),
              children: [
                widget.depense.status == "0"
                    ? ActionButton(
                        onPressed: () {
                          _confirmPermValidation(context, true);
                        },
                        tooltip: "Accorder",
                        color: Colors.green[200],
                        icon: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                          size: 30,
                        ),
                      )
                    : SizedBox(height: 0, width: 0),
                ActionButton(
                  onPressed: () {
                    _confirmPermValidation(context, false);
                  },
                  tooltip: "Refuser",
                  color: Colors.red[200],
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ],
            ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          /* Tableau deb */
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: DataTable(
              horizontalMargin: 5,
              sortAscending: true,
              sortColumnIndex: 1,
              columns: [
                DataColumn(
                    label: Text("Date de\nDécaissement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("état".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Montant",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        FunctionUtils.convertFormatDate(
                            widget.depense.datedepense),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataCell(
                      renderEtatDepense(int.parse(widget.depense.status), 12),
                      // Text(

                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ),
                    DataCell(
                      Text(
                        widget.depense.montantdepense,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              // rows: generateRow(widget.noms[i]),
            ),
          ),
          /* Tableau end */
          /* =============================================================== */
          /* Details deb */
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                //Etat
                Center(
                  child: renderEtatDepense(int.parse(widget.depense.status)),
                ),
                // Section concernee
                ListTile(
                  leading: Icon(
                    Icons.local_convenience_store_rounded,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Section concernée",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: PafpeGreen,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      (widget.section.designation) ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                // Nom du personnel qui q fqit lq demande
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Nom et Prenom",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: PafpeGreen,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      (widget.depense.nom + " " + widget.depense.prenoms) ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                // Date de demande
                ListTile(
                  leading: Icon(
                    Icons.date_range,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Date de demande",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: PafpeGreen,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    FunctionUtils.convertFormatDate(widget.depense.datedemande),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  isThreeLine: true,
                ),

                // Description
                ListTile(
                  leading: Icon(
                    Icons.format_align_justify,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: PafpeGreen,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: ExpandableText(
                      widget.depense.description ??
                          allTranslations.text('not_defined'),
                      "Description"),
                  isThreeLine: true,
                ),
                // Motif
                ListTile(
                  leading: Icon(
                    Icons.format_align_justify,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Motif",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: PafpeGreen,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: ExpandableText(
                      widget.depense.motifdemande ??
                          allTranslations.text('not_defined'),
                      "Motif"),
                  isThreeLine: true,
                ),
                // Date de traitement
                widget.depense.datetraitement.isEmptyOrNull
                    ? SizedBox(height: 0, width: 0)
                    : ListTile(
                        leading: Icon(
                          Icons.date_range,
                          size: 30,
                        ),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          "Date de demande",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: PafpeGreen,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          FunctionUtils.convertFormatDate(
                              widget.depense.datedemande),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                // Motif rejet
                widget.depense.motifsuppression.isEmptyOrNull
                    ? SizedBox(height: 0, width: 0)
                    : ListTile(
                        leading: Icon(
                          Icons.format_align_justify,
                          size: 30,
                        ),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          "Motif de rejet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: PafpeGreen,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          // textAlign: TextAlign.justify,
                        ),
                        subtitle: ExpandableText(
                            widget.depense.motifsuppression ??
                                allTranslations.text('not_defined'),
                            "Motif de rejet"),
                        isThreeLine: true,
                      ),
              ],
            ),
          ),
          /* Details end */
          SizedBox(height: 20),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Envoyer la depense
  // sendPerm() async {
  //   print("user changing...");
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           contentPadding: EdgeInsets.all(12),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text(allTranslations.text('processing')),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               CircularProgressIndicator(
  //                   // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
  //                   )
  //             ],
  //           ),
  //         );
  //       });
  //   Api api = ApiRepository();
  //   api.sendPerm(addPermDto).then((value) {
  //     if (value.isRight()) {
  //       value.all((a) {
  //         if (a != null && a.status.compareTo("000") == 0) {
  //           //enregistrement des informations de l'utilisateur dans la session
  //           Navigator.of(context).pop(null);
  //           Navigator.of(context).pop(null);
  //           FunctionUtils.displaySnackBar(context, a.message, type: 1);
  //           clearController();
  //           setState(() {
  //             widget.depense = a.information.firstWhere((element) =>
  //                 element.keypermission == widget.depense.keypermission);
  //           });
  //           return true;
  //         } else {
  //           //l'api a retourne une Erreur
  //           Navigator.of(context).pop(null);
  //           Navigator.of(context).pop(null);
  //           FunctionUtils.displaySnackBar(context, a.message, type: 0);
  //           return false;
  //         }
  //       });
  //     } else {
  //       Navigator.of(context).pop(null);
  //       Navigator.of(context).pop(null);
  //       FunctionUtils.displaySnackBar(
  //           context, allTranslations.text('error_process'));
  //       return false;
  //     }
  //   });
  // }

  /// envoie des donnees au serveur {
  // validate(bool accorded) async {
  //   setState(() {
  //     validateDto.operation = accorded ? "1" : "2";
  //   });
  //   print("user changing...");
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           contentPadding: EdgeInsets.all(12),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text(allTranslations.text('processing')),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               CircularProgressIndicator(
  //                   // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
  //                   )
  //             ],
  //           ),
  //         );
  //       });

  //   Api api = ApiRepository();
  //   api.validatePerm(validateDto).then((value) {
  //     if (value.isRight()) {
  //       value.all((a) {
  //         if (a != null && a.status.compareTo("000") == 0) {
  //           //enregistrement des informations de l'utilisateur dans la session
  //           Navigator.of(context).pop(null);
  //           FunctionUtils.displaySnackBar(context, a.message, type: 1);
  //           return true;
  //         } else {
  //           //l'api a retourne une Erreur
  //           Navigator.of(context).pop(null);

  //           FunctionUtils.displaySnackBar(context, a.message, type: 0);
  //           return false;
  //         }
  //       });
  //     } else {
  //       Navigator.of(context).pop(null);
  //       FunctionUtils.displaySnackBar(
  //           context, allTranslations.text('error_process'));
  //       return false;
  //     }
  //   });
  // }

  _confirmPermValidation(BuildContext context, bool accepted) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text("Confirmer"),
        content: Text(
          "Confirmer " +
              (accepted ? "l'accord" : "le refus") +
              " de cette depense",
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
              Navigator.pop(context);
              setState(() {
                // validate(accepted);
              });
            },
          ),
        ],
      ),
    );
  }

/* Forms */

  void showAddForm() {
    // _centreController.text = widget.depense.idCenter.toString();
    // _apprenantController.text = widget.depense.keyapprenant;
    // _motifController.text = widget.depense.motifpermission;
    // _datedebutController.text = widget.depense.datedebutpermission;
    // _datefinController.text = widget.depense.datefinpermission;
    // _heuredebutController.text = widget.depense.heuredebutpermission;
    // _heurefinController.text = widget.depense.heurefinpermission;
    // _datedemandeController.text = widget.depense.datedemandepermission;
    // addPermDto.permissionKey = widget.depense.keypermission;
    addPermDto.operation = "2";
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
                          addPermDto.idCenter = _centreController.text;
                          addPermDto.keyApprenant = _apprenantController.text;
                          addPermDto.motif = _motifController.text ?? "";
                          addPermDto.dateDemande =
                              _datedemandeController.text.split(" ")[0] ?? "";
                          addPermDto.dateDebut =
                              _datedebutController.text.split(" ")[0] ?? "";
                          addPermDto.dateFin =
                              _datefinController.text.split(" ")[0] ?? "";
                          addPermDto.heureDebut =
                              _heuredebutController.text ?? "";
                          addPermDto.heureFin = _heurefinController.text ?? "";
                        });
                        // sendPerm();
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

  showForm() {
    // _centreController.text = widget.depense.idCenter.toString();
    // _apprenantController.text = widget.depense.keyapprenant;
    // _motifController.text = widget.depense.motifpermission;
    // _datedebutController.text = widget.depense.datedebutpermission;
    // _datefinController.text = widget.depense.datefinpermission;
    // _heuredebutController.text = widget.depense.heuredebutpermission;
    // _heurefinController.text = widget.depense.heurefinpermission;
    // _datedemandeController.text = widget.depense.datedemandepermission;
    // addPermDto.permissionKey = widget.depense.keypermission;
    addPermDto.operation = "2";

    showPlatformDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Stack(
          children: <Widget>[permForm(context)],
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
                addPermDto.dateDemande = _datedemandeController.text ?? "";
                addPermDto.dateDebut = _datedebutController.text ?? "";
                addPermDto.dateFin = _datefinController.text ?? "";
                addPermDto.heureDebut = _heuredebutController.text ?? "";
                addPermDto.heureFin = _heurefinController.text ?? "";
              });
              // sendPerm();
            },
          ),
        ],
      ),
    );
  }

  /// Confirmer l'accord ou le refus d'une depense
  // confirmDeleteTask(BuildContext context, PermissionApprenantModel depense) {
  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
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

/* ===== Filtrage par centre ===== */
  void filterPerCentre(int centerId) {
    setState(() {
      apprenantsFilter.clear();
      if (centerId != null) {
        apprenantsFilter = widget.apprenants
            .filter((apprenants) => apprenants.idcentre == centerId.toString())
            .toList();
      } else {
        apprenantsFilter.addAll(widget.apprenants);
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

  renderEtatDepense(int etat, [double font]) {
    Text result = etat == 0
        ? Text("En attente",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: font ?? 16, color: Grey, fontStyle: FontStyle.italic))
        : etat == 1
            ? Text("En cours de décaissement",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: font ?? 16,
                    color: GreenLight,
                    fontStyle: FontStyle.italic))
            : etat == 2
                ? Text("Refusée",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: font ?? 16,
                        color: Colors.red[200],
                        fontStyle: FontStyle.italic))
                : Text(allTranslations.text('not_defined'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: font ?? 16,
                        color: Grey,
                        fontStyle: FontStyle.italic));
    return result;
  }

  renderPermColor(int etat) {
    Color result = etat == 0
        ? Colors.grey[300]
        : etat == 1
            ? Colors.green[100]
            : etat == 2
                ? Colors.red[100]
                : Colors.grey[200];
    return result;
  }
}
