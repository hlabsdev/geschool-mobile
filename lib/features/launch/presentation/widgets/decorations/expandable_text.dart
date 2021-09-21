// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:geschool/features/common/data/function_utils.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, this.title);

  final String text;
  final String title;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.text.length > 150 ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: isExpanded
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 50.0),
          child: Text(widget.text,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey[800],
              )),
        ),
        isExpanded
            ? const SizedBox(height: 0, width: 0)
            : Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: const Text('Voir plus...'),
                  onPressed: () {
                    FunctionUtils.shoDetailPop(
                        context, widget.title, widget.text);
                  },
                ),
              ),
      ],
    );
  }
}
