import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:polymathic/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:polymathic/components/tasks_list.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _isAddTaskVisible = false;
  bool _isAddable = false;
  bool isImportant = false;
  bool isUrgent = false;

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
                            onPressed: () {},
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
                          setState(() {
                            _isAddTaskVisible = true;
                          });
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
          TasksList(),
        ],
      ),
    );
  }
}
