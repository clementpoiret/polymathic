import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polymathic/components/task_item.dart';
import 'package:polymathic/utils/task.dart';

class TasksList extends StatefulWidget {
  const TasksList({
    Key key,
    @required this.taskList,
  }) : super(key: key);

  final List<Map<String, dynamic>> taskList;

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool _isListVisible = true;
  final String _emptySvg = 'assets/svg/empty.svg';

  @override
  Widget build(BuildContext context) {
    int nTask = widget.taskList.length;

    if (nTask == 0) {
      setState(() {
        _isListVisible = false;
      });
    } else {
      setState(() {
        _isListVisible = true;
      });
    }

    return Expanded(
      child: Visibility(
        visible: _isListVisible,
        child: ListView(
          children: <Widget>[
            for (var task in sortTasks(widget.taskList)) TaskItem(task: task),
          ],
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
