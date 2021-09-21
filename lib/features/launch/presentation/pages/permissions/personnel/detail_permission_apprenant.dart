import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_fab.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class DetailPermissionApprenant extends StatefulWidget {
  PermissionApprenantModel permission;
  UserModel me;
  List<ApprenantModel> apprenants;
  List<CentreModel> centres;
  bool isApprenant;

  DetailPermissionApprenant({
    Key key,
    this.permission,
    this.me,
    this.apprenants,
    this.centres,
    this.isApprenant,
  }) : super(key: key);

  @override
  _DetailPermissionApprenantState createState() =>
      _DetailPermissionApprenantState();
}

class _DetailPermissionApprenantState extends State<DetailPermissionApprenant> {
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
    validateDto.idCenter = widget.permission.idCenter;
    validateDto.uIdentifiant = widget.me.authKey;
    validateDto.permissionKey = widget.permission.keypermission;
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
        title: Text(allTranslations.text('detail_permission')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(height: 8),
                //Etat
                Center(
                  child: renderEtatPerm(int.parse(widget.permission.status)),
                ),
                // Nom
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    allTranslations.text('name'),
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
                      (widget.permission.nom +
                              " " +
                              widget.permission.prenoms) ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                // Date (Avec heure debut et fin)
                ListTile(
                  leading: Icon(
                    Icons.date_range,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Date",
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FunctionUtils.convertFormatDate(
                                  widget.permission.datedemandepermission) ??
                              allTranslations.text('not_defined'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        SizedBox(height: 5),
                        Column(
                          children: [
                            SizedBox(height: 8.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    allTranslations.text('start') + ":",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: PafpeGreen,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "" +
                                        FunctionUtils.convertFormatDate(widget
                                            .permission.datedebutpermission) +
                                        " à " +
                                        widget.permission.heuredebutpermission,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey[800]),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Fin:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: PafpeGreen,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "" +
                                        FunctionUtils.convertFormatDate(widget
                                            .permission.datefinpermission) +
                                        " à " +
                                        widget.permission.heurefinpermission,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey[800]),
                                  ),
                                ),
                              ],
                            ), // old
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                widget.permission.motifpermission.isEmptyOrNull
                    ? SizedBox(height: 0, width: 0)
                    : ListTile(
                        leading: Icon(Icons.format_align_justify, size: 30),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          allTranslations.text('motif'),
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
                            widget.permission.motifpermission ??
                                allTranslations.text('not_defined'),
                            "motif"),
                        isThreeLine: true,
                      ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: buildFab(widget.permission, widget.isApprenant),
    );
  }

  Widget buildFab(PermissionApprenantModel permission, bool isApprenant) {
    Widget fab;

    // For aprenant case
    if (isApprenant == true || isApprenant == null) {
      if (permission.status == "2" || permission.status == "1") {
        fab = SizedBox(height: 0, width: 0);
      } else if (permission.status == "0") {
        fab = FloatingActionButton(
          onPressed: () {
            showAddForm();
          },
          child: const Icon(Icons.edit_rounded),
        );
      }
    }

    // For personnel case satus 0
    else if (isApprenant == false) {
      // Refusee ou directement enregistree
      if (permission.status == "2" || permission.isdemande == "0") {
        fab = SizedBox(height: 0, width: 0);

        //  satus 0: En attente
      } else if (permission.status == "0") {
        fab = ExpandableFab(
          distance: 100.0,
          icon: const Icon(Icons.edit_rounded),
          children: [
            ActionButton(
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
            ),
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
        );
      }
      // Staus 1: Accordee
      else if (permission.status == "1") {
        fab = FloatingActionButton(
          onPressed: () {
            showForm();
          },
          child: const Icon(Icons.edit_rounded),
        );
      }
    }

    return fab;
  }

  /// Envoyer la permission
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
              widget.permission = a.information.firstWhere((element) =>
                  element.keypermission == widget.permission.keypermission);
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

  /// envoie des donnees au serveur {
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

  _confirmPermValidation(BuildContext context, bool accepted) {
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
              Navigator.pop(context);
              setState(() {
                validate(accepted);
              });
            },
          ),
        ],
      ),
    );
  }

