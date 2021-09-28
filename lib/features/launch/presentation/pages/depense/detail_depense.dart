import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/validate_depense_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/depense_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/depense_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/depense_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_fab.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/fab_element.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class DetailDepense extends StatefulWidget {
  DepenseModel depense;
  UserModel me;
  Sections section;
  CentreModel centre;
  DetailDepense({
    Key key,
    this.depense,
    this.me,
    this.section,
    this.centre,
  }) : super(key: key);

  @override
  _DetailDepenseState createState() => _DetailDepenseState();
}

class _DetailDepenseState extends State<DetailDepense>
    with TickerProviderStateMixin {
  ValidateDepenseDto validateDto = ValidateDepenseDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();
  TextEditingController _motifController = TextEditingController();

  AnimationController controller;
  var apprenantsFilter;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
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
      floatingActionButton: buildFab(widget.depense),

      /* DepenseCardWidget.isTreated(widget.depense)
          ? SizedBox(height: 0, width: 0)
          : ExpandableFab(
              distance: 100.0,
              icon: const Icon(Icons.edit_rounded),
              children: [
                widget.depense.status == "0"
                    ? ActionButton(
                        onPressed: () {
                          _confirmValidation(context, true);
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
                    _confirmValidation(context, false);
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
            ), */

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
                    label: Text("Date demande",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Etat",
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
                            widget.depense.datedemande),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataCell(
                      renderEtatDepense(widget.depense, 13),
                    ),
                    DataCell(
                      Text(
                        FunctionUtils.formatMontant(
                            int.tryParse(widget.depense.montantdepense),
                            isMultiline: true),
                        textAlign: TextAlign.center,
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
                  child: renderEtatDepense(widget.depense),
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
                // Motif
                ListTile(
                  leading: Icon(
                    Icons.movie_creation_rounded,
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
                // Motif rejet
                widget.depense.motifsuppression.isEmptyOrNull
                    ? SizedBox(height: 0, width: 0)
                    : ListTile(
                        leading: Icon(
                          Icons.rule_folder_rounded,
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
                // Date de traitement
                widget.depense.datedepense.isEmptyOrNull
                    ? SizedBox(height: 0, width: 0)
                    : ListTile(
                        leading: Icon(
                          Icons.date_range,
                          size: 30,
                        ),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          "Date de décaissement",
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
                /* // Date de demande
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
                 */
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

// Construi les fab multiple
  Widget buildFab(DepenseModel depense) {
    Widget fab;
    List<FabElement> icons = [
      FabElement(
        tooltip: "Accorder",
        icon: Icons.check_circle_rounded,
        backgroundColor: Colors.green,
        forgroundColor: Colors.white,
        onPressed: () => _confirmValidation(context, depense, true, false),
      ),
      FabElement(
        tooltip: "Refuser",
        icon: Icons.cancel_rounded,
        backgroundColor: Colors.redAccent,
        forgroundColor: Colors.white,
        onPressed: () => _confirmValidation(context, depense, false, false),
      ),
    ];

    fab = DepenseCardWidget.isTreated(widget.depense)
        ? null
        : depense.status == "1"
            ? FloatingActionButton(
                onPressed: () =>
                    _confirmValidation(context, depense, true, true),
                tooltip: "Décaisser",
                child: Icon(
                  Icons.money_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
              )
            : new Column(
                mainAxisSize: MainAxisSize.min,
                children: new List.generate(icons.length, (int index) {
                  Widget child = new Container(
                    height: 70.0,
                    width: 56.0,
                    alignment: FractionalOffset.topCenter,
                    child: new ScaleTransition(
                      scale: new CurvedAnimation(
                        parent: controller,
                        curve: new Interval(
                            0.0, 1.0 - index / icons.length / 2.0,
                            curve: Curves.easeOut),
                      ),
                      child: new FloatingActionButton(
                        heroTag: null,
                        backgroundColor: icons[index].backgroundColor,
                        mini: true,
                        tooltip: icons[index].tooltip,
                        child: new Icon(icons[index].icon,
                            color: icons[index].forgroundColor),
                        onPressed: () {
                          icons[index].onPressed();
                        },
                      ),
                    ),
                  );
                  return child;
                }).toList()
                  ..add(
                    new FloatingActionButton(
                      heroTag: null,
                      child: new AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, Widget child) {
                          return new Transform(
                            transform: new Matrix4.rotationZ(
                                controller.value * 0.5 * math.pi),
                            alignment: FractionalOffset.center,
                            child: new Icon(controller.isDismissed
                                ? Icons.menu
                                : Icons.close),
                          );
                        },
                      ),
                      onPressed: () {
                        if (controller.isDismissed) {
                          controller.forward();
                        } else {
                          controller.reverse();
                        }
                      },
                    ),
                  ),
              );

    return fab;
  }

  /// envoie des donnees de validation au serveur
  validate(bool accorded, bool decaisser) {
    setState(() {
      if (decaisser) {
        validateDto.operation = "3";
      } else {
        validateDto.operation = accorded ? "1" : "2";
      }
    });
    Api api = ApiRepository();
    FunctionUtils.sendData(
        context: context,
        dto: validateDto,
        repositoryFunction: api.validateDepense,
        onSuccess: (a) {
          // getInfos();
          setState(() {
            if (decaisser) {
              widget.depense.datedepense =
                  DateTime.now().toIso8601String().split(".")[0];
            } else {
              widget.depense.status = accorded ? "1" : "2";
            }
          });
        },
        onFailure: () {});
  }

  showForm(BuildContext context, DepenseModel depense) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: refusForm(context),
                scrollable: true,
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
                      if (formKey.currentState.validate()) {
                        setState(() {
                          validateDto.motif = _motifController.text ?? "";
                        });
                        validate(false, false);
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Form refusForm(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: _motifController,
        maxLines: 50,
        minLines: 1,
        decoration: InputDecoration(
          contentPadding: Vx.m2,
          labelText: "Motif du refus",
        ),
        validator: (value) {
          if (value.isEmptyOrNull) {
            return "Veillez renseigner la raison du refus";
          }
          return null;
        },
      ),
    );
  }

  /// Confirmer l'accord ou le refus d'une depense
  _confirmValidation(BuildContext context, DepenseModel depense, bool accepted,
      bool decaisser) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text("Confirmer"),
        content: Text(
          "Confirmer " +
              (decaisser
                  ? "le décaissement"
                  : (accepted ? "l'accord" : "le refus")) +
              " de cette dépense",
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: Text("Valider"),
            onPressed: () {
              setState(() {
                validateDto.uIdentifiant = widget.me.authKey;
                validateDto.registrationId = "";
                validateDto.cIdentifiant = widget.centre.keyCenter;
                validateDto.dIdentifiant = depense.keydepense;
              });
              Navigator.of(context).pop(null);
              print("Devrait se fermer");
              if (!accepted) {
                showForm(context, depense);
              } else {
                validate(accepted, decaisser);
              }
            },
          ),
        ],
      ),
    );
  }

  renderEtatDepense(DepenseModel depense, [double font]) {
    int etat = int.tryParse(depense.status);
    Text result;
    if (etat == 0) {
      result = Text("Non traitée",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: font ?? 16, color: Grey, fontStyle: FontStyle.italic));
    } else if (etat == 1) {
      result = (depense.datedepense.isEmptyOrNull)
          ? Text("Validée",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: font ?? 16,
                  color: GreenLight,
                  fontStyle: FontStyle.italic))
          : Text("Décaissée",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: font ?? 16,
                  color: Colors.lime[600],
                  fontStyle: FontStyle.italic));
    } else if (etat == 2) {
      result = Text("Refusée",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: font ?? 16,
              color: Colors.red[200],
              fontStyle: FontStyle.italic));
    } else {
      result = Text(allTranslations.text('not_defined'),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: font ?? 16, color: Grey, fontStyle: FontStyle.italic));
    }

    return result;
  }
}
