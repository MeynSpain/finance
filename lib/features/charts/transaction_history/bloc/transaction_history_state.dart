part of 'transaction_history_bloc.dart';

class TransactionHistoryState extends Equatable {
  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final String categoryName;
  final String errorMessage;

  TransactionHistoryState._({
    required this.status,
    required this.categoryName,
    required this.errorMessage,
    required this.transactions,
  });

  factory TransactionHistoryState.initial() {
    return TransactionHistoryState._(
      status: TransactionStatus.initial,
      transactions: [],
      categoryName: '',
      errorMessage: '',
    );
  }

  TransactionHistoryState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
    String? categoryName,
    String? errorMessage,
  }) {
    return TransactionHistoryState._(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      categoryName: categoryName ?? this.categoryName,
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
        categoryName,
        errorMessage,
      ];
}
