import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/respmodels/conduite_list_reponse_model.dart';
import 'package:geschool/features/launch/presentation/pages/conduites/detail_conduite.dart';

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
    if (widget.information != null && widget.information.infos != null) {
      absences = widget.information.infos.absence ?? null;
      absenceDatas = widget.information.infos.absence.datas ?? null;
      retardDatas = widget.information.infos.retard.datas ?? null;
      punitionDatas = widget.information.infos.punition.datas ?? null;
      retards = widget.information.infos.retard ?? null;
      punitions = widget.information.infos.punition ?? null;
      decoupages = widget.information.decoupage ?? null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.information == null || widget.information.infos == null) {
      return Center(child: Text("Pas de donnees"));
    } else {
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
          // Absence
          ListTile(
            // tileColor: Colors.grey[300],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ABSENCES",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // Text("${absences.valeur ?? 0} ${absences.unite.toUpperCase()}",
                Text("${ecartHeure()} ${absences.unite.toUpperCase()}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[200])),
              ],
            ),
          ),
          Divider(),
          // Retards
          ListTile(
            // tileColor: Colors.grey[300],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("RETARDS",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                    "${retardDatas.length ?? 0} ${retards.unite.toUpperCase()}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[200])),
              ],
            ),
          ),
          Divider(),
          // Punition
          ExpansionTile(
            initiallyExpanded: true,
            backgroundColor: Colors.grey[300],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("PUNITIONS",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(thickness: 5);
                },
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[200],
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: Icon(
                          Icons.push_pin_outlined,
                          // size: 30,
                        ),
                        title: Text(
                          "Date:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          FunctionUtils.convertFormatDateTime(
                                  punitionDatas[i].datepunition) ??
                              "Non defini...",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // trailing: Icon(Icons.remove_red_eye),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailConduite(
                                punition: punitionDatas[i],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30)
            ],
          ),
        ],
      );
    }
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
