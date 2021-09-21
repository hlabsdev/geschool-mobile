import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/pages/taches/detail_tache.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/models/basemodels/tache_model.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:velocity_x/velocity_x.dart';

class TacheCardWidget extends StatelessWidget {
  const TacheCardWidget({
    Key key,
    @required this.tache,
    @required this.isAdmin,
    @required this.isAll,
  }) : super(key: key);

  final TacheModel tache;
  final bool isAdmin;
  final bool isAll;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: renderTacheColor(tache),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        // tileColor: renderTacheColor(tache),
        leading: Icon(
          Icons.assignment_rounded,
          color: Colors.grey[700],
          size: 50,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width / 2),
                  child: Text(
                    "" + tache.descriptionTache,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: GreenLight,
                    ),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.justify,
                  ),
                ),
                Text(
                  tache.nameUser,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Black,
                  ),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  // textAlign: TextAlign.justify,
                ),
              ],
            ),
            tache.dateRappelTache.isEmptyOrNull
                ? Center(child: Text(""))
                : Icon(
                    Icons.add_alert_rounded,
                    color: Colors.red[300],
                  ),
          ],
        ),
        subtitle: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Heure:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(FunctionUtils.convertFormatDate(tache.dateTache)),
                Text(FunctionUtils.convertDateTimeToHour(tache.dateTache)),
                Text(
                  FunctionUtils.convertDateTimeToHour(tache.dateRappelTache),
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    // fontSize: 20,
                    color: tache.dateRappelTache.isEmptyOrNull
                        ? Colors.white
                        : Colors.red[300],
                  ),
                ),
              ],
            ),
          ],
        ),
        // trailing: ,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DetailTache(
                tache: tache,
                isAdmin: isAdmin,
                me: UserModel.fromJson(json.decode(UserPreferences().user)),
                pIdentifiant: tache.keyPersonnel,
              ),
            ),
          );
        },
        trailing: isAll ? Icon(Icons.arrow_back_ios_rounded) : null,
      ),
    );
  }

  static renderTacheColor(TacheModel tache) {
    Color result =
        tache.rapportTache.isEmptyOrNull ? Colors.grey[100] : Colors.grey[400];
    return result;
  }

  /* End */
}
