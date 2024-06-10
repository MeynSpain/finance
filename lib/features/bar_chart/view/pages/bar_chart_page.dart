import 'package:finance/core/constants/date_type.dart';
import 'package:finance/core/constants/status/bar_chart_status.dart';
import 'package:finance/core/constants/template/templates.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/core/services/money_service.dart';
import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/bar_chart/legend/view/widgets/legend_widget.dart';
import 'package:finance/features/bar_chart/view/widgets/row_button_widget.dart';
import 'package:finance/features/transfers/view/dialogs/select_account_dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talker_flutter/talker_flutter.dart';

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {

  final MoneyService moneyService = MoneyService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<BarChartBloc, BarChartState>(
          builder: (context, state) {
            return TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => SelectAccountDialog(
                      accounts: [
                        ...state.accounts ?? [],
                      ],
                      selectedAccount: state.currentAccount,
                      accept: (AccountModel? account) {
                        print(account);
                        if (account != null) {
                          getIt<BarChartBloc>().add(BarChartChangeAccountEvent(
                            account: account,
                          ));
                        }
                      },
                    ));
              },
              child: RichText(
                text: TextSpan(style: theme.textTheme.bodyMedium, children: [
                  TextSpan(
                    text: state.currentAccount?.name ?? 'Выберите счет',
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 14,
                    ),
                  )
                ]),
              ),
            );
          },
        ),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    // interval: 10000,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${moneyService.convert(value.toInt(), 100)} ');
                                    },
                                    reservedSize: 50
                                  )
                                ),
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
