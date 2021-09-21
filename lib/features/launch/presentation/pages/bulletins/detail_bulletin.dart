import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto%20copy.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/bulletin_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:open_file/open_file.dart';

// ignore: must_be_immutable
class DetailBulletin extends StatefulWidget {
  Bulletin detail;
  UserModel me;

  DetailBulletin({this.detail, this.me});

  @override
  _DetailBulletinState createState() => _DetailBulletinState();
}

class _DetailBulletinState extends State<DetailBulletin> {
  GetBulletinLinkDto bulletinDto = GetBulletinLinkDto();
  String lien;
  String nomFic;
  String dossierFic;
  bool isLoading;
  bool error = false;

  @override
  void initState() {
    bulletinDto.uIdentifiant = widget.me.authKey;
    bulletinDto.bIdentifiant = widget.detail.keyBulletin;
    bulletinDto.idCenter = widget.detail.idcentre;
    bulletinDto.registrationId = "";
    nomFic =
        "BULLETIN ${widget.detail.nom.toUpperCase()} ${widget.detail.prenoms.toUpperCase()} - ${widget.detail.libelle.toUpperCase()}(${widget.detail.libelleanneescolaire}).pdf";
    dossierFic = "/storage/emulated/0/Download/";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getInfos();
        },
        tooltip: allTranslations.text('download_bulletin'),
        child: Icon(Icons.download_rounded),
      ),
      appBar: AppBar(
        title:
            Text("Détail du " + allTranslations.text('bulletin').toLowerCase()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: [
          checkFileExist()
              ? IconButton(
                  icon: Icon(Icons.file_present),
                  tooltip: "Voir le bulletin déja téléchargé",
                  onPressed: () {
                    openFile(dossierFic + nomFic, true);
                  })
              : SizedBox(height: 0),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 15),
          Card(
            // margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                /* TITRE DEB */
                SizedBox(height: 5),
                Center(
                  child: Text(
                    widget.detail.libelle.toUpperCase() +
                        (" (${widget.detail.libelleanneescolaire})" ??
                            allTranslations.text('not_defined')),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /* TITRE END */
                /* ============================================== */
                /* INFO ETUDIANT DEB */
                ListTile(
                  leading: Icon(Icons.person_rounded, size: 30),
                  contentPadding: EdgeInsets.only(right: 5, left: 5),
                  title: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allTranslations.text('name'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: PafpeGreen,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.justify,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                            child: Text(
                              "${widget.detail.nom} ${widget.detail.prenoms}" ??
                                  allTranslations.text('not_defined'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Matricule",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: PafpeGreen,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.justify,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(
                              "${widget.detail.matricule}" ??
                                  allTranslations.text('not_defined'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  // subtitle:
                  // isThreeLine: true,
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.home_work_rounded, size: 30),
                  contentPadding: EdgeInsets.only(right: 5, left: 5),
                  title: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allTranslations.text('specialite'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: PafpeGreen,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.justify,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(
                              widget.detail.libellespecialite ??
                                  allTranslations.text('not_defined'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allTranslations.text('classe'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: PafpeGreen,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.justify,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              widget.detail.libelleclasse ??
                                  allTranslations.text('not_defined'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // subtitle:
                  // isThreeLine: true,
                ),
                /* INFO ETUDIANT END */
                /* ============================================== */
                /* NOTES ET MOYENNES DEB */
                DataTable(
                  // horizontalMargin: 8,
                  showBottomBorder: true,
                  columns: [
                    DataColumn(
                        label: Text(allTranslations.text('general_note'),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text(allTranslations.text('general_moyenne'),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text(allTranslations.text('rank'),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        // DataCell(Text(affect.idcentre.toString())),
                        DataCell(
                          Text(
                            widget.detail.note ?? "...",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            widget.detail.moyenne ?? "...",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            widget.detail.rang ?? "...",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                /* NOTES ET MOYENNES END */
                /* ============================================== */
                SizedBox(height: 5),
                /* Conduite deb */ ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 35),
                  title: Text(
                    allTranslations.text('conduite'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Retards" + ":\t"),
                          Text(
                            widget.detail.retard,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Absences" + ":\t "),
                          Text(
                            widget.detail.absence,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Punitions" + ":\t "),
                          Text(
                            widget.detail.punition,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                /* Conduite end */
                /* ============================================== */
                /* DECISIONS DEB */
                // SizedBox(height: 2),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 35),
                  title: Text(
                    allTranslations.text('decision_conseil'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Situation" + ":\t"),
                          renderSituation(widget.detail.situation),
                        ],
                      ),
                      Row(
                        children: [
                          Text(allTranslations.text('tableau_honeur') + ":\t "),
                          Text(
                              (widget.detail.honneur == "1"
                                  ? "OUI"
                                  : "NON" ??
                                      allTranslations.text('not_defined')),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(allTranslations.text('encouragement') + ":\t "),
                          Text(("....." ?? allTranslations.text('not_defined')),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(allTranslations.text('congrats') + ":\t"),
                          Text("....." ?? allTranslations.text('not_defined'),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                /* DECISIONS End */
              ],
            ),
          ),
          SizedBox(),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              allTranslations.text('pls_click_to_download_bulletin'),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  renderSituation(String situation) {
    if (situation == "0") {
      return Text(".....", style: TextStyle(fontWeight: FontWeight.bold));
    }
    if (situation == "1") {
      return Text("ADMIS(e)".toUpperCase(),
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.green[300]));
    }
    if (situation == "2") {
      return Text("ECHOUé(e)".toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.orange[300]));
    }
    if (situation == "3") {
      return Text("EXCLUS(e)!".toUpperCase(),
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.red[300]));
    }
  }

  void getInfos() {
    print("user changing...");
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
                Text(allTranslations.text('downloading')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        });

    print("En recuperation...");
    Api api = ApiRepository();
    if (lien == null || lien == "") {
      /* On recuperer d'abord le lien */
      api.getBulletinLink(bulletinDto).then((value) {
        if (value.isRight()) {
          value.all((a) {
            if (a != null && a.status.compareTo("000") == 0) {
              //enregistrement des informations de recuperes
              setState(() {
                lien = a.message;
              });
              Navigator.of(context).pop(null);
              FunctionUtils.displaySnackBar(context,
                  "Lien du bulletin recupéré avec succès.\nVous pouvez le télécharger à tout moment");
              downloadFile(lien, nomFic).then((value) async => openFile(value),
                  onError: (value) {
                FunctionUtils.displaySnackBar(context, value);
              });
              return true;
            } else {
              Navigator.of(context).pop(null);
              FunctionUtils.displaySnackBar(context,
                  "Il semblerait que le bulletin complet ne soit pas encore disponible. \nDonc vous ne pourez pas le telecharger pour le moment.");
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
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(context, error.toString());
      });
    } else {
      /* Le lien est deja là */
      Navigator.pop(context);
      downloadFile(lien, nomFic).then((value) async => openFile(value),
          onError: (value) {
        FunctionUtils.displaySnackBar(context, value);
      });
      Navigator.of(context).pop(null);
    }
  }

  Future<String> downloadFile(String url, String fileName) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    try {
      FunctionUtils.displaySnackBar(context, "Debut du telechargement");
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        print(response.toString());
        filePath = '/storage/emulated/0/Download/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        /* .then((value) {
          final message = OpenFile.open(filePath);
          print(message);
        }); */
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = "Le teclechagement n'a pas abouti";
    }
    return filePath;
  }

  bool checkFileExist() {
    File file = File(dossierFic + nomFic);
    return file.existsSync();
  }

  Future<void> openFile(String path, [bool exist]) async {
    if (path.contains("Error")) {
      FunctionUtils.displaySnackBar(context, path);
    } else {
      if (exist == null) {
        FunctionUtils.displaySnackBar(context, "Opération terminée: $path");
      }
      // Timer(Duration(seconds: 3), () {
      //   Navigator.of(context).pop(null);
      // });

      var filePath = path;
      print('$filePath');
      final message = await OpenFile.open(filePath);
      print(message);
      setState(() {});
    }
  }

/* 
  Future<void> openFile(String path) async {
    var filePath = path;
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      filePath = result.files.single.path;
    } else {
      // User canceled the picker
    }
    final _result = await OpenFile.open(filePath);
    print(_result.message);

    setState(() {
      _openResult = "type=${_result.type}  message=${_result.message}";
    });
  } */
/* End */
}
