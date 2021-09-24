import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/affectation_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/filter_pane_widget.dart';

// ignore: must_be_immutable
class AllAffectations extends StatefulWidget {
  UserModel me;
  List<AffectationModel> affectations;
  List<String> noms;
  List<String> centres;
  AllAffectations({this.me, this.affectations, this.noms, this.centres});
  @override
  _AllAffectationsState createState() => _AllAffectationsState();
}

class _AllAffectationsState extends State<AllAffectations> {
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  List<AffectationModel> filteredInfo = [];
  var noms = [];
  TextEditingController centreController = TextEditingController();
  bool allChk = false;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    isLoading = false;
    widget.affectations.sort((abs1, abs2) => (DateTime.parse(abs1.dateDebut)
        .compareTo(DateTime.parse(abs2.dateDebut))));
    for (var nom in widget.noms) {
      noms.add([nom, 0]);
      print("\n ${[nom, 0]}");
    }
    /* Remplir le nmbre de ligne par noms deb */
    for (var item in widget.affectations) {
      for (var n in noms) {
        if (n[0] == (item.nom)) {
          n[1] += 1;
          print("\n Incrementation(InitState) :${n[0]} = ${n[1]} Lignes");
        }
      }
    }
    /* Remplir le nmbre de ligne par noms end */
    centreController.text = "";
    filteredInfo.clear();
    filteredInfo.addAll(widget.affectations);
    allChk = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('all_affectations')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getInfos();
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 26.0,
            ),
          ),
        ],
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: widget.affectations,
        noDataText: Text(allTranslations.text('no_affectation')),
        child: ListView(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            children: <Widget>[
              /* Filtre par centre et personnel deb */
              SingleFilterPaneWidget(
                hint: centreController.text == ""
                    ? Text("Centre")
                    : Text((centreController.text)),
                isSearchable: false,
                items: widget.centres
                    .map((centre) => DropdownMenuItem(
                          child: Text(centre),
                          value: centre,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    centreController.text = value;
                  });
                  filterInfo(
                    false,
                    centreController.text,
                  );
                },
                onChecked: (valueNew) {
                  setState(() {
                    allChk = valueNew;
                    centreController.clear();
                  });
                },
                listAll: () => listAll(),
              ),
              SizedBox(height: 5),
              /* Filtre par centre et personnel end */
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                // itemCount: widget.noms.length,
                itemCount: noms.length,
                itemBuilder: (BuildContext context, int i) {
                  return noms[i][1] > 0
                      ? Card(
                          margin:
                              EdgeInsets.only(bottom: 25, left: 5, right: 5),
                          elevation: 1,
                          color: Colors.grey[100],
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              // Text("${widget.noms[i]}",
                              Text("${noms[i][0]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              DataTable(
                                horizontalMargin: 5,
                                sortAscending: true,
                                sortColumnIndex: 1,
                                columns: [
                                  DataColumn(
                                      label: Text('Centre',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text(allTranslations.text('start'),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Fin',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                ],
                                rows: generateRow(noms[i][0]),
                                // rows: generateRow(widget.noms[i]),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(height: 0);
                },
              ),
            ]),
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
    api.getAffectations(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              widget.affectations = a.information;
              for (var item in widget.affectations) {
                if (!widget.noms.contains(item.nom)) widget.noms.add(item.nom);
                if (!widget.centres.contains(item.centre))
                  widget.centres.add(item.centre);
              }
              widget.affectations.sort((abs1, abs2) =>
                  (DateTime.parse(abs1.dateDebut)
                      .compareTo(DateTime.parse(abs2.dateDebut))));
              noms.clear();
              for (var nom in widget.noms) {
                noms.add([nom, 0]);
                print("\n ${[nom, 0]}");
              }
              /* Remplir le nmbre de ligne par noms deb */
              // clearLigneNom();
              for (var item in widget.affectations) {
                for (var n in noms) {
                  if (n[0] == (item.nom)) {
                    n[1] += 1;
                    print(
                        "\n Incrementation(GetInfos) :${n[0]} = ${n[1]} Lignes");
                  }
                }
              }
              /* Remplir le nmbre de ligne par noms end */

              centreController.text = "";
              filteredInfo.clear();
              filteredInfo.addAll(widget.affectations);
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
        loading(false);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      loading(false);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  clearLigneNom() {
    for (var n in noms) {
      n[1] = 0;
    }
  }

  generateRow(String nom) {
    List<DataRow> rows = [];
    print("Nom genere: $nom");
    // for (var affect in widget.affectations) {
    for (var affect in filteredInfo) {
      if (affect.nom == nom) {
        // for (var n in noms) {
        //   if (n[0] == (nom)) {
        //     n[1] += 1;
        //     print("\n Incrementation(GenRow) :${n[0]} = ${n[1]} Lignes");
        //   }
        // }

        rows.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  affect.centre,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              DataCell(
                Text(
                  FunctionUtils.convertFormatDate(affect.dateDebut),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Text(
                  FunctionUtils.convertFormatDate(affect.dateFin),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return rows;
  }

  void listAll() {
    // allChk = !allChk;
    setState(() {
      centreController.text = "";
    });
    if (allChk) filterInfo(true);
  }

  filterInfo(bool tout, [String centre]) {
    setState(() {
      clearLigneNom();
      if (!tout) {
        allChk = false;
        filteredInfo = widget.affectations
            .where((element) => element.centre == centre)
            .toList();

        for (var item in filteredInfo) {
          for (var n in noms) {
            if (n[0] == (item.nom)) {
              n[1] += 1;
              print(
                  "\n Incrementation(FilterCenter) :${n[0]} = ${n[1]} Lignes");
            }
          }
        }
      } else {
        centreController.text = "";
        filteredInfo.clear();
        filteredInfo.addAll(widget.affectations);
        allChk = true;

        for (var item in filteredInfo) {
          for (var n in noms) {
            if (n[0] == (item.nom)) {
              n[1] += 1;
              print("\n Incrementation(FilterAll) :${n[0]} = ${n[1]} Lignes");
            }
          }
        }
      }
    });
  }

/* End */
}
