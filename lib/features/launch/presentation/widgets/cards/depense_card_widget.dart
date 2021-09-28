import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/depense_model.dart';
import 'package:geschool/features/launch/presentation/pages/depense/all_depenses.dart';
import 'package:velocity_x/velocity_x.dart';

class DepenseCardWidget extends StatelessWidget {
  final DepenseModel depense;
  final Widget trailing;
  final Function onTap;

  DepenseCardWidget(
      {Key key, @required this.depense, this.trailing, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: renderDepenseColor(int.tryParse(depense.status)),
      color: renderDepenseColor(depense),
      child: ListTile(
        leading:
            Icon(Icons.personal_injury, size: 50.0, color: Colors.grey[700]),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nom deponsant
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 3)),
              child: Text(
                depense.nom + " " + depense.prenoms,
                style: TextStyle(color: PafpeGreen, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            // Date
            Align(
              alignment: Alignment.bottomLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: (MediaQuery.of(context).size.width / 2.5)),
                child: Text(
                  FunctionUtils.convertFormatDate(depense.datedemande),
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Montant
            Row(
              children: [
                Text('Montant: ',
                    style: TextStyle(
                        // color: Colors.blueAccent,
                        // fontWeight: FontWeight.bold,
                        )),
                Text(
                    '${FunctionUtils.formatMontant(int.tryParse(depense.montantdepense))}',
                    style: TextStyle(
                      // color: Colors.blue[200],
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            isTreated(depense)
                ? Container(
                    height: 18,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: depense.status == "2"
                          ? Colors.red[300]
                          : Colors.green[300],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (depense.status == "2" ? "Refusée" : "Décaissée")
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                : SizedBox(height: 0, width: 0),
          ],
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  /// Cette fonction prend une ```DepenseModel``` en parametre et
  /// renvoie ```true``` si  ```status==2``` ou s'il a ete decaisse, et ```false``` dans le cas contraire
  static bool isTreated(DepenseModel depense) {
    return (depense.status == "2" ||
        (!(depense.datedepense.isEmptyOrNull) && (depense.status == "1")));
  }

  renderDepenseColor(DepenseModel depense) {
    Color result;
    int etat = int.tryParse(depense.status);
    result = isTreated(depense)
        ? Colors.grey[300]
        : etat == 0
            ? Colors.white
            : Colors.green[200];
    return result;
  }

  /* End */
}

/*  */