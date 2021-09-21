import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/common/data/models/respmodels/bulletin_list_response_model.dart';
import 'package:geschool/features/launch/presentation/pages/bulletins/detail_bulletin.dart';

// ignore: must_be_immutable
class EleveBulletinWidget extends StatefulWidget {
  EleveBulletinWidget({
    Key key,
    @required this.information,
  }) : super(key: key);
  ApprenantBulletin information;
  @override
  _EleveBulletinWidgetState createState() => _EleveBulletinWidgetState();
}

class _EleveBulletinWidgetState extends State<EleveBulletinWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 10),
        widget.information.decoupages == null
            ? Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: (MediaQuery.of(context).size.height) / 3),
                child: Center(
                  child: Text("Aucun bulletin disponible."),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: widget.information.decoupages.length,
                itemBuilder: (context, index) {
                  // itemBuilder: (context, element) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: ListTile(
                      focusColor: Colors.grey[300],
                      leading: Icon(Icons.list_alt_rounded,
                          color: Colors.lime[600], size: 30),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      title: Text(
                        widget.information.decoupages[index].libelledecoupage,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: GreenLight,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(allTranslations.text('specialite') +
                                  ":\t" +
                                  widget.information.decoupages[index].datas
                                      .bulletin.libellespecialite ??
                              allTranslations.text('not_defined')),
                          Text(allTranslations.text('classe') +
                                  ":\t " +
                                  widget.information.decoupages[index].datas
                                      .bulletin.libelleclasse ??
                              allTranslations.text('not_defined')),
                        ],
                      ),
                      // trailing: IconButton(
                      //   iconSize: 20,
                      //   icon: Icon(Icons.navigate_next_sharp),
                      //   onPressed: () => {null},
                      //   tooltip: "Detail",
                      // ),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => DetailBulletin(
                                  detail: widget.information.decoupages[index]
                                      .datas.bulletin,
                                  me: UserModel.fromJson(
                                      json.decode(UserPreferences().user))),
                            ))
                      },
                      // isThreeLine: true,
                    ),
                  );
                },
                // separatorBuilder: (context, i) => Divider(),
              ),
        SizedBox(height: 10),
      ],
    );
  }
}
/* ===================== */
