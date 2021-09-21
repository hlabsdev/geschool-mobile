/* @Hlabs */
import 'package:flutter/material.dart';
import 'package:geschool/allTranslations.dart';

// ignore: must_be_immutable
class RefreshableWidget extends StatefulWidget {
  RefreshableWidget({
    Key key,
    @required this.isLoading,
    @required this.error,
    @required this.information,
    @required this.onRefresh,
    @required this.child,
    @required this.noDataText,
  }) : super(key: key);

  bool isLoading;
  bool error;
  List<dynamic> information;
  Function onRefresh;
  Widget child;
  Text noDataText;

  @override
  _RefreshableWidgetState createState() => _RefreshableWidgetState();
}

class _RefreshableWidgetState extends State<RefreshableWidget> {
  String message = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 75,
      strokeWidth: 2.5,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 800));
        widget.onRefresh();
        setState(() {});
        return null;
      },
      child: Builder(builder: (_) {
        if (widget.isLoading) {
          return ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: (MediaQuery.of(context).size.height) / 4),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/img/loading.gif',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  Text(allTranslations.text('loading')),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          );
        }
        if (widget.error) {
          return ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: (MediaQuery.of(context).size.height) / 2.5),
            children: [
              Center(
                  child: Text(
                allTranslations.text('error_process'),
                textAlign: TextAlign.center,
              )),
            ],
          );
        }
        if (widget.information.length == 0 || widget.information == null) {
          return ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: (MediaQuery.of(context).size.height) / 2.5),
            children: [
              Center(child: widget.noDataText),
            ],
          );
        }
        return Scrollbar(
          // isAlwaysShown: true,
          // controller: _scrollbarController,
          radius: Radius.circular(10),
          thickness: 5,
          child: widget.child,
        );
      }),
    );
  }
}
