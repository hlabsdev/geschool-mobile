import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/mission_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/repositories/api_repository.dart';
import 'package:geschool/features/launch/presentation/pages/missions/all_missions.dart';
import 'package:geschool/features/launch/presentation/widgets/cards/mission_card_widget.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/refreshable_widget.dart';

// ignore: must_be_immutable
class MyMissions extends StatefulWidget {
  UserModel me;
  MyMissions({this.me});
  @override
  _MyMissionsState createState() => _MyMissionsState();
}

class _MyMissionsState extends State<MyMissions> {
  List<MissionModel> information = [];
  List<MissionModel> mesInformations = [];
  List<MissionModel> avenir = [];
  List<MissionModel> encour = [];
  List<MissionModel> passee = [];
  GetInfoDto infoDto = GetInfoDto();
  bool isLoading;
  bool error = false;
  bool isAdmin = false;
  int isExpanded1 = 1;
  int isExpanded2 = 2;
  int isExpanded3 = 3;
  int selected = 0;

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
        title: Text(allTranslations.text('my_missions')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 20.0),
            icon: Icon(
              Icons.refresh_rounded,
              size: 30.0,
            ),
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
                          builder: (context) =>
                              AllMissions(me: widget.me, missions: information),
                        ));
                  },
                )
              : Text(''),
        ],
      ),
      body: RefreshableWidget(
        onRefresh: getInfos,
        isLoading: isLoading,
        error: error,
        information: mesInformations,
        noDataText: isAdmin
            ? Text(
                allTranslations.text('no_my_mission') +
                    "\n" +
                    allTranslations.text('can_see_all').toLowerCase() +
                    allTranslations.text('missions').toLowerCase(),
                textAlign: TextAlign.center)
            : Text(allTranslations.text('no_my_mission')),
        child: ListView(
          children: [
            /* Expansions deb */
            SizedBox(height: 8),
            ExpansionTile(
              collapsedBackgroundColor: Colors.orange[100],
              initiallyExpanded: isExpanded1 == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = isExpanded1;
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
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  ("Missions à venir").toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  avenir.length,
                  (i) =>
                      MissionCardWidget(isAdmin: isAdmin, mission: avenir[i]),
                  growable: true),
            ),
            SizedBox(height: 8),
            ExpansionTile(
              collapsedBackgroundColor: Colors.green[100],
              initiallyExpanded: isExpanded2 == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = isExpanded2;
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
                  color: Colors.green[100],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  ("Missions en cours").toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  encour.length,
                  (i) =>
                      MissionCardWidget(isAdmin: isAdmin, mission: encour[i]),
                  growable: true),
            ),
            SizedBox(height: 8),
            ExpansionTile(
              collapsedBackgroundColor: Colors.grey[400],
              initiallyExpanded: isExpanded3 == selected,
              onExpansionChanged: (value) {
                if (value)
                  setState(() {
                    Duration(seconds: 20000);
                    selected = isExpanded3;
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
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  ("Missions passées").toUpperCase(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              children: List.generate(
                  passee.length,
                  (i) =>
                      MissionCardWidget(isAdmin: isAdmin, mission: passee[i]),
                  growable: true),
            ),
            /* Expansions end */
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

  // ignore: missing_return
  void getInfos() {
    print("En recuperation...");
    loading(true);
    Api api = ApiRepository();
    api.getMissions(infoDto).then((value) {
      if (value.isRight()) {
        value.all((a) {
          if (a != null && a.status.compareTo("000") == 0) {
            //enregistrement des informations de recuperes
            setState(() {
              information = a.information;
              mesInformations =
                  a.information.where((element) => element.isMe == 1).toList();

              passee.clear();
              avenir.clear();
              encour.clear();
              passee = mesInformations
                  .where((element) =>
                      FunctionUtils.getDateEtat(
                          element.datedepart, element.dateretourprob) ==
                      1)
                  .toList();
              avenir = mesInformations
                  .where((element) =>
                      FunctionUtils.getDateEtat(
                          element.datedepart, element.dateretourprob) ==
                      2)
                  .toList();
              encour = mesInformations
                  .where((element) =>
                      FunctionUtils.getDateEtat(
                          element.datedepart, element.dateretourprob) ==
                      3)
                  .toList();
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
      }
    }, onError: (error) {
      // setState(() {
      //   error = true;
      // });
      loading(false);
      FunctionUtils.displaySnackBar(context, error.message);
    });
  }

/* End */
}
