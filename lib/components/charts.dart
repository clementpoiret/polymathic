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
  List<OrdinalSet> ordinalSet = [];

  maps.forEach((map) {
    ordinalSet.add(
      OrdinalSet(
        map['ymdDate'].toString().substring(5),
        map[key],
      ),
    );
  });

  return ordinalSet;
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

  factory SimpleGroupedBarChart.emptyGraph() {
    return SimpleGroupedBarChart(
      _createEmptyData(),
      animate: true,
    );
  }

  factory SimpleGroupedBarChart.fromLists({
    List<String> ids,
    List<List<OrdinalSet>> ordinalSets,
    List colors,
  }) {
    List<charts.Series<OrdinalSet, String>> sets = [];

    ordinalSets.asMap().forEach(
      (index, ordinalSet) {
        sets.add(
          charts.Series<OrdinalSet, String>(
            id: ids[index],
            colorFn: (_, __) => colors[index],
            domainFn: (OrdinalSet stat, _) => stat.date,
            measureFn: (OrdinalSet stat, _) => stat.value,
            data: ordinalSet,
          ),
        );
      },
    );

    return SimpleGroupedBarChart(
      sets,
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
  static List<charts.Series<OrdinalSet, String>> _createEmptyData() {
    final List<OrdinalSet> urgentImportantTasks = [];

    final List<OrdinalSet> importantTasks = [];

    final List<OrdinalSet> urgentTasks = [];

    final List<OrdinalSet> shitTasks = [];

    return [
      charts.Series<OrdinalSet, String>(
        id: 'Urg. & Imp.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault.darker,
        domainFn: (OrdinalSet stat, _) => stat.date,
        measureFn: (OrdinalSet stat, _) => stat.value,
        data: urgentImportantTasks,
      ),
      charts.Series<OrdinalSet, String>(
        id: 'Imp.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (OrdinalSet stat, _) => stat.date,
        measureFn: (OrdinalSet stat, _) => stat.value,
        data: importantTasks,
      ),
      charts.Series<OrdinalSet, String>(
        id: 'Urg.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault.lighter,
        domainFn: (OrdinalSet stat, _) => stat.date,
        measureFn: (OrdinalSet stat, _) => stat.value,
        data: urgentTasks,
      ),
      charts.Series<OrdinalSet, String>(
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        id: 'None',
        domainFn: (OrdinalSet stat, _) => stat.date,
        measureFn: (OrdinalSet stat, _) => stat.value,
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
      _createEmptyData(),
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

  static List<charts.Series<TimeSerie, DateTime>> _createEmptyData() {
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
