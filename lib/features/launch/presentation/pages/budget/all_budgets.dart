// ignore_for_file: non_constant_identifier_names, unused_field

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_budget_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/detail_budget_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/budget_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/widgets/data_chart.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/budget_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/filter_pane_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// ignore: must_be_immutable
class AllBudgets extends StatefulWidget {
  UserModel me;
  AllBudgets({this.me});

  @override
  _AllBudgetsState createState() => _AllBudgetsState();
}

class _AllBudgetsState extends State<AllBudgets> {
  TextEditingController centreController = TextEditingController();
  /* For form deb */
  TextEditingController _centreController = TextEditingController();
  TextEditingController _donateurController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateoperationController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _natureController = TextEditingController();
  TextEditingController _modePaiementController = TextEditingController();
  /* For form end */
  bool allChk = false;

  bool isLoading;
  bool error = false;
  bool isAdmin = false;

  /* Imported prepared for parsing deb */

  List<DetailBudgetModel> information = [];
  List<AllDatas> informationPerCentre = [];
  List<DetailBudgetModel> budgetFilter = [];

  /// Dans l'API c'est budget_recu
  int total_detail_budgetaires_initial = 0;
  int total_detail_budgetaires = 0;

  /// Dans l'API c'est budget_prevision
  int total_entres_initial = 0;
  int total_entres = 0;
  List<CentreModel> centres = [];
  List<NatureDons> natures = [];
  List<ModePaiement> modes = [];

  SlidableController slidableController;
  Icon _arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  Animation<double> rotationAnimation;
  GetInfoDto infoDto = GetInfoDto();
  ValidatePermDto validateDto = ValidatePermDto();
  AddBudgetDto budgetDto = AddBudgetDto();
  final formKey = GlobalKey<FormState>();

  int selected = -1;
  bool expandFlag = false;

