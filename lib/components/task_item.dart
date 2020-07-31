import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:polymathic/components/tag.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/utils/stat.dart';
import 'package:polymathic/utils/task.dart';

class TaskItem extends StatefulWidget {
  final Function notifyParent;
  final Map<String, dynamic> task;

  const TaskItem({
    Key key,
    @required this.task,
    @required this.notifyParent,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Stat stat;

  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 4.0),
                  child: InkWell(
                    child: Icon(
                      Ionicons.md_done_all,
                    ),
                    onTap: () {
                      confirmCompletion();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 0.0),
                  child: InkWell(
                    child: Icon(
                      Ionicons.md_remove_circle_outline,
                    ),
                    onTap: () {
                      confirmDeletion();
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 32.0,
              width: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.task['content'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    getAdvice(widget.task),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  if (widget.task['important'] == 1 ||
                      widget.task['urgent'] == 1)
                    SizedBox(
                      height: 8.0,
                    ),
                  if (widget.task['important'] == 1 ||
                      widget.task['urgent'] == 1)
                    Row(
                      children: <Widget>[
                        if (widget.task['important'] == 1)
                          Tag(
                            text: 'Important',
                            color: Colors.indigo[400],
                            textColor: Colors.white,
                          ),
                        if (widget.task['important'] == 1)
                          SizedBox(
                            width: 8.0,
                          ),
                        if (widget.task['urgent'] == 1)
                          Tag(
                            text: 'Urgent',
                            color: Colors.pink[400],
                            textColor: Colors.white,
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void completeTask({Function onComplete}) {
    print('DELETING TASK AND ADDING STAT');
    _deleteTask();
    _insertStat();
    onComplete();
  }

  void confirmCompletion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Did you finish that task?'),
          content: Text(
              'You are about to mark it as completed. This completion will be added to your statistical reports.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("CONTINUE"),
              onPressed: () {
                completeTask(onComplete: widget.notifyParent);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void confirmDeletion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove that task?'),
          content: Text(
              'You are about to remove the task. It will no longer appear in your statistics.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("CONTINUE"),
              onPressed: () {
                removeTask(onComplete: widget.notifyParent);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    stat = Stat(
      important: widget.task['important'],
      urgent: widget.task['urgent'],
      added: 0,
      removed: 1,
    );
  }

  void removeTask({Function onComplete}) {
    print('REMOVING TASK AND ADDING STAT');
    stat = Stat(
      important: widget.task['important'],
      urgent: widget.task['urgent'],
      added: -1,
      removed: 0,
    );

    _deleteTask();
    _insertStat();
    onComplete();
  }

  void _deleteStat() async {
    final rowsDeleted = await dbHelper.delete(
      DatabaseHelper.statsTable,
      stat.id,
    );
    print('deleted $rowsDeleted stat(s): stat ${stat.id}');
  }

  void _deleteTask() async {
    final rowsDeleted = await dbHelper.delete(
      DatabaseHelper.tasksTable,
      widget.task['_id'],
    );
    print('deleted $rowsDeleted task(s): task ${widget.task['_id']}');
  }

  void _insertStat() async {
    final id = await dbHelper.insert(
      DatabaseHelper.statsTable,
      stat.toMap(),
    );
    print('inserted stat: $id');
  }

  void _reinsertTask() async {
    final id = await dbHelper.insert(
      DatabaseHelper.tasksTable,
      widget.task,
    );
    print('reinserted task: $id');
  }
}
