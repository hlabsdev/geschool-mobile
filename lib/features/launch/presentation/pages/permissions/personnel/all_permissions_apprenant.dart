import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/permission_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/permissions/personnel/detail_permission_apprenant.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/permission_apprenant_card_widget_card.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/filter_pane_widget.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class AllPermissionsApprenant extends StatefulWidget {
  UserModel me;
  AllPermissionsApprenant({
    this.me,
  });

  @override
  _AllPermissionsApprenantState createState() =>
      _AllPermissionsApprenantState();
}

class _AllPermissionsApprenantState extends State<AllPermissionsApprenant> {
  List<PermissionApprenantModel> information = [];
  List<PermissionApprenantModel> permissionFilter = [];
  List<ApprenantModel> apprenants = [];
  List<ApprenantModel> apprenantsFilter = [];
  List<CentreModel> centres = [];
  List<PermissionApprenantModel> attente = [];
  List<PermissionApprenantModel> acordee = [];
  List<PermissionApprenantModel> noacordee = [];

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

  SlidableController slidableController;
  Icon _arrowLeft = Icon(Icons.keyboard_arrow_left_rounded);
  Animation<double> rotationAnimation;
  GetInfoDto infoDto = GetInfoDto();
  ValidatePermDto validateDto = ValidatePermDto();
  AddPermissionDto addPermDto = AddPermissionDto();
  final formKey = GlobalKey<FormState>();

