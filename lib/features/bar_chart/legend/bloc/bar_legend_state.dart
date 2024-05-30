part of 'bar_legend_bloc.dart';

class BarLegendState extends Equatable {
  final BarLegendStatus status;
  final String errorMessage;
  final List<TransactionModel> transactions;
  final Map<CategoryModel, double> showingMap;
  final String typeTransaction;

  BarLegendState._({
    required this.status,
    required this.errorMessage,
    required this.transactions,
    required this.showingMap,
    required this.typeTransaction,
  });

  factory BarLegendState.initial() {
    return BarLegendState._(
      status: BarLegendStatus.initial,
      errorMessage: '',
      transactions: [],
      showingMap: {},
      typeTransaction: '',
    );
  }

  BarLegendState copyWith({
    BarLegendStatus? status,
    String? errorMessage,
    List<TransactionModel>? transactions,
    Map<CategoryModel, double>? showingMap,
    String? typeTransaction,
  }) {
    return BarLegendState._(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      transactions: transactions ?? this.transactions,
      showingMap: showingMap ?? this.showingMap,
      typeTransaction: typeTransaction ?? this.typeTransaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        typeTransaction,
        transactions,
        showingMap,
      ];
}
