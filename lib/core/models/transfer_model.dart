import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';

class TransferModel extends Equatable {
  String? uid;
  String? userUid;
  int? amount;
  String? fromAccountUid;
  String? toAccountUid;
  Timestamp? timestamp;
  String? type;
  String? description;

  TransferModel(
      {this.uid,
      this.userUid,
      this.amount,
      this.fromAccountUid,
      this.toAccountUid,
      this.timestamp,
      this.type,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.userUid: userUid,
      Globals.amount: amount,
      Globals.fromAccountUid: fromAccountUid,
      Globals.toAccountUid: toAccountUid,
      Globals.timestamp: timestamp,
      Globals.type: type,
      Globals.description: description,
    };
  }

  factory TransferModel.fromTransfer(TransferModel transferModel) {
    return TransferModel(
      uid: transferModel.uid,
      userUid: transferModel.userUid,
      amount: transferModel.amount,
      fromAccountUid: transferModel.fromAccountUid,
      toAccountUid: transferModel.toAccountUid,
      timestamp: transferModel.timestamp,
      type: transferModel.type,
      description: transferModel.description,
    );
  }

  factory TransferModel.fromMap(Map<String, dynamic> mapData) {
    return TransferModel(
      uid: mapData[Globals.uid],
      userUid: mapData[Globals.userUid],
      amount: mapData[Globals.amount],
      fromAccountUid: mapData[Globals.fromAccountUid],
      toAccountUid: mapData[Globals.toAccountUid],
      timestamp: mapData[Globals.timestamp],
      type: mapData[Globals.type],
      description: mapData[Globals.description],
    );
  }

  @override
  String toString() {
    return 'TransferModel{uid: $uid, userUid: $userUid, amount: $amount, fromAccountUid: $fromAccountUid, toAccountUid: $toAccountUid, timestamp: $timestamp, type: $type, description: $description}';
  }

  @override
  List<Object?> get props => [
        uid,
        userUid,
        amount,
        fromAccountUid,
        toAccountUid,
        timestamp,
        type,
        description,
      ];
}