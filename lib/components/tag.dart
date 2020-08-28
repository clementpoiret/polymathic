import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  const Tag({
    Key key,
    @required this.text,
    @required this.color,
    this.textColor,
  }) : super(key: key);

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
