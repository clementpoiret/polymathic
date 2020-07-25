import 'package:flutter/material.dart';
import 'package:polymathic/components/charts.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                            '80.6',
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
    );
  }

  @override
  void initState() {
    super.initState();
    print(DateTime.now().toIso8601String());
  }
}
