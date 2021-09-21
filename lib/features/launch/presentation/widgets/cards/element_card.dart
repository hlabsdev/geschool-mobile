import 'package:flutter/material.dart';

class ElementCard extends StatelessWidget {
  final String pngSrc;
  final String title;
  final Function press;
  const ElementCard({
    Key key,
    this.pngSrc,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      elevation: 5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Spacer(),
                Image.asset(
                  pngSrc,
                  scale: 1.3,
                ),
                // Spacer(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      // ignore: deprecated_member_use
                      Theme.of(context).textTheme.title.copyWith(fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
