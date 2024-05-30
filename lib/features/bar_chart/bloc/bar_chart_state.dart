part of 'bar_chart_bloc.dart';

class BarChartState extends Equatable {
  final BarChartStatus status;
  final String errorMessage;

  final List<TransactionModel> transactions;
  final Map<DateTime, List<TransactionModel>> transactionsMap;

  final Map<DateTime, List<TransactionModel>> mapIncome;
  final Map<DateTime, List<TransactionModel>> mapExpense;

  final List<BarChartGroupData> showingBarGroups;

  final DateType dateType;

  // final List<String> titles;
  // final List<int> incomeList;
  // final List<int> expenseList;

  BarChartState._({
    required this.status,
    required this.transactions,
    required this.transactionsMap,
    required this.errorMessage,
    required this.showingBarGroups,
    required this.mapIncome,
    required this.mapExpense,
    required this.dateType,
  });

  factory BarChartState.initial() {
    return BarChartState._(
      status: BarChartStatus.initial,
      transactions: [],
      transactionsMap: {},
      errorMessage: '',
      showingBarGroups: [],
      mapIncome: {},
      mapExpense: {},
      dateType: DateType.weekDay,
    );
  }

  BarChartState copyWith({
    BarChartStatus? status,
    List<TransactionModel>? transactions,
    Map<DateTime, List<TransactionModel>>? transactionsMap,
    String? errorMessage,
    List<BarChartGroupData>? showingBarGroups,
    Map<DateTime, List<TransactionModel>>? mapIncome,
    Map<DateTime, List<TransactionModel>>? mapExpense,
    DateType? dateType,
  }) {
    return BarChartState._(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      transactionsMap: transactionsMap ?? this.transactionsMap,
      errorMessage: errorMessage ?? '',
      showingBarGroups: showingBarGroups ?? this.showingBarGroups,
      mapIncome: mapIncome ?? this.mapIncome,
      mapExpense: mapExpense ?? this.mapExpense,
      dateType: dateType ?? this.dateType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        transactionsMap,
        errorMessage,
        showingBarGroups,
        mapIncome,
        mapExpense,
        dateType,
      ];
}
