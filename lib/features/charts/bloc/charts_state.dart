part of 'charts_bloc.dart';

class ChartsState extends Equatable {
  final ChartsStatus status;
  final List<TransactionModel> listTransactions;
  final String errorMessage;
  final Map<String, double> dataMap;
  final Map<String, double> constDataMap;
  final Map<String, bool> selectedMap;
  final int totalValue;


  ChartsState._({
    required this.status,
    required this.listTransactions,
    required this.errorMessage,
    required this.dataMap,
    required this.constDataMap,
    required this.selectedMap,
    required this.totalValue,
  });

  factory ChartsState.initial() {
    return ChartsState._(
      status: ChartsStatus.initial,
      listTransactions: [],
      errorMessage: '',
      dataMap: {},
      constDataMap: {},
      selectedMap: {},
      totalValue: 0,
    );
  }

  ChartsState copyWith({
    ChartsStatus? status,
    List<TransactionModel>? listTransactions,
    String? errorMessage,
    Map<String, double>? dataMap,
    final Map<String, double>? constDataMap,
    final Map<String, bool>? selectedMap,
    int? totalValue,
  }) {
    return ChartsState._(
      status: status ?? this.status,
      listTransactions: listTransactions ?? this.listTransactions,
      errorMessage: errorMessage ?? this.errorMessage,
      dataMap: dataMap ?? this.dataMap,
      constDataMap: constDataMap ?? this.constDataMap,
      selectedMap: selectedMap ?? this.selectedMap,
      totalValue: totalValue ?? this.totalValue,
    );
  }

  @override
  List<Object?> get props =>
      [
        status,
        errorMessage,
        listTransactions,
        dataMap,
        constDataMap,
        selectedMap,
        totalValue,
      ];
}
