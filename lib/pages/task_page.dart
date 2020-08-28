import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:polymathic/components/tasks_list.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/i18n/strings.g.dart' show t;
import 'package:polymathic/utils/constants.dart';
import 'package:polymathic/utils/stat.dart';
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
  double duration = 1.0;
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
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: t.yourTask,
                              border: InputBorder.none,
                              hintText: t.enterYourTask,
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
                              color: kAccentColor,
                            ),
                            shape: CircleBorder(
                              side: BorderSide(color: kAccentColor),
                            ),
                            onPressed: () {
                              Task task = Task(
                                content: taskContent,
                                isImportant: isImportant ? 1 : 0,
                                isUrgent: isUrgent ? 1 : 0,
                                duration: duration,
                              );

                              Stat stat = Stat(
                                urgent: isUrgent ? 1 : 0,
                                important: isImportant ? 1 : 0,
                                duration: duration,
                                added: 1,
                                removed: 0,
                              );

                              _onPressAddButton(task, stat);

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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: t.estimatedDuration,
                              border: InputBorder.none,
                              hintText: t.estimatedDurationHint,
                            ),
                            onChanged: (value) {
                              duration =
                                  double.parse(value.replaceAll(',', '.'));
                            },
                          ),
                        ),
                        SwitchListTile(
                          activeColor: kPrimaryColor,
                          value: isImportant,
                          title: Text(t.importantTask),
                          onChanged: (bool value) {
                            setState(() {
                              isImportant = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          activeColor: kPrimaryColor,
                          value: isUrgent,
                          title: Text(t.urgentTask),
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
                        t.addTask,
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
            notifyParent: query,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    query();
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
            title: Text(t.taskWarningTitle),
            content: Text(
              t.taskWarningText,
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text(
                  t.cancel.toUpperCase(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(t.proceedAnyway.toUpperCase()),
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

  void query() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tasksTable);
    final rowCount = await dbHelper.queryRowCount(DatabaseHelper.tasksTable);

    setState(() {
      taskList = allRows;
      nTasks = rowCount;
    });
  }

  void _insertStat(Stat stat) async {
    Map<String, dynamic> row = stat.toMap();
    final id = await dbHelper.insert(DatabaseHelper.statsTable, row);
    print('inserted stat: $id');
  }

  void _insertTask(Task task) async {
    Map<String, dynamic> row = task.toMap();
    final id = await dbHelper.insert(DatabaseHelper.tasksTable, row);
    print('inserted task: $id');
  }

  void _onPressAddButton(Task task, Stat stat) {
    _insertTask(task);
    _insertStat(stat);
    query();
    _isAddable = false;
    isImportant = false;
    isUrgent = false;
    duration = 1.0;
  }
}
