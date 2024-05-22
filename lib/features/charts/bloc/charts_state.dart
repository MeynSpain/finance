part of 'charts_bloc.dart';

class ChartsState extends Equatable {
  final ChartsStatus status;
  final List<TransactionModel> listTransactions;
  final String errorMessage;
  final Map<String, double> dataMap;

  ChartsState._(
      {required this.status,
      required this.listTransactions,
      required this.errorMessage,
      required this.dataMap});

  factory ChartsState.initial() {
    return ChartsState._(
      status: ChartsStatus.initial,
      listTransactions: [],
      errorMessage: '',
      dataMap: {},
    );
  }

  ChartsState copyWith({
    ChartsStatus? status,
    List<TransactionModel>? listTransactions,
    String? errorMessage,
    Map<String, double>? dataMap,
  }) {
    return ChartsState._(
      status: status ?? this.status,
      listTransactions: listTransactions ?? this.listTransactions,
      errorMessage: errorMessage ?? this.errorMessage,
      dataMap: dataMap ?? this.dataMap,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        listTransactions,
        dataMap,
      ];
}
