import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/tag_model.dart';

class Templates {
  Templates._();

  static List<TagModel> getStartTagsTemplate() {
    List<TagModel> listTags = [
      TagModel(name: Globals.root),
      TagModel(name: Globals.rent),
      TagModel(name: Globals.health),
      TagModel(name: Globals.utilities),
      TagModel(name: Globals.products),
      TagModel(name: Globals.subscribes),
      TagModel(name: Globals.leisure),
      TagModel(name: Globals.transport),

    ];
    return listTags;
  }

  static CategoryModel getStartCategoryTemplate({required String name, required String userUid}) {
    CategoryModel startCategoryTemplate = CategoryModel(
      userUid: userUid,
      name: name,
      balance: 0,
      transactions: [],
      childrenCategory: [
        CategoryModel(
          balance: 0,
          name: Globals.rent,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.health,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.utilities,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.subscribes,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.products,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.leisure,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.transport,
          userUid: userUid,
          childrenCategory: [],
          transactions: [],
        ),
      ]
    );

    return startCategoryTemplate;
  }
}