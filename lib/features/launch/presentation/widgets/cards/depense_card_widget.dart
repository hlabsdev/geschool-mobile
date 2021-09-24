import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/depense_model.dart';
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
        // tileColor: Colors.grey[300],
        leading:
            Icon(Icons.personal_injury, size: 50.0, color: Colors.grey[700]),
        // title: Text(elmt.typeEvaluation),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom deponsant
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 2.5)),
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
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // Motif
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 2)),
              child: Text(
                depense.motifdemande,
                style: TextStyle(color: GreenLight),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Montant
            Text('Montant : ${depense.montantdepense}',
                style: TextStyle(
                    // color: Colors.blueAccent,
                    // fontWeight: FontWeight.bold,
                    )),
          ],
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  // renderDepenseColor(int etat) {
  renderDepenseColor(DepenseModel depense) {
    Color result;
    int etat = int.tryParse(depense.status);
    if ((depense.datedepense.isEmptyOrNull) && (depense.status == "1")) {
      result = Colors.white;
    } else {
      result = etat == 0
          ? Colors.grey[400]
          : etat == 1
              ? Colors.green[200]
              : etat == 2
                  ? Colors.red[200]
                  : Colors.grey[200];
    }

    return result;
  }

  /* End */
}

/*  */