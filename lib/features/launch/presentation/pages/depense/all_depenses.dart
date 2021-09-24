import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/validate_depense_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/depense_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/centre_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/depense_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/depense/detail_depense.dart';
import 'package:geschool/features/launch/presentation/widgets/data_chart.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/depense_card_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/filter_pane_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class AllDepenses extends StatefulWidget {
  UserModel me;
  AllDepenses({this.me});

  @override
  _AllDepensesState createState() => _AllDepensesState();
}

class _AllDepensesState extends State<AllDepenses> {
  GetInfoDto infoDto = GetInfoDto();
  TextEditingController centreController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController personnelController = TextEditingController();
  bool allChk = false;

  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  var data = [
    {"Saisie budgetaires", 6180000},
    {"Paiement scolarite", 110000},
    {"Total prestations", 2351135},
  ];

  /* Imported prepared for parsing deb */

  List<DenpensePerCentre> informationPerCentre = [];
  // List<DenpenseCentreDatas> information = [];
  // List<DenpenseCentreDatas> infoFilter = [];
  DenpensePerCentre information = new DenpensePerCentre();
  DenpensePerCentre infoFilter = new DenpensePerCentre();
  List<CentreModel> centres = [];
  List<DepenseModel> attente = [];
  List<DepenseModel> decaissement = [];
  List<DepenseModel> refus = [];
  List<AllPersonnels> personnels = [];
  List<Sections> sections = [];

  /* For form deb */
  TextEditingController _centreController = TextEditingController();
  TextEditingController _apprenantController = TextEditingController();
  TextEditingController _motifController = TextEditingController();
  TextEditingController _datedemandeController = TextEditingController();
  TextEditingController _datedebutController = TextEditingController();
  TextEditingController _heuredebutController = TextEditingController();
  TextEditingController _datefinController = TextEditingController();
  TextEditingController _heurefinController = TextEditingController();
  /* For form end */
  TextEditingController periodeController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  TextEditingController matiereController = TextEditingController();

  SlidableController slidableController;
  Icon _arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  Animation<double> rotationAnimation;
  ValidateDepenseDto validateDto = ValidateDepenseDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();

  int selected = -1;
  bool expandFlag = false;

