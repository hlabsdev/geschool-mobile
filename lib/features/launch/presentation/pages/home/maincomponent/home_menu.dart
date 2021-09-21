import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/features/launch/presentation/widgets/menus/small_item_menu.dart';
import 'package:geschool/features/launch/presentation/widgets/decorations/custom_shape.dart';

// ignore: must_be_immutable
class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  UserModel me;

  @override
  void initState() {
    me = UserModel.fromJson(json.decode(UserPreferences().user));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(color: Colors.grey[100]),
          // decoration: BoxDecoration(color: Colors.white54),
          child: Column(
            children: [
              ClipPath(
                clipper:
                    CustomShape(), // this is my own class which extendsCustomClipper
                child: Container(
                  height: 150,
                  color: PafpeGreen,
                ),
              ),
              SizedBox(height: 60),
              Center(child: SmallItemMenu(me)),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
