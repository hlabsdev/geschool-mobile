import 'package:flutter/material.dart';
import 'dart:math' as math;

/* ============================= Fab element deb ============================= */
/// @Hlabs: Class for builduing fab withing a ```MultiFabWidget```
class FabElement {
  const FabElement({
    Key key,
    this.tooltip,
    @required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.onPressed,
  });

  /// for showhing a tooltip on long press
  final String tooltip;

  ///The icon show by this element (Obligatoire). exemple:
  ///```dart
  ///Icons.edit_rounded
  ///```
  final IconData icon;

  ///Colors shown on the background
  final Color backgroundColor;

  ///the icon color
  final Color iconColor;

  /// The function to execute onPressed event
  final void Function() onPressed;
}
/* ============================= Fab element deb ============================= */

/* ========================== Multi fab Widget deb ========================== */
/// @Hlabs: Widget for creating a multiple floating action button
/// Note: Before using this make sure to add the ```TickerProviderStateMixin``` mixin to the classe.
/// exemple:
/// ```dart
/// class _DetailPermissionApprenantState extends State<DetailPermissionApprenant> with TickerProviderStateMixin {....}
/// ```
class MultiFabWidget extends StatelessWidget {
  const MultiFabWidget({
    Key key,
    @required this.childrens,
    @required this.controller,
  }) : super(key: key);

  /// list of ```FabElement``` (Obligatoire)
  final List<FabElement> childrens;

  /// Animation controller for fade out/fade in animation (Obligatoire)
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(childrens.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: controller,
              curve: new Interval(0.0, 1.0 - index / childrens.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: childrens[index].backgroundColor,
              mini: true,
              tooltip: childrens[index].tooltip,
              child: new Icon(childrens[index].icon,
                  color: childrens[index].iconColor),
              onPressed: () {
                childrens[index].onPressed();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      controller.isDismissed ? Icons.menu : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (controller.isDismissed) {
                controller.forward();
              } else {
                controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
/* ========================== Multi fab Widget end ========================== */
