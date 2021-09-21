import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';

// ignore: must_be_immutable
class DetailAbsence extends StatefulWidget {
  AbsenceModel absence;
  List<TypesAbsencesPersonnel> typeAbs;

  DetailAbsence({
    this.absence,
    this.typeAbs,
  });

  @override
  _DetailAbsenceState createState() => _DetailAbsenceState();
}

class _DetailAbsenceState extends State<DetailAbsence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('absence_detail')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
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
            color: Colors.grey[100],
            child: Column(
              children: [
                Center(
                  heightFactor: 2,
                  child: Text(
                    widget.absence.autoriseAbsence == 2
                        ? "Absence non autorisée"
                        : "Absence autorisée",
                    style: TextStyle(
                        fontSize: 18,
                        color: widget.absence.autoriseAbsence == 2
                            ? Colors.red[300]
                            : GreenLight,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person, size: 30),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    allTranslations.text('name'),
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
                      widget.absence.nameUser ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                !(widget.absence.datedemandeabsence == null ||
                        widget.absence.datedemandeabsence == "")
                    ? ListTile(
                        leading: Icon(Icons.date_range, size: 30),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          allTranslations.text('ask_date'),
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
                            FunctionUtils.convertFormatDate(
                                widget.absence.datedemandeabsence),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),

                // Dates
                ListTile(
                  // Dates
                  visualDensity: VisualDensity.comfortable,
                  leading: Icon(Icons.date_range_rounded, size: 30),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Dates",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: GreenLight,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  isThreeLine: true,
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allTranslations.text('start') + ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            Text(
                              "${FunctionUtils.convertFormatDate(widget.absence.datedebutabsence)} \tà\t ${widget.absence.heuredebutabsence.substring(0, 5).toUpperCase()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allTranslations.text('end') + ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            Text(
                              "${FunctionUtils.convertFormatDate(widget.absence.datefinabsence)} \tà\t ${widget.absence.heurefinabsence.substring(0, 5).toUpperCase()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blueGrey[800]),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.absence.heurearattraper != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    allTranslations.text('hour_to_spend'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                  Text(
                                    "${widget.absence.heurearattraper ?? "..."} Heures"
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.blueGrey[800]),
                                  ),
                                ],
                              )
                            : SizedBox(height: 0),
                      ],
                    ),
                  ),
                ),
                // Lieu Detisnation
                !(widget.absence.lieudestinantionabsence == null ||
                        widget.absence.lieudestinantionabsence == "")
                    ? ListTile(
                        leading: Icon(Icons.local_convenience_store_rounded,
                            size: 30),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          allTranslations.text('destination_absence'),
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
                            widget.absence.lieudestinantionabsence ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                // coordonnees
                !(widget.absence.coordonneesabsence == null ||
                        widget.absence.coordonneesabsence == "")
                    ? ListTile(
                        leading: Icon(Icons.call, size: 30),
                        contentPadding: EdgeInsets.only(right: 10, left: 5),
                        title: Text(
                          allTranslations.text('contact_absence'),
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
                            widget.absence.coordonneesabsence ??
                                allTranslations.text('not_defined'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                // Type abence
                ListTile(
                  leading: Icon(Icons.category_rounded, size: 30),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Type",
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
                      FunctionUtils.renderTypeAbs(
                              widget.absence.keytypeabsence, widget.typeAbs) ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                // Motif
                ListTile(
                  leading: Icon(Icons.format_align_justify_rounded, size: 30),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    allTranslations.text('motif'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: GreenLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                  subtitle: ExpandableText(
                      widget.absence.motifabsence ??
                          allTranslations.text('not_defined'),
                      "Motif"),
                  isThreeLine: true,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  /* End */
}
