import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class DetailAbsenceApprenant extends StatefulWidget {
  AbsenceApprenantModel absence;
  List<TypesAbsencesApprenant> typeAbs;

  DetailAbsenceApprenant({
    this.absence,
    this.typeAbs,
  });

  @override
  _DetailAbsenceApprenantState createState() => _DetailAbsenceApprenantState();
}

class _DetailAbsenceApprenantState extends State<DetailAbsenceApprenant> {
  List<String> types = ["Retard", "Absent"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('absence_detail')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Nom
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.lime[600],
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.only(right: 10, left: 5),
                    title: Text(
                      allTranslations.text('name'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: PafpeGreen,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      // textAlign: TextAlign.justify,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        widget.absence.nameUser ??
                            allTranslations.text('not_defined'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                  ),
                  // Type absence
                  ListTile(
                    leading: Icon(
                      Icons.sort,
                      color: Colors.lime[600],
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.only(right: 10, left: 5),
                    title: Text(
                      allTranslations.text('type_absence'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: PafpeGreen,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      // textAlign: TextAlign.justify,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        renderTypeAbs(int.parse(widget.absence.typeabsence)),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                  ),
                  // Date (Avec heure debut et fin)
                  ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.lime[600],
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.only(right: 10, left: 5),
                    title: Text(
                      "Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: PafpeGreen,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      // textAlign: TextAlign.justify,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FunctionUtils.convertFormatDate(
                                    widget.absence.dateabsencedebut) ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(height: 5),
                          Column(
                            children: [
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      allTranslations.text('start') + ":",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey[800]),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "Fin:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey[800]),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "" +
                                          FunctionUtils.convertDateTimeToHour(
                                              widget.absence.dateabsencedebut),
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
                                          FunctionUtils.convertDateTimeToHour(
                                              widget.absence.dateabsencefin),
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
                        ],
                      ),
                    ),
                  ),
                  widget.absence.justification.isEmptyOrNull
                      ? SizedBox(height: 0, width: 0)
                      : ListTile(
                          leading: Icon(
                            Icons.format_align_justify,
                            color: Colors.lime[600],
                            size: 30,
                          ),
                          contentPadding: EdgeInsets.only(right: 10, left: 5),
                          title: Text(
                            allTranslations.text('justification'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: PafpeGreen,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.justify,
                          ),
                          subtitle: ExpandableText(
                              widget.absence.justification ??
                                  allTranslations.text('not_defined'),
                              "Justification"),
                          isThreeLine: true,
                        ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ));
  }

  renderTypeAbs(int key) {
    String result = widget.typeAbs
        .firstWhere(
          (elmt) => elmt.key == key,
          orElse: () => null,
        )
        .value;
    return result ?? allTranslations.text('not_defined');
  }
}
