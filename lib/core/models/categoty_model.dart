import 'package:finance/core/constants/globals.dart';

class CategoryModel {
  String? uid;
  String? userUid;
  String? name;
  int? balance;
  String? parentCategoryUid;
  List<CategoryModel>? childrenCategory;

  CategoryModel({this.uid,
    this.userUid,
    this.name,
    this.balance,
    this.parentCategoryUid,
    this.childrenCategory});

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

// factory CategoryModel.fromMap(Map<String, dynamic> mapData) {
//   return CategoryModel(
//     uid: mapData['uid'],
//     name: mapData['name'],
//     balance: mapData['balance'],
//     parentCategoryUid: mapData['parentCategoryUid'],
//     childrenCategory: List<CategoryModel>.from(mapData['childrenCategory'].map((child)) )
//   );
// }
}
