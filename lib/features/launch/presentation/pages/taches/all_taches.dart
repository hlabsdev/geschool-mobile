import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/tache_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/tache_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/personnel_list_response_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/taches/detail_tache.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/tache_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class AllTasks extends StatefulWidget {
  UserModel me;
  List<TacheModel> taches;
  AllTasks({this.me, this.taches});

  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  final _datePickerKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  final _rappelFormKey = GlobalKey<FormState>();
  final _rapportFormKey = GlobalKey<FormState>();
  List<PersonnelTache> personnels = [];
  List<PersonnelTache> personnelsFilter = [];
  List<CentreModel> centres = [];
  List<TacheModel> tachesFilter = [];
  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  bool allChk = false;
  String appBarTitle;
  Animation<double> rotationAnimation;
  Icon arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  String sousTitreChecbox;
  SlidableController slidableController;
  TextEditingController _centreController = TextEditingController();
  TextEditingController _personnelController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _datetacheController = TextEditingController();
  TextEditingController _daterappelController = TextEditingController();
  TextEditingController _rapportController = TextEditingController();
  TextEditingController centreController = TextEditingController(text: "");
  TextEditingController userController = TextEditingController(text: "");
  GetInfoDto infoDto = GetInfoDto();
  TacheDto tacheDto = TacheDto();
  String errorMsg = "Test";

  bool isFormError = false;

  @override
  void initState() {
    centreController.clear();
    userController.clear();
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    FunctionUtils.sortTaches(widget.taches);
    getCentre();
    getUsers();
    filterTache(null);
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: changeSlideArrowDirection,
    );
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddForm(null);
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        tooltip: allTranslations.text('update'),
        backgroundColor: GreenLight,
      ),
      appBar: AppBar(
        title: Text(allTranslations.text('all_tasks')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              getInfos();
              getCentre();
              getUsers();
            },
          ),
        ],
      ),
      body: RefreshableWidget(
        onRefresh: () {
          getInfos();
          getCentre();
          getUsers();
        },
        isLoading: isLoading,
        error: error,
        information: widget.taches,
        noDataText: Text(allTranslations.text('no_tache')),
        child: ListView(
          children: [
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              color: Colors.yellow[200],
              child: DatePicker(
                // DateTime.now().subtract(Duration(days: 3)),
                DateTime.now().subtract(Duration(days: 100)),
                key: _datePickerKey,
                daysCount: 500,
                initialSelectedDate: DateTime.now(),
                locale: "fr-FR",
                selectionColor: Colors.grey[700],
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  filterTache(date);
                },
              ),
            ),
            /* Filtre par centre et personnel deb */
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        child: SearchableDropdown(
                          closeButton: "Fermer",
                          isExpanded: true,
                          items: centres
                              .map((centre) => DropdownMenuItem(
                                    child: Text(centre.denominationCenter),
                                    value: centre.denominationCenter,
                                  ))
                              .toList(),
                          hint: centreController.text == ""
                              ? Text("Centre")
                              : Text(FunctionUtils.getCenterName(
                                  int.parse(centreController.text), centres)),
                          onChanged: (value) {
                            filterPerCentre(getCenterId(value));
                            setState(() {
                              centreController.text =
                                  FunctionUtils.getCenterId(value, centres)
                                      .toString();
                            });
                            print(
                                "${centreController.text} -1- ${userController.text}");
                            filterInfo(
                              false,
                              centreController.text,
                              userController.text,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        child: SearchableDropdown(
                          closeButton: "Fermer",
                          isExpanded: true,
                          items: personnelsFilter
                              .map((perso) => DropdownMenuItem(
                                    child: Text(
                                        getPersonnelName(perso.keypersonnel)),
                                    // value: perso.keypersonnel,
                                    value: getPersonnelName(perso.keypersonnel),
                                    onTap: () => print(perso.keypersonnel),
                                  ))
                              .toList(),
                          hint: userController.text == ""
                              ? Text("Personnel")
                              : Text(getPersonnelName(userController.text)),
                          onChanged: (value) {
                            setState(() {
                              !value.isEmpty
                                  ? userController.text = getPersonnelKey(value)
                                  : null;
                            });
                            print(
                                "${centreController.text} -2- ${userController.text}");
                            filterInfo(
                              false,
                              centreController.text,
                              userController.text,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 5),
            /* Filtre par centre et personnel end */
            Container(
              height: 50,
              color: Colors.grey[100],
              child: CheckboxListTile(
                tristate: false,
                secondary: const Icon(
                  Icons.filter_alt_rounded,
                ),
                title: const Text('Tout'),
                // subtitle: Text(allTranslations.text('can_filter_per_date')),
                value: allChk,
                onChanged: (valueNew) {
                  setState(() {
                    allChk = valueNew;
                    centreController.clear();
                    userController.clear();
                  });
                  listAll();
                },
              ),
            ),
            // List des Taches

            ListView.builder(
              shrinkWrap: true,
              primary: false,
              cacheExtent: 4,
              // physics: AlwaysScrollableScrollPhysics(),
              itemCount: tachesFilter.length,
              itemBuilder: (context, i) {
                return Slidable(
                  actionPane: SlidableBehindActionPane(),
                  controller: slidableController,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Détail',
                      color: LoudGrey,
                      icon: Icons.remove_red_eye,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailTache(
                              tache: tachesFilter[i],
                              isAdmin: true,
                              me: widget.me,
                              pIdentifiant: tachesFilter[i].keyPersonnel,
                            ),
                          ),
                        );
                      },
                    ),
                    IconSlideAction(
                      caption: 'Plus',
                      color: GreenLight,
                      icon: Icons.more_vert,
                      onTap: () {
                        _moreAction(context, tachesFilter[i]);
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Détail',
                      color: LoudGrey,
                      icon: Icons.remove_red_eye,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DetailTache(
                              tache: tachesFilter[i],
                              isAdmin: true,
                              me: widget.me,
                              pIdentifiant: tachesFilter[i].keyPersonnel,
                            ),
                          ),
                        );
                      },
                    ),
                    IconSlideAction(
                      caption: 'Plus',
                      color: GreenLight,
                      icon: Icons.more_vert,
                      onTap: () {
                        _moreAction(context, tachesFilter[i]);
                      },
                    ),
                  ],
                  child: TacheCardWidget(
                      tache: tachesFilter[i], isAdmin: true, isAll: true),
                  closeOnScroll: true,
                );
              },
            ),
            // ),
            // ),
          ],
        ),
      ),
    );
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;

      centreController.clear();
      userController.clear();
    });
  }

  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getTaches(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              widget.taches = a.information;
              FunctionUtils.sortTaches(widget.taches);
              allChk = true;
              tachesFilter.clear();
              tachesFilter.addAll(widget.taches);

              // FunctionUtils.sortTaches(tachesFilter);
            });
            centres.clear();
            personnels.clear();
            getCentre();
            getUsers();
            loading(false);
            return true;
          } else {
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message);
            return false;
          }
        });
      } else if (value.isLeft()) {
        setState(() {
          error = true;
        });
        loading(false);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      loading(false);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  void getCentre() {
    print("En recuperation...");
    Api api = ApiRepository();
    api.getCentre(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              if (widget.me.idcenters.contains("1")) {
                centres = a.information;
              } else {
                for (var cent in a.information) {
                  for (var item in widget.me.idcenters) {
                    if (cent.idCenter.toString() == item &&
                        !centres.contains(cent)) {
                      centres.add(cent);
                    }
                  }
                }
              }
            });
            return true;
          } else {
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message);
            return false;
          }
        });
      } else if (value.isLeft()) {
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
      }
    }, onError: (error) {
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  getUsers() {
    print("En recuperation...");
    Api api = ApiRepository();
    api.getPersonnels(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            setState(() {
              personnels = a.information.personnels;
              personnels.forEach((element) {
                print("\nPersonnes: " + element.toJson().toString());
              });
              personnelsFilter.clear();
              personnelsFilter.addAll(personnels);
            });
            return true;
          } else {
            FunctionUtils.displaySnackBar(context, a.message);
            return false;
          }
        });
      } else if (value.isLeft()) {
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    }, onError: (error) {
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

  sendTache() {
    print("En envoie...");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Center(
            child: CircularProgressIndicator(
              semanticsLabel: allTranslations.text('pls_wait'),
            ),
          ),
        );
      },
    );
    Api api = ApiRepository();
    api.sendTache(tacheDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            ///enregistrement des informations de recuperes
            setState(() {
              widget.taches = a.information;
            });
            filterTache(null);
            Navigator.of(context).pop(null);
            clearController();
            Navigator.of(context).pop(null);
            clearController();
            // context, "Opération effectuée avec succès",
            FunctionUtils.displaySnackBar(context, a.message, type: 1);
            return true;
          } else {
            setState(() {
              isFormError = true;
              errorMsg = a.message;
            });
            Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else if (value.isLeft()) {
        setState(() {
          error = true;
          isFormError = true;
          errorMsg = allTranslations.text('error_process');
        });
        Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'),
            type: 0);
        return false;
      }
    }, onError: (error) {
      Navigator.of(context).pop(null);
      setState(() {
        isFormError = true;
        errorMsg = error.message;
      });
      FunctionUtils.displaySnackBar(context, error.message, type: 0);
    });
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      rotationAnimation = slideAnimation;
    });
  }

  void changeSlideArrowDirection(bool isOpen) {
    setState(() {
      arrowLeft = isOpen
          ? Icon(Icons.keyboard_arrow_right_rounded)
          : Icon(Icons.keyboard_arrow_left_rounded);
    });
  }

  void filterTache(DateTime date) {
    setState(() {
      if (date != null) {
        tachesFilter.clear();
        tachesFilter = widget.taches
            .filter(
                (task) => DateTime.parse(task.dateTache).compareTo(date) == 0)
            .toList();
        allChk = false;
        // FunctionUtils.sortTaches(tachesFilter);
        sousTitreChecbox = 'Filtré par date';
      } else {
        allChk = true;
        tachesFilter.clear();
        tachesFilter.addAll(widget.taches);
        // FunctionUtils.sortTaches(tachesFilter);
        sousTitreChecbox = 'Sans filtre';
      }
      // Ranger selon si la tache est rapportee ou pas
      // tachesFilter.sort((a, b) => a.rapportTache.length.compareTo(b.rapportTache.length));
    });
  }

  void filterInfo(bool tout, [String centre, String user]) {
    print("$centre -3- $user");
    setState(() {
      if (!tout) {
        // Tout
        tachesFilter = widget.taches
            .where(
              (tache) => ((centre.isEmpty
                      ? tache.keyTache.isNotEmpty
                      : tache.idCentre == int.tryParse(centre)) &&
                  (user.isEmpty
                      ? tache.keyTache.isNotEmpty
                      : tache.keyPersonnel == user)),
            )
            .toList();
        // FunctionUtils.sortTaches(tachesFilter);
        allChk = false;
      } else {
        centreController.text = "";
        userController.text = "";
        if (tachesFilter.length > 0) tachesFilter.clear();
        // tachesFilter.addAll(mesInformations);
        tachesFilter.addAll(widget.taches);
        // FunctionUtils.sortTaches(tachesFilter);
        allChk = true;
      }

      // FunctionUtils.sortTaches(tachesFilter);
    });
  }

  void listAll() {
    allChk == true ? filterTache(null) : filterTache(DateTime.now());
  }

  int getCenterId(String name) {
    int id;
    id = centres
        .firstWhere((element) => element.denominationCenter == name)
        .idCenter;
    return id;
  }

  String getCenterName(int id) {
    String name;
    name = centres
        .firstWhere((element) => element.idCenter == id)
        .denominationCenter;
    return name;
  }

  getPersonnelName(String key) {
    String name;
    PersonnelTache perso = PersonnelTache();
    perso = personnels.firstWhere((element) => element.keypersonnel == key,
        orElse: () => null);
    name = "${perso.nom} ${perso.prenoms}";
    return name;
  }

  String getPersonnelKey(String name) {
    String key;
    PersonnelTache perso = PersonnelTache();
    if (!name.isEmptyOrNull) {
      perso = personnels.firstWhere(
        (element) =>
            (element.nom + " " + element.prenoms).toLowerCase() ==
            name.toLowerCase(),
        orElse: () => null,
      );
      key = perso.keypersonnel;
    }
    return key;
  }

  void showAddForm(TacheModel tache) {
    if (tache != null) {
      setState(() {
        isFormError = false;
        errorMsg = "";
        _centreController.text = tache.idCentre.toString();
        _personnelController.text = tache.keyPersonnel;
        _descriptionController.text = tache.descriptionTache;
        _datetacheController.text = tache.dateTache;
        _daterappelController.text = tache.dateRappelTache;
        _rapportController.text = tache.rapportTache;
      });
    } else if (centres.length == 1)
      _centreController.text = centres[0].idCenter.toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Stack(
                  children: <Widget>[tacheForm(context)],
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
                        // Navigator.of(context).pop();
                        saveTache(tache);
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

  Form tacheForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          isFormError
              ? Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.red[300],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(errorMsg,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyle(color: Colors.white))),
                  ),
                )
              : SizedBox(height: 0),
          // SizedBox(height: 10.0),
          Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 15),
              child: Column(
                children: [
                  // DropdownButtonFormField<int>(
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
                              : Text(getCenterName(
                                  int.parse(_centreController.text))),
                          onChanged: (value) {
                            filterPerCentre(getCenterId(value));
                            setState(() {
                              _centreController.text =
                                  getCenterId(value).toString();
                            });
                          },
                        ).py12()
                      : SizedBox(height: 0),
                  // DropdownButtonFormField<String>(
                  SearchableDropdown(
                    isExpanded: true,
                    // items: personnelsFilter
                    items: personnelsFilter
                        .map((perso) => DropdownMenuItem(
                              child: Text(getPersonnelName(perso.keypersonnel)),
                              // value: perso.keypersonnel,
                              value: getPersonnelName(perso.keypersonnel),
                              onTap: () => print(perso.keypersonnel),
                            ))
                        .toList(),
                    hint: _personnelController.text == ""
                        ? Text("Personnel")
                        : Text(getPersonnelName(_personnelController.text)),
                    onChanged: (value) {
                      setState(() {
                        value.isEmpty
                            ? null
                            : _personnelController.text =
                                getPersonnelKey(value);
                      });
                    },
                  ).py12(),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      contentPadding: Vx.m2,
                      // border: OutlineInputBorder(),
                      labelText: allTranslations.text('description'),
                      // prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return allTranslations.text('pls_set_description');
                      }
                      return null;
                    },
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    // cursorColor: GreenLight,
                    timeFieldWidth: 55,
                    dateMask: 'd MMM, yyyy',
                    controller: _datetacheController,
                    locale: Locale('fr'),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.date_range),
                    use24HourFormat: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return allTranslations.text('pls_set_datetache');
                      }
                      return null;
                    },
                    dateLabelText: 'Date Tâche',
                    timeLabelText: "Heure",
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        _datetacheController.text =
                            val.toString().split(".")[0];
                      });
                    },
                    onSaved: (val) {
                      print(val);
                      setState(() {
                        _datetacheController.text =
                            val.toString().split(".")[0];
                      });
                    },
                  ).py12(),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    timeFieldWidth: 55,
                    dateMask: 'd MMM, yyyy',
                    controller: _daterappelController,
                    locale: Locale('fr'),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date Rappel',
                    timeLabelText: "Heure",
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        _daterappelController.text =
                            val.toString().split(".")[0];
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return allTranslations.text('pls_set_datetrappel');
                      }
                      return null;
                    },
                    onSaved: (val) {
                      print(val);
                      setState(() {
                        _daterappelController.text =
                            val.toString().split(".")[0];
                      });
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }

