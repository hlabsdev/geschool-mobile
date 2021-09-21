import 'package:flutter/material.dart';

class CardMenuBtn extends StatelessWidget {
  final String imgpath;
  final String text;
  final Function press;
  final Color color;
  final double height;
  final double width;
  final double scale;
  final double fontsize;

  const CardMenuBtn({
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
    return InkWell(
      onTap: press,
      child: SizedBox(
        width: width ?? 100,
        height: height ?? 100,
        child: Card(
          color: Colors.grey[100],
          // color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                /* decoration: BoxDecoration(
                  color: Colors.grey[200],
                  // color: Colors.white,
                  // border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ), */
                child: Image.network(
                  imgpath,
                  color: color ?? Colors.black87,
                  fit: BoxFit.scaleDown,
                  scale: scale ?? 2.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text.toUpperCase(),
                  // style: Theme.of(context).textTheme.bodyText1,
                  style: TextStyle(fontSize: fontsize ?? 10.0),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
