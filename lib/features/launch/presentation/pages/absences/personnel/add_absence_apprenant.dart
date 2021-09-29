import 'dart:async';
import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_abs_dto.dart';
import 'package:geschool/features/common/data/dto/get_eleve_classe_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/info_absence.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/classe_eleve_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/classe_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class AddApprenantAbsence extends StatefulWidget {
  UserModel me;
  Classes classe;

  AddApprenantAbsence({
    this.me,
    this.classe,
  });

  @override
  _AddApprenantAbsenceState createState() => _AddApprenantAbsenceState();
}

final formKey = GlobalKey<FormState>();

class _AddApprenantAbsenceState extends State<AddApprenantAbsence> {
  List<Eleves> information = [];
  List<InfoAbsence> absences = [];
  GetEleveClasseDto apprenantDto = GetEleveClasseDto();
  AddAbsDto addAbs = AddAbsDto();
  TextEditingController _dateDebutController = TextEditingController();
  TextEditingController _dateFinController = TextEditingController();
  final Map typeControllers = {};
  final Map debutControllers = {};
  final Map finRetardControllers = {};
  final Map checkControllers = {};
  List<TypesAbsences> typeAbs = [];
  ScrollController _scrollbarController = ScrollController();
  bool isLoading;
  bool error = false;
  String message = "";

  final _rappelFormKey = GlobalKey<FormState>();
  _scrollListener() {
    if (_scrollbarController.hasClients) {
      if (_scrollbarController.offset >=
              _scrollbarController.position.maxScrollExtent &&
          !_scrollbarController.position.outOfRange) {
        setState(() {
          message = "reach the bottom";
        });
      }
      if (_scrollbarController.offset <=
              _scrollbarController.position.minScrollExtent &&
          !_scrollbarController.position.outOfRange) {
        setState(() {
          message = "reach the top";
        });
      }
    }
  }

