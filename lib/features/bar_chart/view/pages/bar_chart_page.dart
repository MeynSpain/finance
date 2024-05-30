import 'package:finance/core/constants/date_type.dart';
import 'package:finance/core/constants/status/bar_chart_status.dart';
import 'package:finance/core/constants/template/templates.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/bar_chart/legend/view/widgets/legend_widget.dart';
import 'package:finance/features/bar_chart/view/widgets/row_button_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: RowButtonWidget()),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              // color: Colors.grey[800],
              child: BlocBuilder<BarChartBloc, BarChartState>(
                builder: (context, state) {
                  return state.status == BarChartStatus.loading
                      ? CircularProgressIndicator()
                      : BarChart(
                          BarChartData(
                              titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: false,
                                  )),
                                  topTitles: const AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: false,
                                  )),
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 42,
                                    getTitlesWidget: bottomTitle,
                                  ))),
                              barGroups: state.showingBarGroups,
                              barTouchData: BarTouchData(
                                touchCallback: (event, response) {

                                  if (event is FlPanDownEvent) {
                                    if (response?.spot?.touchedBarGroup != null) {
                                      getIt<BarChartBloc>().add(
                                          BarChartShowLegendEvent(
                                              groupIndex: response!
                                                  .spot!.touchedBarGroup.x,
                                              rodIndex: response
                                                  .spot!.touchedRodDataIndex));
                                    }
                                  }
                                },
                              )),
                        );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.red,
              child: LegendWidget(),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomTitle(double value, TitleMeta meta) {
    List<String> titles = [];

    switch (getIt<BarChartBloc>().state.dateType) {
      case DateType.weekDay:
        titles = Templates.titlesWeekday;
        break;
      case DateType.month:
        titles = Templates.titlesMonths;
        break;
      case DateType.year:
        titles = [];
        break;
    }

    final Widget text = Text(
      getIt<BarChartBloc>().state.dateType == DateType.year
          ? '${value.toInt()}'
          : titles[value.toInt() - 1],
      // style: Tex,
    );

    return SideTitleWidget(
      child: text,
      axisSide: meta.axisSide,
      space: 14,
      angle: 0,
    );
  }
}
