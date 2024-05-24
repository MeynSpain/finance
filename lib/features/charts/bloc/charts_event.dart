part of 'charts_bloc.dart';

@immutable
abstract class ChartsEvent {}

class ChartsGetLastMonthTransactionsEvent extends ChartsEvent {
  final String userUid;
  final String rootCategoryUid;

  ChartsGetLastMonthTransactionsEvent({required this.userUid, required this.rootCategoryUid});
}

class ChartsDeleteDataFromDataMapEvent extends ChartsEvent {
  final String key;

  ChartsDeleteDataFromDataMapEvent({required this.key});
}

class ChartsToggleElementEvent extends ChartsEvent {
  final String key;

  ChartsToggleElementEvent({required this.key});
}

class ChartsChangeTypeEvent extends ChartsEvent {
  final bool isIncome;

  ChartsChangeTypeEvent({required this.isIncome});
}