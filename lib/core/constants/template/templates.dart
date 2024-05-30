import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/tag_model.dart';

class Templates {
  Templates._();

  // static List<TagModel> getStartTagsTemplate() {
  //   List<TagModel> listTags = [
  //     TagModel(name: Globals.root, type: Globals.typeCategory),
  //     TagModel(name: Globals.rent, type: Globals.typeCategory),
  //     TagModel(name: Globals.health, type: Globals.typeCategory),
  //     TagModel(name: Globals.utilities, type: Globals.typeCategory),
  //     TagModel(name: Globals.products, type: Globals.typeCategory),
  //     TagModel(name: Globals.subscribes, type: Globals.typeCategory),
  //     TagModel(name: Globals.leisure, type: Globals.typeCategory),
  //     TagModel(name: Globals.transport, type: Globals.typeCategory),
  //
  //   ];
  //   return listTags;
  // }

  static CategoryModel getStartCategoryTemplate(
      {required String name, required String userUid}) {
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
        ]);

    return startCategoryTemplate;
  }

  static const List<String> titlesWeekday = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс'
  ];

  static const List<String> titlesMonths = [
    'Янв',
    'Фев',
    'Март',
    'Апр',
    'Май',
    'Июнь',
    'Июль',
    'Авг',
    'Сен',
    'Окт',
    'Ноя',
    'Дек',
  ];
}
