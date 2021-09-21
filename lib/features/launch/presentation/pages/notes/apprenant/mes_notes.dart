import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/note_apprenant_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/eleve_note_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class MesNotes extends StatefulWidget {
  UserModel me;
  MesNotes({this.me});
  @override
  _MesNotesState createState() => _MesNotesState();
}

class _MesNotesState extends State<MesNotes> {
  List<NoteApprenantModel> information = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  String annee;
  List<String> matieres = [];
  List<String> evaluations = [];
  List<String> decoupages = [];

  bool error = false;

  bool allChk = true;

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
        title: Text(
            allTranslations.text('my_note') + " (${isLoading ? "" : annee})"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  getInfos();
                },
                child: Icon(
                  Icons.refresh_rounded,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: information,
        noDataText: Text(allTranslations.text('no_note')),
        child: EleveNoteWidget(
          evaluations: evaluations,
          information: information,
          matieres: matieres,
          decoupages: decoupages,
        ),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getStudentNotes(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information.infos;
              if (information.length > 0)
                for (var note in information) {
                  if (!matieres.contains(note.matiere))
                    matieres.add(note.matiere);
                  if (!evaluations.contains(note.evaluation))
                    evaluations.add(note.evaluation);
                  if (!decoupages.contains(note.decoupage))
                    decoupages.add(note.decoupage);
                }
              annee = information.first.idannee;
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
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      loading(false);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

/* End */
}
