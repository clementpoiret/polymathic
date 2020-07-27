import 'package:flutter/material.dart';
import 'package:polymathic/components/tag.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/utils/constants.dart';
import 'package:polymathic/utils/task.dart';
import 'package:polymathic/utils/stat.dart';

class TaskItem extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskItem({
    Key key,
    @required this.task,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isDone = false;
  Stat stat;

  final dbHelper = DatabaseHelper.instance;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Checkbox(
              activeColor: kPrimaryColor,
              value: isDone,
              onChanged: (value) {
                setState(() {
                  isDone = value;
                });

                if (isDone) {
                  _delete();
                  stat.insert();
                } else {
                  _reinsert();
                  stat.delete();
                }
              },
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
                    style: isDone
                        ? TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    getAdvice(widget.task),
                    style: isDone
                        ? TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          )
                        : TextStyle(
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

  void _delete() async {
    final rowsDeleted = await dbHelper.delete(
      DatabaseHelper.tasksTable,
      widget.task['_id'],
    );
    print('deleted $rowsDeleted task(s): task ${widget.task['_id']}');
  }

  void _reinsert() async {
    final id = await dbHelper.insert(
      DatabaseHelper.tasksTable,
      widget.task,
    );
    print('reinserted task: $id');
  }
}
