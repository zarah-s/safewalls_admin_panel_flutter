import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stats extends StatefulWidget {
  final Provider provider;
  const Stats({Key? key, required this.provider}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        // Performs zooming on double tap
        enableDoubleTapZooming: true,
        enableMouseWheelZooming: true,
        enablePanning: true,
        enablePinching: true,
        enableSelectionZooming: true);
  }

  @override
  Widget build(BuildContext context) {
    // widget.provider.apiData.users
    //     .map((e) => print(DateFormat("dd-MM-yyyy HH:m")
    //         .format(DateTime.parse(e['created_at']))))
    //     .toList();
    final List<ChartData> chartData = <ChartData>[
      ChartData(2010, 10.53, 3.3),
      ChartData(2011, 9.5, 5.4),
      ChartData(2012, 10, 2.65),
      ChartData(2013, 9.4, 2.62),
      ChartData(2014, 5.8, 1.99),
      ChartData(2015, 4.9, 1.44),
      ChartData(2016, 4.5, 2),
      ChartData(2017, 3.6, 1.56),
      ChartData(2019, 3.43, 2.1),
      ChartData(2044, 3.43, 2.1),
      ChartData(2034, 3.43, 2.1),
      ChartData(2023, 3.43, 2.1),
      ChartData(2032, 3.43, 2.1),
      ChartData(2021, 3.43, 2.1),
      ChartData(2076, 200.43, 2.1),
    ];

    final List<DonoughtData> donought = [
      DonoughtData('Africa', 25, africa),
      DonoughtData('Asia', 38, asia),
      DonoughtData('America', 34, america),
      DonoughtData('Europe', 52, europe),
      DonoughtData('Australia', 52, australia),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 71,
            ),
            const TextWidget(
              text: "DASHBOARD",
              size: 40,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 59,
            ),
            Wrap(
              spacing: 10,
              children: const [
                StatsMoment(label: "wkly"),
                StatsMoment(label: "mtly"),
                StatsMoment(label: "yrly"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: SfCartesianChart(
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(
                  text: 'Users Chart',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: getblackOpacity(.8),
                  ),
                ),
                // Enable legend
                legend: Legend(isVisible: true),

                // Enable tooltip
                tooltipBehavior: _tooltipBehavior,
                // series: SplineSeries<SalesData,
                series: <ChartSeries>[
                  SplineAreaSeries<ChartData, int>(
                      name: "Users",
                      gradient: const LinearGradient(
                        colors: [Color(0xff7c0091), Color(0xffce00c6)],
                      ),
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y),
                  SplineAreaSeries<ChartData, int>(
                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 0.9,
                      name: "Professionals",
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 76, 21, .9),
                          Color(0XFF006F1F)
                        ],
                      ),
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y1),
                ],
              ),
            ),
            const SizedBox(
              height: 148,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 78, left: 48, bottom: 78),
                          padding: const EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(238, 238, 238, .5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SfCircularChart(annotations: <
                              CircularChartAnnotation>[
                            CircularChartAnnotation(
                              widget: Text(
                                '62%',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ], series: <CircularSeries>[
                            // Renders doughnut chart

                            DoughnutSeries<DonoughtData, String>(
                                enableTooltip: true,
                                dataSource: donought,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                pointColorMapper: (DonoughtData data, _) =>
                                    data.color,
                                xValueMapper: (DonoughtData data, _) => data.x,
                                yValueMapper: (DonoughtData data, _) => data.y)
                          ]),
                        ),
                        const SizedBox(
                          width: 21,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 78, bottom: 78),
                          padding: const EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(238, 238, 238, .5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SfCircularChart(
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Text(
                                  '62%',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                            series: <CircularSeries>[
                              // Renders doughnut chart

                              DoughnutSeries<DonoughtData, String>(
                                  dataSource: donought,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                  pointColorMapper: (DonoughtData data, _) =>
                                      data.color,
                                  xValueMapper: (DonoughtData data, _) =>
                                      data.x,
                                  yValueMapper: (DonoughtData data, _) =>
                                      data.y)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      CountryLabel(
                        color: africa,
                        continent: "Africa",
                        total: "300",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CountryLabel(
                        color: asia,
                        continent: "Asia",
                        total: "300",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CountryLabel(
                        color: america,
                        continent: "America",
                        total: "300",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CountryLabel(
                        color: europe,
                        continent: "Europe",
                        total: "300",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CountryLabel(
                        color: australia,
                        continent: "Australia",
                        total: "300",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class CountryLabel extends StatelessWidget {
  const CountryLabel({
    Key? key,
    required this.continent,
    required this.total,
    required this.color,
  }) : super(key: key);
  final String continent;
  final String total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextWidget(
              text: total,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          TextWidget(
            text: continent,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}

class StatsMoment extends StatelessWidget {
  const StatsMoment({Key? key, required this.label}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      color: Colors.white,
      shadowColor: getblackOpacity(.35),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        alignment: Alignment.center,
        width: 45,
        height: 45,
        child: TextWidget(
          text: label,
          size: 12,
          color: getblackOpacity(.8),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final int x;
  final double y;
  final double y1;
}

class DonoughtData {
  DonoughtData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
