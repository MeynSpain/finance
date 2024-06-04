import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';

class AccountModel extends Equatable {
  String? uid;
  String? userUid;
  String name;
  int balance;
  String type;
  bool? isAccountedInTotalBalance;

  AccountModel({
    this.uid,
    this.userUid,
    required this.name,
    required this.balance,
    required this.type,
    this.isAccountedInTotalBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.userUid: userUid,
      Globals.name: name,
      Globals.balance: balance,
      Globals.type: type,
      Globals.isAccountedInTotalBalance: isAccountedInTotalBalance,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> mapData) {
    return AccountModel(
      uid: mapData[Globals.uid],
      userUid: mapData[Globals.userUid],
      name: mapData[Globals.name],
      balance: mapData[Globals.balance],
      type: mapData[Globals.type],
      isAccountedInTotalBalance: mapData[Globals.isAccountedInTotalBalance],
    );
  }

  @override
  String toString() {
    return 'AccountModel{uid: $uid, name: $name, type: $type, userUid: $userUid, balance: $balance}';
  }

  @override
  List<Object?> get props => [
        uid,
        userUid,
        name,
        balance,
        type,
        isAccountedInTotalBalance,
      ];
}
