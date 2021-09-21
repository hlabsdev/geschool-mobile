import 'package:geschool/features/common/data/function_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

abstract class FeedBackMeassage {
  BuildContext _buildContext;
  String _message;

  FeedBackMeassage(this._buildContext, this._message);

  void showErrorDialog() {
    Alert(
      context: _buildContext,
      type: AlertType.error,
      title: "Erreur",
      desc: "$_message",
      //image: Image.asset("assets/img/menu_rdv.png"),
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Fermer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(_buildContext),
          width: 120,
        )
      ],
    ).show();
  }

  void showSuccessDialog() {
    Alert(
      context: _buildContext,
      type: AlertType.success,
      title: "Succès",
      desc: "$_message",
      //image: Image.asset("assets/img/menu_rdv.png"),
      buttons: [
        DialogButton(
          color: FunctionUtils.colorFromHex(contentPrimaryColor),
          child: Text(
            "Fermer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(_buildContext),
          width: 120,
        )
      ],
    ).show();
  }

  void actionToDo();
}
