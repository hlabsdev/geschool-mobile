import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/expandable_text.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class DetailBudget extends StatefulWidget {
  PermissionApprenantModel budget;
  UserModel me;
  List<ApprenantModel> apprenants;
  List<CentreModel> centres;

  DetailBudget({
    Key key,
    this.budget,
    this.me,
    this.apprenants,
    this.centres,
  }) : super(key: key);

  @override
  _DetailBudgetState createState() => _DetailBudgetState();
}

class _DetailBudgetState extends State<DetailBudget> {
  ValidatePermDto validateDto = ValidatePermDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();

  TextEditingController _centreController = TextEditingController();
  TextEditingController _apprenantController = TextEditingController();
  TextEditingController _motifController = TextEditingController();
  TextEditingController _datedemandeController = TextEditingController();
  TextEditingController _datedebutController = TextEditingController();
  TextEditingController _heuredebutController = TextEditingController();
  TextEditingController _datefinController = TextEditingController();
  TextEditingController _heurefinController = TextEditingController();

  var apprenantsFilter;

  @override
  void initState() {
    validateDto.idCenter = widget.budget.idCenter;
    validateDto.uIdentifiant = widget.me.authKey;
    validateDto.permissionKey = widget.budget.keypermission;
    validateDto.registrationId = "";
    // Perm
    addPermDto.uIdentifiant = widget.me.authKey;
    addPermDto.registrationId = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('detail_budget')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),

          /* Details deb */
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Nom du deposant",
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
                      (widget.budget.nom + " " + widget.budget.prenoms) ??
                          allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.format_align_justify,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.only(right: 10, left: 5),
                  title: Text(
                    "Description",
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
                      widget.budget.motifpermission ??
                          allTranslations.text('not_defined'),
                      "Description"),
                  isThreeLine: true,
                ),
              ],
            ),
          ),
          /* Details end */

          /* Tableau deb */
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: DataTable(
              horizontalMargin: 5,
              sortAscending: true,
              sortColumnIndex: 1,
              columns: [
                DataColumn(
                    label: Text("Date de \nl'operation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Nature \ndes fonds",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Montant",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        FunctionUtils.convertFormatDate(
                            widget.budget.datedemandepermission),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        widget.budget.heuredebutpermission,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        widget.budget.datedebutpermission,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              // rows: generateRow(widget.noms[i]),
            ),
          ),
          /* Tableau end */
          SizedBox(height: 20),
        ],
      ),
    );
  }

/* End */
}