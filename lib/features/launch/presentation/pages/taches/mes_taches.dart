import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/tache_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/taches/all_taches.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/tache_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class MyTasks extends StatefulWidget {
  UserModel me;
  MyTasks({this.me});

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  final _datePickerKey = GlobalKey();
  List<TacheModel> information = [];
  List<TacheModel> mesInformations = [];
  List<TacheModel> tachesFilter = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  bool allChk = false;
  String sousTitreChecbox;
  SlidableController slidableController;

  @override
  void initState() {
    infoDto.uIdentifiant = widget.me.authKey;
    infoDto.registrationId = "";
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('my_tasks')),
        elevation: 0,
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
            },
          ),
          isAdmin
              ? IconButton(
                  padding: EdgeInsets.only(right: 20.0),
                  icon: Icon(
                    Icons.list_rounded,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllTasks(
                            me: widget.me,
                            taches: information,
                          ),
                        ));
                  },
                )
              : Text(""),
        ],
      ),
      // bottomNavigationBar: BottomNavBar(),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: mesInformations,
        noDataText: isAdmin
            ? Text(
                allTranslations.text('no_my_tache') +
                    "\n" +
                    allTranslations.text('can_see_all').toLowerCase() +
                    allTranslations.text('taches').toLowerCase(),
                textAlign: TextAlign.center)
            : Text(allTranslations.text('no_my_tache')),
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              color: Colors.yellow[200],
              child: DatePicker(
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
            Container(
              color: Colors.grey[100],
              child: CheckboxListTile(
                tristate: false,
                secondary: const Icon(
                  Icons.filter_alt_rounded,
                ),
                title: const Text('Tout'),
                subtitle: Text(allTranslations.text('can_filter_per_date')),
                value: allChk,
                onChanged: (valueNew) {
                  setState(() {
                    allChk = valueNew;
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
              itemCount: tachesFilter.length,
              itemBuilder: (context, i) {
                return TacheCardWidget(
                    tache: tachesFilter[i], isAdmin: isAdmin, isAll: false);
              },
            ),
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

  void checkAdmin(int value) {
    setState(() {
      isAdmin = value == 1 ? true : false;
    });
  }

  void filterTache(DateTime date) {
    setState(() {
      if (date != null) {
        tachesFilter.clear();
        // tachesFilter = mesInformations
        tachesFilter = mesInformations
            .filter(
                (task) => DateTime.parse(task.dateTache).compareTo(date) == 0)
            .toList();
        allChk = false;
        // _datePickerKey.
        sousTitreChecbox = 'Filtré par date';
      } else {
        allChk = true;
        tachesFilter.clear();
        // tachesFilter.addAll(mesInformations);
        tachesFilter.addAll(mesInformations);
        sousTitreChecbox = 'Sans filtre';
      }

      FunctionUtils.sortTaches(tachesFilter);
    });
  }

  void listAll() {
    allChk == true ? filterTache(null) : filterTache(DateTime.now());
  }

  // ignore: missing_return
  // void getInfos() {
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
              information = a.information;
              mesInformations =
                  a.information.where((element) => element.isMe == 1).toList();
              tachesFilter.clear();
              tachesFilter.addAll(mesInformations);
              FunctionUtils.sortTaches(tachesFilter);
              allChk = true;
            });
            loading(false);
            checkAdmin(a.isAdmin);
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

/* End */
}
