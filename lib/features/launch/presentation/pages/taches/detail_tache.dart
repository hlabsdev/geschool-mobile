import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/tache_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/tache_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class DetailTache extends StatefulWidget {
  TacheModel tache;
  bool isAdmin;
  UserModel me;
  String pIdentifiant;

  DetailTache({this.tache, this.isAdmin, this.me, this.pIdentifiant});

  @override
  _DetailTacheState createState() => _DetailTacheState();
}

class _DetailTacheState extends State<DetailTache> {
  TextEditingController _daterappelController = TextEditingController();
  TextEditingController _rapportController = TextEditingController();
  TacheDto tacheDto = TacheDto();

  final _rapportFormKey = GlobalKey<FormState>();
  final _rappelFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _daterappelController.text = widget.tache.dateTache;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Détail de la tache"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 25),
          // shrinkWrap: true,
          primary: false,
          children: [
            // Card about task start
            Card(
              margin: EdgeInsets.all(8),
              color: Colors.grey[100],
              child: DataTable(
                columnSpacing: 12,
                horizontalMargin: 8,
                columns: [
                  DataColumn(
                    label: Text(
                      'Personnel',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Date",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Etat',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          widget.tache.nameUser,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          FunctionUtils.convertFormatDateTime(
                              widget.tache.dateTache),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          getEtat(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Card about task end
            Card(
              margin: EdgeInsets.all(8),
              color: Colors.grey[100],
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.format_align_justify_rounded),
                    title: Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: GreenLight,
                      ),
                    ),
                    subtitle: ExpandableText(
                        widget.tache.descriptionTache ??
                            allTranslations.text('not_defined'),
                        "Description"),
                    isThreeLine: true,
                  ),
                  ListTile(
                    leading: Icon(Icons.add_alert_rounded),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.tache.dateRappelTache.isEmptyOrNull
                            ? Text(
                                "Aucun Rappel definis",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: GreenLight,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rappel definis sur:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: GreenLight,
                                    ),
                                  ),
                                  Text(
                                    "${FunctionUtils.convertFormatDateTime(widget.tache.dateRappelTache)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.red[300],
                                    ),
                                  ),
                                ],
                              ),
                        (widget.isAdmin &
                                (DateTime.parse(widget.tache.dateTache)
                                    .isAfter(DateTime.now())) &
                                (widget.tache.rapportTache.isEmptyOrNull))
                            ? IconButton(
                                onPressed: () {
                                  showRappelChange();
                                },
                                icon: Icon(Icons.edit_rounded,
                                    color: Colors.blueAccent),
                              )
                            : Text(""),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_rounded),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rapport sur la tache",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: GreenLight,
                          ),
                        ),
                        (widget.isAdmin &
                                (DateTime.parse(widget.tache.dateTache)
                                    .isBefore(DateTime.now())) &
                                (widget.tache.rapportTache.isEmptyOrNull))
                            ? IconButton(
                                onPressed: () {
                                  showRapportForm();
                                },
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: Colors.blueAccent,
                                ),
                              )
                            : Text(""),
                      ],
                    ),
                    // subtitle: Text("" + widget.tache.rapportTache.toString(), m),
                    subtitle: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: ExpandableText(
                          widget.tache.rapportTache ??
                              allTranslations.text('not_defined'),
                          "Motif"),

                      // Text(
                      //   widget..rapportTache ?? "",
                      //   style: TextStyle(fontSize: 16),
                      //   textAlign: TextAlign.start,
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 20,
                      // ),
                    ),
                    isThreeLine: true,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // ignore: missing_return
  String getEtat() {
    if (DateTime.parse(widget.tache.dateTache).isAfter(DateTime.now()))
      return "A faire";
    else if (DateTime.parse(widget.tache.dateTache).day == DateTime.now().day)
      return "En cours";
    else if (DateTime.parse(widget.tache.dateTache).isBefore(DateTime.now()))
      return "Passée";
  }

  void showRapportForm() {
    setState(() {
      _rapportController.text = widget.tache.rapportTache;
    });
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(8),
            scrollable: true,
            content: Stack(
              // fit: StackFit.loose,
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
                  key: _rapportFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: SizedBox(
                            // width: 300,
                            // height: 50,
                            child: TextFormField(
                              showCursor: true,
                              enableInteractiveSelection: true,
                              // textAlign: TextAlign.justify,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _rapportController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    bottom: 40, left: 5, right: 5),
                                border: OutlineInputBorder(),
                                labelText: allTranslations.text('rapport'),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return allTranslations
                                      .text('pls_set_rapport');
                                }
                                return null;
                              },
                            ),
                          )),
                      SizedBox(height: 10.0),
                      /* InkValidationButton(
                          onPressed: () {
                            if (_rapportFormKey.currentState.validate()) {
                              print('Tache ajoutée');
                              saveRapport(widget.tache);
                              Navigator.of(context).pop();
                            }
                          },
                          buttontext: "${allTranslations.text('submit')}"), */
                      // SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () {
                  clearController();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Valider"),
                onPressed: () {
                  if (_rapportFormKey.currentState.validate()) {
                    print('Tache encour d\'ajout');
                    saveRapport(widget.tache);
                    // Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void showRappelChange() {
    setState(() {
      _daterappelController.text = widget.tache.dateRappelTache;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(8),
            scrollable: true,
            content: Stack(
              // fit: StackFit.loose,
              children: <Widget>[
                Form(
                  key: _rappelFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'd MMM, yyyy',
                          // controller: _daterappelController,
                          locale: Locale('fr'),
                          // initialDatePickerMode: DatePickerMode.year,
                          initialValue:
                              DateTime.parse(widget.tache.dateRappelTache)
                                  .toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Heure",
                          onChanged: (val) {
                            print(val);
                            setState(() {
                              _daterappelController.text =
                                  val.toString().split(".")[0];
                            });
                          },
                          validator: (val) {
                            // print(val);
                            return null;
                          },
                          onSaved: (val) {
                            print(val);
                            setState(() {
                              _daterappelController.text =
                                  val.toString().split(".")[0];
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      /* InkValidationButton(
                          onPressed: () {
                            if (_rappelFormKey.currentState.validate()) {
                              print('Tache ajoutée');
                              saveRappel(widget.tache);
                              Navigator.of(context).pop();
                            }
                          },
                          buttontext: "${allTranslations.text('submit')}"), */
                      // SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () {
                  clearController();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Valider"),
                onPressed: () {
                  if (_rappelFormKey.currentState.validate()) {
                    print('Tache ajoutée');
                    saveRappel(widget.tache);
                  }
                },
              ),
            ],
          );
        });
  }

  sendTache() {
    print("En envoie...");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    // loading(true);
    Api api = ApiRepository();
    api.sendTache(tacheDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              widget.tache = a.information.firstWhere(
                (element) => element.keyTache == widget.tache.keyTache,
                orElse: () => widget.tache,
              );
            });
            Navigator.of(context).pop(null);
            clearController();
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 1);
            return true;
          } else {
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else if (value.isLeft()) {
        Navigator.of(context).pop(null);
        // loading(false);
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

  void clearController() {
    _daterappelController.text = "";
    _rapportController.text = "";
  }

  void saveRapport(TacheModel tache) {
    setState(() {
      tacheDto.operation = 3;
      tacheDto.tacheKey = tache.keyTache;
      tacheDto.registrationId = "";
      print(_rapportController.text);
      tacheDto.rapportTache = _rapportController.text;
      tacheDto.dateTache = tache.dateTache;
      tacheDto.dateRappel = tache.dateRappelTache;
      tacheDto.description = tache.descriptionTache;
      tacheDto.idCentre = tache.idCentre;
      tacheDto.uIdentifiant = widget.me.authKey;
      tacheDto.pIdentifiant = widget.pIdentifiant;
    });
    print(tacheDto.toJson());
    sendTache();
  }

  void saveRappel(TacheModel tache) {
    setState(() {
      tacheDto.operation = 2;
      tacheDto.tacheKey = tache.keyTache;
      tacheDto.rapportTache = _rapportController.text;
      tacheDto.registrationId = "";
      print(_daterappelController.text);
      tacheDto.dateTache = tache.dateTache;
      tacheDto.dateRappel =
          DateTime.parse(_daterappelController.text).toString().split('.')[0];
      tacheDto.description = tache.descriptionTache;
      tacheDto.idCentre = tache.idCentre;
      tacheDto.uIdentifiant = widget.me.authKey;
      tacheDto.pIdentifiant = widget.pIdentifiant;
    });
    print(tacheDto.toJson());
    sendTache();
  }

  bool rappelDefined(TacheModel tache) {
    if (tache.dateRappelTache != null || tache.dateRappelTache != "") {
      return true;
    } else {
      return false;
    }
  }
}
