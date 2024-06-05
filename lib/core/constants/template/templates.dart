import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/models/account_model.dart';
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

  // static List<>

  static AccountModel getStartAccountTemplate({required String userUid}) {
    return AccountModel(
      name: Globals.mainAccount,
      balance: 0,
      userUid: userUid,
      type: Globals.typeAccountNonNullable,
      isAccountedInTotalBalance: true,
    );
  }

  static List<CategoryModel> getStartCategoryTemplate(
      {required String userUid}) {
    return [
      CategoryModel(
        userUid: userUid,
        name: Globals.wages,
        balance: 0,
        transactions: [],
        childrenCategory: [],
        // type: Globals.typeCategoryNonDeleted
      ),
      CategoryModel(
        userUid: userUid,
        name: 'Переводы',
        balance: 0,
        transactions: [],
        childrenCategory: [],
        type: Globals.typeCategoryTransfers,
      ),
      CategoryModel(
        balance: 0,
        name: Globals.rent,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted,
      ),
      CategoryModel(
        balance: 0,
        name: Globals.health,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted,
      ),
      CategoryModel(
        balance: 0,
        name: Globals.utilities,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted,
      ),
      CategoryModel(
        balance: 0,
        name: Globals.subscribes,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted,
      ),
      CategoryModel(
        balance: 0,
        name: Globals.products,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted,
      ),
      CategoryModel(
        balance: 0,
        name: Globals.leisure,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted
      ),
      CategoryModel(
        balance: 0,
        name: Globals.transport,
        userUid: userUid,
        childrenCategory: [],
        transactions: [],
        // type: Globals.typeCategoryNonDeleted,
      ),
    ];
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
