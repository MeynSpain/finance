import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';

class AccountModel extends Equatable {
  String? uid;
  String? userUid;
  String name;
  int balance;

  AccountModel({
    this.uid,
    this.userUid,
    required this.name,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.userUid: userUid,
      Globals.name: name,
      Globals.balance: balance,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> mapData) {
    return AccountModel(
      uid: mapData[Globals.uid],
      userUid: mapData[Globals.userUid],
      name: mapData[Globals.name],
      balance: mapData[Globals.balance],
    );
  }


  @override
  String toString() {
    return 'AccountModel{uid: $uid, userUid: $userUid, name: $name, balance: $balance}';
  }

  @override
  List<Object?> get props => [
        uid,
        userUid,
        name,
        balance,
      ];
}
