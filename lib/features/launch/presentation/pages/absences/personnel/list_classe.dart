import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/anneescolaire_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/classe_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/note_apprenant_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/add_absence_apprenant.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

class ListClasse extends StatefulWidget {
  final UserModel me;

  ListClasse({Key key, this.me}) : super(key: key);

  @override
  _ListClasseState createState() => _ListClasseState();
}

class _ListClasseState extends State<ListClasse> {
  List<Classes> information, classeFilter = [];
  List<Specialites> specialites = [];
  List<String> centres = [];
  AnneeScolaireModel annee = AnneeScolaireModel();
  List<NoteApprenantModel> notesEleves = [];
  Animation<double> rotationAnimation;
  GetInfoDto infoDto = GetInfoDto();
  TextEditingController specialiteController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  TextEditingController matiereController = TextEditingController();
  bool isLoading;
  bool error = false;
  bool expandFlag = false;
  bool isAdmin = false;
  bool allChk = false;

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
        title: Text(allTranslations.text('classes')),
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
        noDataText: Text(allTranslations.text('no_class')),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: specialites
                              .map((spec) => DropdownMenuItem(
                                    child: Text(spec.libellespecialite),
                                    value: spec.keyspecialite,
                                    onTap: () => print(spec.libellespecialite),
                                  ))
                              .toList(),
                          hint: specialiteController.text == ""
                              ? Text("Spécialité")
                              : Text(
                                  specialiteController.text,
                                  overflow: TextOverflow.ellipsis,
                                  // maxLines: 3,
                                  softWrap: true,
                                ),
                          onChanged: (value) {
                            specialiteController.text = value;
                            filterInfo(false, specialiteController.text);
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        color: Colors.grey[100],
                        child: CheckboxListTile(
                          tristate: false,
                          dense: true,
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
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(height: 5),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              // GroupedListView<EvaluationModel, String>(
              itemCount: classeFilter.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                      // tileColor: Colors.grey[300],
                      leading: Icon(Icons.school,
                          size: 50.0, color: Colors.grey[700]),
                      // title: Text(elmt.typeEvaluation),
                      title: Text(classeFilter[i].libelleclasse,
                          style: TextStyle(color: GreenLight)),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Matiere : ${elmt.matiere}'),
                          Text(allTranslations.text('specialite') +
                              ' : ${specialites.firstWhere((element) => element.keyspecialite == classeFilter[i].keyspecialite).libellespecialite}'),
                          // Text(
                          //     // 'Date : ${FunctionUtils.convertFormatDate(elmt.dateEvaluation)}'),
                          //     'Effectif : ${(i * 4) + 6 - (i / 2).ceil()}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddApprenantAbsence(
                              me: widget.me,
                              classe: classeFilter[i],
                            ),
                          ),
                        );
                      }),
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

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getClasses(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information.classes;
              information.forEach((element) {
                print("Classe: $element");
              });

              /* Listes */
              specialites.clear();
              for (var classe in information) {
                if (!centres.contains(classe.centre))
                  centres.add(classe.centre);
                var spec = a.information.specialites.firstWhere(
                    (spec) => spec.keyspecialite == classe.keyspecialite);
                if (!specialites.contains(spec)) specialites.add(spec);
              }
              specialiteController.text = "";
              if (classeFilter.length > 0) classeFilter.clear();
              classeFilter.addAll(information);
              allChk = true;
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

  void filterInfo(bool tout, [String specialite]) {
    // print("Filtering by: " + critere);
    setState(() {
      if (!tout) {
        if (specialite != "") {
          classeFilter = information
              .where((classe) => classe.keyspecialite == specialite)
              .toList();
        }
        allChk = false;
      } else {
        specialiteController.text = "";
        if (classeFilter.length > 0) classeFilter.clear();
        classeFilter.addAll(information);
        allChk = true;
      }
    });
  }

  void listAll() {
    // allChk = !allChk;
    setState(() {
      specialiteController.text = "";
    });
    if (allChk) filterInfo(true);
  }

  /* End */
}
