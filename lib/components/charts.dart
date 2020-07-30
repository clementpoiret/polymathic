import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

List<List<TimeSerie>> mapsToTimeSeries(
  List<Map<String, dynamic>> maps,
  List<String> keys,
) {
  List<List<TimeSerie>> timeSeries = [];

  if (maps.isNotEmpty) {
    keys.forEach((key) {
      List<TimeSerie> ts = [];

      maps.forEach(
        (map) {
          ts.add(
            TimeSerie(
              DateTime.parse(map['ymdDate']),
              map[key],
            ),
          );
        },
      );

      timeSeries.add(ts);
    });
  }

  return timeSeries;
}

List<OrdinalSet> mapToOrdinalSet(
  List<Map<String, dynamic>> maps,
  String key,
) {
  List<OrdinalSet> ordinalSets = [];

  maps.forEach((map) {});

  return ordinalSets;
}

/// Sample ordinal data type.
class OrdinalSet {
  final String date;
  final int value;

  OrdinalSet(this.date, this.value);
}

class SimpleGroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleGroupedBarChart(this.seriesList, {this.animate});

  factory SimpleGroupedBarChart.withSampleData() {
    return SimpleGroupedBarChart(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSet, String>> _createSampleData() {
    final urgentImportantTasks = [
      OrdinalSet('07-20', 5),
      OrdinalSet('07-21', 25),
      OrdinalSet('07-22', 100),
    ];

    final importantTasks = [
      OrdinalSet('07-20', 10),
      OrdinalSet('07-21', 15),
      OrdinalSet('07-22', 50),
    ];

    final urgentTasks = [
      OrdinalSet('07-20', 25),
      OrdinalSet('07-21', 50),
      OrdinalSet('07-22', 10),
    ];

    final shitTasks = [
      OrdinalSet('07-20', 20),
      OrdinalSet('07-21', 35),
      OrdinalSet('07-22', 15),
    ];

    return [
      charts.Series<OrdinalSet, String>(
        id: 'Urg. & Imp.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault.darker,
        domainFn: (OrdinalSet sales, _) => sales.date.toString(),
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: urgentImportantTasks,
      ),
      charts.Series<OrdinalSet, String>(
        id: 'Imp.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (OrdinalSet sales, _) => sales.date.toString(),
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: importantTasks,
      ),
      charts.Series<OrdinalSet, String>(
        id: 'Urg.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault.lighter,
        domainFn: (OrdinalSet sales, _) => sales.date.toString(),
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: urgentTasks,
      ),
      charts.Series<OrdinalSet, String>(
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        id: 'None',
        domainFn: (OrdinalSet sales, _) => sales.date.toString(),
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: shitTasks,
      ),
    ];
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  factory SimpleTimeSeriesChart.emptyGraph() {
    return SimpleTimeSeriesChart(
      _createSampleData(),
      animate: true,
    );
  }

  factory SimpleTimeSeriesChart.fromLists({
    List<String> ids,
    List<List<TimeSerie>> timeSeries,
    List colors,
  }) {
    List<charts.Series<TimeSerie, DateTime>> series = [];

    timeSeries.asMap().forEach((index, timeSerie) {
      series.add(charts.Series<TimeSerie, DateTime>(
        id: ids[index],
        colorFn: (_, __) => colors[index],
        domainFn: (TimeSerie task, _) => task.time,
        measureFn: (TimeSerie task, _) => task.value,
        data: timeSerie,
      ));
    });

    return SimpleTimeSeriesChart(
      series,
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [charts.SeriesLegend()],
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.gray.shadeDefault,
          ),
        ),
      ),
    );
  }

  static List<charts.Series<TimeSerie, DateTime>> _createSampleData() {
    final List<TimeSerie> completed = [];

    final List<TimeSerie> added = [];

    return [
      charts.Series<TimeSerie, DateTime>(
        id: 'Added Tasks',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (TimeSerie task, _) => task.time,
        measureFn: (TimeSerie task, _) => task.value,
        data: added,
      ),
      charts.Series<TimeSerie, DateTime>(
        id: 'Completed Tasks',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (TimeSerie task, _) => task.time,
        measureFn: (TimeSerie task, _) => task.value,
        data: completed,
      ),
    ];
  }
}

class TimeSerie {
  final DateTime time;
  final int value;

  TimeSerie(this.time, this.value);
}
