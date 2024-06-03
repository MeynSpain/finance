part of 'last_transactions_bloc.dart';

@immutable
abstract class LastTransactionsEvent {}

class LastTransactionsInitialEvent extends LastTransactionsEvent {
  final String userUid;
  final String accountUid;

  LastTransactionsInitialEvent(
      {required this.userUid, required this.accountUid});
}

class LastTransactionsAddTransactionEvent extends LastTransactionsEvent {
  final TransactionModel transaction;
  final String categoryUid;

  LastTransactionsAddTransactionEvent({required this.transaction, required this.categoryUid});
}
