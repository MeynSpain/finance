part of 'transaction_history_bloc.dart';

@immutable
abstract class TransactionHistoryEvent {}

class TransactionHistoryLoadTransactionsEvent extends TransactionHistoryEvent {
  final List<TransactionModel> transactions;
  final String categoryName;
  final List<CategoryModel> categories;

  TransactionHistoryLoadTransactionsEvent({
    required this.transactions,
    required this.categoryName,
    required this.categories,
  });
}