  int selected = -1;
  bool isLoading;
  bool error = false;
  bool expandFlag = false;
  bool isAdmin = false;
  bool allChk = false;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: changeSlideArrowDirection,
    );
    addPermDto.uIdentifiant = widget.me.authKey;
    addPermDto.registrationId = "";

    validateDto.uIdentifiant = widget.me.authKey;
    validateDto.registrationId = "";

    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";

    _centreController.clear();
    _apprenantController.clear();
    getInfos();
    getCentre();
    getApprenants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> etatPermission = [
      ["Permissions en attentes", attente, Colors.grey[300]],
      ["Permissions acordées", acordee, Colors.green[100]],
      ["Permissions refusées", noacordee, Colors.red[100]],
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('permissions')),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 20.0),
            icon: Icon(
              Icons.refresh_rounded,
              size: 30.0,
            ),
            onPressed: () {
              getInfos();
              getCentre();
              getApprenants();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(context, null);
        },
        child: Icon(Icons.add_rounded),
      ),
      body: RefreshableWidget(
        onRefresh: () {
          getInfos();
          getCentre();
          getApprenants();
        },
        isLoading: isLoading,
        error: error,
        information: information,
        noDataText: Text(allTranslations.text('no_permission')),
        child: ListView(
          children: [
            /* Filtre par centre et personnel deb */
            /* Container(
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
                          hint: _centreController.text == ""
                              ? Text("Centre")
                              : Text(FunctionUtils.getCenterName(
                                  int.parse(_centreController.text), centres)),
                          onChanged: (value) {
                            filterPerCentre(
                                FunctionUtils.getCenterId(value, centres));
                            setState(() {
                              _centreController.text =
                                  FunctionUtils.getCenterId(value, centres)
                                      .toString();
                            });
                            filterInfo(
                              false,
                              _centreController.text,
                              _apprenantController.text,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2.3),
                        child: SearchableDropdown(
                          closeButton: "Fermer",
                          isExpanded: true,
                          items: apprenantsFilter
                              .map((apprenant) => DropdownMenuItem(
                                    child: Text(FunctionUtils.getApprenantName(
                                        apprenant.keyapprenant, apprenants)),
                                    value: FunctionUtils.getApprenantName(
                                        apprenant.keyapprenant, apprenants),
                                    onTap: () => print(apprenant.keyapprenant),
                                  ))
                              .toList(),
                          hint: _apprenantController.text == ""
                              ? Text("Apprenant")
                              : Text(FunctionUtils.getApprenantName(
                                  _apprenantController.text, apprenants)),
                          onChanged: (value) {
                            setState(() {
                              _apprenantController.text =
                                  FunctionUtils.getApprenantKey(
                                      value, apprenants);
                            });
                            filterInfo(
                              false,
                              _centreController.text,
                              _apprenantController.text,
                            );
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
                        activeColor: GreenLight,
                        secondary: const Text('Tout'),
                        value: allChk,
                        onChanged: (valueNew) {
                          setState(() {
                            allChk = valueNew;
                            _centreController.clear();
                            _apprenantController.clear();
                          });
                          listAll();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ), */
            // SizedBox(height: 5),
            /* Filtre par centre et personnel end */
            DoubleFilterPaneWidget(
              items1: centres
                  .map((centre) => DropdownMenuItem(
                        child: Text(centre.denominationCenter),
                        value: centre.denominationCenter,
                      ))
                  .toList(),
              items2: apprenantsFilter
                  .map((apprenant) => DropdownMenuItem(
                        child: Text(FunctionUtils.getApprenantName(
                            apprenant.keyapprenant, apprenants)),
                        value: FunctionUtils.getApprenantName(
                            apprenant.keyapprenant, apprenants),
                        onTap: () => print(apprenant.keyapprenant),
                      ))
                  .toList(),
              hint1: _centreController.text == ""
                  ? Text("Centre")
                  : Text(FunctionUtils.getCenterName(
                      int.parse(_centreController.text), centres)),
              hint2: _apprenantController.text == ""
                  ? Text("Apprenant")
                  : Text(FunctionUtils.getApprenantName(
                      _apprenantController.text, apprenants)),
              onChanged1: (value) {
                filterPerCentre(FunctionUtils.getCenterId(value, centres));
                setState(() {
                  _centreController.text =
                      FunctionUtils.getCenterId(value, centres).toString();
                });
                filterInfo(
                  false,
                  _centreController.text,
                  _apprenantController.text,
                );
              },
              onChanged2: (value) {
                setState(() {
                  _apprenantController.text =
                      FunctionUtils.getApprenantKey(value, apprenants);
                });
                filterInfo(
                  false,
                  _centreController.text,
                  _apprenantController.text,
                );
              },
              onChecked: (valueNew) {
                setState(() {
                  allChk = valueNew;
                  _centreController.clear();
                  _apprenantController.clear();
                });
              },
              listAll: () => listAll(),
              isSearchable: true,
            ),
            SizedBox(height: 5),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  /* children: index == 1
                      ? [
                          GroupedListView<PermissionApprenantModel, String>(
                            shrinkWrap: true,
                            primary: false,
                            elements: curentperm[1],
                            groupBy: (element) {
                              return element.isdemande;
                            },
                            groupSeparatorBuilder: (value) {
                              return Center(
                                  child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Grey,
                                // margin: EdgeInsets.all(10),
                                elevation: 2,
                                child: Text(
                                  value == "1" ? "DEMANDES" : "PERMISSIONS",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ));
                            },
                            groupComparator: (value1, value2) =>
                                value2.compareTo(value1),
                            itemBuilder: (context, element) {
                              return Slidable(
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
                                              DetailPermissionApprenant(
                                            me: widget.me,
                                            permission: element,
                                            centres: centres,
                                            apprenants: apprenants,
                                            isApprenant: false,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  element.status == "2"
                                      ? SizedBox(height: 0, width: 0)
                                      : IconSlideAction(
                                          caption: 'Plus',
                                          color: GreenLight,
                                          icon: Icons.edit,
                                          onTap: () {
                                            _moreAction(context, element);
                                          },
                                        ),
                                ],
                                child: PermissionApprenantCardWidget(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return DetailPermissionApprenant(
                                            me: widget.me,
                                            permission: element,
                                            centres: centres,
                                            apprenants: apprenants,
                                            isApprenant: false,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  permission: element,
                                  trailing: _arrowLeft,
                                ),
                              );
                            },
                          )
                        ]
                      : */
                  children: List.generate(
                      curentperm[1].length,
                      (i) => Slidable(
                            controller: slidableController,
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: checkActionable(curentperm[1][i])
                                ? <Widget>[
                                    IconSlideAction(
                                      caption: 'Detail',
                                      color: Grey,
                                      icon: Icons.remove_red_eye_rounded,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DetailPermissionApprenant(
                                              me: widget.me,
                                              permission: curentperm[1][i],
                                              centres: centres,
                                              apprenants: apprenants,
                                              isApprenant: false,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    curentperm[1][i].status == "2"
                                        ? SizedBox(height: 0, width: 0)
                                        : IconSlideAction(
                                            caption: 'Plus',
                                            color: GreenLight,
                                            icon: Icons.edit,
                                            onTap: () {
                                              _moreAction(
                                                  context, curentperm[1][i]);
                                            },
                                          ),
                                  ]
                                : null,
                            child: PermissionApprenantCardWidget(
                              isApprenant: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return DetailPermissionApprenant(
                                        me: widget.me,
                                        permission: curentperm[1][i],
                                        centres: centres,
                                        apprenants: apprenants,
                                        isApprenant: false,
                                      );
                                    },
                                  ),
                                );
                              },
                              permission: curentperm[1][i],
                              trailing: checkActionable(curentperm[1][i])
                                  ? _arrowLeft
                                  : null,
                            ),
                          ),
                      growable: true),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool checkActionable(PermissionApprenantModel perm) {
    bool result = true;
    if (perm.isdemande == "0" || perm.status == "2") {
      result = false;
    }
    return result;
  }

  void loading(bool load) {
    setState(() {
      isLoading = load;
      _centreController.clear();
      _apprenantController.clear();
    });
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      rotationAnimation = slideAnimation;
    });
  }

  void changeSlideArrowDirection(bool isOpen) {
    setState(() {
      _arrowLeft = isOpen
          ? Icon(Icons.keyboard_arrow_right_rounded)
          : Icon(Icons.keyboard_arrow_left_rounded);
    });
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

  renderPermColor(int etat) {
    Color result = etat == 0
        ? Colors.grey[300]
        : etat == 1
            ? Colors.green[100]
            : etat == 2
                ? Colors.red[100]
                : Colors.grey[200];
    return result;
  }

  getInfos() {
    Api api = ApiRepository();
    FunctionUtils.getData(
      context: context,
      dto: infoDto,
      startFunction: () => loading(true),
      stopFunction: () => loading(false),
      repositoryFunction: api.getPerms,
      onFailure: (value) {
        setState(() {
          error = value;
        });
      },
      onSuccess: (value) {
        setState(() {
          information = value.information;
          if (permissionFilter.length > 0) permissionFilter.clear();
          permissionFilter.addAll(information);
          allChk = true;
          permissionFilter.sort((a, b) =>
              DateTime.tryParse(b.datedemandepermission)
                  .compareTo(DateTime.tryParse(a.datedemandepermission)));
          separate(permissionFilter);
        });
      },
    );
  }

  getCentre() {
    print("En recuperation...");
    Api api = ApiRepository();
    api.getCentre(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              centres.clear();
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

  getApprenants() {
    print("En recuperation...");
    Api api = ApiRepository();
    api.getAprenants(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            setState(() {
              apprenants = a.information;
              apprenants.forEach((element) {
                print("\n Apprenants: " + element.toJson().toString());
              });
              apprenantsFilter.clear();
              apprenantsFilter.addAll(apprenants);
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
            setState(() {});
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
        dto: addPermDto,
        repositoryFunction: api.sendPerm,
        clearController: clearController,
        onSuccess: (a) {
          setState(() {
            information = a.information;
            if (permissionFilter.length > 0) permissionFilter.clear();
            permissionFilter.addAll(information);
            allChk = true;
            permissionFilter.sort((a, b) =>
                DateTime.tryParse(b.datedemandepermission)
                    .compareTo(DateTime.tryParse(a.datedemandepermission)));
          });
        },
        onFailure: () {});
  }

  /* sendPerm() {
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
                CircularProgressIndicator()
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
              if (permissionFilter.length > 0) permissionFilter.clear();
              permissionFilter.addAll(information);
              allChk = true;

              permissionFilter.sort((a, b) =>
                  a.datedemandepermission.compareTo(b.datedemandepermission));
            });
            return true;
          } else {
            //l'api a retourne une Erreur
            Navigator.of(context).pop(null);
            // Navigator.of(context).pop(null);
            FunctionUtils.displaySnackBar(context, a.message, type: 0);
            return false;
          }
        });
      } else {
        Navigator.of(context).pop(null);
        // Navigator.of(context).pop(null);
        FunctionUtils.displaySnackBar(
            context, allTranslations.text('error_process'));
        return false;
      }
    });
  } */

  void listAll() {
    filterInfo(true);
  }

  void filterInfo(bool tout, [String centre, String apprenant]) {
    // print("Filtering by: " + critere);
    setState(() {
      if (!tout) {
        permissionFilter = information
            .where(
              (perm) => ((centre.isEmptyOrNull
                      ? perm.keypermission.isNotEmpty
                      : perm.idCenter == centre) &&
                  (apprenant.isEmptyOrNull
                      ? perm.keypermission.isNotEmpty
                      : perm.keyapprenant == apprenant)),
            )
            .toList();
        allChk = false;
      } else {
        _centreController.text = "";
        _apprenantController.text = "";
        if (permissionFilter.length > 0) permissionFilter.clear();
        permissionFilter.addAll(information);

        allChk = true;
      }

      permissionFilter.sort((a, b) => DateTime.tryParse(b.datedemandepermission)
          .compareTo(DateTime.tryParse(a.datedemandepermission)));
      separate(permissionFilter);
    });
  }

/* ===== Filtrage par centre ===== */
  void filterPerCentre(int centerId) {
    setState(() {
      apprenantsFilter.clear();
      if (centerId != null) {
        apprenantsFilter = apprenants
            .filter((apprenants) => apprenants.idcentre == centerId.toString())
            .toList();
      } else {
        apprenantsFilter.addAll(apprenants);
      }
    });
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

  showForm(BuildContext context, PermissionApprenantModel permission) {
    if (permission != null) {
      _centreController.text = permission.idCenter.toString();
      _apprenantController.text = permission.keyapprenant;
      _motifController.text = permission.motifpermission;
      _datedebutController.text = permission.datedebutpermission;
      _datefinController.text = permission.datefinpermission;
      _heuredebutController.text = permission.heuredebutpermission;
      _heurefinController.text = permission.heurefinpermission;
      _datedemandeController.text = permission.datedemandepermission;
      addPermDto.permissionKey = permission.keypermission;
      addPermDto.operation = "2";
    } else {
      addPermDto.operation = "1";
    }

    centres.length == 1
        ? _centreController.text = centres.first.idCenter.toString()
        : null;

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
                        addPermDto.heureDebut =
                            _heuredebutController.text ?? "";
                        addPermDto.heureFin = _heurefinController.text ?? "";
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
      },
    ).then(
      (value) => clearController(),
    );
  }

  /// Confirmer l'accord ou le refus d'une permission
  // confirmDeleteTask(BuildContext context, PermissionApprenantModel permission) {
  Form permForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Liste des centre
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
                    filterPerCentre(FunctionUtils.getCenterId(value, centres));
                    setState(() {
                      _centreController.text =
                          FunctionUtils.getCenterId(value, centres).toString();
                    });
                  },
                ).py12()
              : SizedBox(height: 0),
          // Liste d'apprenant
          SearchableDropdown(
            isExpanded: true,
            // items: personnelsFilter
            items: apprenantsFilter
                .map((apprenant) => DropdownMenuItem(
                      child: Text(FunctionUtils.getApprenantName(
                          apprenant.keyapprenant, apprenants)),
                      // value: perso.keypersonnel,
                      value: FunctionUtils.getApprenantName(
                          apprenant.keyapprenant, apprenants),
                      onTap: () => print(apprenant.keyapprenant),
                    ))
                .toList(),
            hint: _apprenantController.text == ""
                ? Text("Apprenant")
                : Text(FunctionUtils.getApprenantName(
                    _apprenantController.text, apprenants)),
            onChanged: (value) {
              setState(() {
                _apprenantController.text =
                    FunctionUtils.getApprenantKey(value, apprenants);
              });
            },
          ).py12(),
          // Motif
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
          // Date demande commente
          /* TextFormField(
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
          ), */
          // Date demande
          DateTimePicker(
            type: DateTimePickerType.date,
            timeFieldWidth: 55,
            dateMask: 'd MMM, yyyy',
            controller: _datedemandeController,
            locale: Locale('fr'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: Icon(Icons.date_range),
            use24HourFormat: true,
            validator: (value) {
              if (value.isEmpty) {
                return allTranslations.text('pls_set_datedemande');
              }
              return null;
            },
            dateLabelText: allTranslations.text('datedemande'),
            onChanged: (val) {
              print(val);
              setState(() {
                _datedemandeController.text = val.toString().split(".")[0];
              });
            },
            onSaved: (val) {
              print(val);
              setState(() {
                _datedemandeController.text = val.toString().split(".")[0];
              });
            },
          ).py12(),
          // Date debut
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
          // Date fin
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

  _confirmPermValidation(
      BuildContext context, dynamic permission, bool accepted) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Confirmer"),
        content: Text(
          "Confirmer " +
              (accepted ? "l'accord" : "le refus") +
              " de cette permission",
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
                validateDto.uIdentifiant = widget.me.authKey;
                validateDto.registrationId = "";
                validateDto.idCenter = permission.idCenter;
                validateDto.permissionKey = permission.keypermission;
              });
              Navigator.pop(context);
              validate(accepted);
            },
          ),
        ],
      ),
    );
  }

  void _moreAction(context, PermissionApprenantModel permission) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        ///Liste de des actions
        List<Widget> listAction = <Widget>[];

        //si la pemission est deja refusee on ne peut plus la modifier
        if (permission.status == "2" || permission.isdemande == "0") {
          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel,
              color: Grey,
            ),
            title: Text('Aucune action supplémentaire disponible'),
          ));
        }
        //si la pemission est deja validee on ne peut plus la modifier
        else if (permission.status == "1" && permission.isdemande == "1") {
          /* listAction.add(ListTile(
            leading: Icon(
              Icons.cancel_rounded,
              color: Colors.red[300],
            ),
            title: Text('Refuser'),
            onTap: () {
              Navigator.of(context).pop(null);
              _confirmPermValidation(context, permission, false);
            },
          )); */
          listAction.add(ListTile(
            leading: Icon(
              Icons.edit_rounded,
              color: Colors.blue[300],
            ),
            title: Text("Modifier"),
            onTap: () {
              Navigator.of(context).pop(null);
              showForm(context, permission);
            },
          ));
        }
        // On peut tout faire sauf modifier pour une demande
        else if (permission.status == "0") {
          listAction.add(ListTile(
            leading: Icon(
              Icons.check_circle_rounded,
              color: GreenLight,
            ),
            title: Text('Accorder'),
            onTap: () {
              Navigator.of(context).pop(null);
              _confirmPermValidation(context, permission, true);
            },
          ));
          listAction.add(ListTile(
            leading: Icon(
              Icons.cancel_rounded,
              color: Colors.red[300],
            ),
            title: Text('Refuser'),
            onTap: () {
              Navigator.of(context).pop(null);
              _confirmPermValidation(context, permission, false);
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

/* End */
}
