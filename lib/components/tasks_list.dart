import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  int nTasks = 0;
  bool _isListVisible = false;
  final String _emptySvg = 'assets/svg/empty.svg';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: _isListVisible,
        child: Container(
          color: Colors.amber,
          height: 64.0,
        ),
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              _emptySvg,
              height: 256,
              semanticsLabel: 'No tasks',
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'There are no ongoing tasks :(',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
