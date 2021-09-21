import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/anneescolaire_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/evaluation_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/note_apprenant_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/list_eleves.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/note_par_classe.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class ListEvaluations extends StatefulWidget {
  UserModel me;
  ListEvaluations({
    this.me,
  });

  @override
  _ListEvaluationsState createState() => _ListEvaluationsState();
}

class _ListEvaluationsState extends State<ListEvaluations> {
  List<EvaluationModel> information = [];
  List<EvaluationModel> evaluationFilter = [];
  List<Centres> centres = [];
  List<String> decoupages = [];
  List<String> classes = [];
  List<String> matieres = [];
  AnneeScolaireModel annee = AnneeScolaireModel();
  List<NoteApprenantModel> notesEleves = [];
  SlidableController slidableController;
  Icon _arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  Animation<double> rotationAnimation;
  GetInfoDto infoDto = GetInfoDto();
  TextEditingController periodeController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  TextEditingController matiereController = TextEditingController();
  bool isLoading;
  bool error = false;
  bool expandFlag = false;
  bool isAdmin = false;
  bool allChk = false;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: changeSlideArrowDirection,
    );
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('evaluations')),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: information,
        noDataText: Text(allTranslations.text('no_my_evaluation')),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
              height: MediaQuery.of(context).size.width / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 3.3),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: decoupages
                              .map((perso) => DropdownMenuItem(
                                    child: Text(perso),
                                    value: perso,
                                    onTap: () => print(perso),
                                  ))
                              .toList(),
                          hint: periodeController.text == ""
                              ? Text("Période")
                              : Text(
                                  periodeController.text,
                                  overflow: TextOverflow.ellipsis,
                                  // maxLines: 3,
                                  softWrap: true,
                                ),
                          onChanged: (value) {
                            periodeController.text = value;
                            filterInfo(false, periodeController.text,
                                classeController.text, matiereController.text);
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 3.3),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: classes
                              .map((perso) => DropdownMenuItem(
                                    child: Text(perso),
                                    value: perso,
                                    onTap: () => print(perso),
                                  ))
                              .toList(),
                          hint: classeController.text == ""
                              ? Text("Classe")
                              : Text(classeController.text),
                          onChanged: (value) {
                            setState(() {
                              classeController.text = value;
                            });
                            filterInfo(false, periodeController.text,
                                classeController.text, matiereController.text);
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 3.3),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: matieres
                              .map((perso) => DropdownMenuItem(
                                    child: Text(perso),
                                    value: perso,
                                    onTap: () => print(perso),
                                  ))
                              .toList(),
                          hint: matiereController.text == ""
                              ? Text("Matière")
                              : Text(matiereController.text),
                          onChanged: (value) {
                            setState(() {
                              matiereController.text = value;
                            });
                            filterInfo(false, periodeController.text,
                                classeController.text, matiereController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) - 30,
                    child: Container(
                      color: Colors.grey[100],
                      child: CheckboxListTile(
                        tristate: false,
                        dense: true,
                        activeColor: GreenLight,
                        secondary: const Text('Tout'),
                        value: allChk,
                        onChanged: (valueNew) {
                          setState(() {
                            allChk = valueNew;
                          });
                          listAll();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              // GroupedListView<EvaluationModel, String>(
              itemCount: evaluationFilter.length,
              itemBuilder: (context, i) {
                return Slidable(
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Saisir les notes',
                      color: GreenLight,
                      icon: Icons.edit,
                      onTap: () {
                        /* this._moreActionEleve(
                          context, classes[i], specialites[i].nom); */
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => NoteClasse(
                              me: widget.me,
                              // evaluation: elmt,
                              evaluation: evaluationFilter[i],
                              annee: annee,
                              centre: centres
                                  .firstWhere((element) => element.key != 1),
                            ),
                          ),
                        );
                      },
                    ),
                    IconSlideAction(
                      caption: 'Les notes',
                      color: Grey,
                      icon: Icons.remove_red_eye_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ListEleves(
                              me: widget.me,
                              // evaluation: elmt,
                              evaluation: evaluationFilter[i],
                              annee: annee,
                              centre: centres
                                  .firstWhere((element) => element.key != 1),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  child: Card(
                    child: ListTile(
                        // tileColor: Colors.grey[300],
                        leading: Icon(Icons.class__rounded,
                            size: 50.0, color: Colors.grey[700]),
                        // title: Text(elmt.typeEvaluation),
                        title: Text(
                          evaluationFilter[i].typeEvaluation,
                          style: TextStyle(color: GreenLight),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('Matiere : ${elmt.matiere}'),
                            Text('Matière : ${evaluationFilter[i].matiere}'),
                            Text(
                                // 'Date : ${FunctionUtils.convertFormatDate(elmt.dateEvaluation)}'),
                                'Date : ${FunctionUtils.convertFormatDate(evaluationFilter[i].dateEvaluation)}'),
                          ],
                        ),
                        trailing: _arrowLeft,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ListEleves(
                                me: widget.me,
                                // evaluation: elmt,
                                evaluation: evaluationFilter[i],
                                annee: annee,
                                centre: centres
                                    .firstWhere((element) => element.key != 1),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              },
            ),
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

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      rotationAnimation = slideAnimation;
    });
  }

  void changeSlideArrowDirection(bool isOpen) {
    setState(() {
      _arrowLeft = isOpen
          ? Icon(Icons.keyboard_arrow_right_rounded)
          : Icon(Icons.keyboard_arrow_left_rounded);
    });
  }

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getEvaluations(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information.evaluations;
              if ((a.information.centres.length) > 0)
                centres = a.information.centres;
              if ((a.information.anneeScolaires.length) > 0)
                annee = a.information.anneeScolaires.first;
              /* Listes */
              for (var eval in information) {
                if (!matieres.contains(eval.matiere))
                  matieres.add(eval.matiere);
                if (!classes.contains(eval.classe)) classes.add(eval.classe);
                if (!decoupages.contains(eval.decoupage))
                  decoupages.add(eval.decoupage);
              }
              matiereController.text = "";
              classeController.text = "";
              periodeController.text = "";
              if (evaluationFilter.length > 0) evaluationFilter.clear();
              evaluationFilter.addAll(information);
              allChk = true;

              evaluationFilter.sort((note1, note2) =>
                  note1.dateEvaluation.compareTo(note2.dateEvaluation));
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

  void filterInfo(bool tout,
      [String decoupage, String classe, String matiere]) {
    // print("Filtering by: " + critere);
    setState(() {
      if (!tout) {
        ///Triple filtrage
        if (decoupage != "" && classe != "" && matiere != "") {
          evaluationFilter = information
              .where(
                (note) =>
                    note.decoupage == decoupage &&
                    note.classe == classe &&
                    note.matiere == matiere,
              )
              .toList();

          ///Double filtrage
        } else if (decoupage != "" && classe != "" && matiere == "") {
          evaluationFilter = information
              .where(
                (note) => note.decoupage == decoupage && note.classe == classe,
              )
              .toList();
        } else if (decoupage != "" && classe == "" && matiere != "") {
          evaluationFilter = information
              .where(
                (note) =>
                    note.decoupage == decoupage && note.matiere == matiere,
              )
              .toList();
        } else if (decoupage == "" && classe != "" && matiere != "") {
          evaluationFilter = information
              .where(
                (note) => note.classe == classe && note.matiere == matiere,
              )
              .toList();

          ///Filtrage unique
        } else if (decoupage != "" && classe == "" && matiere == "") {
          evaluationFilter =
              information.where((note) => note.decoupage == decoupage).toList();
        } else if (decoupage == "" && classe != "" && matiere == "") {
          evaluationFilter =
              information.where((note) => note.classe == classe).toList();
        } else if (decoupage == "" && classe == "" && matiere != "") {
          evaluationFilter =
              information.where((note) => note.matiere == matiere).toList();
        }
        allChk = false;
      } else {
        matiereController.text = "";
        classeController.text = "";
        periodeController.text = "";
        if (evaluationFilter.length > 0) evaluationFilter.clear();
        evaluationFilter.addAll(information);
        allChk = true;
      }

      evaluationFilter.sort((note1, note2) =>
          note1.dateEvaluation.compareTo(note2.dateEvaluation));
      /* print("\n ======== Start ======== \n");
      for (var item in filteredInfo) {
        print("\n");
        print(item.toJson());
        print("\n");
      }
      print("\n ======== End ======== \n"); */
    });
  }

  void listAll() {
    // allChk = !allChk;
    setState(() {
      matiereController.text = "";
      classeController.text = "";
      periodeController.text = "";
    });
    if (allChk) filterInfo(true);
  }

/* End */
}
