import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/affectation_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/affectations/all_affectations.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class MyAffectations extends StatefulWidget {
  UserModel me;
  MyAffectations({this.me});
  @override
  _MyAffectationsState createState() => _MyAffectationsState();
}

class _MyAffectationsState extends State<MyAffectations> {
  List<AffectationModel> information = [];
  List<AffectationModel> mesInformations = [];
  List<String> noms = [];
  List<String> centres = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // filterList();
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('my_affectations')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              getInfos();
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 26.0,
            ),
          ),
          isAdmin
              ? IconButton(
                  icon: Icon(
                    Icons.list_rounded,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllAffectations(
                            me: widget.me,
                            affectations: information,
                            noms: noms,
                            centres: centres,
                          ),
                        ));
                  },
                )
              : Text(''),
        ],
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: mesInformations,
        noDataText: isAdmin
            ? Text(
                allTranslations.text('no_my_affectation') +
                    "\n" +
                    allTranslations.text('can_see_all').toLowerCase() +
                    allTranslations.text('affectations').toLowerCase(),
                textAlign: TextAlign.center)
            : Text(allTranslations.text('no_my_affectation')),
        child: ListView(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          children: [
            Card(
              margin: EdgeInsets.only(bottom: 25, left: 5, right: 5),
              elevation: 1,
              color: Colors.grey[100],
              child: Column(
                children: [
                  SizedBox(height: 5),
                  /* Text("Nom: ${noms[i]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), */
                  DataTable(
                    horizontalMargin: 5,
                    sortAscending: true,
                    sortColumnIndex: 1,
                    columns: [
                      DataColumn(
                          label: Text('Centre',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text(allTranslations.text('start'),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Fin',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                    ],
                    rows: generateRow(),
                  ),
                ],
              ),
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

  void checkAdmin(int value) {
    setState(() {
      isAdmin = value == 1 ? true : false;
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
              information = a.information;
              noms.clear();
              for (var item in information) {
                if (!noms.contains(item.nom)) noms.add(item.nom);
                if (!centres.contains(item.centre)) centres.add(item.centre);
              }
              mesInformations =
                  a.information.where((element) => element.isMe == 1).toList();
              // mesInformations.addAll(information);
            });

            loading(false);
            checkAdmin(a.isAdmin);
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

  generateRow() {
    List<DataRow> rows = [];
    for (var affect in mesInformations) {
      // if (affect.nom == nom) {
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
      // }
    }
    return rows;
  }
}
