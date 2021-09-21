import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/respmodels/note_apprenant_list_response_model.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class EleveNoteWidget extends StatefulWidget {
  List<String> decoupages;
  List<String> evaluations;
  List<String> matieres;
  List<NoteApprenantModel> information;

  EleveNoteWidget({
    Key key,
    @required this.decoupages,
    @required this.evaluations,
    @required this.matieres,
    @required this.information,
  }) : super(key: key);

  @override
  _EleveNoteWidgetState createState() => _EleveNoteWidgetState();
}

class _EleveNoteWidgetState extends State<EleveNoteWidget> {
  TextEditingController periodeController = TextEditingController();
  TextEditingController evaluationController = TextEditingController();
  TextEditingController matiereController = TextEditingController();
  List<NoteApprenantModel> filteredInfo = [];
  List<String> decoupagesFilter = [];
  bool allChk = false;
  int sortIndex = 0;
  bool asc = true;
  @override
  void initState() {
    filterInfo(true);

    // widget.information.sort((note1, note2) => note1.dateEvaluation.compareTo(note2.dateEvaluation));
    /* print("\n ======== Start ======== \n");
    for (var item in widget.information) {
      print("\n");
      print(item.toJson());
      print("\n");
    }
    print("\n ======== End ======== \n"); */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /* Filtert container deb */
        Container(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
          height: MediaQuery.of(context).size.width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 3.3),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      items: widget.decoupages
                          .map((perso) => DropdownMenuItem(
                                child: Text(perso),
                                value: perso,
                                onTap: () => print(perso),
                              ))
                          .toList(),
                      hint: periodeController.text == ""
                          ? Text("Période")
                          : Text(
                              periodeController.text,
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 3,
                              softWrap: true,
                            ),
                      onChanged: (value) {
                        periodeController.text = value;
                        filterInfo(false, periodeController.text,
                            evaluationController.text, matiereController.text);
                      },
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 3.3),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      items: widget.matieres
                          .map((perso) => DropdownMenuItem(
                                child: Text(perso),
                                value: perso,
                                onTap: () => print(perso),
                              ))
                          .toList(),
                      hint: matiereController.text == ""
                          ? Text("Matière")
                          : Text(matiereController.text),
                      onChanged: (value) {
                        setState(() {
                          matiereController.text = value;
                        });
                        filterInfo(false, periodeController.text,
                            evaluationController.text, matiereController.text);
                      },
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 3.3),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      items: widget.evaluations
                          .map((perso) => DropdownMenuItem(
                                child: Text(perso),
                                value: perso,
                                onTap: () => print(perso),
                              ))
                          .toList(),
                      hint: evaluationController.text == ""
                          ? Text("Evaluation")
                          : Text(evaluationController.text),
                      onChanged: (value) {
                        setState(() {
                          evaluationController.text = value;
                        });
                        filterInfo(false, periodeController.text,
                            evaluationController.text, matiereController.text);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              SizedBox(
                width: (MediaQuery.of(context).size.width) - 30,
                child: Container(
                  color: Colors.grey[100],
                  child: CheckboxListTile(
                    tristate: false,
                    dense: true,
                    secondary: const Text('Tout'),
                    value: allChk,
                    onChanged: (valueNew) {
                      setState(() {
                        allChk = valueNew;
                      });
                      listAll();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        /* Filtert container end */
        SizedBox(height: 5),
        Column(
            // children: [
            children: List.generate(
          // widget.decoupages.length,
          decoupagesFilter.length,
          (i) => Card(
            // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.grey[100],
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                    periodeController.text.length > 0
                        ? widget.decoupages[
                            widget.decoupages.indexOf(periodeController.text)]
                        : decoupagesFilter[i],
                    /*  widget.decoupages[
                        widget.decoupages.indexOf(periodeController.text) ?? i], */
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                DataTable(
                  columnSpacing: 45,
                  sortColumnIndex: sortIndex,
                  sortAscending: asc,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Matiere',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onSort: (i, value) {
                        setState(() {
                          sortIndex = i;
                          asc = value;
                        });
                        sortMatiere(value);
                      },
                    ),
                    DataColumn(
                      label: Text(
                        'Evaluation',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onSort: (i, value) {
                        setState(() {
                          sortIndex = i;
                          asc = value;
                        });
                        sortEval(value);
                      },
                    ),
                    DataColumn(
                      label: Text(
                        'Note',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onSort: (i, value) {
                        setState(() {
                          sortIndex = i;
                          asc = value;
                        });
                        sortNote(value);
                      },
                      numeric: true,
                    ),
                  ],
                  rows: generateRow(periodeController.text.length > 0
                      ? widget.decoupages[
                          widget.decoupages.indexOf(periodeController.text)]
                      : decoupagesFilter[i]),
                  /* rows: generateRow(widget.decoupages[
                      widget.decoupages.indexOf(periodeController.text) ?? i]), */
                ),
              ],
            ),
          ),
        )

            // ],
            ),
        SizedBox(height: 10),
      ],
    );
  }

  void filterInfo(bool tout, [String decoupage, String eval, String matiere]) {
    // print("Filtering by: " + critere);
    setState(() {
      if (!tout) {
        // Filtrage deb
        // Filtrage de la liste des decoupages
        if (!decoupage.isEmptyOrNull) {
          decoupagesFilter.clear();
          decoupagesFilter =
              widget.decoupages.where((decp) => decp == decoupage).toList();
        }

        filteredInfo = widget.information
            .where(
              (note) => ((decoupage.isEmptyOrNull
                      ? note.keynote.isNotEmpty
                      : note.decoupage == decoupage) &&
                  (eval.isEmptyOrNull
                      ? note.keynote.isNotEmpty
                      : note.evaluation == eval) &&
                  (matiere.isEmptyOrNull
                      ? note.keynote.isNotEmpty
                      : note.matiere == matiere)),
            )
            .toList();
        sort();
        // Filtrage end

        allChk = false;
      } else {
        decoupagesFilter.clear();
        decoupagesFilter.addAll(widget.decoupages);
        matiereController.text = "";
        evaluationController.text = "";
        periodeController.text = "";
        if (filteredInfo.length > 0) filteredInfo.clear();
        filteredInfo.addAll(widget.information);
        // Filtrage deb
        sort();
        // Filtrage end
        allChk = true;
      }
    });
  }

  /// Pour ranger selon la matiere, ensuite selon les date d'evaluation
  void sort() {
    setState(() {
      filteredInfo.sort((a, b) => a.dateEvaluation.compareTo(b.dateEvaluation));
      filteredInfo.sort((a, b) => b.evaluation.compareTo(a.evaluation));
      filteredInfo.sort((a, b) => a.matiere.compareTo(b.matiere));
    });
  }

  ///Ranger selon la date d'evaluation'
  void sortDateEval(

      ///ordre de rangement: true pour croissant et false pour decroissant
      bool asc) {
    setState(() {
      asc
          ? filteredInfo
              .sort((a, b) => a.dateEvaluation.compareTo(b.dateEvaluation))
          : filteredInfo
              .sort((a, b) => b.dateEvaluation.compareTo(a.dateEvaluation));
    });
  }

  ///Ranger selon le nom de l'evaluation'
  void sortEval(

      ///ordre de rangement: true pour croissant et false pour decroissant
      bool asc) {
    setState(() {
      asc
          ? filteredInfo.sort((a, b) => a.evaluation.compareTo(b.evaluation))
          : filteredInfo.sort((a, b) => b.evaluation.compareTo(a.evaluation));
    });
  }

  ///Ranger selon la matiere'
  void sortMatiere(

      ///ordre de rangement: true pour croissant et false pour decroissant
      bool asc) {
    setState(() {
      asc
          ? filteredInfo.sort((a, b) => a.matiere.compareTo(b.matiere))
          : filteredInfo.sort((a, b) => b.matiere.compareTo(a.matiere));
    });
  }

  ///Ranger selon la note'
  void sortNote(

      ///ordre de rangement: true pour croissant et false pour decroissant
      bool asc) {
    setState(() {
      asc
          ? filteredInfo.sort((a, b) =>
              double.tryParse(a.note).compareTo(double.tryParse(b.note)))
          : filteredInfo.sort((a, b) =>
              double.tryParse(b.note).compareTo(double.tryParse(a.note)));
    });
  }

  void listAll() {
    // allChk = !allChk;
    setState(() {
      matiereController.text = "";
      evaluationController.text = "";
      periodeController.text = "";
    });
    if (allChk) filterInfo(true);
  }

  generateRow([String decoupage]) {
    List<DataRow> rows = [];
    for (var note in filteredInfo) {
      if (note.decoupage == decoupage) {
        rows.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  note.matiere ?? allTranslations.text('not_defined'),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      note.evaluation ?? allTranslations.text('not_defined'),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      FunctionUtils.convertFormatDate(note.dateEvaluation),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[400],
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  note.note ?? allTranslations.text('not_defined'),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return rows;
  }
}
