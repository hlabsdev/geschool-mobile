import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';

class MyNotifications extends StatefulWidget {
  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('notifications')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      body: Container(
        child: Center(
          child: Text("Nothing here"),
        ),
      ),
    );
  }
}
