import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BudgetChart extends StatelessWidget {
  final List<dynamic> data;

  BudgetChart({@required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (dynamic series, _) => series.year,
          measureFn: (dynamic series, _) => series.subscribers,
          colorFn: (dynamic series, _) => series.barColor)
    ];
  }
}

/// Bar chart examp
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      // animate: true,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return new charts.BarLabelDecorator(
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 500),
      new OrdinalSales('2015', 250),
      new OrdinalSales('2016', 1000),
      new OrdinalSales('2017', 100),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (OrdinalSales sales, _) =>
              '\$ ${sales.sales.toString()}')
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
