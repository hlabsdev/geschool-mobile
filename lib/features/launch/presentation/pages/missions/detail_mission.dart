import 'package:flutter/material.dart';
import 'package:geschool/features/common/data/models/basemodels/mission_model.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';

// ignore: must_be_immutable
class DetailMission extends StatefulWidget {
  MissionModel mission;
  bool isAdmin;
  UserModel me;

  DetailMission({this.mission, this.isAdmin, this.me});

  @override
  _DetailMissionState createState() => _DetailMissionState();
}

class _DetailMissionState extends State<DetailMission> {
  DetailsModel myself;

  @override
  void initState() {
    print("\nMission: ${widget.mission.toJson()}");
    print("\nDétail : ${widget.mission.details.toList().toString()}");
    print("\nMoi meme: ${widget.me.toJson()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void findMyself() {
      setState(() {
        String name = "${widget.me.nom} ${widget.me.prenoms}";
        myself = widget.mission.details.firstWhere(
          (element) =>
              element.namePersonnel.trim().toLowerCase() ==
              name.trim().toLowerCase(),
          orElse: () => null,
        );
      });
      // return myself != null ? true : false;
    }

    findMyself();
    // print("Myself: ${myself.toJson()}");

    return Scaffold(
      appBar: AppBar(
        title: Text("Détail de la mission"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          /* Card mission détail start */
          Card(
            color: Colors.grey[100],
            elevation: 1,
            child: Column(
              children: [
                SizedBox(height: 8),
                Text(
                  "Mission " +
                      FunctionUtils.getEtatMission(FunctionUtils.getDateEtat(
                              widget.mission.datedepart,
                              widget.mission.dateretourprob))
                          .toLowerCase(),
                  style: TextStyle(
                      fontSize: 14,
                      color: FunctionUtils.getDateEtat(
                                  widget.mission.datedepart,
                                  widget.mission.dateretourprob) ==
                              3
                          ? GreenLight
                          : FunctionUtils.getDateEtat(widget.mission.datedepart,
                                      widget.mission.dateretourprob) ==
                                  2
                              ? Colors.orange[200]
                              : Colors.black45,
                      fontStyle: FontStyle.italic),
                ),
                ListTile(
                  leading: Icon(
                    Icons.format_align_justify_rounded,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    allTranslations.text('motif'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: GreenLight,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: ExpandableText(
                      widget.mission.motif ??
                          allTranslations.text('not_defined'),
                      "Motif"),
                  isThreeLine: true,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_road,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    allTranslations.text('itineraire'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: GreenLight,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      widget.mission.itineraireretenu ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  visualDensity: VisualDensity.comfortable,
                  leading: Icon(
                    Icons.date_range_rounded,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allTranslations.text('depart') + ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            Text(
                              "${FunctionUtils.convertFormatDate(widget.mission.datedepart)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allTranslations.text('probable_arrival') + ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            Text(
                              "${FunctionUtils.convertFormatDate(widget.mission.dateretourprob)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.local_convenience_store_rounded,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    allTranslations.text('lieumission'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: GreenLight,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      widget.mission.lieumission ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          /* Card mission détail end */

          // Card about me start
          myself == null
              ? Text('')
              : Card(
                  color: Colors.grey[100],
                  elevation: 1,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.only(right: 10, left: 5),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          myself.namePersonnel ??
                              allTranslations.text('not_defined'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: GreenLight,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          // textAlign: TextAlign.justify,
                        ),
                        Text(
                          "Frais: \n" +
                              (myself.frais ??
                                  allTranslations.text('not_defined')) +
                              " F",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Revenu le:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                              Text(
                                "Personne à contacter:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  FunctionUtils.convertFormatDate(
                                      myself.dateretoureffmission),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blueGrey[800]),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  myself.contactabsence ??
                                      allTranslations.text('not_defined'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blueGrey[800]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isThreeLine: true,
                  ),
                ),
          // Card about me end

          SizedBox(height: 8.0),
          Center(
            child: Text(
              "Les Participants",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            elevation: 1,
            color: Colors.grey[100],
            child: DataTable(
                // horizontalMargin: 20,
                columnSpacing: 40,
                columns: [
                  DataColumn(
                    label: Text(
                      "Personnel",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  /*  DataColumn(
                      label: Text(
                        'Frais',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ), */
                  DataColumn(
                    label: Text(
                      "Revenu Le",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Personne \nà contacter",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                rows: generateRow()),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  generateRow() {
    List<DataRow> rows = [];
    for (var element in widget.mission.details) {
      if (myself != null) {
        if (element.namePersonnel != myself.namePersonnel) {
          rows.add(DataRow(
            cells: [
              // DataCell(Text(element.idcentre.toString())),
              DataCell(
                Text(
                  element.namePersonnel ?? allTranslations.text('not_defined'),
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  FunctionUtils.convertFormatDate(element.dateretoureffmission),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Text(
                  element.contactabsence.toUpperCase() ??
                      allTranslations.text('not_defined'),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ));
        }
      } else {
        rows.add(DataRow(
          cells: [
            // DataCell(Text(element.idcentre.toString())),
            DataCell(
              Text(
                element.namePersonnel ?? allTranslations.text('not_defined'),
                maxLines: 3,
                style: TextStyle(
                  fontSize: 13,
                ),
                // textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                // textAlign: TextAlign.justify,
              ),
            ),
            DataCell(
              Text(
                FunctionUtils.convertFormatDate(element.dateretoureffmission),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            DataCell(
              Text(
                element.contactabsence.toUpperCase() ??
                    allTranslations.text('not_defined'),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ));
      }
    }

    return rows;
  }

  /* End */
}
