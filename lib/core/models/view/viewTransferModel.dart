import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/core/models/transfer_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';

class ViewTransferModel extends Equatable {
  String uid;
  String userUid;
  int amount;
  AccountModel? fromAccount;
  AccountModel toAccount;
  DateTime dateTime;
  String type;
  String? description;

  ViewTransferModel({
    required this.uid,
    required this.userUid,
    required this.amount,
    this.fromAccount,
    required this.toAccount,
    required this.dateTime,
    required this.type,
    this.description,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     Globals.uid: uid,
  //     Globals.userUid: userUid,
  //     Globals.amount: amount,
  //     Globals.fromAccountUid: fromAccountUid,
  //     Globals.toAccountUid: toAccountUid,
  //     Globals.timestamp: timestamp,
  //     Globals.type: type,
  //     Globals.description: description,
  //   };
  // }

  factory ViewTransferModel.fromTransfer(TransferModel transferModel) {
    List<AccountModel> accounts = getIt<CategoriesBloc>().state.listAccounts;

    int? indexFrom;
    if (transferModel.fromAccountUid != null) {
      indexFrom = accounts
          .indexWhere((account) => account.uid == transferModel.fromAccountUid);
    }

    int indexTo = accounts
        .indexWhere((account) => account.uid == transferModel.toAccountUid);

    return ViewTransferModel(
      uid: transferModel.uid ?? '',
      userUid: transferModel.userUid ?? '',
      amount: transferModel.amount ?? 0,
      dateTime: transferModel.timestamp?.toDate() ?? DateTime.now(),
      type: transferModel.type ?? '',
      description: transferModel.description,
      toAccount: accounts[indexTo],
      fromAccount: indexFrom != null ? accounts[indexFrom] : null,
    );
  }

  // factory TransferModel.fromMap(Map<String, dynamic> mapData) {
  //   return TransferModel(
  //     uid: mapData[Globals.uid],
  //     userUid: mapData[Globals.userUid],
  //     amount: mapData[Globals.amount],
  //     fromAccountUid: mapData[Globals.fromAccountUid],
  //     toAccountUid: mapData[Globals.toAccountUid],
  //     timestamp: mapData[Globals.timestamp],
  //     type: mapData[Globals.type],
  //     description: mapData[Globals.description],
  //   );
  // }

  // @override
  // String toString() {
  //   return 'TransferModel{uid: $uid, userUid: $userUid, amount: $amount, fromAccountUid: $fromAccountUid, toAccountUid: $toAccountUid, timestamp: $timestamp, type: $type, description: $description}';
  // }

  @override
  List<Object?> get props => [
        uid,
        userUid,
        amount,
        fromAccount,
        toAccount,
        dateTime,
        type,
        description,
      ];
}
