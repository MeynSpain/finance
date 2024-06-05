import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';

import 'transaction_model.dart';

class CategoryModel extends Equatable {
  String? uid;
  String? userUid;
  String? name;
  int? balance;
  String? parentCategoryUid;
  List<CategoryModel> childrenCategory = [];
  List<TransactionModel>? transactions;
  String? type;

  CategoryModel({
    this.uid,
    this.userUid,
    this.name,
    this.balance,
    this.parentCategoryUid,
    required this.childrenCategory,
    this.transactions,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.userUid: userUid,
      Globals.name: name,
      Globals.balance: balance,
      Globals.parentCategoryUid: parentCategoryUid,
      Globals.type: type,
      // Globals.transactions:
      //     transactions?.map((transaction) => transaction.toMap()).toList(),
      // 'childrenCategory':
      //     childrenCategory?.map((child) => child.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'CategoryModel{uid: $uid, userUid: $userUid, name: $name, balance: $balance, parentCategoryUid: $parentCategoryUid, childrenCategory: $childrenCategory}';
  }

  factory CategoryModel.fromMap(Map<String, dynamic> mapData) {
    return CategoryModel(
      uid: mapData[Globals.uid],
      userUid: mapData[Globals.userUid],
      name: mapData[Globals.name],
      balance: mapData[Globals.balance],
      parentCategoryUid: mapData[Globals.parentCategoryUid],
      type: mapData[Globals.type],
      childrenCategory: [],
      // transactions: (mapData?[Globals.transactions] as List<dynamic>)
      //     .map((transaction) => TransactionModel.fromMap(transaction))
      //     .toList(),
    );
  }

  @override
  List<Object?> get props => [
        uid,
        userUid,
        name,
        balance,
        parentCategoryUid,
        childrenCategory,
        transactions,
        type,
      ];
}
