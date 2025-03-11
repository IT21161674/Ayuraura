import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../constants/colors.dart';

class ProgressScreen extends StatelessWidget {
  ProgressScreen({Key? key}) : super(key: key);

  final List<DailyMetrics> barChartData = _createBarChartData();
  final List<DayMetrics> lineChartData = _createLineChartData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const _HeaderSection(),
              const SizedBox(height: 24),
              _buildBarChartCard(),
              const SizedBox(height: 24),
              // _buildLineChartCard(),
              const SizedBox(height: 24),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Daily Emotional Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: charts.BarChart(
                _createBarChartSeries(),
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelRotation: 45,
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 10,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec: charts.StaticNumericTickProviderSpec(
                    [
                      charts.TickSpec(0, label: '0'),
                      charts.TickSpec(1),
                      charts.TickSpec(2),
                      charts.TickSpec(3),
                      charts.TickSpec(4),
                      charts.TickSpec(5, label: '5'),
                    ],
                  ),
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                behaviors: [
                  charts.ChartTitle('Days',
                      titleStyleSpec: const charts.TextStyleSpec(fontSize: 14),
                      behaviorPosition: charts.BehaviorPosition.bottom),
                  charts.ChartTitle('Intensity',
                      titleStyleSpec: const charts.TextStyleSpec(fontSize: 14),
                      behaviorPosition: charts.BehaviorPosition.start),
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.bottom,
                    desiredMaxColumns: 4,
                    entryTextStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Weekly Mood Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: charts.LineChart(
                _createLineChartSeries().cast<charts.Series<dynamic, num>>(),
                animate: true,
                defaultRenderer: charts.LineRendererConfig(
                  includeArea: false,
                  includePoints: true,
                ),
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelRotation: 45,
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 10,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec: charts.StaticNumericTickProviderSpec(
                    [
                      charts.TickSpec(0, label: '0'),
                      charts.TickSpec(1),
                      charts.TickSpec(2),
                      charts.TickSpec(3),
                      charts.TickSpec(4),
                      charts.TickSpec(5, label: '5'),
                    ],
                  ),
                ),
                behaviors: [
                  charts.ChartTitle('Days',
                      titleStyleSpec: const charts.TextStyleSpec(fontSize: 14),
                      behaviorPosition: charts.BehaviorPosition.bottom),
                  charts.ChartTitle('Level',
                      titleStyleSpec: const charts.TextStyleSpec(fontSize: 14),
                      behaviorPosition: charts.BehaviorPosition.start),
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.top,
                    desiredMaxColumns: 2,
                    entryTextStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<DailyMetrics, String>> _createBarChartSeries() {
    return [
      charts.Series<DailyMetrics, String>(
        id: 'Stress',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.stress),
        domainFn: (DailyMetrics metrics, _) => metrics.day,
        measureFn: (DailyMetrics metrics, _) => metrics.stress,
        data: barChartData,
        labelAccessorFn: (DailyMetrics metrics, _) => 'Stress: ${metrics.stress}',
      ),
      charts.Series<DailyMetrics, String>(
        id: 'Happiness',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.happiness),
        domainFn: (DailyMetrics metrics, _) => metrics.day,
        measureFn: (DailyMetrics metrics, _) => metrics.happiness,
        data: barChartData,
        labelAccessorFn: (DailyMetrics metrics, _) => 'Happiness: ${metrics.happiness}',
      ),
      charts.Series<DailyMetrics, String>(
        id: 'Calmness',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.calmness),
        domainFn: (DailyMetrics metrics, _) => metrics.day,
        measureFn: (DailyMetrics metrics, _) => metrics.calmness,
        data: barChartData,
        labelAccessorFn: (DailyMetrics metrics, _) => 'Calmness: ${metrics.calmness}',
      ),
      charts.Series<DailyMetrics, String>(
        id: 'Energy',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.energy),
        domainFn: (DailyMetrics metrics, _) => metrics.day,
        measureFn: (DailyMetrics metrics, _) => metrics.energy,
        data: barChartData,
        labelAccessorFn: (DailyMetrics metrics, _) => 'Energy: ${metrics.energy}',
      ),
    ];
  }

  List<charts.Series<DayMetrics, String>> _createLineChartSeries() {
    return [
      charts.Series<DayMetrics, String>(
        id: 'Happiness',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.happiness),
        domainFn: (DayMetrics metrics, _) => metrics.day,
        measureFn: (DayMetrics metrics, _) => metrics.happiness,
        data: lineChartData,
      ),
      charts.Series<DayMetrics, String>(
        id: 'Calmness',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.calmness),
        domainFn: (DayMetrics metrics, _) => metrics.day,
        measureFn: (DayMetrics metrics, _) => metrics.calmness,
        data: lineChartData,
      ),
    ];
  }

  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.arrow_back, size: 20),
        label: const Text('Back to Dashboard'),
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          primary: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  static List<DailyMetrics> _createBarChartData() {
    return List.generate(7, (index) => DailyMetrics(
      day: 'Day ${index + 1}',
      stress: (5 * (index % 3) / 2).round().toDouble(),
      happiness: (5 * (index % 4) / 3).round().toDouble(),
      calmness: (5 * (index % 5) / 4).round().toDouble(),
      energy: (5 * (index % 2) / 1).round().toDouble(),
    ));
  }

  static List<DayMetrics> _createLineChartData() {
    return List.generate(7, (index) => DayMetrics(
      day: 'Day ${index + 1}',
      happiness: (5 * (index % 4) / 3).round().toDouble(),
      calmness: (5 * (index % 5) / 4).round().toDouble(),
    ));
  }
}

class DailyMetrics {
  final String day;
  final double stress;
  final double happiness;
  final double calmness;
  final double energy;

  DailyMetrics({
    required this.day,
    required this.stress,
    required this.happiness,
    required this.calmness,
    required this.energy,
  });
}

class DayMetrics {
  final String day;
  final double happiness;
  final double calmness;

  DayMetrics({
    required this.day,
    required this.happiness,
    required this.calmness,
  });
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Emotional Analytics 📊",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Visualizing your mood patterns and stress levels",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(AppColors.stress, 'Stress'),
            _buildLegendItem(AppColors.happiness, 'Happiness'),
            _buildLegendItem(AppColors.calmness, 'Calmness'),
            _buildLegendItem(AppColors.energy, 'Energy'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}