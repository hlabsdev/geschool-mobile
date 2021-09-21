import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/absence_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';
import 'package:geschool/features/launch/presentation/pages/absences/apprenant/detail_absence_apprenant.dart';
import 'package:velocity_x/velocity_x.dart';

class EleveAbsenceWidget extends StatefulWidget {
  const EleveAbsenceWidget({
    Key key,
    @required this.information,
    @required this.typeAbs,
  }) : super(key: key);

  final List<AbsenceApprenantModel> information;
  final List<TypesAbsencesApprenant> typeAbs;

  @override
  _EleveAbsenceWidgetState createState() => _EleveAbsenceWidgetState();
}

class _EleveAbsenceWidgetState extends State<EleveAbsenceWidget> {
  List<AbsenceApprenantModel> absence = [];
  List<AbsenceApprenantModel> retard = [];
  int selected = -1;

  @override
  Widget build(BuildContext context) {
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
          itemCount: widget.typeAbs.length,
          itemBuilder: (context, index) {
            List<AbsenceApprenantModel> curentabs = widget.information
                .where((abs) =>
                    abs.typeabsence == widget.typeAbs[index].key.toString())
                .toList();
            return ExpansionTile(
              collapsedBackgroundColor: widget.typeAbs[index].value == "Retard"
                  ? Colors.grey[400]
                  : Colors.grey[700],
              backgroundColor: widget.typeAbs[index].value == "Retard"
                  ? Colors.grey[400]
                  : Colors.grey[700],
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
                  color: widget.typeAbs[index].value == "Retard"
                      ? Colors.grey[400]
                      : Colors.grey[700],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.typeAbs[index].value.toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  curentabs.length,
                  (i) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        // color: absenceCardColor(curentabs[i]),
                        color: curentabs[i].justification.isEmptyOrNull
                            ? Colors.red[100]
                            : Colors.green[100],
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
                                curentabs[i].justification.isEmptyOrNull
                                    ? "Non Justifié"
                                    : "Justifié",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                FunctionUtils.convertFormatDate(
                                    curentabs[i].dateabsencedebut),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: GreenLight),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          subtitle: Column(
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
                                              curentabs[i].dateabsencedebut),
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
                                              curentabs[i].dateabsencefin),
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
                                    DetailAbsenceApprenant(
                                        absence: curentabs[i],
                                        typeAbs: widget.typeAbs),
                              ),
                            );
                          },
                        ),
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

  renderTypeAbs(int key) {
    String result = widget.typeAbs
        .firstWhere(
          (elmt) => elmt.key == key,
          orElse: () => null,
        )
        .value;
    return result ?? allTranslations.text('not_defined');
  }

  // void separate(List<AbsenceApprenantModel> allList) {
  //   setState(() {
  //     absence.clear();
  //     retard.clear();
  //     absence =
  //         allList.where((element) => element.autoriseAbsence == 1).toList();

  //     retar = allList.where((element) => element.autoriseAbsence == 2).toList();
  //   });
  // }

  absenceCardColor(AbsenceApprenantModel abs) {
    if (renderTypeAbs(int.parse(abs.typeabsence)).toLowerCase() == 'absence')
      return Colors.red[100];
    else if (renderTypeAbs(int.parse(abs.typeabsence)).toLowerCase() ==
        'permission') {
      return Colors.green[100];
    } else if (renderTypeAbs(int.parse(abs.typeabsence)).toLowerCase() ==
        'retard') {
      return Colors.grey[300];
    }
  }
}
