import 'package:flutter/material.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/pages/permissions/personnel/detail_permission_apprenant.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/permission_apprenant_card_widget_card.dart';

// ignore: must_be_immutable
class ElevePermissionWidget extends StatefulWidget {
  ElevePermissionWidget({
    Key key,
    @required this.me,
    @required this.information,
  }) : super(key: key);

  UserModel me;
  List<PermissionApprenantModel> information;

  @override
  _ElevePermissionWidgetState createState() => _ElevePermissionWidgetState();
}

class _ElevePermissionWidgetState extends State<ElevePermissionWidget> {
  List<PermissionApprenantModel> attente = [];
  List<PermissionApprenantModel> acordee = [];
  List<PermissionApprenantModel> noacordee = [];

  int selected = -1;
  @override
  void initState() {
    separate(widget.information);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> etatPermission = [
      ["Permissions en attentes", attente, Colors.grey[300]],
      ["Permissions acordées", acordee, Colors.green[100]],
      ["Permissions refusées", noacordee, Colors.red[100]],
    ];

    return ListView(
      children: [
        SizedBox(height: 10),

        /* Expansions deb */
        SizedBox(height: 8),
        SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          primary: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: etatPermission.length,
          itemBuilder: (context, index) {
            List<dynamic> curentperm = etatPermission[index];
            return ExpansionTile(
              collapsedBackgroundColor: curentperm[2],
              backgroundColor: curentperm[2],
              initiallyExpanded: index == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = index;
                  });
                else
                  setState(() {
                    selected = -1;
                  });
              },
              title: Container(
                // margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 40,
                decoration: BoxDecoration(
                  color: curentperm[2],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  curentperm[0].toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  curentperm[1].length,
                  (i) => PermissionApprenantCardWidget(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailPermissionApprenant(
                                me: widget.me,
                                permission: curentperm[1][i],
                                isApprenant: true,
                              ),
                            ),
                          );
                        },
                        permission: curentperm[1][i],
                      ),
                  growable: true),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 8);
          },
        ),
        /* Expansions end */
        /* GroupedListView<AbsenceApprenantModel, String>(
          shrinkWrap: true,
          elements: information,
          groupBy: (element) => element.typeabsence,
          groupSeparatorBuilder: (value) => Container(
            height: 30,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 35.0),
            decoration: BoxDecoration(
              color: Grey,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              renderTypeAbs(int.parse(value)).toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          itemComparator: (item1, item2) =>
              (DateTime.parse(item1.dateabsencedebut).compareTo(
            DateTime.parse(item2.dateabsencefin),
          )),
          order: GroupedListOrder.DESC,
          itemBuilder: (context, element) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: absenceCardColor(element),
              child: ListTile(
                leading: Icon(
                  Icons.flag_rounded,
                  color: Colors.grey[700],
                  size: 50,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      element.justification ?? "Pas de justification...",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
                            style: TextStyle(
                                fontSize: 14, color: Colors.blueGrey[800]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Fin:",
                            style: TextStyle(
                                fontSize: 14, color: Colors.blueGrey[800]),
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
                            "" +
                                FunctionUtils.convertFormatDate(
                                    element.dateabsencedebut),
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
                                FunctionUtils.convertFormatDate(
                                    element.dateabsencefin),
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
                      builder: (BuildContext context) => DetailAbsenceApprenant(
                          absence: element, typeAbs: typeAbs),
                    ),
                  );
                },
              ),
            );
          },
        ), */
      ],
    );
  }

  void separate(List<PermissionApprenantModel> allList) {
    setState(() {
      attente.clear();
      acordee.clear();
      noacordee.clear();
      attente = allList.where((element) => element.status == "0").toList();

      acordee = allList.where((element) => element.status == "1").toList();
      noacordee = allList.where((element) => element.status == "2").toList();
    });
  }

  /* End */
}
