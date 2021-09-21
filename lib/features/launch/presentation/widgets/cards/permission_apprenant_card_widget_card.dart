import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';

class PermissionApprenantCardWidget extends StatelessWidget {
  final PermissionApprenantModel permission;
  final Widget trailing;
  final Function onTap;
  final bool isApprenant;

  PermissionApprenantCardWidget({
    Key key,
    @required this.permission,
    this.trailing,
    @required this.onTap,
    this.isApprenant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: renderPermColor(permission),
      child: ListTile(
        dense: true, visualDensity: VisualDensity.compact,
        leading:
            Icon(Icons.personal_injury, size: 50.0, color: Colors.grey[700]),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom deponsant
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 2.5)),
              child: Text(
                permission.nom + " " + permission.prenoms,
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
                  FunctionUtils.convertFormatDate(
                      permission.datedemandepermission),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),

        /* Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 2)),
              child: Text(
                permission.nom + " " + permission.prenoms,
                style: TextStyle(color: PafpeGreen, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: (MediaQuery.of(context).size.width / 4)),
                  child: Text(
                    permission.motifpermission,
                    style: TextStyle(color: GreenLight),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: (MediaQuery.of(context).size.width / 2.5)),
                  child: Text(
                    FunctionUtils.convertFormatDate(
                        permission.datedemandepermission),
                    // style: TextStyle(color: GreenLight),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ), */
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // Motif
            Text(
              permission.motifpermission,
              style: TextStyle(color: GreenLight),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
                'Du : ${FunctionUtils.convertFormatDate(permission.datedebutpermission)} à ${permission.heuredebutpermission}',
                style: TextStyle(fontSize: 13)),
            Text(
                'Au : ${FunctionUtils.convertFormatDate(permission.datefinpermission)} à ${permission.heurefinpermission}',
                style: TextStyle(fontSize: 13)),
          ],
        ),

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     SizedBox(height: 5),
        //     Text(
        //         'Du : ${FunctionUtils.convertFormatDate(permission.datedebutpermission)} à ${permission.heuredebutpermission}'),
        //     Text(
        //         'Au : ${FunctionUtils.convertFormatDate(permission.datefinpermission)} à ${permission.heurefinpermission}'),
        //   ],
        // ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  renderPermColor(PermissionApprenantModel perm) {
    int etat = int.tryParse(perm.status);
    int isdemande = int.tryParse(perm.isdemande);
    Color result;
    if (isApprenant == null || isApprenant == true) {
      result = etat == 0
          ? Colors.grey[200]
          : etat == 1
              ? Colors.green[200]
              : etat == 2
                  ? Colors.red[200]
                  : Colors.grey[200];
    } else {
      result = etat == 0
          ? Colors.grey[200]
          : etat == 1
              ? isdemande == 0
                  ? Colors.green[200]
                  : Colors.green[300]
              : etat == 2
                  ? Colors.red[200]
                  : Colors.grey[200];
    }
    return result;
  }

  /* End */
}

/*  */