  /* Imported prepared for parsing end */

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    budgetDto.uIdentifiant = widget.me.authKey;
    budgetDto.registrationId = "";
    total_detail_budgetaires_initial = 0;
    total_detail_budgetaires = 0;
    total_entres_initial = 0;
    total_entres = 0;
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('saisie_budget')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getInfos();
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 26.0,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddForm(null);
        },
        child: Icon(Icons.add_rounded),
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: information,
        noDataText: Text(allTranslations.text('no_budget')),
        child: ListView(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          children: <Widget>[
            /* Filtre par centre et personnel deb */
            SingleFilterPaneWidget(
              hint: centreController.text == ""
                  ? Text("Centre")
                  : Text(FunctionUtils.getCenterNameByKey(
                      centreController.text, centres)),
              isSearchable: false,
              items: centres
                  .map((centre) => DropdownMenuItem(
                        child: Text(centre.denominationCenter),
                        value: centre.keyCenter,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  centreController.text = value;
                });
                filterInfo(
                  false,
                  centreController.text,
                );
              },
              onChecked: (valueNew) {
                setState(() {
                  allChk = valueNew;
                  centreController.clear();
                });
              },
              listAll: () => listAll(),
            ),
            SizedBox(height: 5),
            /* Filtre par centre et personnel end */
            /* ====== Exnasion de liste de saisie budgetaire  deb*/
            ExpansionTile(
              collapsedBackgroundColor: Colors.grey[300],
              backgroundColor: Colors.grey[300],
              initiallyExpanded: false,
              title: Container(
                // margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Detail budgetaires",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(budgetFilter.length,
                  (i) => BudgetCardWidget(budget: budgetFilter[i]),
                  growable: false),
            ),
            /* ====== Exnasion de liste de saisie budgetaire  end*/
            /* ===== Graphe deb */
            SizedBox(height: 10, width: 0),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Text(
                  'Graphe comparant les entrés et le \ntotal des détails budgetaires',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 50,
                maxHeight: MediaQuery.of(context).size.height / 2 - 30,
              ),
              // child: SimpleBarChart.withSampleData(),
              child: buildGraph(),
            ),
            /* ===== Graphe end */
            SizedBox(height: 20, width: 0),
          ],
        ),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  getInfos() {
    Api api = ApiRepository();
    FunctionUtils.getData(
      context: context,
      dto: infoDto,
      startFunction: () => loading(true),
      stopFunction: () => loading(false),
      repositoryFunction: api.getBudgets,
      onFailure: (value) {
        setState(() {
          error = value;
        });
      },
      onSuccess: (value) {
        setState(() {
          centres.clear();
          natures.clear();
          modes.clear();
          informationPerCentre.clear();
          information.clear();
          informationPerCentre = value.information.allDatas;
          centres = value.information.centers;
          natures = value.information.natureDons;
          modes = value.information.modePaiement;
          total_detail_budgetaires_initial = 0;
          total_entres_initial = 0;
          for (var item in informationPerCentre) {
            information.addAll(item.datas);
            if (item.budgetRecu != null)
              total_detail_budgetaires_initial += item.budgetRecu;
            if (item.budgetPrevision != null)
              total_entres_initial += item.budgetPrevision;
          }
          information.sort((a, b) => DateTime.tryParse(b.dateOperation)
              .compareTo(DateTime.tryParse(a.dateOperation)));
          total_detail_budgetaires = total_detail_budgetaires_initial;
          total_entres = total_entres_initial;
          if (budgetFilter.length > 0) budgetFilter.clear();
          budgetFilter.addAll(information);
          allChk = true;

          budgetFilter.sort((a, b) => DateTime.tryParse(b.dateOperation)
              .compareTo(DateTime.tryParse(a.dateOperation)));
        });
      },
    );
  }

  /// envoie des donnees de validation au serveur
  validate(bool accorded) async {
    setState(() {
      validateDto.operation = accorded ? "1" : "2";
    });
    print("user changing...");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(allTranslations.text('processing')),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation(FunctionUtils.colorFromHex("")), //a changer
                    )
              ],
            ),
          );
        });

    Api api = ApiRepository();
    api.validatePerm(validateDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de l'utilisateur dans la session
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 1);
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);

            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    });
  }

  sendPerm() {
    Api api = ApiRepository();
    FunctionUtils.sendData(
        context: context,
        dto: budgetDto,
        repositoryFunction: api.sendBudget,
        clearController: clearController,
        onSuccess: (a) {
          ///On ferme le formulaire
          Navigator.of(context).pop(null);

          getInfos();
          /* setState(() {
            information.clear();
            for (var item in informationPerCentre) {
              information.addAll(item.datas);
            }
            if (budgetFilter.length > 0) budgetFilter.clear();
            budgetFilter.addAll(information);
            allChk = true;
            budgetFilter
                .sort((a, b) => a.dateOperation.compareTo(b.dateOperation));
          }); */
        },
        onFailure: () {});
  }

  buildGraph() {
    // prin
    var data = [
      new BudgetEntry("Entrés", total_entres,
          charts.MaterialPalette.deepOrange.shadeDefault),
      new BudgetEntry("Détails budgetaires", total_detail_budgetaires,
          charts.MaterialPalette.gray.shade800),
    ];

    var serieList = [
      new charts.Series<BudgetEntry, String>(
        id: "Budgets",
        // colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        colorFn: (BudgetEntry budgets, _) => budgets.color,
        domainFn: (BudgetEntry budgets, _) => budgets.denomination.toString(),
        measureFn: (BudgetEntry budgets, _) => budgets.montant,
        data: data,
        labelAccessorFn: (BudgetEntry budgets, _) => "${budgets.montant} F CFA",
      )
    ];

    return SimpleBarChart(
      serieList,
      animate: true,
    );
  }

  void listAll() {
    filterInfo(true);
  }

  void filterInfo(bool tout, [String centre, String apprenant]) {
    setState(() {
      if (!tout) {
        //Filtrage par centre
        AllDatas centreData = informationPerCentre
            .firstWhere((oneCentre) => (oneCentre.keyCenter == centre));
        budgetFilter = centreData.datas;
        total_detail_budgetaires = centreData.budgetRecu ?? 0;
        total_entres = centreData.budgetPrevision ?? 0;
        allChk = false;
      } else {
        _centreController.text = "";
        _donateurController.text = "";
        if (budgetFilter.length > 0) budgetFilter.clear();
        // budgetFilter.addAll(mesInformations);
        budgetFilter.addAll(information);
        total_detail_budgetaires = total_detail_budgetaires_initial;
        total_entres = total_entres_initial;
        allChk = true;
      }
    });
  }

  void clearController() {
    _centreController.text = "";
    _donateurController.text = "";
    _descriptionController.text = "";
    _montantController.text = "";
    _natureController.text = "";
    _modePaiementController.text = "";
    _dateoperationController.text = "";
  }

  void showAddForm(DetailBudgetModel budget) {
    // if (budget != null) {
    //   _descriptionController.text = budget.description;
    //   _montantController.text = budget.montantOperation;
    //   _natureController.text = budget.natureFondKey;
    //   _modePaiementController.text = budget.modedon;
    //   _donateurController = budget.
    //   _descriptionController =
    //   _dateoperationController
    //   _montantController = Tex
    //   _natureController = Text
    //   _modePaiementController
    // }

    centres.length == 1
        ? _centreController.text = centres.first.keyCenter
        : debugPrint('');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Stack(
                  children: <Widget>[permForm(context)],
                ),
                scrollable: true,
                actions: [
                  TextButton(
                    onPressed: () {
                      clearController();
                      Navigator.of(context).pop();
                    },
                    child: Text(allTranslations.text('cancel')),
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        print('Tâche ajoutée');
                        setState(() {
                          budgetDto.description =
                              _descriptionController.text ?? "";
                          budgetDto.montant = _montantController.text ?? "";
                          budgetDto.nIdentifiant = _natureController.text ?? "";
                          budgetDto.modePaiement =
                              _modePaiementController.text ?? "";
                          budgetDto.datedetailbudget =
                              _dateoperationController.text ?? "";
                          budgetDto.donnateur = _donateurController.text ?? "";
                          budgetDto.cIdentifiant = _centreController.text ?? "";
                        });
                        sendPerm();
                      }
                    },
                    child: Text(allTranslations.text('submit')),
                  )
                ],
              );
            },
          );
          // });
        }).then((value) => clearController());
  }

  /// Confirmer l'accord ou le refus d'une permission
  // confirmDeleteTask(BuildContext context, PermissionApprenantModel permission) {
  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Centre
          centres.length > 1
              ? SearchableDropdown(
                  isExpanded: true,
                  items: centres
                      .map((center) => DropdownMenuItem(
                            child: Text(center.denominationCenter),
                            value: center.denominationCenter,
                          ))
                      .toList(),
                  hint: Text("Centre"),
                  onChanged: (value) {
                    setState(() {
                      _centreController.text =
                          FunctionUtils.getCenterKey(value, centres).toString();
                    });
                  },
                ).py12()
              : SizedBox(height: 0),
          // Nature des fonds
          DropdownButtonFormField(
            isExpanded: true,
            items: natures
                .map((nature) => DropdownMenuItem(
                      child: Text(nature.libelle),
                      value: nature.keynaturebudget,
                    ))
                .toList(),
            hint: Text("Nature des fonds"),
            onChanged: (value) {
              setState(() {
                _natureController.text = value;
              });
            },
          ).py12(),
          // Mode de payement
          DropdownButtonFormField(
            isExpanded: true,
            items: modes
                .map((mode) => DropdownMenuItem(
                      child: Text(mode.libelle),
                      value: mode.id.toString(),
                    ))
                .toList(),
            hint: Text("Mode de paiement"),
            onChanged: (value) {
              setState(() {
                _modePaiementController.text = value;
              });
            },
          ).py12(),
          // Date de l'operation
          DateTimePicker(
            type: DateTimePickerType.dateTime,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _dateoperationController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            // icon: Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Heure",
            onChanged: (val) {
              print(val);
              setState(() {
                _dateoperationController.text =
                    val.toString().split(".")[0].split(" ")[0];
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_date_operation');
              }
              return null;
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _dateoperationController.text = val.toString().split(".")[0];
              });
            },
          ),
          // Montant
          TextFormField(
            controller: _montantController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              labelText: allTranslations.text('montant'),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_montant');
              }
              return null;
            },
          ),
          // Nom prenoms Deponsant
          TextFormField(
            controller: _donateurController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              labelText: allTranslations.text('name_deposant'),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_name_deposant');
              }
              return null;
            },
          ),
          // Description
          TextFormField(
            controller: _descriptionController,
            maxLines: 20,
            minLines: 1,
            // expands: true,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              // border: OutlineInputBorder(),
              labelText: allTranslations.text('motif'),
              // prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_motif');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

/* End */
}
