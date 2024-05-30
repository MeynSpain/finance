part of 'last_transactions_bloc.dart';

class LastTransactionsState extends Equatable {
  final LastTransactionsStatus status;
  final String errorMessage;
  final List<PairModel<CategoryModel, TransactionModel>> transactions;

  LastTransactionsState._({
    required this.status,
    required this.transactions,
    required this.errorMessage,
  });

  factory LastTransactionsState.initial() {
    return LastTransactionsState._(
      status: LastTransactionsStatus.initial,
      transactions: [],
      errorMessage: '',
    );
  }

  LastTransactionsState copyWith({
    LastTransactionsStatus? status,
    List<PairModel<CategoryModel, TransactionModel>>? transactions,
    String? errorMessage,
  }) {
    return LastTransactionsState._(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? '',
    );
  }

  String getFormatDate(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        errorMessage,
      ];
}
