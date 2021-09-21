import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/common/data/models/basemodels/mission_model.dart';
import 'package:geschool/features/launch/presentation/pages/missions/detail_mission.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/core/utils/preference.dart';

class MissionCardWidget extends StatelessWidget {
  const MissionCardWidget({
    Key key,
    @required this.isAdmin,
    @required this.mission,
  }) : super(key: key);

  final bool isAdmin;
  final MissionModel mission;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: FunctionUtils.missionCardColor(mission),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        focusColor: Colors.grey[300],
        leading: Icon(
          Icons.time_to_leave_rounded,
          color: Colors.grey[700],
          size: 50,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        title: SizedBox(
          width: (MediaQuery.of(context).size.width / 2),
          child: Text(
            mission.lieumission,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: GreenLight,
            ),
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(right: 8.0, bottom: 8),
          child: Column(
            children: [
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Départ:",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Retour estimé:",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
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
                      FunctionUtils.convertFormatDate(mission.datedepart),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      FunctionUtils.convertFormatDate(mission.dateretourprob),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DetailMission(
                  mission: mission,
                  isAdmin: isAdmin,
                  me: UserModel.fromJson(json.decode(UserPreferences().user)),
                ),
              ))
        },
      ),
    );
  }
}
