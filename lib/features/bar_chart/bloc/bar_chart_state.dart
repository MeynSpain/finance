part of 'bar_chart_bloc.dart';

class BarChartState extends Equatable {
  final BarChartStatus status;
  final String errorMessage;

  final List<AccountModel> accounts;
  AccountModel? currentAccount;

  final List<TransactionModel> transactions;
  final Map<DateTime, List<TransactionModel>> transactionsMap;

  final Map<DateTime, List<TransactionModel>> mapIncome;
  final Map<DateTime, List<TransactionModel>> mapExpense;

  final List<BarChartGroupData> showingBarGroups;

  final DateType dateType;

  final DateTime startDate;
  final DateTime endDate;

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
    required this.accounts,
    required this.currentAccount,
    required this.startDate,
    required this.endDate,
  });

  factory BarChartState.initial() {
    return BarChartState._(
      status: BarChartStatus.initial,
      accounts: [],
      currentAccount: null,
      transactions: [],
      transactionsMap: {},
      errorMessage: '',
      showingBarGroups: [],
      mapIncome: {},
      mapExpense: {},
      dateType: DateType.weekDay,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
  }

  BarChartState copyWith({
    BarChartStatus? status,
    List<TransactionModel>? transactions,
    List<AccountModel>? accounts,
    AccountModel? currentAccount,
    Map<DateTime, List<TransactionModel>>? transactionsMap,
    String? errorMessage,
    List<BarChartGroupData>? showingBarGroups,
    Map<DateTime, List<TransactionModel>>? mapIncome,
    Map<DateTime, List<TransactionModel>>? mapExpense,
    DateType? dateType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BarChartState._(
      accounts: accounts ?? this.accounts,
      currentAccount: currentAccount ?? this.currentAccount,
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      transactionsMap: transactionsMap ?? this.transactionsMap,
      errorMessage: errorMessage ?? '',
      showingBarGroups: showingBarGroups ?? this.showingBarGroups,
      mapIncome: mapIncome ?? this.mapIncome,
      mapExpense: mapExpense ?? this.mapExpense,
      dateType: dateType ?? this.dateType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        currentAccount,
        transactions,
        transactionsMap,
        errorMessage,
        showingBarGroups,
        mapIncome,
        mapExpense,
        dateType,
        startDate,
        endDate,
      ];
}