/* ===== Filtrage par centre ===== */
  void filterPerCentre(int centerId) {
    setState(() {
      personnelsFilter.clear();
      if (centerId != null) {
        personnelsFilter = personnels
            .filter((perso) => perso.idcenters.contains(centerId.toString()))
            .toList();
      } else {
        personnelsFilter.addAll(personnels);
      }
    });
  }

  void clearController() {
    _centreController.text = "";
    _personnelController.text = "";
    _descriptionController.text = "";
    _datetacheController.text = "";
    _daterappelController.text = "";
    _rapportController.text = "";
  }

  void saveTache(TacheModel tache) {
    setState(() {
      if (tache != null) {
        tacheDto.operation = 2;
        tacheDto.tacheKey = tache.keyTache;
      } else {
        tacheDto.operation = 1;
      }

      tacheDto.registrationId = "";
      print(_daterappelController.text);
      tacheDto.dateTache =
          DateTime.parse(_datetacheController.text).toString().split('.')[0];
      tacheDto.dateRappel =
          DateTime.parse(_daterappelController.text).toString().split('.')[0];
      tacheDto.description = _descriptionController.text;
      tacheDto.idCentre = int.parse(_centreController.text);
      tacheDto.uIdentifiant = widget.me.authKey;
      tacheDto.pIdentifiant = _personnelController.text;
    });
    print(tacheDto.toJson());
    sendTache();
    tachesFilter.clear();
    tachesFilter.addAll(widget.taches);
  }

  confirmDeleteTask(BuildContext context, TacheModel tache) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(allTranslations.text('confirm_delete')),
        content: Text(allTranslations.text('delete_message_task')),
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
                tachesFilter.remove(tache);
                tachesFilter.remove(tache);
              });
            },
          ),
        ],
      ),
    );
  }

  void _moreAction(context, TacheModel tache) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        List<Widget> listAction = <Widget>[];
        if (DateTime.parse(tache.dateTache).isBefore(DateTime.now())) {
          if (tache.rapportTache == null || tache.rapportTache.trim() == "") {
            listAction.add(ListTile(
              leading: Icon(
                Icons.assignment_rounded,
                color: GreenLight,
              ),
              title: Text('Ajouter un rapport'),
              onTap: () {
                showRapportForm(tache);
              },
            ));
          } else {
            listAction.add(ListTile(
              leading: Icon(
                Icons.cancel,
                color: Grey,
              ),
              title: Text('Aucune action supplémentaire disponible'),
              /* onTap: () {
                // showRapportForm(tache);
              }, */
            ));
          }
        } else {
          listAction.add(ListTile(
            leading: Icon(
              Icons.edit_rounded,
              color: Colors.blue[300],
            ),
            title: Text("Modifier la tâche"),
            onTap: () => {
              showAddForm(tache),
            },
          ));
          listAction.add(ListTile(
            leading: Icon(
              Icons.add_alert_rounded,
              color: Grey,
            ),
            title: Text('Definir une alerte'),
            onTap: () {
              showRappelChange(tache);
            },
          ));
        }
        listAction.add(SizedBox(height: 10.0));
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: listAction,
        );
      },
    );
  }

  void showRapportForm(TacheModel tache) {
    setState(() {
      _rapportController.text = tache.rapportTache;
    });
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: Stack(
              children: <Widget>[
                Form(
                  key: _rapportFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: SizedBox(
                            child: TextFormField(
                              showCursor: true,
                              enableInteractiveSelection: true,
                              textAlign: TextAlign.justify,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _rapportController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    bottom: 40, left: 5, right: 5),
                                border: OutlineInputBorder(),
                                labelText: allTranslations.text('rapport'),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return allTranslations
                                      .text('pls_set_rapport');
                                }
                                return null;
                              },
                            ),
                          )),
                      SizedBox(height: 10.0),
                      /* InkValidationButton(
                          onPressed: () {
                            if (_rapportFormKey.currentState.validate()) {
                              print('Rapport ajoutée');
                              Navigator.of(context).pop();
                              saveRapport(tache);
                            }
                          },
                          buttontext: "${allTranslations.text('submit')}"), */
                      // SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Annuler"),
                onPressed: () {
                  clearController();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Valider"),
                onPressed: () {
                  if (_rapportFormKey.currentState.validate()) {
                    print('Tache encour d\'ajout');
                    saveRapport(tache);
                    // Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void showRappelChange(TacheModel tache) {
    setState(() {
      _daterappelController.text = tache.dateRappelTache;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Stack(
            children: <Widget>[
              Form(
                key: _rappelFormKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        timeFieldWidth: 55,
                        dateMask: 'd MMM, yyyy',
                        locale: Locale('fr'),
                        initialValue:
                            DateTime.parse(tache.dateRappelTache).toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateHintText: 'Date Rappel',
                        timeHintText: "Heure",
                        onChanged: (val) {
                          print(val);
                          setState(() {
                            _daterappelController.text =
                                val.toString().split(".")[0];
                          });
                        },
                        validator: (val) {
                          return val == null
                              ? allTranslations.text('pls_set_datetrappel')
                              : null;
                        },
                        onSaved: (val) {
                          print(val);
                          setState(() {
                            _daterappelController.text =
                                val.toString().split(".")[0];
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    /* InkValidationButton(
                        onPressed: () {
                          if (_rappelFormKey.currentState.validate()) {
                            print('Rappel modifié');
                            Navigator.of(context).pop();
                            saveRappel(tache);
                          }
                        },
                        buttontext: "${allTranslations.text('submit')}"), */
                    // SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                clearController();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Valider"),
              onPressed: () {
                if (_rappelFormKey.currentState.validate()) {
                  print('Tache ajoutée');
                  saveRappel(tache);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void saveRapport(TacheModel tache) {
    setState(() {
      tacheDto.operation = 3;
      tacheDto.tacheKey = tache.keyTache;
      tacheDto.registrationId = "";
      print(_rapportController.text);
      tacheDto.rapportTache = _rapportController.text;
      tacheDto.dateTache = tache.dateTache;
      tacheDto.dateRappel = tache.dateRappelTache;
      tacheDto.description = tache.descriptionTache;
      tacheDto.idCentre = tache.idCentre;
      tacheDto.uIdentifiant = widget.me.authKey;
      tacheDto.pIdentifiant = getPersonnelKey(tache.nameUser);
      // clearController();
    });
    print(tacheDto.toJson());
    sendTache();
    tachesFilter.clear();
    tachesFilter.addAll(widget.taches);
  }

  void saveRappel(TacheModel tache) {
    setState(() {
      tacheDto.operation = 2;
      tacheDto.tacheKey = tache.keyTache;
      tacheDto.registrationId = "";
      print(_daterappelController.text);
      tacheDto.dateTache = tache.dateTache;
      tacheDto.rapportTache = _rapportController.text;
      tacheDto.dateRappel =
          DateTime.parse(_daterappelController.text).toString().split('.')[0];
      tacheDto.description = tache.descriptionTache;
      tacheDto.idCentre = tache.idCentre;
      tacheDto.uIdentifiant = widget.me.authKey;
      tacheDto.pIdentifiant = getPersonnelKey(tache.nameUser);
      // clearController();
    });
    print(tacheDto.toJson());
    sendTache();
    tachesFilter.clear();
    tachesFilter.addAll(widget.taches);
  }

/* === End === */
}
