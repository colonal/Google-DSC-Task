import 'package:charts_flutter/flutter.dart' as charts;
import '../user.dart';
import '../model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_common/common.dart' as common;

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<common.Series<dynamic, DateTime>> seriesList;
  final bool? animate;

  const SimpleTimeSeriesChart(this.seriesList, {this.animate, Key? key})
      : super(key: key);

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList,
        animate: animate,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          charts.SlidingViewport(),
          charts.PanAndZoomBehavior(),
        ],
        domainAxis: charts.DateTimeAxisSpec(
          tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
            invoices!.map((Invoice element) {
              List date = element.date!.split(" ")[0].split("/");
              List time = element.date!.split(" ")[1].split(":");
              String money = element.money!.substring(1, element.money!.length);

              return charts.TickSpec<DateTime>(
                DateTime(
                  int.parse(date[2]),
                  int.parse(date[0]),
                  int.parse(date[1]),
                  int.parse(time[0]),
                  int.parse(time[1]),
                ),
              );
            }).toList(),
          ),
          tickFormatterSpec: const charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(
              format: 'dd MMM yyyy HH:mm',
              transitionFormat: 'dd MMM yyyy HH:mm',
            ),
          ),
        ));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      ...invoices!.map((Invoice element) {
        List date = element.date!.split(" ")[0].split("/");
        List time = element.date!.split(" ")[1].split(":");
        String money = element.money!.substring(1, element.money!.length);
        print(
            "money: $money\tdate: ${DateTime(int.parse(date[2]), int.parse(date[0]), int.parse(date[1]), int.parse(time[0]), int.parse(time[1]))}");
        return TimeSeriesSales(
            DateTime(
              int.parse(date[2]),
              int.parse(date[0]),
              int.parse(date[1]),
              int.parse(time[0]),
              int.parse(time[1]),
            ),
            int.parse(money));
      }).toList(),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',

        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,

        seriesColor: charts.ColorUtil.fromDartColor(Colors.white),
        areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white),
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white),
        patternColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white),
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
//Expanded(flex: 5, child: SimpleTimeSeriesChart.withSampleData()),
