part of 'transfers_bloc.dart';

@immutable
abstract class TransfersEvent {}

class TransferAddNewTransferEvent extends TransfersEvent {
  final String userUid;
  final AccountModel fromAccount;
  final AccountModel toAccount;
  final int amount;
  final String description;
  final DateTime dateTime;

  TransferAddNewTransferEvent({
    required this.userUid,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.description,
    required this.dateTime,
  });
}

class TransfersGetAllTransfersByDateEvent extends TransfersEvent {
  final String userUid;
  final DateTime startDate;
  final DateTime endDate;

  TransfersGetAllTransfersByDateEvent({
    required this.userUid,
    required this.startDate,
    required this.endDate,
  });
}