import 'package:flutter/material.dart';

class ListMenuBtn extends StatelessWidget {
  final String imgpath;
  final String text;
  final Function press;
  final Color color;
  final double height;
  final double width;
  final double scale;
  final double fontsize;

  const ListMenuBtn({
    Key key,
    this.imgpath,
    this.text,
    this.press,
    this.color,
    this.height,
    this.width,
    this.scale,
    this.fontsize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: ListTile(
        tileColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Container(
          padding: EdgeInsets.all(8),
          child: Image.network(
            imgpath,
            color: color ?? Colors.black87,
            fit: BoxFit.scaleDown,
            scale: scale ?? 2.5,
          ),
        ),
        title: Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: fontsize ?? 15.0),
          // textAlign: TextAlign.center,
          softWrap: true,
        ),
        onTap: press,
      ),
    );
  }
}