/* Forms */

  void showAddForm() {
    _centreController.text = widget.permission.idCenter.toString();
    _apprenantController.text = widget.permission.keyapprenant;
    _motifController.text = widget.permission.motifpermission;
    _datedebutController.text = widget.permission.datedebutpermission;
    _datefinController.text = widget.permission.datefinpermission;
    _heuredebutController.text = widget.permission.heuredebutpermission;
    _heurefinController.text = widget.permission.heurefinpermission;
    _datedemandeController.text = widget.permission.datedemandepermission;
    addPermDto.permissionKey = widget.permission.keypermission;
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
      },
    );
  }

  showForm() {
    _centreController.text = widget.permission.idCenter.toString();
    _apprenantController.text = widget.permission.keyapprenant;
    _motifController.text = widget.permission.motifpermission;
    _datedebutController.text = widget.permission.datedebutpermission;
    _datefinController.text = widget.permission.datefinpermission;
    _heuredebutController.text = widget.permission.heuredebutpermission;
    _heurefinController.text = widget.permission.heurefinpermission;
    _datedemandeController.text = widget.permission.datedemandepermission;
    addPermDto.permissionKey = widget.permission.keypermission;
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
      },
    );
  }

  /// Confirmer l'accord ou le refus d'une permission
  // confirmDeleteTask(BuildContext context, PermissionApprenantModel permission) {
  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          widget.isApprenant
              ? SizedBox(height: 0, width: 0)
              : widget.centres.length > 1
                  ? SearchableDropdown(
                      isExpanded: true,
                      items: widget.centres
                          .map((perso) => DropdownMenuItem(
                                child: Text(perso.denominationCenter),
                                value: perso.denominationCenter,
                              ))
                          .toList(),
                      hint: _centreController.text == ""
                          ? Text("Centre")
                          : Text(FunctionUtils.getCenterName(
                              int.parse(_centreController.text),
                              widget.centres)),
                      onChanged: (value) {
                        filterPerCentre(
                            FunctionUtils.getCenterId(value, widget.centres));
                        setState(() {
                          _centreController.text =
                              FunctionUtils.getCenterId(value, widget.centres)
                                  .toString();
                        });
                      },
                    ).py12()
                  : SizedBox(height: 0, width: 0),
          // DropdownButtonFormField<String>(
          widget.isApprenant
              ? SizedBox(height: 0, width: 0)
              : SearchableDropdown(
                  isExpanded: true,
                  // items: personnelsFilter
                  items: widget.apprenants
                      .map((apprenant) => DropdownMenuItem(
                            child: Text(FunctionUtils.getApprenantName(
                                apprenant.keyapprenant, widget.apprenants)),
                            // value: perso.keypersonnel,
                            value: FunctionUtils.getApprenantName(
                                apprenant.keyapprenant, widget.apprenants),
                            onTap: () => print(apprenant.keyapprenant),
                          ))
                      .toList(),
                  hint: _apprenantController.text == ""
                      ? Text("Personnel")
                      : Text(FunctionUtils.getApprenantName(
                          _apprenantController.text, widget.apprenants)),
                  onChanged: (value) {
                    setState(() {
                      _apprenantController.text = FunctionUtils.getApprenantKey(
                          value, widget.apprenants);
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
          widget.isApprenant
              ? SizedBox(height: 0, width: 0)
              : // Date demande
              DateTimePicker(
                  type: DateTimePickerType.date,
                  timeFieldWidth: 55,
                  dateMask: 'd MMM, yyyy',
                  controller: _datedemandeController,
                  locale: Locale('fr'),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.date_range),
                  use24HourFormat: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return allTranslations.text('pls_set_datedemande');
                    }
                    return null;
                  },
                  dateLabelText: allTranslations.text('datedemande'),
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      _datedemandeController.text =
                          val.toString().split(".")[0];
                    });
                  },
                  onSaved: (val) {
                    print(val);
                    setState(() {
                      _datedemandeController.text =
                          val.toString().split(".")[0];
                    });
                  },
                ).py12(),

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

  renderEtatPerm(int etat) {
    Text result = etat == 0
        ? Text("En attente",
            style: TextStyle(
                fontSize: 16, color: Grey, fontStyle: FontStyle.italic))
        : etat == 1
            ? Text("Accordée",
                style: TextStyle(
                    fontSize: 16,
                    color: GreenLight,
                    fontStyle: FontStyle.italic))
            : etat == 2
                ? Text("Refusée",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[200],
                        fontStyle: FontStyle.italic))
                : Text(allTranslations.text('not_defined'),
                    style: TextStyle(
                        fontSize: 16,
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
