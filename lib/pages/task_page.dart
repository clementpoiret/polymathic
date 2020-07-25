import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:polymathic/components/tasks_list.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/utils/constants.dart';
import 'package:polymathic/utils/task.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int nTasks = 0;
  bool _isAddTaskVisible = false;
  bool _isAddable = false;
  bool isImportant = false;
  bool isUrgent = false;
  String taskContent = '';

  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> taskList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: _isAddTaskVisible,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 16.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Task',
                              border: InputBorder.none,
                              hintText: 'Enter your task here',
                            ),
                            onChanged: (value) {
                              taskContent = value;

                              setState(() {
                                if (value != null && value != '') {
                                  _isAddable = true;
                                } else {
                                  _isAddable = false;
                                }
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _isAddable,
                          child: RawMaterialButton(
                            child: Icon(
                              MaterialIcons.add,
                              color: kPrimaryColor,
                            ),
                            shape: CircleBorder(
                              side: BorderSide(color: kPrimaryColor),
                            ),
                            onPressed: () {
                              Task task = Task(
                                  content: taskContent,
                                  isImportant: isImportant ? 1 : 0,
                                  isUrgent: isUrgent ? 1 : 0);
                              _onPressAddButton(task);
                              setState(() {
                                _isAddTaskVisible = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0x14000000),
                    child: Column(
                      children: <Widget>[
                        SwitchListTile(
                          activeColor: kPrimaryColor,
                          value: isImportant,
                          title: Text('Important task'),
                          onChanged: (bool value) {
                            setState(() {
                              isImportant = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          activeColor: kPrimaryColor,
                          value: isUrgent,
                          title: Text('Urgent task'),
                          onChanged: (bool value) {
                            setState(() {
                              isUrgent = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            replacement: Container(
              width: double.infinity,
              child: DottedBorder(
                color: Colors.grey,
                borderType: BorderType.RRect,
                strokeWidth: 1.0,
                dashPattern: [8, 8],
                radius: Radius.circular(8.0),
                padding: EdgeInsets.all(6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                        child: Icon(
                          MaterialIcons.add,
                          color: Colors.white,
                        ),
                        shape: CircleBorder(
                          side: BorderSide(color: kAccentColor),
                        ),
                        fillColor: kAccentColor,
                        onPressed: () {
                          ivyLeeCheck();
                        },
                      ),
                      Text(
                        'Add a new task',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          TasksList(
            taskList: taskList,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _insert(Task task) async {
    Map<String, dynamic> row = task.toMap();
    final id = await dbHelper.insert(DatabaseHelper.tasksTable, row);
    print('inserted row: $id');
  }

  void _onPressAddButton(Task task) {
    print(task.toMap());
    _insert(task);
    _query();
    _isAddable = false;
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tasksTable);
    final rowCount = await dbHelper.queryRowCount(DatabaseHelper.tasksTable);

    setState(() {
      taskList = allRows;
      nTasks = rowCount;
    });
  }

  void ivyLeeCheck() {
    void _showForm() {
      setState(() {
        _isAddTaskVisible = true;
      });
    }

    if (nTasks < 6) {
      _showForm();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wow, that\'s a lot!'),
            content: Text(
                'You already have 6 scheduled tasks for today.\nAccording to the Ivy Lee Method for productivity, you should focus on those 6 tasks before adding more.'),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("PROCEED ANYWAY"),
                onPressed: () {
                  _showForm();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
