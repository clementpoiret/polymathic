// import 'dart:ffi';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polymathic/components/charts.dart';
import 'package:polymathic/helpers/database.dart';
import 'package:polymathic/i18n/strings.g.dart' show t;
import 'package:polymathic/utils/stat.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int days = 7;

  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final String _noDataSvg = 'assets/svg/nodata.svg';

  bool _enoughData = false;

  int nCompletedTasks = 0;
  int nCompletedTasksForDays = 0;
  double productivityScore = double.nan;

  bool showSummaryGraph = false;
  bool showStatsOnTasksGraph = false;

  List<List<TimeSerie>> tasksSummaryTimeSeries = [];
  List<List<OrdinalSet>> statsOnTasks = [];

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(t.statsForXDays(n: days)),
              ),
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
                        t.completedTasks,
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
                              t.productivityIndex,
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
                              nCompletedTasksForDays.toString(),
                              style: TextStyle(fontSize: 32.0),
                            ),
                            Text(
                              t.completedTasksForXDays(n: days),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    child: showSummaryGraph
                        ? tasksSummaryLineChart(tasksSummaryTimeSeries)
                        : SimpleTimeSeriesChart.emptyGraph(),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    child: showStatsOnTasksGraph
                        ? statsOnTasksBarChart(statsOnTasks)
                        : SimpleGroupedBarChart.emptyGraph(),
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

  SimpleGroupedBarChart statsOnTasksBarChart(
    List<List<OrdinalSet>> ordinalSets,
  ) {
    return SimpleGroupedBarChart.fromLists(
        ids: [
          t.urgentAndImportantAbr,
          t.importantAbr,
          t.urgentAbr,
          t.noneAbr,
        ],
        ordinalSets: ordinalSets,
        colors: [
          charts.MaterialPalette.pink.shadeDefault.darker,
          charts.MaterialPalette.pink.shadeDefault,
          charts.MaterialPalette.pink.shadeDefault.lighter,
          charts.MaterialPalette.gray.shadeDefault,
        ]);
  }

  SimpleTimeSeriesChart tasksSummaryLineChart(
    List<List<TimeSerie>> timeSeries,
  ) {
    return SimpleTimeSeriesChart.fromLists(
      ids: ['Added Tasks', t.completedTasks],
      timeSeries: timeSeries,
      colors: [
        charts.MaterialPalette.indigo.shadeDefault,
        charts.MaterialPalette.pink.shadeDefault,
      ],
    );
  }

  void _checkEnoughData() async {
    String sql = '''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate
          FROM ${DatabaseHelper.statsTable}
          GROUP BY ymdDate
          ''';
    List<Map> output = await dbHelper.query(sql);
    int value = output.length;

    if (this.mounted) {
      setState(() {
        _enoughData = (value < 2) ? false : true;
      });

      if (_enoughData) {
        _completedTasks();
        _productivityIndex();
        _summaryData(days);
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

  void _summaryData(int days) async {
    DateTime today = DateTime.now();
    DateTime daysFromNow = today.add(Duration(days: -7));

    String sql = '''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate,
          SUM(${DatabaseHelper.statRemoved})
          FROM ${DatabaseHelper.statsTable}
          WHERE ymdDate > '${daysFromNow.toIso8601String()}'
          ''';
    List<Map> output = await dbHelper.query(sql);
    setState(() {
      nCompletedTasksForDays = output.first.values?.last;
      showSummaryGraph = true;
      showStatsOnTasksGraph = true;
    });

    sql = '''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate,
          SUM(${DatabaseHelper.statRemoved}) as completed,
          SUM(${DatabaseHelper.statAdded}) as added
          FROM ${DatabaseHelper.statsTable}
          WHERE ymdDate > '${daysFromNow.toIso8601String()}'
          GROUP BY ymdDate
          ''';
    output = await dbHelper.query(sql);

    if (this.mounted) {
      setState(() {
        tasksSummaryTimeSeries = mapsToTimeSeries(output, [
          'added',
          'completed',
        ]);
      });
    }

    List<List<OrdinalSet>> stats = [
      mapToOrdinalSet(
        await dbHelper.query('''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate,
            SUM(${DatabaseHelper.statRemoved})
            FROM ${DatabaseHelper.statsTable}
            WHERE ymdDate > '${daysFromNow.toIso8601String()}'
            AND ${DatabaseHelper.statImportant} = 1
            AND ${DatabaseHelper.statUrgent} = 1
            GROUP BY ymdDate
          '''),
        'SUM(removed)',
      ),
      mapToOrdinalSet(
        await dbHelper.query('''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate,
            SUM(${DatabaseHelper.statRemoved})
            FROM ${DatabaseHelper.statsTable}
            WHERE ymdDate > '${daysFromNow.toIso8601String()}'
            AND ${DatabaseHelper.statImportant} = 1
            AND ${DatabaseHelper.statUrgent} = 0
            GROUP BY ymdDate
          '''),
        'SUM(removed)',
      ),
      mapToOrdinalSet(
        await dbHelper.query('''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate,
            SUM(${DatabaseHelper.statRemoved})
            FROM ${DatabaseHelper.statsTable}
            WHERE ymdDate > '${daysFromNow.toIso8601String()}'
            AND ${DatabaseHelper.statImportant} = 0
            AND ${DatabaseHelper.statUrgent} = 1
            GROUP BY ymdDate
          '''),
        'SUM(removed)',
      ),
      mapToOrdinalSet(
        await dbHelper.query('''
          SELECT STRFTIME('%Y-%m-%d', date) AS ymdDate,
            SUM(${DatabaseHelper.statRemoved})
            FROM ${DatabaseHelper.statsTable}
            WHERE ymdDate > '${daysFromNow.toIso8601String()}'
            AND ${DatabaseHelper.statImportant} = 0
            AND ${DatabaseHelper.statUrgent} = 0
            GROUP BY ymdDate
          '''),
        'SUM(removed)',
      ),
    ];

    setState(() {
      statsOnTasks = stats;
    });
  }
}
