part of 'bar_legend_bloc.dart';

@immutable
abstract class BarLegendEvent {}

class BarLegendShowNewLegendEvent extends BarLegendEvent {
  final List<TransactionModel> transactions;
  final String typeTransaction;

  BarLegendShowNewLegendEvent({
    required this.transactions,
    required this.typeTransaction,
  });
}
