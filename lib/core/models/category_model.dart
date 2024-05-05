import 'package:finance/core/constants/globals.dart';

class CategoryModel {
  String? uid;
  String? userUid;
  String? name;
  int? balance;
  String? parentCategoryUid;
  List<CategoryModel> childrenCategory = [];

  CategoryModel(
      {this.uid,
      this.userUid,
      this.name,
      this.balance,
      this.parentCategoryUid,
      required this.childrenCategory});

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.userUid: userUid,
      Globals.name: name,
      Globals.balance: balance,
      Globals.parentCategoryUid: parentCategoryUid,
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
        childrenCategory: []);
  }
}
