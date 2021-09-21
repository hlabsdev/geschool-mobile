import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/respmodels/conduite_list_reponse_model.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class DetailConduite extends StatefulWidget {
  PunitionDataModel punition;

  DetailConduite({
    this.punition,
  });

  @override
  _DetailConduiteState createState() => _DetailConduiteState();
}

class _DetailConduiteState extends State<DetailConduite> {
  List<String> types = ["Retard", "Absent"];
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.punition.motifpunition.length > 150) {
      firstHalf = widget.punition.motifpunition.substring(0, 150);
      secondHalf = widget.punition.motifpunition
          .substring(150, widget.punition.motifpunition.length);
    } else {
      firstHalf = widget.punition.motifpunition;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('punition_detail')),
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
                  // Date debut
                  ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.lime[600],
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.only(right: 10, left: 5),
                    title: Text(
                      allTranslations.text('start'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: PafpeGreen,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        FunctionUtils.convertFormatDateTime(
                                widget.punition.datepunition) ??
                            allTranslations.text('not_defined'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                  ),
                  // Date Fin
                  ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.lime[600],
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.only(right: 10, left: 5),
                    title: Text(
                      allTranslations.text('end'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: PafpeGreen,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        FunctionUtils.convertFormatDateTime(
                                widget.punition.datefinpunition) ??
                            allTranslations.text('not_defined'),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                  ),
                  // Motif
                  widget.punition.motifpunition.isEmptyOrNull
                      ? SizedBox(height: 0, width: 0)
                      : ListTile(
                          leading: Icon(
                            Icons.format_align_justify,
                            color: Colors.lime[600],
                            size: 30,
                          ),
                          contentPadding: EdgeInsets.only(right: 10, left: 5),
                          title: Text(
                            allTranslations.text('motif'),
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
                              widget.punition.motifpunition ??
                                  allTranslations.text('not_defined'),
                              "Motif"),
                          isThreeLine: true,
                        ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ));
  }
}
