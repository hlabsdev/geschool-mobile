import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/launch/presentation/pages/home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 50,
        color: Colors.grey[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // children: listIcon,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(),
                  ),
                );
/* 
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    maintainState: true,
                    opaque: true,
                    pageBuilder: (context, __, ___) => Home(index: 1),
                    // transitionDuration: const Duration(seconds: 2),
                  ),
                ); */
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/icons/Home.svg",
                    height: 22,
                    color: BottomIcon,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Acueil",
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: BottomIcon),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
