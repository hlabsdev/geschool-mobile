// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_note_dto.dart';
import 'package:geschool/features/common/data/dto/apprenant_eval_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/anneescolaire_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/evaluation_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/apprenant_eval_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/list_eleves.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/ink_button_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class NoteClasse extends StatefulWidget {
  EvaluationModel evaluation;
  UserModel me;
  AnneeScolaireModel annee;
  Centres centre;

  NoteClasse({
    this.evaluation,
    this.me,
    this.centre,
    this.annee,
  });

  @override
  _NoteClasseState createState() => _NoteClasseState();
}

final formKey = GlobalKey<FormState>();

class _NoteClasseState extends State<NoteClasse> {
  List<ApprenantEval> information = [];
  List<InfoNote> notes = [];
  ApprenantEvalDto apprenantDto = ApprenantEvalDto();
  AddNoteDto addNoteDto = AddNoteDto();
  final Map noteControllers = {};

  bool isLoading;
  bool error = false;
  @override
  initState() {
    apprenantDto.uIdentifiant = widget.me.authKey;
    apprenantDto.eIdentifiant = widget.evaluation.keyEvaluation;
    apprenantDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enregistrement de notes"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      body: Form(
        key: formKey,
        child: RefreshableWidget(
          error: error,
          information: information,
          isLoading: isLoading,
          noDataText: Text("Aucune données ici pour le moment"),
          onRefresh: getInfos,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    allTranslations.text('periode') +
                            ":\t" +
                            widget.evaluation.decoupage ??
                        allTranslations.text('not_defined'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.evaluation.typeEvaluation +
                            " du:\t${FunctionUtils.convertFormatDate(widget.evaluation.dateEvaluation)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        allTranslations.text('classe') +
                                ":\t " +
                                widget.evaluation.classe ??
                            allTranslations.text('not_defined'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        allTranslations.text('matiere') +
                                ":\t" +
                                widget.evaluation.matiere ??
                            allTranslations.text('not_defined'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Column(
                  children: List.generate(
                    information.length,
                    (i) {
                      return ListTile(
                        leading: Icon(
                          Icons.person_outline_rounded,
                        ),
                        title: Text(
                          information[i].nom ??
                              allTranslations.text('not_defined'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // color: PafpeGreen,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          // textAlign: TextAlign.justify,
                        ),
                        trailing: SizedBox(
                            width: 70,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              // controller: noteControllers[
                              //     '_noteController' + i.toString()],
                              controller: noteControllers[i],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true, signed: false),
                              inputFormatters: [
                                // FilteringTextInputFormatter.,
                              ],
                              decoration: InputDecoration(
                                // contentPadding: Vx.m2,
                                contentPadding: EdgeInsets.only(
                                    bottom: 10, left: 5, right: 5),
                                border: OutlineInputBorder(),
                                labelText: allTranslations.text('note'),
                              ),
                              // validator: (value) {
                              //   if (value.isEmpty) {
                              //     return allTranslations
                              //         .text('pls_set_note');
                              //   }
                              //   return null;
                              // },
                            )),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                ),
                width: 150,
                child: InkValidationButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      print('Notes Enregistre');
                      saveNote();
                      // _showConfirmationAlert();
                      // Navigator.of(context).pop();
                    }
                  },
                  buttontext: "${allTranslations.text('submit')}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/* Fonctions deb */

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getApprenantsEval(apprenantDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information;

              addNoteDto.uIdentifiant = widget.me.authKey;
              addNoteDto.aIdentifiant = widget.annee.keyAnnee;
              addNoteDto.eIdentifiant = widget.evaluation.keyEvaluation;
              addNoteDto.idCenter = widget.centre.key.toString();
              addNoteDto.aIdentifiant = widget.annee.keyAnnee;

              for (int i = 0; i < information.length; i++) {
                String note = information[i].note == null
                    ? ""
                    : information[i].note.toString();
                // logic to create a variable of List type and even name it according to the value it is holding:
                // noteControllers['_noteController' + i.toString()] =
                //     new TextEditingController(
                //   text: note
                // );
                noteControllers[i] = new TextEditingController(text: note);
              }
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
      // Navigator.of(context).pop(null);
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
    api.sendNotes(addNoteDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            // D'abord fermer le circular progress
            print("\n\nFermerture du circular..\n\n");
            Navigator.of(context).pop(null);
            //Afficher le message de succes
            FunctionUtils.displaySnackBar(
                context, "Notes enregistrées avec succès",
                type: 1);
            //pateinter 3 secondes
            Timer(Duration(seconds: 3), () {
              //  puis fermer le flushbar
              Navigator.of(context).pop(null);
              //  et enfin revenir sur la page des details de note
              print("\n\nquitter la page..\n\n");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ListEleves(
                    me: widget.me,
                    annee: widget.annee,
                    centre: widget.centre,
                    evaluation: widget.evaluation,
                  ),
                ),
              );
              print(widget.centre.toJson());
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

  void saveNote() {
    var listnote = [];
    setState(() {
      for (int i = 0; i < noteControllers.length; i++) {
        notes.add(InfoNote(
          iduser: information[i].id.toString(),
          // note: noteControllers['_noteController' + i.toString()].text ?? "",
          note: noteControllers[i].text ?? "",
        ));
        // print(noteControllers['_noteController' + i.toString()].text);
        print(noteControllers[i].text);
      }
      //
      print("\n\n");
      notes.forEach((element) {
        // print("\n\n");
        // print(json.encode(element.toJson()));
        listnote.add(json.encode(element.toJson()));
      });
      print("\n\n");
      print((listnote.toString()));
      print("\n\n");
    });
    print("\n\n");
    // addNoteDto.infoNote = json.encode(listnote.toString());
    addNoteDto.infoNote = listnote.toString();
    print(addNoteDto.infoNote);
    print("\n\n");
    print("\n${addNoteDto.toJson()}\n");
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
                saveNote();
              },
            ),
          ],
        );
      },
    );
  }
}
