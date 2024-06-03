part of 'bar_chart_bloc.dart';

@immutable
abstract class BarChartEvent {}

class BarChartInitialEvent extends BarChartEvent {
  final String userUid;
  final String accountUid;

  BarChartInitialEvent({required this.userUid, required this.accountUid});
}

class BarChartGetTransactionsByDateEvent extends BarChartEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String userUid;
  final String accountUid;
  final DateType dateType;

  BarChartGetTransactionsByDateEvent(
      {required this.startDate,
      required this.endDate,
      required this.userUid,
      required this.accountUid,
      required this.dateType});
}

class BarChartShowLegendEvent extends BarChartEvent {
  final int groupIndex;
  final int rodIndex;

  BarChartShowLegendEvent({required this.groupIndex, required this.rodIndex});
}
