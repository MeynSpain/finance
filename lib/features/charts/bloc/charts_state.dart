part of 'charts_bloc.dart';

class ChartsState extends Equatable {
  final ChartsStatus status;
  final List<TransactionModel> listTransactions;
  final String errorMessage;

  // Расходы
  final Map<String, double> dataMapExpense;
  final Map<String, double> constDataMapExpense;

  // final Map<String, bool> selectedMapExpense;
  // final int totalValueExpense;

  // Доходы
  final Map<String, double> dataMapIncome;
  final Map<String, double> constDataMapIncome;

  // final Map<String, bool> selectedMapIncome;
  // final int totalValueIncome;

  // Общий для диаграммы
  final int totalValue;
  final Map<String, double> dataMap;
  final Map<String, double> constDataMap;
  final Map<String, bool> selectedDataMap;

  // Цвета
  final Map<String, Color> colorMap;
  final Map<String, Color> constColorMap;

  ChartsState._({
    required this.status,
    required this.listTransactions,
    required this.errorMessage,
    required this.totalValue,
    required this.dataMap,
    required this.selectedDataMap,
    required this.constDataMap,
    required this.dataMapExpense,
    required this.constDataMapExpense,
    // required this.selectedMapExpense,
    // required this.totalValueExpense,

    required this.dataMapIncome,
    required this.constDataMapIncome,

    // required this.selectedMapIncome,
    // required this.totalValueIncome,
    required this.colorMap,
    required this.constColorMap,
  });

  factory ChartsState.initial() {
    return ChartsState._(
      status: ChartsStatus.initial,
      listTransactions: [],
      errorMessage: '',
      dataMapExpense: {},
      constDataMapExpense: {},
      // selectedMapExpense: {},
      // totalValueExpense: 0,
      dataMapIncome: {},
      constDataMapIncome: {},
      // selectedMapIncome: {},
      // totalValueIncome: 0,
      dataMap: {},
      constDataMap: {},
      totalValue: 0,
      selectedDataMap: {},

      colorMap: {},
      constColorMap: {},
    );
  }

  ChartsState copyWith({
    ChartsStatus? status,
    List<TransactionModel>? listTransactions,
    String? errorMessage,
    Map<String, double>? dataMapExpense,
    Map<String, double>? constDataMapExpense,
    // Map<String, bool>? selectedMapExpense,
    // int? totalValueExpense,
    Map<String, double>? dataMapIncome,
    Map<String, double>? constDataMapIncome,
    // Map<String, bool>? selectedMapIncome,
    // int? totalValueIncome,

    Map<String, double>? dataMap,
    Map<String, double>? constDataMap,
    Map<String, bool>? selectedDataMap,
    int? totalValue,
    Map<String, Color>? colorMap,
    Map<String, Color>? constColorMap,
  }) {
    return ChartsState._(
      status: status ?? this.status,
      listTransactions: listTransactions ?? this.listTransactions,
      errorMessage: errorMessage ?? this.errorMessage,
      dataMapExpense: dataMapExpense ?? this.dataMapExpense,
      constDataMapExpense: constDataMapExpense ?? this.constDataMapExpense,
      // selectedMapExpense: selectedMapExpense ?? this.selectedMapExpense,
      // totalValueExpense: totalValueExpense ?? this.totalValueExpense,
      dataMapIncome: dataMapIncome ?? this.dataMapIncome,
      constDataMapIncome: constDataMapExpense ?? this.constDataMapIncome,
      // selectedMapIncome: selectedMapExpense ?? this.selectedMapIncome,
      // totalValueIncome: totalValueIncome ?? this.totalValueIncome,\
      dataMap: dataMap ?? this.dataMap,
      constDataMap: constDataMap ?? this.constDataMap,
      selectedDataMap: selectedDataMap ?? this.selectedDataMap,
      totalValue: totalValue ?? this.totalValue,
      colorMap: colorMap ?? this.colorMap,
      constColorMap: constColorMap ?? this.constColorMap,
    );
  }

  @override
  List<Object?> get props => [
        status,
        listTransactions,
        errorMessage,
        totalValue,
        dataMap,
        selectedDataMap,
        constDataMap,
        dataMapExpense,
        constDataMapExpense,
        dataMapIncome,
        constDataMapIncome,
        colorMap,
        constColorMap,
      ];
}
