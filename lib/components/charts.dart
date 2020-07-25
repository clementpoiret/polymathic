import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// Sample ordinal data type.
class OrdinalSet {
  final String year;
  final int value;

  OrdinalSet(this.year, this.value);
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
      OrdinalSet('2014', 5),
      OrdinalSet('2015', 25),
      OrdinalSet('2016', 100),
      OrdinalSet('2017', 75),
      OrdinalSet('2018', 75),
      OrdinalSet('2019', 75),
      OrdinalSet('2020', 75),
      OrdinalSet('2021', 75),
      OrdinalSet('2022', 75),
    ];

    final importantTasks = [
      OrdinalSet('2014', 10),
      OrdinalSet('2015', 15),
      OrdinalSet('2016', 50),
      OrdinalSet('2017', 45),
      OrdinalSet('2018', 75),
      OrdinalSet('2019', 75),
      OrdinalSet('2020', 75),
      OrdinalSet('2021', 75),
      OrdinalSet('2022', 75),
    ];

    final urgentTasks = [
      OrdinalSet('2014', 25),
      OrdinalSet('2015', 50),
      OrdinalSet('2016', 10),
      OrdinalSet('2017', 20),
      OrdinalSet('2018', 75),
      OrdinalSet('2019', 75),
      OrdinalSet('2020', 75),
      OrdinalSet('2021', 75),
      OrdinalSet('2022', 75),
    ];

    final shitTasks = [
      OrdinalSet('2014', 20),
      OrdinalSet('2015', 35),
      OrdinalSet('2016', 15),
      OrdinalSet('2017', 10),
      OrdinalSet('2018', 75),
      OrdinalSet('2019', 75),
      OrdinalSet('2020', 75),
      OrdinalSet('2021', 75),
      OrdinalSet('2022', 75),
    ];

    return [
      charts.Series<OrdinalSet, String>(
        id: 'Urg. & Imp.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault.darker,
        domainFn: (OrdinalSet sales, _) => sales.year,
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: urgentImportantTasks,
      ),
      charts.Series<OrdinalSet, String>(
        id: 'Imp.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (OrdinalSet sales, _) => sales.year,
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: importantTasks,
      ),
      charts.Series<OrdinalSet, String>(
        id: 'Urg.',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault.lighter,
        domainFn: (OrdinalSet sales, _) => sales.year,
        measureFn: (OrdinalSet sales, _) => sales.value,
        data: urgentTasks,
      ),
      charts.Series<OrdinalSet, String>(
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        id: 'None',
        domainFn: (OrdinalSet sales, _) => sales.year,
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

  factory SimpleTimeSeriesChart.withSampleData() {
    return SimpleTimeSeriesChart(
      _createSampleData(),
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
    final completed = [
      TimeSerie(DateTime(2017, 9, 19), 5),
      TimeSerie(DateTime(2017, 9, 26), 3),
      TimeSerie(DateTime(2017, 10, 3), 4),
      TimeSerie(DateTime(2017, 10, 10), 6),
    ];

    final added = [
      TimeSerie(DateTime(2017, 9, 19), 5),
      TimeSerie(DateTime(2017, 9, 26), 3),
      TimeSerie(DateTime(2017, 10, 3), 5),
      TimeSerie(DateTime(2017, 10, 10), 2),
    ];

    return [
      charts.Series<TimeSerie, DateTime>(
        id: 'Added Tasks',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSerie sales, _) => sales.time,
        measureFn: (TimeSerie sales, _) => sales.value,
        data: added,
      ),
      charts.Series<TimeSerie, DateTime>(
        id: 'Completed Tasks',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (TimeSerie sales, _) => sales.time,
        measureFn: (TimeSerie sales, _) => sales.value,
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
