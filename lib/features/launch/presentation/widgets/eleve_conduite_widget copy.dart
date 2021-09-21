import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/respmodels/conduite_list_reponse_model.dart';

class EveleConduiteWidget extends StatefulWidget {
  const EveleConduiteWidget({
    Key key,
    @required this.information,
  }) : super(key: key);

  // final List<NoteApprenantModel> information;
  final DetailApprenantConduite information;

  @override
  _EveleConduiteWidgetState createState() => _EveleConduiteWidgetState();
}

class _EveleConduiteWidgetState extends State<EveleConduiteWidget> {
  // List<NoteApprenantModel> filteredInfo = List<NoteApprenantModel>();
  DetailApprenantConduite filteredInfo = DetailApprenantConduite();
  List<String> decoupagesFilter = [];
  TextEditingController periodeController = TextEditingController();
  Absence absences = Absence();
  Retard retards = Retard();
  Punition punitions = Punition();
  List<Decoupage> decoupages = [];
  List<AbsenceDataModel> absenceDatas = [];
  List<AbsenceDataModel> retardDatas = [];
  List<PunitionDataModel> punitionDatas = [];
  double nbrHeures;
  bool allChk = false;
  @override
  void initState() {
    absences = widget.information.infos.absence;
    absenceDatas = widget.information.infos.absence.datas;
    retardDatas = widget.information.infos.retard.datas;
    punitionDatas = widget.information.infos.punition.datas;
    retards = widget.information.infos.retard;
    punitions = widget.information.infos.punition;
    decoupages = widget.information.decoupage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 15),
      children: [
        // Filtre deb
        Container(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
          // height: MediaQuery.of(context).size.width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 2.3),
                    child: DropdownButtonFormField<Decoupage>(
                      isExpanded: true,
                      value: decoupages.firstWhere(
                        (element) => element.id == periodeController.text,
                        orElse: () => null,
                      ),
                      items: decoupages
                          .map((perso) => DropdownMenuItem<Decoupage>(
                                child: Text(perso.libelle),
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
                        periodeController.text = value.id;
                        filterInfo(false, value);
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
              SizedBox(height: 20),
            ],
          ),
        ),
        // Filtre end
        ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.grey[300],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ABSENCES",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // Text("${absences.valeur ?? 0} ${absences.unite.toUpperCase()}",
              Text("${ecartHeure()} ${absences.unite.toUpperCase()}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[200])),
            ],
          ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: absenceDatas.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  leading: Icon(
                    Icons.outlined_flag_rounded,
                    size: 30,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        absenceDatas[i].justification ??
                            "Pas de justification...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              allTranslations.text('start') + ":",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey[800]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Fin:",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey[800]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "" +
                                  FunctionUtils.convertFormatDateTime(
                                      absenceDatas[i].dateabsencedebut),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "" +
                                  FunctionUtils.convertFormatDateTime(
                                      absenceDatas[i].dateabsencefin),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ),
                        ],
                      ), // old
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
            SizedBox(height: 30)
          ],
        ),
        Divider(),
        ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.grey[300],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("RETARDS",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("${retardDatas.length ?? 0} ${retards.unite.toUpperCase()}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[200])),
            ],
          ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: retardDatas.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  leading: Icon(
                    Icons.last_page,
                    size: 30,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        retardDatas[i].justification ??
                            "Pas de justification...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              allTranslations.text('start') + ":",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey[800]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Fin:",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey[800]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "" +
                                  FunctionUtils.convertFormatDateTime(
                                      retardDatas[i].dateabsencedebut),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "" +
                                  FunctionUtils.convertFormatDateTime(
                                      retardDatas[i].dateabsencefin),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ),
                        ],
                      ), // old
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
            SizedBox(height: 30)
          ],
        ),
        Divider(),
        ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.grey[300],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PUNITIONS",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                  "${punitionDatas.length ?? 0} ${punitions.unite.toUpperCase()}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[200])),
            ],
          ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: punitionDatas.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  leading: Icon(
                    Icons.push_pin_outlined,
                    size: 30,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        punitionDatas[i].motifpunition ?? "Non defini...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              allTranslations.text('start') + ":",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey[800]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Fin:",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey[800]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "" +
                                  FunctionUtils.convertFormatDateTime(
                                      punitionDatas[i].datepunition),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "" +
                                  FunctionUtils.convertFormatDateTime(
                                      punitionDatas[i].datefinpunition),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ),
                        ],
                      ), // old
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
            SizedBox(height: 30)
          ],
        ),
      ],
    );
  }

  void listAll() {
    // allChk = !allChk;
    setState(() {
      periodeController.text = "";
    });
    if (allChk) filterInfo(true);
  }

  double ecartHeure() {
    double result = 0;
    // String ecart;
    for (var abs in absenceDatas) {
      Duration add = DateTime.parse(abs.dateabsencedebut)
          .difference(DateTime.parse(abs.dateabsencefin));
      result += double.parse(((add.inMinutes) / 60).toStringAsFixed(2));
    }
    result = result.abs();

    return result;
    /* Logique pour retoutner le nombre de mois, jours et heures debut */
    // if (result <= 23) {
    //   ecart = "$result Heures";
    // } else if (result > 23 && result < 729) {
    //   var jours = (result / 24).truncate();
    //   var heures = double.parse((result % 24).toStringAsFixed(2));
    //   ecart = "$jours Jours, ";
    //   if (heures > 0) ecart += "$heures Heures";
    // } else if (result > 729) {
    //   var mois = (result / 730).truncate();
    //   int jours = ((result % 730) / 24).truncate();
    //   var heures = double.parse(((result % 730) % 24).toStringAsFixed(2));
    //   // var heures = result / 24;
    //   ecart = "$mois Mois, ";
    //   if (jours > 1) ecart += "$jours Jours";
    //   if (heures > 0) ecart += "\n$heures Heures";
    // }
    // return ecart;
    /* Logique pour retoutner le nombre de mois, jours et heures fin */
  }

  filterInfo(bool tout, [Decoupage decoupage]) {
    setState(() {
      if (!tout) {
        DateTime debut = DateTime.parse(decoupage.datedebutdecoupage);
        DateTime fin = DateTime.parse(decoupage.datefindecoupage);
        absenceDatas = widget.information.infos.absence.datas
            .where((element) =>
                (DateTime.parse(element.dateabsencefin).isAfter(debut) &&
                    DateTime.parse(element.dateabsencefin).isBefore(fin)))
            .toList();

        retardDatas = widget.information.infos.retard.datas
            .where((element) =>
                (DateTime.parse(element.dateabsencefin).isAfter(debut) &&
                    DateTime.parse(element.dateabsencefin).isBefore(fin)))
            .toList();
        punitionDatas = widget.information.infos.punition.datas
            .where((element) =>
                (DateTime.parse(element.datefinpunition).isAfter(debut) &&
                    DateTime.parse(element.datefinpunition).isBefore(fin)))
            .toList();
      } else {
        periodeController.text = "";
        absenceDatas = (widget.information.infos.absence.datas);
        retardDatas = (widget.information.infos.retard.datas);
        punitionDatas = (widget.information.infos.punition.datas);
        allChk = true;
      }
    });
  }

  /* End */
}
