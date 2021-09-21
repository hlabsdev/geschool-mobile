import 'package:geschool/features/common/data/function_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>{


  void showErrorDialog(String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Erreur",
      desc: "$message",
      //image: Image.asset("assets/img/menu_rdv.png"),
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Fermer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void showSuccessDialog(String message) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Succès",
      desc: "$message",
      //image: Image.asset("assets/img/menu_rdv.png"),
      buttons: [
        DialogButton(
          color: FunctionUtils.colorFromHex(contentPrimaryColor),
          child: Text(
            "Fermer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => actionToDo(),
          width: 120,
        )
      ],
    ).show();
  }

  void actionToDo();
}