import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/launch/presentation/pages/absences/personnel/detail_absence.dart';

class AbsencePersonnelCardWidget extends StatelessWidget {
  final AbsenceModel absence;
  final List<TypesAbsencesPersonnel> typeAbs;

  const AbsencePersonnelCardWidget({
    Key key,
    this.absence,
    this.typeAbs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: absenceCardColor(absence),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ListTile(
        leading: Icon(
          Icons.flag_rounded,
          color: Colors.grey[700],
          size: 50,
        ),
        title: SizedBox(
          width: (MediaQuery.of(context).size.width / 2),
          child: Text(
            FunctionUtils.renderTypeAbs(absence.keytypeabsence, typeAbs) ??
                allTranslations.text('not_defined').toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
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
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey[800]),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Fin:",
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey[800]),
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
                    FunctionUtils.convertFormatDate(absence.datedebutabsence),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blueGrey[800]),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    FunctionUtils.convertFormatDate(absence.datefinabsence),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  DetailAbsence(absence: absence, typeAbs: typeAbs),
            ),
          );
        },
      ),
    );
  }

  renderStatusAbsenceTris(AbsenceModel absence) {
    Text result = Text("");
    if (absence.autoriseAbsence == 2) {
      result = Text(
        "Non autorisée",
        style: TextStyle(color: Colors.red[600]),
      );
    } else if (absence.autoriseAbsence == 1) {
      result = Text(
        "Autorisée",
        style: TextStyle(color: Colors.green[600]),
      );
    }
    return result;
  }

  // renderTypeAbs(String key) {
  //   String result = typeAbs
  //       .firstWhere(
  //         (elmt) => elmt.key == key,
  //         orElse: () => null,
  //       )
  //       .value;
  //   return result ?? allTranslations.text('not_defined');
  // }

  absenceCardColor(AbsenceModel abs) {
    if (abs.autoriseAbsence == 2)
      return Colors.red[100];
    else if (abs.autoriseAbsence == 1) {
      return Colors.green[100];
    }
  }

/* End */
}
