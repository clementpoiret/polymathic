import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polymathic/components/task_item.dart';
import 'package:polymathic/i18n/strings.g.dart' show t;
import 'package:polymathic/utils/task.dart';

class TasksList extends StatefulWidget {
  final Function notifyParent;
  final List<Map<String, dynamic>> taskList;

  const TasksList({
    Key key,
    @required this.notifyParent,
    @required this.taskList,
  }) : super(key: key);

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
            for (var task in sortTasks(widget.taskList))
              TaskItem(
                task: task,
                notifyParent: widget.notifyParent,
              ),
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
              t.noOngoingTasks,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
