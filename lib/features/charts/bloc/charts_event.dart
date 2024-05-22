part of 'charts_bloc.dart';

@immutable
abstract class ChartsEvent {}

class ChartsGetLastMonthTransactionsEvent extends ChartsEvent {
  final String userUid;
  final String rootCategoryUid;

  ChartsGetLastMonthTransactionsEvent({required this.userUid, required this.rootCategoryUid});
}
