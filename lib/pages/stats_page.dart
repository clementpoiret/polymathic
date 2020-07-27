import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polymathic/components/charts.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/utils/stat.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final String _noDataSvg = 'assets/svg/nodata.svg';

  bool _enoughData = false;

  int nCompletedTasks = 0;
  double productivityScore = double.nan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Visibility(
        visible: _enoughData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        nCompletedTasks.toString(),
                        style: TextStyle(fontSize: 32.0),
                      ),
                      Text(
                        'Completed Tasks',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              productivityScore.toString(),
                              style: TextStyle(fontSize: 32.0),
                            ),
                            Text(
                              'Productivity Index (/100)',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '12',
                              style: TextStyle(fontSize: 32.0),
                            ),
                            Text(
                              'Completed Tasks (weekly)',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 256.0,
                    width: double.infinity,
                    child: SimpleTimeSeriesChart.withSampleData(),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 256.0,
                    width: double.infinity,
                    child: SimpleGroupedBarChart.withSampleData(),
                  ),
                ),
              ),
            ],
          ),
        ),
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              _noDataSvg,
              height: 256,
              semanticsLabel: 'No data',
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'We don\'t have enough data yet :(',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _checkEnoughData();
  }

  void _checkEnoughData() async {
    String sql =
        'SELECT SUM(${DatabaseHelper.statAdded}) FROM ${DatabaseHelper.statsTable}';
    List<Map> output = await dbHelper.query(sql);
    int value = output.first.values?.first;

    if (this.mounted) {
      setState(() {
        _enoughData = (value == null) ? false : true;
      });

      if (_enoughData) {
        _completedTasks();
        _productivityIndex();
      }
    }
  }

  void _completedTasks() async {
    String sql =
        'SELECT SUM(${DatabaseHelper.statRemoved}) FROM ${DatabaseHelper.statsTable}';
    List<Map> output = await dbHelper.query(sql);

    if (this.mounted) {
      setState(() {
        nCompletedTasks = output.first.values?.first;
      });
    }
  }

  void _productivityIndex() async {
    int nUrgentImportantAdded = await dbHelper.getAddedTasks(
      isUrgent: 1,
      isImportant: 1,
    );
    int nUrgentAdded = await dbHelper.getAddedTasks(
      isUrgent: 1,
      isImportant: 0,
    );
    int nImportantAdded = await dbHelper.getAddedTasks(
      isUrgent: 0,
      isImportant: 1,
    );
    int nNoneAdded = await dbHelper.getAddedTasks(
      isUrgent: 0,
      isImportant: 0,
    );

    int nUrgentImportantCompleted = await dbHelper.getRemovedTasks(
      isUrgent: 1,
      isImportant: 1,
    );
    int nUrgentCompleted = await dbHelper.getRemovedTasks(
      isUrgent: 1,
      isImportant: 0,
    );
    int nImportantCompleted = await dbHelper.getRemovedTasks(
      isUrgent: 0,
      isImportant: 1,
    );
    int nNoneCompleted = await dbHelper.getRemovedTasks(
      isUrgent: 0,
      isImportant: 0,
    );

    double index = getProductivityIndex(
      nUrgentImportantAdded: nUrgentImportantAdded,
      nImportantAdded: nImportantAdded,
      nUrgentAdded: nUrgentAdded,
      nNoneAdded: nNoneAdded,
      nUrgentImportantCompleted: nUrgentImportantCompleted,
      nImportantCompleted: nImportantCompleted,
      nUrgentCompleted: nUrgentCompleted,
      nNoneCompleted: nNoneCompleted,
    );

    if (this.mounted) {
      setState(() {
        productivityScore = index;
      });
    }
  }
}
