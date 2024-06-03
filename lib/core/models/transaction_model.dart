import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/models/tag_model.dart';

class TransactionModel extends Equatable {
  /// Будет храниться в меньшей валюте, например в копейках
  int amount;
  String? uid;
  String? userUid;
  String? categoryUid;
  String? accountUid;
  Timestamp? timestamp;
  String? description;
  String type;
  List<TagModel>? tags;

  /// Подумать как добавить атрибуты транзакции
  /// теги
  /// Добавление сумма, теги, с такой то карты

  TransactionModel({
    required this.amount,
    this.uid,
    this.userUid,
    this.categoryUid,
    this.timestamp,
    required this.type,
    this.description,
    this.tags,
    this.accountUid,
  });

  Map<String, dynamic> toMap() {
    return {
      Globals.amount: amount,
      Globals.uid: uid,
      Globals.userUid: userUid,
      Globals.categoryUid: categoryUid,
      Globals.timestamp: timestamp,
      Globals.type: type,
      Globals.description: description,
      Globals.tags: tags?.map((tag) => tag.toMap()).toList(),
      Globals.accountUid: accountUid,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> mapData) {
    return TransactionModel(
      amount: mapData[Globals.amount],
      uid: mapData[Globals.uid],
      userUid: mapData[Globals.userUid],
      categoryUid: mapData[Globals.categoryUid],
      timestamp: mapData[Globals.timestamp],
      type: mapData[Globals.type],
      description: mapData[Globals.description],
      accountUid: mapData[Globals.accountUid],
      tags: (mapData?[Globals.tags] as List<dynamic>)
          .map((tag) => TagModel.fromMap(tag))
          .toList(),
    );
  }


  @override
  String toString() {
    return 'TransactionModel{amount: $amount, uid: $uid, categoryUid: $categoryUid, accountUid: $accountUid, timestamp: $timestamp, description: $description, type: $type}';
  }

  @override
  List<Object?> get props =>
      [amount, userUid, categoryUid, timestamp, type, description, tags];
}
