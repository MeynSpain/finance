import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/models/category_model.dart';

class Templates {
  Templates._();

  static CategoryModel getStartCategoryTemplate({required String name, required String userUid}) {
    CategoryModel startCategoryTemplate = CategoryModel(
      userUid: userUid,
      name: name,
      balance: 0,
      childrenCategory: [
        CategoryModel(
          balance: 0,
          name: Globals.rent,
          userUid: userUid,
          childrenCategory: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.health,
          userUid: userUid,
          childrenCategory: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.utilities,
          userUid: userUid,
          childrenCategory: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.subscribes,
          userUid: userUid,
          childrenCategory: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.products,
          userUid: userUid,
          childrenCategory: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.leisure,
          userUid: userUid,
          childrenCategory: [],
        ),
        CategoryModel(
          balance: 0,
          name: Globals.transport,
          userUid: userUid,
          childrenCategory: [],
        ),
      ]
    );

    return startCategoryTemplate;
  }
}