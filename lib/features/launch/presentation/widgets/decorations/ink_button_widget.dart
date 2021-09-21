import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';

// ignore: must_be_immutable
class InkValidationButton extends StatelessWidget {
  String buttontext;
  void Function() onPressed;
  List<Color> colors;

  InkValidationButton({
    Key key,
    this.buttontext,
    this.onPressed,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors ?? [GreenLight, PafpeGreen]),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(2, 5),
            color: Colors.grey,
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttontext,
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