  @override
  void initState() {
    _scrollbarController = ScrollController(initialScrollOffset: 0.0);
    _scrollbarController.addListener(_scrollListener);
    apprenantDto.uIdentifiant = widget.me.authKey;
    apprenantDto.cIdentifiant = widget.classe.keyclasse;
    apprenantDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Enregistrement d'absences"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      body: RefreshableWidget(
        error: error,
        information: information,
        isLoading: isLoading,
        noDataText: Text("Aucune données ici pour le moment"),
        onRefresh: getInfos,
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        (allTranslations.text('classe') +
                                    ":\t" +
                                    widget.classe.libelleclasse ??
                                allTranslations.text('not_defined'))
                            .toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: GreenLight,
                            fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date " +
                                    allTranslations.text('start') +
                                    ":\t " +
                                    "${FunctionUtils.convertFormatDate(_dateDebutController.text)}" ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "Date " +
                                    allTranslations.text('end') +
                                    ":\t\t\t\t\t\t" +
                                    "${FunctionUtils.convertFormatDate(_dateFinController.text)}" ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Divider(),
                          Text(
                            "Heure " +
                                    allTranslations.text('start') +
                                    ":\t " +
                                    "${FunctionUtils.convertDateTimeToHour(_dateDebutController.text)}" ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "Heure " +
                                    allTranslations.text('end') +
                                    ":\t\t\t\t\t\t" +
                                    "${FunctionUtils.convertDateTimeToHour(_dateFinController.text)}" ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          onPressed: () {
                            selectDateRange(
                                debut: _dateDebutController,
                                fin: _dateFinController);
                          },
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.date_range),
                              Text(
                                "Définir début \net fin du cours",
                                textAlign: TextAlign.center,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                          "Les dates et heures sont obligatoires !\nCocher seulement les absents ou retardataires !",
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.red[200],
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 2)
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: Grey[300],
                height: MediaQuery.of(context).size.height / 2.1,
                child: Scrollbar(
                  controller: _scrollbarController,
                  // showTrackOnHover: true,
                  interactive: true,
                  hoverThickness: 15,
                  isAlwaysShown: true,
                  radius: Radius.circular(10),
                  thickness: 8,
                  child: ListView(
                    // controller: _scrollbarController,
                    shrinkWrap: true,
                    primary: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      information.length,
                      (i) {
                        return ListTile(
                          leading: Checkbox(
                            value: checkControllers[i],
                            visualDensity: VisualDensity.compact,
                            tristate: false,
                            onChanged: (valueNew) {
                              setState(() {
                                checkControllers[i] = valueNew;
                              });
                              // listAll();
                            },
                          ),
                          title: Text(
                            information[i].nom ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: GreenLight,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.justify,
                          ),
                          subtitle: checkControllers[i]
                              ? Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4),
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        items: typeAbs
                                            .map((type) => DropdownMenuItem(
                                                  child: Text(type.value),
                                                  value: type.key.toString(),
                                                  onTap: () =>
                                                      print(type.value),
                                                ))
                                            .toList(),
                                        hint: typeControllers[i].text == ""
                                            ? Text("Type")
                                            : Text(
                                                typeControllers[i].text,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLines: 3,
                                                softWrap: true,
                                              ),
                                        onChanged: (value) {
                                          setState(() {
                                            typeControllers[i].text = value;
                                          });
                                        },
                                      ),
                                    ),
                                    typeControllers[i].text == '2'
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    FunctionUtils.selectTime(
                                                            context,
                                                            finRetardControllers[
                                                                i])
                                                        .then((value) =>
                                                            setState(() {
                                                              finRetardControllers[
                                                                          i]
                                                                      .text =
                                                                  "${_dateDebutController.text.substring(0, 10)} ${finRetardControllers[i].text}";
                                                            }));
                                                    print(
                                                        finRetardControllers[i]
                                                            .text);
                                                    // selectDateRange(
                                                    //     fin: finRetardControllers[
                                                    //         i]);
                                                  },
                                                  child: Text(
                                                      "Definir l'heure de ${allTranslations.text('end').toLowerCase()}"),
                                                ),
                                              ),
                                              Text(
                                                  "Heure ${allTranslations.text('end')}: ${FunctionUtils.convertDateTimeToHour(finRetardControllers[i].text)}",
                                                  // "Heure ${allTranslations.text('end')}: ${(finRetardControllers[i].text)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Black,
                                                  )),
                                            ],
                                          )
                                        : SizedBox(height: 0, width: 0)
                                  ],
                                )
                              : SizedBox(height: 0, width: 0),
                        );
                      },
                      growable: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                ),
                child: InkValidationButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      print('Notes Enregistre');
                      // saveAbs();
                      _showConfirmationAlert();
                      // Navigator.of(context).pop();
                    }
                  },
                  buttontext: "${allTranslations.text('submit')}",
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
/* Fonctions deb */

  loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getApprenantsClasse(apprenantDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information.eleves;
              addAbs.uIdentifiant = widget.me.authKey;
              addAbs.cIdentifiant = widget.classe.keyclasse;
              typeAbs = a.information.typesAbsences;
              for (int i = 0; i < information.length; i++) {
                // logic to create a variable of List type and even name it according to the value it is holding:
                typeControllers[i] = TextEditingController(text: "");
                finRetardControllers[i] =
                    TextEditingController(text: _dateFinController.text);
                checkControllers[i] = false;
              }
            });
            loading(false);
            return true;
          } else {
            // Navigator.of(context).pop(null);
            loading(false);
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
      // Navigator.of(context).pop(null);
      loading(false);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  sendNotes() {
    print("En saisie...");

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
                Text(allTranslations.text('login_processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });

    // loading(true);
    Api api = ApiRepository();
    api.sendAbsence(addAbs).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            // D'abord fermer le circular progress
            print("\n\nFermerture du circular..\n\n");
            Navigator.of(context).pop(null);
            //Afficher le message de succes
            FunctionUtils.displaySnackBar(
                context, "Absences enregistrées avec succès",
                type: 1);
            //pateinter 3 secondes
            Timer(Duration(seconds: 3), () {
              //  puis fermer le flushbar
              Navigator.of(context).pop(null);
              //  et enfin revenir sur la page des details de note
              print("\n\nquitter la page..\n\n");
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ListEleves(
              //       me: widget.me,
              //       annee: widget.annee,
              //       centre: widget.centre,
              //       evaluation: widget.evaluation,
              //     ),
              //   ),
              // );
              Navigator.pop(context);
              // Navigator.of(context).;
            });
            return true;
          } else {
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(
                context, allTranslations.text('error_process'));
            return false;
          }
        });
      } else if (value.isLeft()) {
        // setState(() {
        //   error = true;
        // });
        // loading(false);
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      Navigator.of(context).pop(null);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  saveAbs() {
    var listAbs = [];
    setState(() {
      for (int i = 0; i < checkControllers.length; i++) {
        if (checkControllers[i] == true) {
          absences.add(InfoAbsence(
            idApprenant: information[i].id.toString(),
            idcentre: information[i].idcentre,
            typeAbsence: typeControllers[i].text,
            heureFinRetard: finRetardControllers[i].text,
          ));
          print("TypeAbs: " + typeControllers[i].text);
          print("FinRetard: " + finRetardControllers[i].text);
        }
      }
      //
      print("\n\n");
      absences.forEach((element) {
        // print("\n\n");
        // print(json.encode(element.toJson()));
        listAbs.add(json.encode(element.toJson()));
      });
      print("\n\n");
      print((listAbs.toString()));
      print("\n\n");
    });
    print("\n\n");
    // addAbs.jsonAbsence = json.encode(listAbs.toString());
    addAbs.jsonAbsence = listAbs.toString();
    print(addAbs.jsonAbsence);
    print("\n\n");
    print("\n${addAbs.toJson()}\n");
    sendNotes();
  }

  _showConfirmationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Confirmer"),
          content: Text("Continuer avec l'enregistrement?"),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Continuer"),
              onPressed: () {
                Navigator.of(context).pop();
                saveAbs();
              },
            ),
          ],
        );
      },
    );
  }

  selectDateRange({TextEditingController debut, TextEditingController fin}) {
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
                      debut != null
                          ? Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: DateTimePicker(
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                controller: _dateDebutController,
                                locale: Locale('fr'),
                                // initialDatePickerMode: DatePickerMode.year,
                                // initialValue: DateTime.parse(debut.text).toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                dateLabelText: 'Date début',
                                timeLabelText: "Heure",
                                onChanged: (val) {
                                  print(val);
                                  setState(() {
                                    debut.text = val.toString().split(".")[0];
                                  });
                                },
                                validator: (val) {
                                  // print(val);
                                  return null;
                                },
                                onSaved: (val) {
                                  print(val);
                                  setState(() {
                                    debut.text = val.toString().split(".")[0];
                                  });
                                },
                              ),
                            )
                          : SizedBox(height: 0, width: 0),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'd MMM, yyyy',
                          controller: _dateFinController,
                          locale: Locale('fr'),
                          // initialDatePickerMode: DatePickerMode.year,
                          // initialValue: DateTime.parse(fin.text).toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date fin',
                          timeLabelText: "Heure",
                          onChanged: (val) {
                            print(val);
                            setState(() {
                              fin.text = val.toString().split(".")[0];
                            });
                          },
                          validator: (val) {
                            // print(val);
                            return null;
                          },
                          onSaved: (val) {
                            print(val);
                            setState(() {
                              fin.text = val.toString().split(".")[0];
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () {
                  debut.clear();
                  fin.clear();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Valider"),
                onPressed: () {
                  setState(() {
                    addAbs.heureDebut = _dateDebutController.text;
                    addAbs.heureFin = _dateFinController.text;
                  });

                  Navigator.pop(context);
                  if (_rappelFormKey.currentState.validate()) {
                    print('Abs ajoutée');
                    print('Debut: ${addAbs.heureDebut}');
                    print('Fin: ${addAbs.heureFin}');
                    // saveRappel(widget.tache);
                  }
                },
              ),
            ],
          );
        });
  }

/* End */
}
