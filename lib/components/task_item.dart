import 'package:flutter/material.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/utils/constants.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key key,
    @required this.task,
  }) : super(key: key);

  final Map<String, dynamic> task;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isDone = false;

  final dbHelper = DatabaseHelper.instance;

  void _delete() async {
    final rowsDeleted = await dbHelper.delete(widget.task['_id']);
    print('deleted $rowsDeleted row(s): row ${widget.task['_id']}');
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
                _delete();
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
                    style: TextStyle(fontSize: 16),
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
}

class Tag extends StatelessWidget {
  const Tag({
    Key key,
    @required this.text,
    @required this.color,
    @required this.textColor,
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