  /* Imported prepared for parsing end */

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    information.budgetDepense = 0;
    information.budgetPlafond = 0;
    information.budgetPrevision = 0;
    information.budgetRecu = 0;
    information.totalDepense = 0;
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> etatDepense = [
      ["Demandes en attentes", attente, Colors.grey[300]],
      ["Demandes en cours de décaissements", decaissement, Colors.green[100]],
      ["Demandes Traitées", refus, Colors.red[100]],
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('demande_depense')),
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
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: informationPerCentre,
        noDataText: Text(allTranslations.text('no_budget')),
        child: ListView(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          children: <Widget>[
            /* Filtre par centre et personnel deb */
            SingleFilterPaneWidget(
              hint: centreController.text == ""
                  ? Text("Centre")
                  : Text((centreController.text)),
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
            /* ====== Exnasion de liste de depenses  deb*/

            ListView.builder(
              shrinkWrap: true,
              primary: false,
              // itemCount: infoFilter.length,
              // itemBuilder: (context, i) {
              itemCount: etatDepense.length,
              itemBuilder: (context, index) {
                List<dynamic> curentDepense = etatDepense[index];
                return ExpansionTile(
                  collapsedBackgroundColor: curentDepense[2],
                  backgroundColor: curentDepense[2],
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
                    height: 40,
                    decoration: BoxDecoration(
                      color: curentDepense[2],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      curentDepense[0].toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  children: List.generate(
                      curentDepense[1].length,
                      (i) => Slidable(
                            controller: slidableController,
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Detail',
                                color: Grey,
                                icon: Icons.remove_red_eye_rounded,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DetailDepense(
                                        me: widget.me,
                                        depense: curentDepense[1][i],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              curentDepense[1][i].status == "2"
                                  ? SizedBox(height: 0, width: 0)
                                  : IconSlideAction(
                                      caption: 'Plus',
                                      color: GreenLight,
                                      icon: Icons.edit,
                                      onTap: () {
                                        _moreAction(
                                            context, curentDepense[1][i]);
                                      },
                                    ),
                            ],
                            child: DepenseCardWidget(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailDepense(
                                      me: widget.me,
                                      section: sections.firstWhere((sect) =>
                                          sect.keysection ==
                                          curentDepense[1][i].keysection),
                                      depense: curentDepense[1][i],
                                    ),
                                  ),
                                );
                              },
                              depense: curentDepense[1][i],
                              trailing: _arrowLeft,
                            ),
                          ),
                      growable: true),
                );
              },
            ),

            /* ====== Exnasion de liste de depenses  end*/

            /* ============================================================== */

            /* ===== Graphe deb */
            SizedBox(height: 10, width: 0),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2),
              child: Text(
                  "Graphe comparant les dépenses et le total \ndes dépenses de l'établissement.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20, width: 0),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 30,
                maxHeight: MediaQuery.of(context).size.height / 2,
              ),
              // child: SimpleBarChart.withSampleData(),
              child: buildGraph(),
            ),
            /* ===== Graphe end */
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

  void separate(DenpensePerCentre allList) {
    setState(() {
      attente.clear();
      decaissement.clear();
      refus.clear();
      // for (var item in allList) {
      attente.addAll(allList.datas.data1);
      decaissement.addAll(allList.datas.data2);
      refus.addAll(allList.datas.data3);
      // }
      attente.sort((a, b) => DateTime.tryParse(b.datedemande)
          .compareTo(DateTime.tryParse(a.datedemande)));
      decaissement.sort((a, b) => DateTime.tryParse(b.datedemande)
          .compareTo(DateTime.tryParse(a.datedemande)));
      refus.sort((a, b) => DateTime.tryParse(b.datedemande)
          .compareTo(DateTime.tryParse(a.datedemande)));
      personnels = allList.datas.allPersonnels;
      sections = allList.datas.sections;
    });
  }

  getInfos() {
    Api api = ApiRepository();
    FunctionUtils.getData(
      context: context,
      dto: infoDto,
      startFunction: () => loading(true),
      stopFunction: () => loading(false),
      repositoryFunction: api.getDepenses,
      onFailure: (value) {
        setState(() {
          error = value;
        });
      },
      onSuccess: (value) {
        setState(() {
          informationPerCentre = value.information;
          information = new DenpensePerCentre(
            budgetDepense: 0,
            budgetPlafond: 0,
            budgetPrevision: 0,
            budgetRecu: 0,
            totalDepense: 0,
            datas: new DenpenseCentreDatas(
              allPersonnels: [],
              data1: [],
              data2: [],
              data3: [],
              sections: [],
            ),
          );
          infoFilter = new DenpensePerCentre();
          //Ici toute
          for (var denpensePerCentre in informationPerCentre) {
            if (denpensePerCentre != null) {
              // Variable uniques
              information.budgetDepense +=
                  denpensePerCentre?.budgetDepense ?? 0;
              information.budgetPlafond +=
                  denpensePerCentre?.budgetPlafond ?? 0;
              information.budgetPrevision +=
                  denpensePerCentre?.budgetPrevision ?? 0;
              information.budgetRecu += denpensePerCentre?.budgetRecu ?? 0;
              information.totalDepense += denpensePerCentre?.totalDepense ?? 0;
              // Listes debut
              information.datas.sections
                  .addAll(denpensePerCentre.datas.sections);
              information.datas.allPersonnels
                  .addAll(denpensePerCentre.datas.allPersonnels);
              information.datas.data1.addAll(denpensePerCentre.datas.data1);
              information.datas.data2.addAll(denpensePerCentre.datas.data2);
              information.datas.data3.addAll(denpensePerCentre.datas.data3);
            }
          }
          infoFilter = information;
          separate(infoFilter);
          allChk = true;
        });
      },
    );
    getCentres();
  }

  getCentres() {
    Api api = ApiRepository();
    FunctionUtils.getData(
      context: context,
      dto: infoDto,
      startFunction: () => loading(true),
      stopFunction: () => loading(false),
      repositoryFunction: api.getCentre,
      onFailure: (value) {
        setState(() {
          error = value;
        });
      },
      onSuccess: (CentreResponseModel value) {
        setState(() {
          centres.clear();
          centres = value.information;
        });
      },
    );
  }

  /// envoie des donnees de validation au serveur
  validate(bool accorded, bool decaisser) {
    setState(() {
      if (decaisser) {
        validateDto.operation = "3";
      } else {
        validateDto.operation = accorded ? "1" : "2";
      }
    });
    Api api = ApiRepository();
    FunctionUtils.sendData(
        context: context,
        dto: validateDto,
        repositoryFunction: api.validateDepense,
        clearController: clearController,
        onSuccess: (a) {
          getInfos();
        },
        onFailure: () {});
  }

  /* validate0(bool accorded) async {
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
  } */

  sendDepense() {
    Api api = ApiRepository();
    FunctionUtils.sendData(
        context: context,
        // dto: budgetDto,
        repositoryFunction: api.sendDepense,
        clearController: clearController,
        onSuccess: (a) {
          ///On ferme le formulaire
          Navigator.of(context).pop(null);

          getInfos();
        },
        onFailure: () {});
  }

