import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_note_dto.dart';
import 'package:geschool/features/common/data/dto/apprenant_eval_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/anneescolaire_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/evaluation_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/apprenant_eval_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/notes/personnel/note_par_classe.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class ListEleves extends StatefulWidget {
  EvaluationModel evaluation;
  AnneeScolaireModel annee;
  Centres centre;
  UserModel me;
  ListEleves({this.me, this.evaluation, this.annee, this.centre});

  @override
  _ListElevesState createState() => new _ListElevesState();
}

class _ListElevesState extends State<ListEleves> {
  SlidableController slidableController;
  Icon arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  GetInfoDto infoDto = GetInfoDto();
  List<ApprenantEval> information = [];
  List<InfoNote> notes = [];
  ApprenantEvalDto apprenantDto = ApprenantEvalDto();
  AddNoteDto addNoteDto = AddNoteDto();

  bool isLoading;
  bool error = false;
  final Map noteControllers = {};

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: changeSlideArrowDirection,
    );
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    apprenantDto.uIdentifiant = widget.me.authKey;
    apprenantDto.eIdentifiant = widget.evaluation.keyEvaluation;
    apprenantDto.registrationId = "";
    getInfos();
    super.initState();
  }

  Animation<double> rotationAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit_rounded),
        tooltip: "Saisir des notes",
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NoteClasse(
                me: widget.me,
                // evaluation: elmt,
                evaluation: widget.evaluation,
                annee: widget.annee,
                centre: widget.centre,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("Les notes de l'évaluation"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.only(right: 20.0),
              icon: Icon(Icons.refresh_rounded),
              onPressed: () {
                getInfos();
              })
        ],
      ),
      body: RefreshableWidget(
        error: error,
        information: information,
        isLoading: isLoading,
        noDataText: Text("Aucune données ici pour le moment"),
        onRefresh: getInfos,
        child: ListView(
          children: [
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: information.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.person, size: 45.0),
                    title: Text(information[index].nom,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                        (information[index].note ?? "...").toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GreenLight)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      rotationAnimation = slideAnimation;
    });
  }

  void changeSlideArrowDirection(bool isOpen) {
    setState(() {
      arrowLeft = isOpen
          ? Icon(Icons.keyboard_arrow_right_rounded)
          : Icon(Icons.keyboard_arrow_left_rounded);
    });
  }

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
                noteControllers['_noteController' + i.toString()] =
                    new TextEditingController(
                  text: note,
                );
              }
            });
            loading(false);
            return true;
          } else {
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message);
            loading(false);
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
        loading(false);
        return false;
      }
    }, onError: (error) {
      // Navigator.of(context).pop(null);
      FunctionUtils.displaySnackBar(context, error.message);
      loading(false);
    });
  }

  showConfirmationAlert(BuildContext context, title, message) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Accepter"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
/* 
  void moreActionEleve(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.add, color: GreenLight),
                    title: new Text('Ajouter une abscence'),
                    onTap: () => {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => AddAbsence())),
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: AddAbsence())),
                        }),
                new ListTile(
                    leading: new Icon(Icons.close, color: Colors.redAccent),
                    title: new Text('Faire un Bonus'),
                    onTap: () => {
                          // showConfirmationAlert(context, 'Désactivation',
                          // 'Vous êtes sur le point de désactiver ce personnel'),
                        }),
                /* new ListTile(
                  leading: new Icon(Icons.delete, color: Colors.redAccent),
                  title: new Text('Supprimer'),
                  onTap: () => {
                    showConfirmationAlert(context, 'Suppression',
                        'Vous êtes sur le point de supprimer ce personnel'),
                  },
                ), */
              ],
            ),
          );
        });
  } */

  /* End */
}