/* 
  sendPerm() async {
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
    api.sendPerm(addPermDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de l'utilisateur dans la session
            Navigator.of(context).pop(null);
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 1);
            clearController();
            setState(() {
              information = a.information;
              /* Listes */
              matiereController.text = "";
              classeController.text = "";
              periodeController.text = "";
              if (infoFilter.length > 0) infoFilter.clear();
              infoFilter.addAll(information);
              allChk = true;

              infoFilter.sort((a, b) =>
                  a.datedemandepermission.compareTo(b.datedemandepermission));
            });
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    });
  } */

  void listAll() {
    filterInfo(true);
  }

  buildGraph() {
    // prin
    var data = [
      new BudgetEntry("Budget\nPrévisionnel", infoFilter.budgetPrevision,
          charts.MaterialPalette.yellow.shadeDefault),
      new BudgetEntry("Total\nEntrées", infoFilter.budgetRecu,
          charts.MaterialPalette.blue.shadeDefault),
      new BudgetEntry("Budget\nDépenses", infoFilter.budgetDepense,
          charts.MaterialPalette.gray.shadeDefault),
      new BudgetEntry("Plafond", infoFilter.budgetPlafond,
          charts.MaterialPalette.deepOrange.shadeDefault),
      new BudgetEntry("Total\nDépenses", infoFilter.totalDepense,
          charts.MaterialPalette.red.shadeDefault),
    ];

    var serieList = [
      new charts.Series<BudgetEntry, String>(
        id: "Depenses",
        colorFn: (BudgetEntry budgets, _) => budgets.color,
        domainFn: (BudgetEntry budgets, _) => budgets.denomination.toString(),
        measureFn: (BudgetEntry budgets, _) => budgets.montant,
        data: data,
        labelAccessorFn: (BudgetEntry budgets, _) => "${budgets.montant} FCFA",
        overlaySeries: false,
      )
    ];

    return SimpleBarChart(
      serieList,
      animate: true,
    );
  }

  void filterInfo(bool tout,
      [String centre, String section, String personnel]) {
    setState(() {
      if (!tout) {
        //Pour fair un tri selon la section et le personnel
        // DenpensePerCentre partial;
        if (!centre.isEmptyOrNull) {
          infoFilter = informationPerCentre
              .firstWhere((depenseCentre) => depenseCentre.keyCenter == centre);
        }
        // partial = infoFilter.allChk = false;
      } else {
        centreController.clear();
        sectionController.clear();
        personnelController.clear();
        infoFilter = information;
        allChk = true;
      }
    });
    separate(infoFilter);
  }

  void clearController() {
    _centreController.text = "";
    _apprenantController.text = "";
    _motifController.text = "";
    _datedebutController.text = "";
    _datefinController.text = "";
    _heuredebutController.text = "";
    _heurefinController.text = "";
    _datedemandeController.text = "";
  }

  showForm(BuildContext context, PermissionApprenantModel depense) {
    if (depense != null) {
      _centreController.text = depense.idCenter.toString();
      _apprenantController.text = depense.keyapprenant;
      _motifController.text = depense.motifpermission;
      _datedebutController.text = depense.datedebutpermission;
      _datefinController.text = depense.datefinpermission;
      _heuredebutController.text = depense.heuredebutpermission;
      _heurefinController.text = depense.heurefinpermission;
      _datedemandeController.text = depense.datedemandepermission;
      addPermDto.permissionKey = depense.keypermission;
      addPermDto.operation = "2";
    } else {
      addPermDto.operation = "1";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // title: Text("Confirmer"),
        content: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 1.5),
          child: permForm(context),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Valider"),
            onPressed: () {
              setState(() {
                addPermDto.idCenter = _centreController.text;
                addPermDto.keyApprenant = _apprenantController.text;
                addPermDto.motif = _motifController.text ?? "";
                addPermDto.dateDemande =
                    _datedemandeController.text.split(" ")[0] ?? "";
                addPermDto.dateDebut =
                    _datedebutController.text.split(" ")[0] ?? "";
                addPermDto.dateFin =
                    _datefinController.text.split(" ")[0] ?? "";
                addPermDto.heureDebut = _heuredebutController.text ?? "";
                addPermDto.heureFin = _heurefinController.text ?? "";
              });
              sendDepense();
            },
          ),
        ],
      ),
    );
  }

  /// Confirmer l'accord ou le refus d'une depense
  _confirmValidation(BuildContext context, DepenseModel depense, bool accepted,
      bool decaisser) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: Text("Confirmer"),
        content: Text(
          "Confirmer " +
              (decaisser
                  ? "le décaissement"
                  : (accepted ? "l'accord" : "le refus")) +
              " de cette dépense",
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: Text("Valider"),
            onPressed: () {
              CentreModel center = centres.firstWhere((centre) =>
                  centre.idCenter == int.tryParse(depense.idcentre));
              setState(() {
                validateDto.uIdentifiant = widget.me.authKey;
                validateDto.registrationId = "";
                validateDto.cIdentifiant = center.keyCenter;
                validateDto.dIdentifiant = depense.keydepense;
              });
              Navigator.of(context).pop(null);
              print("Devrait se fermer");
              validate(accepted, decaisser);
            },
          ),
        ],
      ),
    );
  }

  void _moreAction(context, DepenseModel depense) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        ///Liste de des actions
        List<Widget> listAction = <Widget>[];

        //si la pemission est deja validee on ne peut plus la modifier
        if (depense.status == "2") {
          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel,
              color: Grey,
            ),
            title: Text('Aucune action supplémentaire disponible'),
            /* onTap: () {
                // showRapportForm(depense);
              }, */
          ));
        } else if (depense.status == "0") {
          listAction.add(ListTile(
            leading: Icon(
              Icons.check_circle_rounded,
              color: GreenLight,
            ),
            title: Text('Accorder'),
            onTap: () {
              _confirmValidation(context, depense, true, false);
            },
          ));
          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel_rounded,
              color: Colors.red[300],
            ),
            title: Text('Refuser'),
            onTap: () {
              _confirmValidation(context, depense, false, false);
            },
          ));
        } else if (depense.status == "1" && depense.datedepense.isEmptyOrNull) {
          listAction.add(ListTile(
            leading: Icon(
              Icons.money,
              color: GreenLight,
            ),
            title: Text('Décaisser'),
            onTap: () {
              _confirmValidation(context, depense, true, true);
            },
          ));

          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel_rounded,
              color: Colors.red[300],
            ),
            title: Text('Refuser'),
            onTap: () {
              _confirmValidation(context, depense, false, false);
            },
          ));
        }

        // } else {

        // }
        listAction.add(SizedBox(height: 10.0));
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: listAction,
        );
      },
    );
  }

  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          centres.length > 1
              ? SearchableDropdown(
                  isExpanded: true,
                  items: centres
                      .map((perso) => DropdownMenuItem(
                            child: Text(perso.denominationCenter),
                            value: perso.denominationCenter,
                          ))
                      .toList(),
                  hint: _centreController.text == ""
                      ? Text("Centre")
                      : Text(FunctionUtils.getCenterName(
                          int.parse(_centreController.text), centres)),
                  onChanged: (value) {
                    setState(() {
                      _centreController.text =
                          FunctionUtils.getCenterId(value, centres).toString();
                    });
                  },
                ).py12()
              : SizedBox(height: 0),
          // DropdownButtonFormField<String>(
          TextFormField(
            controller: _motifController,
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
          TextFormField(
            controller: _datedemandeController,
            decoration: InputDecoration(
              contentPadding: Vx.m2,
              // border: OutlineInputBorder(),
              labelText: _datedemandeController.text.isEmptyOrNull
                  ? allTranslations.text('datedemande')
                  : FunctionUtils.convertFormatDate(
                      _datedemandeController.text),
              // prefixIcon: Icon(Icons.description),
            ),
            readOnly: true,
            onTap: () {
              FunctionUtils.selectDate(
                  context, _datedemandeController, DateTime.now());
            },
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datedemande');
              }
              return null;
            },
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            // cursorColor: GreenLight,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _datedebutController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: Icon(Icons.date_range),
            use24HourFormat: true,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datedebut');
              }
              return null;
            },
            dateLabelText: 'Date Début',
            timeLabelText: "Heure",
            onChanged: (val) {
              print(val);
              setState(() {
                _datedebutController.text = val.toString().split(".")[0];
                _heuredebutController.text = val.toString().split(" ")[1];
              });
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _datedebutController.text = val.toString().split(".")[0];
                _heuredebutController.text = val.toString().split(" ")[1];
              });
            },
          ).py12(),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _datefinController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Date Fin',
            timeLabelText: "Heure",
            onChanged: (val) {
              print(val);
              setState(() {
                _datefinController.text = val.toString().split(".")[0];
                _heurefinController.text = val.toString().split(" ")[1];
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datefin');
              }
              return null;
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _datefinController.text = val.toString().split(".")[0];
                _heurefinController.text = val.toString().split(" ")[1];
              });
            },
          ),
        ],
      ),
    );
  }

/* End */
}
